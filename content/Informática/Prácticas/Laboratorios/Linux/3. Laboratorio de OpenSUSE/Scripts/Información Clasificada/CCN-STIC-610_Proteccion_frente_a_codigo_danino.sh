#!/bin/bash
# ---------------------------------------------------------------
# CCN-STIC-610 - Protección ante Código Dañino en OpenSUSE
# ---------------------------------------------------------------

source "$(dirname "$0")/lib.sh"

clear
echo -e "${CYAN}----------------------------------------------------------------------------"
echo -e "  CCN-STIC-610 - Protección ante Código Dañino en OpenSUSE"
echo -e "----------------------------------------------------------------------------"
echo -e
echo -e "Este script aplica las siguientes medidas de seguridad:"
echo -e "  - Deshabilitar compiladores del sistema para usuarios no root"
echo -e "  - Habilitar SELinux en modo 'enforcing'"
echo -e
echo -e "Debe ejecutarse como root. Verifique previamente que su sistema no"
echo -e "depende de compilaciones manuales o herramientas de desarrollo."
echo -e "----------------------------------------------------------------------------${NC}"

read -n1 -r -p "Pulse cualquier tecla para continuar..."

# 1. Verificaciones iniciales
check_root

# 2. Restringir compiladores
# En OpenSUSE, gcc y cc suelen ser enlaces simbólicos. 
# Usamos chmod -h no es útil aquí, mejor aplicarlo al binario real si existe.
log_info "Restringiendo acceso a compiladores (chmod 700)..."
COMPILADORES=("/usr/bin/gcc" "/usr/bin/cc" "/usr/bin/make" "/usr/bin/as")

for comp in "${COMPILADORES[@]}"; do
	if [ -f "$comp" ]; then
		# Aplicamos 700: rwx------ (Solo root)
		if chmod 700 "$comp"; then
			log_success "Permisos restringidos: $comp."
		else
			log_error "No se ha podido establecer los nuevos permisos a ${comp}."
		fi
	else
		log_info "Compilador no encontrado: $comp. Saltando..."
	fi
done

# 3. Configuración de SELinux / AppArmor
# Nota: CCN-STIC-610 pide SELinux, pero en OpenSUSE el estándar es AppArmor.
# Si el usuario insiste en SELinux, lo configuramos, pero con seguridad.

SELINUX_CONF="/etc/selinux/config"

if [ -f "$SELINUX_CONF" ]; then
	log_info "Configurando SELinux en $SELINUX_CONF..."
	do_backup "$SELINUX_CONF"
	
	# Cambiamos a enforcing de forma segura
	replace_in_file "^SELINUX=.*" "SELINUX=enforcing" "$SELINUX_CONF"
	replace_in_file "^SELINUXTYPE=.*" "SELINUXTYPE=targeted" "$SELINUX_CONF"
	
	# Intentar aplicar en caliente
	if setenforce 1 2>/dev/null; then
		log_success "SELinux activado en modo Enforcing."
	else
		log_warn "No se pudo activar SELinux en caliente. Asegúrese de que el paquete 'selinux-policy' está instalado y reinicie."
	fi
else
	log_warn "Archivo $SELINUX_CONF no encontrado."
	log_info "Verificando AppArmor (Alternativa nativa de OpenSUSE)..."
	if systemctl is-active --quiet apparmor; then
		log_success "AppArmor está activo y protegiendo el sistema."
	else
		log_warn "Ni SELinux ni AppArmor parecen estar configurados correctamente."
	fi
fi

# 4. Bonus: Deshabilitar servicios de depuración (Common en código dañino)
log_info "Deshabilitando servicios de depuración y traza..."
mask_service abrt-journal-core.service
mask_service abrt-oops.service

# Final
echo -e "\n${GREEN}----------------------------------------------------------------"
echo " CCN-STIC-610 Protección contra código dañino: CONFIGURACIÓN APLICADA"
echo -e "----------------------------------------------------------------${NC}"

read -n1 -r -p "Pulse cualquier tecla para finalizar..."