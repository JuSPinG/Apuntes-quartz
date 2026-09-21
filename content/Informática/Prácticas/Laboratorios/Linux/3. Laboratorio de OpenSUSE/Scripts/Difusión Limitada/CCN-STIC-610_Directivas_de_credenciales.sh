#!/bin/bash

source "$(dirname "$0")/lib.sh"

clear

echo -e "${CYAN}------------------------------------------------------------------"
echo -e "    CCN-STIC-610 - Directiva de Credenciales en OpenSUSE"
echo -e "------------------------------------------------------------------"
echo
echo -e "Este script aplica las siguientes directivas de seguridad:"
echo -e "    - Historial de contraseñas"
echo -e "    - Requisitos de complejidad (mayúsculas, minúsculas, dígitos, caracteres especiales)"
echo -e "    - Longitud mínima"
echo -e "    - Vigencia máxima y mínima"
echo -e "    - Caducidad de contraseñas por usuario"
echo -e "    - Desactivación de la cuenta root"
echo
echo -e "Antes de ejecutar este script debe asegurarse de:"
echo -e "    - Ejecutarlo con privilegios de root"
echo -e "    - Disponer de copia de seguridad de los siguientes ficheros:"
echo -e "        /etc/security/pwquality.conf"
echo -e "        /etc/login.defs"
echo -e "        /etc/pam.d/common-password"
echo
echo -e "------------------------------------------------------------------${NC}"
echo

read -n1 -r -p "Pulse cualquier tecla para continuar..."

# Verificar root
check_root

# Variables
MIN_LEN="10"
MIN_UPPER="1"
MIN_LOWER="1"
MIN_DIGIT="1"
MIN_SPECIAL="1"
PASS_HISTORY="24"
MAX_DAYS="60"
MIN_DAYS="2"

# 1. Configurar la longitud y composición de la contraseña
AUTH_CONF="/etc/security/pwquality.conf"
do_backup $AUTH_CONF
log_info "Aplicando configuración de complejidad en $AUTH_CONF..."

replace_in_file "^[[:space:]]*#[[:space:]]*minlen.*" "minlen = $MIN_LEN" "$AUTH_CONF"
replace_in_file "^[[:space:]]*#[[:space:]]*dcredit.*" "dcredit = -$MIN_DIGIT" "$AUTH_CONF"
replace_in_file "^[[:space:]]*#[[:space:]]*ucredit.*" "ucredit = -$MIN_UPPER" "$AUTH_CONF"
replace_in_file "^[[:space:]]*#[[:space:]]*lcredit.*" "lcredit = -$MIN_LOWER" "$AUTH_CONF"
replace_in_file "^[[:space:]]*#[[:space:]]*ocredit.*" "ocredit = -$MIN_SPECIAL" "$AUTH_CONF"

# 2. Configurar vigencia y reutilización de contraseñas
DEFS="/etc/login.defs"
do_backup "$DEFS"
log_info "Configurando vigencia en $DEFS..."
replace_in_file "^PASS_MAX_DAYS.*" "PASS_MAX_DAYS   $MAX_DAYS" "$DEFS"
replace_in_file "^PASS_MIN_DAYS.*" "PASS_MIN_DAYS   $MIN_DAYS" "$DEFS"

# 3. Historial de contraseñas (ARCHIVO CORRECTO: common-password)
AUTH_FILE="/etc/pam.d/common-password"
do_backup $AUTH_FILE

# A. Complejidad (Requisite = si falla, para aquí)
replace_in_file "password[[:space:]]\+requisite[[:space:]]\+pam_cracklib.so.*" "password    requisite     pam_pwquality.so retry=3 config=/etc/security/pwquality.conf" "$AUTH_FILE"
# B. Historial (Required = debe pasar por aquí)
if grep -Eq 'pam_pwhistory[.]so' "$AUTH_FILE"; then
	replace_in_file \
		"password.*pam_pwhistory[.]so.*" \
	  	"password    required      pam_pwhistory.so remember=$PASS_HISTORY retry=3" \
		"$AUTH_FILE"
else
	log_info "Insertando pam_pwhistory.so..."

	# Insertar justo antes de pam_unix.so
	sed -i '/password.*pam_unix[.]so/i password    required      pam_pwhistory.so remember='"$PASS_HISTORY"' retry=3' "$AUTH_FILE"

	if grep -Eq 'pam_pwhistory[.]so' "$AUTH_FILE"; then
		log_success "Insertado pam_pwhistory.so correctamente."
	else
		log_warn "No se pudo insertar pam_pwhistory.so."
	fi
fi
# C. Guardado (Sufficient = si llegas aquí y todo va bien, dale paso)
# IMPORTANTE: Usamos 'sufficient' y quitamos 'nullok'
replace_in_file "password.*pam_unix.so.*" "password    sufficient    pam_unix.so sha512 shadow use_authtok" "$AUTH_FILE"

# 4. Aplicar caducidad de contraseñas con chage
for LOGIN in $(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd); do
	log_info "Aplicando política de expiración a: $LOGIN"
	chage -m "$MIN_DAYS" -M "$MAX_DAYS" -W 12 "$LOGIN"
	log_success "Política aplicada"
done

# 6. Asegurar que Sudo no dependa de la contraseña de Root
do_backup "/etc/sudoers"
log_info "Configurando sudoers para evitar bloqueos (desactivando targetpw, permisos a wheel)..."

# Descomentar/Eliminar Defaults targetpw
sed -i 's/^Defaults targetpw/#Defaults targetpw/g' /etc/sudoers
sed -i 's/^Defaults runaspw/#Defaults runaspw/g' /etc/sudoers
log_success "Deshabilitado targetpw, se pedirá la contraseña del usuario."

replace_in_file "^#[[:space:]]%wheel ALL=(ALL:ALL) ALL" "%wheel ALL=(ALL:ALL) ALL" "/etc/sudoers"

# 5. Deshabilitar la cuenta root
log_warn "Último paso: Deshabilitar cuenta root."
log_warn "Asegúrese de que su usuario actual puede usar 'sudo' correctamente."
read -p "¿Desea bloquear la cuenta root ahora? (s/n): " RESP
if [[ "$RESP" =~ ^[sS]$ ]]; then
	passwd -l root
	log_success "Acceso directo a root deshabilitado."
else
	log_info "Bloqueo de root cancelado por el usuario."
fi

echo
echo -e "${GREEN}------------------------------------------------------------------------------"
echo -e " CCN-STIC-610 Directivas de credenciales: CONFIGURACIÓN APLICADA"
echo -e " Es posible que para aplicar ciertos cambios sea necesario reiniciar el sistema"
echo -e "------------------------------------------------------------------------------${NC}"

read -n1 -r -p "Pulse cualquier tecla para finalizar..."