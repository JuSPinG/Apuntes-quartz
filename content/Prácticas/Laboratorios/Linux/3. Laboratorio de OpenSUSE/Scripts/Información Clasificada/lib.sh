#!/bin/bash

set -e

# --- Constantes y Colores ---
readonly CYAN='\033[1;36m'
readonly GREEN='\033[1;32m'
readonly RED='\033[1;31m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m'

# 1
UPDATE_SCRIPT="/usr/local/sbin/auto_update.sh"
CRON_FILE="/etc/cron.d/ccn_actualizacion"
# 2
CLAMCONF="/etc/clamd.conf"
FRESHCONF="/etc/freshclam.conf"
# 3
PAM_AUTH="/etc/pam.d/common-auth"
PAM_ACCOUNT="/etc/pam.d/common-account"
FAILLOCK_CONF="/etc/security/faillock.conf"
# 4
CONFIG_FILE="/etc/usbguard/usbguard-daemon.conf"
# 5
AUDITD_CONF="/etc/audit/auditd.conf"
AUDIT_RULES="/etc/audit/rules.d/ccn_audit.rules"
# 6
AUTH_CONF="/etc/security/pwquality.conf"
DEFS="/etc/login.defs"
AUTH_FILE="/etc/pam.d/system-auth"

log_info() {
	echo -e "${CYAN}[+] $1 ${NC}"
}

log_warn() {
	echo -e "${YELLOW}[!] $1 ${NC}"
}

log_success() {
	echo -e "${GREEN}[OK] $1 ${NC}"
}

log_error() {
	echo -e "${RED}[ERROR] $1 ${NC}"
}

check_root() {
	if [ "$EUID" -ne 0 ]; then
		log_error "Este script debe ejecutarse como root (usa sudo)."
		exit 1
	fi
}

# Verificar si un servicio está activo
# Uso: check_service cron
check_service() {
	local service=$1

	log_info "Verificando el servicio ${service}..."
	if ! systemctl is-active --quiet ${service}; then
		log_info "Activando ${service}..."
		if systemctl enable --now ${service}; then
			log_success "${service} activado correctamente."
		else
			log_error "No se ha podido activar ${service}."
		fi
	else
		log_info "${service} ya está activo."
	fi
}

# Verificar si un servicio paquete está instalado y usable
# Uso: check_pkg "firewalld" "firewall-cmd"
check_pkg() {
	local pkg=$1
	local cmd=$2

	log_info "Verificando el estado de ${pkg}..."
	
	# Intento 1: ¿Existe el binario?
	# Intento 2: ¿Está registrado en la base de datos de paquetes?
	if command -v "$cmd" &>/dev/null || rpm -q "$pkg" &>/dev/null; then
		log_info "$pkg ya está presente."
	else
		log_warn "${pkg} no detectado. Preparando instalación..."
		# ... (aquí va tu lógica interactiva de PackageKit que hicimos antes)
		sudo zypper -n install "$pkg"
	fi
}

# Función principal de backup
# Uso: do_backup "/etc/hosts"
do_backup() {
	local f="$1"

	log_info "Creando copia de seguridad de ${f}..."
	if [[ ! -e "$f" ]]; then
		log_warn "No existe: $f"
	else
		local dest="${f}.bak_$(date +%F_%H%M%S)"
		cp -a "$f" "$dest"

		log_success "Backup: $dest"
	fi
}

# Cambiar la política de seguridad
# Uso: set_crypto_policy "FUTURE"
set_crypto_policy() {
	local policy=$1
	local config_dir="/etc/crypto-policies/back-ends"
	local source_dir="/usr/share/crypto-policies/$policy"

	log_info "Estableciendo política de seguridad a ${policy}..."
	if [ ! -d "$source_dir" ]; then
		log_error "Política $policy no disponible."
		return 1
	fi
	sudo rm -f "$config_dir"/*.config "$config_dir"/*.txt
	
	for file in "$source_dir"/*; do
		local fname=$(basename "$file")
		local name_no_ext="${fname%.*}"
		sudo ln -sf "$file" "$config_dir/$name_no_ext.config"
		sudo ln -sf "$file" "$config_dir/$name_no_ext.txt"
	done
	log_success "Política $policy aplicada."
}

# Genera un script con el contenido que se pida
# Uso:
# ```
# create_script "/opt/scripts/update.sh" <<EOF
# !/bin/bash
# Generado el $(date)
# /usr/bin/zypper -n update
# EOF
# ```
create_script() {
	local file="$1"

	log_info "Creando archivo: ${file}..."
		
	cat > "$file"
	
	if [ $? -eq 0 ] && [ -s "$file" ]; then
		chmod +x "$file"
		log_success "Script generado con éxito: $file."
	else
		log_error "Error crítico al generar $file."
		exit 1
	fi
}

# `sed` pero con esteroiedes, resistente a errores
# Uso: replace_in_file "buscar" "reemplazar" "archivo"
replace_in_file() {
	local search="$1"
	local replace="$2"
	local file="$3"

	log_info "Realizando modificación en ${file}."

	if [[ ! -f "$file" ]]; then
		log_error "Archivo no encontrado: $file"
		return 1
	fi

	# 2. IDEMPOTENCIA: ¿Ya existe la línea EXACTA y ACTIVA?
    # Usamos -x para que coincida con la línea completa
    # Usamos -e para evitar que el contenido se interprete como flags
    if grep -qxe "$replace" "$file"; then
        log_info "El cambio ya estaba aplicado (línea exacta) en $file. Saltando..."
        return 0
    fi

	# USO DE -E (Extended Regex) y delimitadores seguros
	if sed -i -E "s|$search|$replace|g" "$file"; then
		if grep -qF "$replace" "$file"; then
			log_success "Modificado: $file ($replace)."
		else
			log_warn "No se produjo cambio en $file. ¿La regex coincidia con algo? (${search})."
		fi
	else
		log_error "Falló la edición con sed en $file."
		return 1
	fi
}

mask_service() {
	local service="$1"

	if systemctl is-enabled "$service" 2>/dev/null | grep -q masked; then
		log_info "${service} ya está enmascarado."
  	else
		log_info "Enmascarando el servicio de ${service}."
		if systemctl mask $service 2>/dev/null; then
			log_success "Se ha deshabilitado el servicio ${service}."
		else
			log_error "No se ha podido deshabilitar el servicio ${service}."
		fi
	fi
}

enable_service() {
	local servicio="$1"
	local descripcion="$2"

	log_info "Habilitando el servicio de ${servicio}."

	if ! systemctl list-unit-files | grep -qw "${servicio}.service"; then
		log_info "$descripcion no está instalado."
		return
	fi

	if systemctl is-enabled "$servicio" &>/dev/null; then
		log_info "$descripcion ya está habilitado."
	else
		if systemctl enable --now "$servicio" &>/dev/null; then
			log_success "$descripcion habilitado."
		else
			log_error "Error al habilitar $descripcion."
		fi
	fi
}

disable_service() {
	local servicio="$1"
	local descripcion="${2:-$1}"

	log_info "Deshabilitando el servicio de ${servicio}."

	if ! systemctl list-unit-files | grep -qw "${servicio}.service"; then
		log_info "$descripcion no está instalado."
		return
	fi

	if ! systemctl is-enabled "$servicio" &>/dev/null; then
		log_info "$descripcion ya está deshabilitado."
	else
		if systemctl disable --now "$servicio" &>/dev/null; then
			log_success "$descripcion deshabilitado."
		else
			log_error "Error al deshabilitar $descripcion."
		fi
	fi
}

unmask_service() {
	local servicio="$1"
	local descripcion="${2:-$1}"

	log_info "Desenmascarando el servicio de ${servicio}."

	if ! systemctl list-unit-files | grep -qw "${servicio}.service"; then
		log_info "$descripcion no está instalado."
		return
	fi

	if systemctl is-enabled "$servicio" 2>/dev/null | grep -q masked; then
		if systemctl unmask "$servicio" &>/dev/null; then
			log_info "$descripcion desenmascarado."
		else
			log_error "Error al desenmascarar $descripcion."
			return
		fi
	else
		log_info "$descripcion ya está desenmascarado."
	fi

	# Habilitar tras desenmascarar
	if systemctl enable --now "$servicio" &>/dev/null; then
		log_success "$descripcion habilitado."
	else
		log_error "Error al habilitar $descripcion."
	fi
}