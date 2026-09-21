#!/bin/bash
# ---------------------------------------------------------------
# CCN-STIC-610 - Configuración Segura de SSH para OpenSUSE (Interactivo)
# Versión mejorada con validación SELinux y entrada interactiva de puerto
# ---------------------------------------------------------------

source "$(dirname "$0")/lib.sh"

clear

echo -e "${CYAN}---------------------------------------------------------------"
echo -e "  CCN-STIC-610 - Seguridad del Servicio SSH en OpenSUSE"
echo -e "---------------------------------------------------------------"
echo
echo "  - Autenticación segura y restricción de acceso"
echo "  - Banner informativo"
echo "  - Cambio de puerto SSH (interactivo)"
echo "  - Desactivación de root remoto"
echo "  - Validación SELinux y firewall"
echo
echo -e "------------------------------------------------------------------${NC}"

read -n1 -r -p "Pulse cualquier tecla para continuar..."

# 1. Verificar privilegios
check_root

# 2. Entrada interactiva del puerto
echo
log_info "Configuración de Red SSH"
read -p "Ingrese el nuevo puerto SSH (por defecto 2301): " NEW_SSH_PORT
NEW_SSH_PORT=${NEW_SSH_PORT:-2301}

if ! [[ "$NEW_SSH_PORT" =~ ^[0-9]+$ ]] || [ "$NEW_SSH_PORT" -lt 1 ] || [ "$NEW_SSH_PORT" -gt 65535 ]; then
    log_error "Puerto no válido ($NEW_SSH_PORT). Abortando."
    exit 1
fi

# 3. Variables de entorno
ALLOWED_USERS="${SUDO_USER:-$USER}"
ALLOWED_GROUPS="wheel"
BANNER_FILE="/etc/motd"
SSH_CONFIG="/etc/ssh/sshd_config"

# 4. Backup de seguridad
do_backup "$SSH_CONFIG"

# 5. Aplicar configuraciones con replace_in_file (Idempotencia)
log_info "Modificando parámetros de sshd_config..."

replace_in_file "^#?[[:space:]]*Port[[:space:]]+.*" "Port $NEW_SSH_PORT" "$SSH_CONFIG"
replace_in_file "^#?[[:space:]]*PermitRootLogin[[:space:]]+.*" "PermitRootLogin no" "$SSH_CONFIG"
replace_in_file "^#?[[:space:]]*PermitEmptyPasswords[[:space:]]+.*" "PermitEmptyPasswords no" "$SSH_CONFIG"
replace_in_file "^#?[[:space:]]*MaxAuthTries[[:space:]]+.*" "MaxAuthTries 3" "$SSH_CONFIG"
replace_in_file "^#?[[:space:]]*LoginGraceTime[[:space:]]+.*" "LoginGraceTime 30" "$SSH_CONFIG"
replace_in_file "^#?[[:space:]]*ClientAliveInterval[[:space:]]+.*" "ClientAliveInterval 300" "$SSH_CONFIG"
replace_in_file "^#?[[:space:]]*ClientAliveCountMax[[:space:]]+.*" "ClientAliveCountMax 0" "$SSH_CONFIG"
replace_in_file "^#?[[:space:]]*X11Forwarding[[:space:]]+.*" "X11Forwarding no" "$SSH_CONFIG"
replace_in_file "^#?[[:space:]]*Banner[[:space:]]+.*" "Banner $BANNER_FILE" "$SSH_CONFIG"
replace_in_file "^#?[[:space:]]*Port[[:space:]]+.*" "Port $NEW_SSH_PORT" "$SSH_CONFIG"
replace_in_file "^#?[[:space:]]*MaxAuthTries[[:space:]]+.*" "MaxAuthTries 3" "$SSH_CONFIG"
replace_in_file "^#?[[:space:]]*ClientAliveCountMax[[:space:]]+.*" "ClientAliveCountMax 0" "$SSH_CONFIG"
replace_in_file "^#?[[:space:]]*Banner[[:space:]]+.*" "Banner $BANNER_FILE" "$SSH_CONFIG"
replace_in_file "^#?[[:space:]]*LoginGraceTime[[:space:]]+.*" "LoginGraceTime 30" "$SSH_CONFIG"
replace_in_file "^#?[[:space:]]*X11Forwarding[[:space:]]+.*" "X11Forwarding no" "$SSH_CONFIG"

# Configurar Usuarios y Grupos permitidos
# Si no existen, los añadimos al final; si existen, los actualizamos.
if ! grep -q "^AllowUsers" "$SSH_CONFIG"; then
    echo "AllowUsers $ALLOWED_USERS" >> "$SSH_CONFIG"
    log_success "Línea AllowUsers añadida."
else
    replace_in_file "^AllowUsers .*" "AllowUsers $ALLOWED_USERS" "$SSH_CONFIG"
fi

if ! grep -q "^AllowGroups" "$SSH_CONFIG"; then
    echo "AllowGroups $ALLOWED_GROUPS" >> "$SSH_CONFIG"
    log_success "Línea AllowGroups añadida."
else
    replace_in_file "^AllowGroups .*" "AllowGroups $ALLOWED_GROUPS" "$SSH_CONFIG"
fi

# 6. Crear Banner Legal
create_script "$BANNER_FILE" <<EOF
AVISO IMPORTANTE DE SEGURIDAD

Está usted accediendo a un equipo propiedad de la Organización.
El acceso no autorizado está prohibido y será registrado.
El uso del sistema implica la aceptación de las políticas de seguridad vigentes.
EOF
chmod 644 "$BANNER_FILE"

# 7. Configuración de Firewall (Firewalld es estándar en OpenSUSE)
log_info "Configurando Firewalld para el puerto $NEW_SSH_PORT..."
if command -v firewall-cmd &>/dev/null; then
    firewall-cmd --permanent --add-port=$NEW_SSH_PORT/tcp &>/dev/null
    firewall-cmd --reload &>/dev/null
    log_success "Puerto $NEW_SSH_PORT abierto en el firewall."
else
    log_warn "firewall-cmd no encontrado. Asegúrese de abrir el puerto manualmente."
fi

# 8. Módulos de Seguridad (SELinux/AppArmor)
if command -v getenforce &>/dev/null && [ "$(getenforce)" != "Disabled" ]; then
    log_info "SELinux activo. Registrando puerto $NEW_SSH_PORT..."
    if semanage port -l | grep -q "$NEW_SSH_PORT"; then
        semanage port -m -t ssh_port_t -p tcp "$NEW_SSH_PORT"
    else
        semanage port -a -t ssh_port_t -p tcp "$NEW_SSH_PORT"
    fi
    log_success "SELinux actualizado para el puerto SSH."
fi

# En OpenSUSE, AppArmor suele controlar el binario, pero no suele restringir el puerto 
# a menos que haya un perfil muy específico. Lo reiniciamos por precaución.
if systemctl is-active --quiet apparmor; then
    log_info "Reiniciando AppArmor para aplicar posibles cambios de perfil..."
    systemctl restart apparmor
fi

# 9. Reiniciar servicio y finalizar
log_info "Reiniciando servicio SSH..."
if systemctl restart sshd; then
    log_success "Servicio SSH reiniciado correctamente en el puerto $NEW_SSH_PORT."
else
    log_error "Fallo al reiniciar SSH. Revise la configuración."
    exit 1
fi

echo
echo -e "${GREEN}---------------------------------------------------------------"
echo -e " CCN-STIC-610 Directivas SSH: CONFIGURACIÓN APLICADA "
echo -e " Puerto: $NEW_SSH_PORT"
echo -e " Usuario permitido: $ALLOWED_USERS"
echo -e " Grupo permitido: $ALLOWED_GROUPS"
echo -e " Revise /etc/ssh/sshd_config antes de cerrar la sesión."
echo -e " SE RECOMIENDA ENCARECIDAMENTE REVISAR CONFIGURACIONES DUPLICADAS"
echo -e "---------------------------------------------------------------${NC}"

read -n1 -r -p "Pulse cualquier tecla para finalizar..."