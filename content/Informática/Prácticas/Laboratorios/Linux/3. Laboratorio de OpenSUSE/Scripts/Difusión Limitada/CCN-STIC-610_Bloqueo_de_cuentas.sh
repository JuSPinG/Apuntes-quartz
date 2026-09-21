#!/bin/bash

source "$(dirname "$0")/lib.sh"

clear

echo -e "${CYAN}------------------------------------------------------------------"
echo -e "    CCN-STIC-610 - Bloqueo de Cuentas en OpenSUSE"
echo -e "------------------------------------------------------------------"
echo
echo -e "Este script aplica las siguientes directivas de seguridad:"
echo -e "    - Duración del bloqueo de cuenta"
echo -e "    - Permitir bloqueo de cuenta de administrador"
echo -e "    - Restablecer recuento tras X intentos fallidos"
echo -e "    - Umbral de intentos antes de bloquear la cuenta"
echo
echo -e "Antes de ejecutar este script debe asegurarse de:"
echo -e "    - Ejecutarlo con privilegios de root"
echo -e "    - Disponer de copia de seguridad de:"
echo -e "        /etc/pam.d/common-auth"
echo -e "        /etc/pam.d/common-account"
echo -e "        /etc/security/faillock.conf (si existe)"
echo
echo -e "------------------------------------------------------------------${NC}"
echo

read -n1 -r -p "Pulse cualquier tecla para continuar..."

check_root

# VARIABLES
DENY_VALUE="5"              # Nº intentos fallidos antes de bloquear
UNLOCK_TIME="0"             # Segundos de espera para desbloquear
FAIL_INTERVAL="900"         # Tiempo (en seg) para contar los fallos
ALLOW_ROOT_BLOCK="1"        # 1 para bloquear root, 0 para no

PAM_AUTH="/etc/pam.d/common-auth"
PAM_ACCOUNT="/etc/pam.d/common-account"
FAILLOCK_CONF="/etc/security/faillock.conf"

# BACKUPS
do_backup "$PAM_AUTH"
do_backup "$PAM_ACCOUNT"
do_backup "$FAILLOCK_CONF"

# CONFIGURACIÓN
create_script "$FAILLOCK_CONF" << EOF
deny=$DENY_VALUE
unlock_time=$UNLOCK_TIME
fail_interval=$FAIL_INTERVAL
$( [[ "$ALLOW_ROOT_BLOCK" == "1" ]] && echo "even_deny_root" )
EOF

insert_before_first_match() {
	local file="$1"
	local anchor_re="$2"
	local block="$3"
	local marker_re="$4"

	log_info "Realizando modificación en ${file}."

	[[ -f "$file" ]] || { log_error "Archivo no encontrado: $file"; return 1; }

	if grep -Eq "$marker_re" "$file"; then
		log_info "El cambio ya estaba aplicado en $file. Saltando..."
		return 0
	fi

	local tmp
	tmp="$(mktemp)" || return 1

	if awk -v re="$anchor_re" -v block="$block" '
		BEGIN {
			n = split(block, lines, "\n")
			inserted = 0
		}
		{
			if (!inserted && $0 ~ re) {
				for (i = 1; i <= n; i++) print lines[i]
				inserted = 1
			}
			print
		}
		END {
			if (!inserted) exit 2
		}
	' "$file" > "$tmp"; then
		mv "$tmp" "$file"
	else
		rm -f "$tmp"
		log_warn "No se produjo cambio en $file."
		return 1
	fi

	grep -Eq "$marker_re" "$file" \
		&& log_success "Modificado: $file." \
		|| log_warn "No se produjo cambio en $file."
}

replace_first_match() {
	local file="$1"
	local search_re="$2"
	local replacement="$3"
	local marker_re="$4"

	log_info "Realizando modificación en ${file}."

	[[ -f "$file" ]] || { log_error "Archivo no encontrado: $file"; return 1; }

	if grep -Eq "$marker_re" "$file"; then
		log_info "El cambio ya estaba aplicado en $file. Saltando..."
		return 0
	fi

	local tmp
	tmp="$(mktemp)" || return 1

	if awk -v re="$search_re" -v repl="$replacement" '
		BEGIN { done = 0 }
		{
			if (!done && $0 ~ re) {
				print repl
				done = 1
				next
			}
			print
		}
		END {
			if (!done) exit 2
		}
	' "$file" > "$tmp"; then
		mv "$tmp" "$file"
	else
		rm -f "$tmp"
		log_warn "No se produjo cambio en $file."
		return 1
	fi

	grep -Eq "$marker_re" "$file" \
		&& log_success "Modificado: $file." \
		|| log_warn "No se produjo cambio en $file."
}

# --- common-auth ---
# 1) preauth antes de pam_unix
insert_before_first_match \
	"$PAM_AUTH" \
	'^auth[[:space:]]+required[[:space:]]+pam_unix[.]so[[:space:]]+try_first_pass[[:space:]]*$' \
	$'auth     required      pam_faillock.so preauth' \
	'^auth[[:space:]]+required[[:space:]]+pam_faillock[.]so[[:space:]]+preauth[[:space:]]*$'

# 2) sustituir pam_unix por el bloque correcto de control
replace_first_match \
	"$PAM_AUTH" \
	'^auth[[:space:]]+required[[:space:]]+pam_unix[.]so[[:space:]]+try_first_pass[[:space:]]*$' \
	$'auth     [success=1 default=bad] pam_unix.so try_first_pass\nauth     [default=die] pam_faillock.so authfail\nauth     sufficient     pam_faillock.so authsucc' \
	'^auth[[:space:]]+\[success=1 default=bad\][[:space:]]+pam_unix[.]so[[:space:]]+try_first_pass[[:space:]]*$'

# --- common-account ---
replace_first_match \
	"$PAM_ACCOUNT" \
	'^account[[:space:]]+required[[:space:]]+pam_unix[.]so[[:space:]]+try_first_pass[[:space:]]*$' \
	$'account  required      pam_faillock.so\naccount  required      pam_unix.so     try_first_pass' \
	'^account[[:space:]]+required[[:space:]]+pam_faillock[.]so[[:space:]]*$'

echo
echo -e "${GREEN}----------------------------------------------------------------"
echo -e " CCN-STIC-610 Bloqueo de cuentas : CONFIGURACIÓN APLICADA "
echo -e " Revise /etc/security/faillock.conf, /etc/pam.d/common-auth y /etc/pam.d/common-account"
echo -e "----------------------------------------------------------------${NC}"

read -n1 -r -p "Pulse cualquier tecla para finalizar..."