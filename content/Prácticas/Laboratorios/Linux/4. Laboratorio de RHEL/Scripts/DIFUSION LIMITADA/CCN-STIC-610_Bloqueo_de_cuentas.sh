#!/bin/bash

# Colores
CYAN='\033[1;36m'
GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m' 

clear


echo -e "${CYAN}------------------------------------------------------------------"
echo -e "    CCN-STIC-610 - Bloqueo de Cuentas en RHEL"
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
echo -e "        /etc/pam.d/system-auth"
echo -e "        /etc/security/faillock.conf (si existe)"
echo
echo -e "------------------------------------------------------------------${NC}"
echo

read -n1 -r -p "Pulse cualquier tecla para continuar..."

# VARIABLES
DENY_VALUE="5"              # Nº intentos fallidos antes de bloquear
UNLOCK_TIME="0"             # Segundos de espera para desbloquear
FAIL_INTERVAL="900"           # Tiempo (en seg) para contar los fallos
ALLOW_ROOT_BLOCK="1"        # 1 para bloquear root, 0 para no

# Ficheros
PAM_FILE="/etc/pam.d/system-auth"
FAILLOCK_CONF="/etc/security/faillock.conf"

# BACKUPS
echo "[+] Creando copia de seguridad de $PAM_FILE..."
cp "$PAM_FILE" "${PAM_FILE}.bak_$(date +%F_%H-%M-%S)" || { echo -e "${RED}[!] Error al crear backup${NC}"; exit 1; }

if [ -f "$FAILLOCK_CONF" ]; then
    echo "[+] Copia de seguridad de $FAILLOCK_CONF..."
    cp "$FAILLOCK_CONF" "${FAILLOCK_CONF}.bak_$(date +%F_%H-%M-%S)"
else
    echo "[+] $FAILLOCK_CONF no existe, se creará."
    touch "$FAILLOCK_CONF"
fi

# CONFIGURACIÓN
echo "[+] Aplicando configuración en $FAILLOCK_CONF..."

cat > "$FAILLOCK_CONF" << EOF
deny = $DENY_VALUE
unlock_time = $UNLOCK_TIME
fail_interval = $FAIL_INTERVAL
even_deny_root = $ALLOW_ROOT_BLOCK
EOF

# VERIFICAR SI LAS LLAMADAS A pam_faillock ESTÁN EN system-auth
if grep -q "pam_faillock.so" "$PAM_FILE"; then
    echo "[*] pam_faillock.so ya está configurado en $PAM_FILE. No se modifica."
else
    echo "[+] Insertando llamadas seguras a pam_faillock.so..."

    sed -i "/^auth.*required.*pam_env.so/a auth        required      pam_faillock.so preauth" "$PAM_FILE"
    sed -i "/^auth.*sufficient.*pam_unix.so/a auth        [default=die] pam_faillock.so authfail" "$PAM_FILE"
    sed -i "/^account.*required.*pam_unix.so/a account     required      pam_faillock.so" "$PAM_FILE"
fi

echo
echo -e "${GREEN}----------------------------------------------------------------"
echo -e " CCN-STIC-610 Bloqueo de cuentas : CONFIGURACIÓN APLICADA "
echo -e " Revise /etc/security/faillock.conf y /etc/pam.d/system-auth"
echo -e "----------------------------------------------------------------${NC}"

read -n1 -r -p "Pulse cualquier tecla para finalizar..."