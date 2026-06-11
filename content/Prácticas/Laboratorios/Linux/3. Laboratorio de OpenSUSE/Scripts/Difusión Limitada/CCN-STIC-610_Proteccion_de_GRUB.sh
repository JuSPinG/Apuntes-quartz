#!/bin/bash
# ---------------------------------------------------------------
# CCN-STIC-610 - Protección de GRUB2 en OpenSUSE
# ---------------------------------------------------------------

source "$(dirname "$0")/lib.sh"

clear

echo -e "${CYAN}----------------------------------------------------------------------------"
echo -e "  CCN-STIC-610 - Protección de GRUB con Usuario y Contraseña en OpenSUSE"
echo -e "----------------------------------------------------------------------------"
echo
echo -e "Este script aplica medidas para proteger el arranque del sistema:"
echo -e "  - Añadir usuario de GRUB"
echo -e "  - Cifrar la contraseña"
echo -e "  - Restringir el acceso a opciones del kernel"
echo
echo -e "Requisitos:"
echo -e "  - Ejecutar como root"
echo -e "  - Herramienta grub2-mkpasswd-pbkdf2 instalada"
echo -e "----------------------------------------------------------------------------${NC}"
echo

read -n1 -r -p "Pulse cualquier tecla para continuar..."

# 1. Verificaciones iniciales
check_root
check_pkg "grub2-mkpasswd-pbkdf2" "grub2-mkpasswd-pbkdf2"

# Crear copia de seguridad
GRUB_CUSTOM="/etc/grub.d/40_custom"
do_backup "$GRUB_CUSTOM"
sudo chmod -x /etc/grub.d/*.bak_*

# Crear hash de contraseña
log_info "Configurando credenciales de GRUB..."
log_warn "Introduzca la contraseña que se pedirá en el ARRANQUE:"

# Capturamos el hash directamente a una variable, evitando archivos temporales en /tmp
echo -n "Contraseña: "
read -s GRUB_PASS
echo
echo -n "Confirme contraseña: "
read -s GRUB_PASS_CONFIRM
echo

# 2. Verificación simple
if [[ "$GRUB_PASS" != "$GRUB_PASS_CONFIRM" ]]; then
    log_error "Las contraseñas no coinciden."
    exit 1
fi

# 3. Generamos el hash con la variable que ahora SÍ tiene valor
HASH=$(grub2-mkpasswd-pbkdf2 <<EOF
$GRUB_PASS
$GRUB_PASS
EOF
)
# Extraemos solo la parte del hash (la última palabra de la última línea)
HASH=$(echo "$HASH" | tail -n1 | awk '{print $NF}')

if [[ -z "$HASH" ]]; then
    log_error "No se pudo generar el hash de la contraseña."
    exit 1
fi

read -p "Introduzca el nombre del usuario administrador de GRUB [grubadmin]: " GRUB_USER
GRUB_USER=${GRUB_USER:-grubadmin}

log_info "Escribiendo configuración en $GRUB_CUSTOM..."

# Limpiamos entradas antiguas de superusers para evitar duplicados
sed -i '/^set superusers/d' "$GRUB_CUSTOM"
sed -i '/^password_pbkdf2/d' "$GRUB_CUSTOM"

create_script "$GRUB_CUSTOM" <<EOF
#!/bin/sh
exec tail -n +3 \$0
# Esta parte se volcará literalmente al grub.cfg final:
set superusers="$GRUB_USER"
password_pbkdf2 $GRUB_USER $HASH
EOF

# 4. Endurecimiento: Eliminar modo rescate y restringir edición
log_info "Aplicando restricciones en /etc/default/grub..."
do_backup "/etc/default/grub"

# Deshabilitar la entrada de recuperación (CCN-STIC)
replace_in_file "^#\?GRUB_DISABLE_RECOVERY=.*" "GRUB_DISABLE_RECOVERY=\"true\"" "/etc/default/grub"

log_info "Asegurando que /boot y /boot/efi sea escribible..."
if mount -o remount,rw /boot 2>/dev/null; then
    log_success "La partición /boot es ahora de escritura"
else
    log_error "No se ha podido cambiar el acceso a la partición /boot"
fi

if mount -o remount,rw /boot/efi 2>/dev/null; then
    log_success "La partición /boot/efi es ahora de escritura"
else
    log_error "No se ha podido cambiar el acceso a la partición /boot/efi"
fi

# 5. Regenerar configuración de GRUB
log_info "Detectando arquitectura y regenerando GRUB..."

# En OpenSUSE, grub2-mkconfig suele ir a /boot/grub2/grub.cfg 
# incluso en UEFI, porque el archivo en la partición EFI es solo un puntero.
GRUB_OUT="/boot/grub2/grub.cfg"

if grub2-mkconfig -o "$GRUB_OUT"; then
    log_success "Configuración de GRUB regenerada en $GRUB_OUT"
    chmod 600 "$GRUB_OUT"
else
    log_error "Error al regenerar la configuración de GRUB."
    exit 1
fi

# 6. Limpieza de entradas de rescate físicas (Opcional pero recomendado por STIC)
log_info "Limpiando archivos de rescate en /boot..."
if rm -f /boot/*rescue* 2>/dev/null; then
    log_success "Archivos de arranque eliminados"
else
    log_error "No se ha podido eliminar los archivos de arranque"
fi

echo
echo -e "${GREEN}---------------------------------------------------------------"
echo -e " CCN-STIC-610 Proteccion de GRUB: CONFIGURACIÓN APLICADA "
echo -e " Revise manualmente las configuraciones aplicadas"
echo -e "---------------------------------------------------------------${NC}"

read -n1 -r -p "Pulse cualquier tecla para finalizar..."
