#!/bin/bash


CYAN='\033[1;36m'
GREEN='\033[1;32m'
NC='\033[0m' 

clear

echo -e "${CYAN}------------------------------------------------------------------"
echo -e "    CCN-STIC-610 - Directiva de Credenciales en RHEL"
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
echo -e "        /etc/pam.d/system-auth"
echo
echo -e "------------------------------------------------------------------${NC}"
echo

read -n1 -r -p "Pulse cualquier tecla para continuar..."

# Variables
MIN_LEN="10"
MIN_UPPER="1"
MIN_LOWER="1"
MIN_DIGIT="1"
MIN_SPECIAL="1"
PASS_HISTORY="24"
MAX_DAYS="60"
MIN_DAYS="2"

echo "[+] Aplicando configuración de seguridad de contraseñas..."

# 1. Configurar la longitud y composición de la contraseña
AUTH_CONF="/etc/security/pwquality.conf"

echo "[+] Editando $AUTH_CONF..."
cp $AUTH_CONF ${AUTH_CONF}.bak_$(date +%F)

sed -i "s/^#*minlen.*/minlen = $MIN_LEN/" $AUTH_CONF
sed -i "s/^#*dcredit.*/dcredit = -$MIN_DIGIT/" $AUTH_CONF
sed -i "s/^#*ucredit.*/ucredit = -$MIN_UPPER/" $AUTH_CONF
sed -i "s/^#*lcredit.*/lcredit = -$MIN_LOWER/" $AUTH_CONF
sed -i "s/^#*ocredit.*/ocredit = -$MIN_SPECIAL/" $AUTH_CONF

# 2. Configurar vigencia y reutilización de contraseñas
echo "[+] Configurando historial y vigencia en /etc/login.defs..."
cp /etc/login.defs /etc/login.defs.bak_$(date +%F)

sed -i "s/^PASS_MAX_DAYS.*/PASS_MAX_DAYS   $MAX_DAYS/" /etc/login.defs
sed -i "s/^PASS_MIN_DAYS.*/PASS_MIN_DAYS   $MIN_DAYS/" /etc/login.defs

# 3. Configurar historial de contraseñas
echo "[+] Configurando historial de contraseñas en /etc/pam.d/system-auth..."
AUTH_FILE="/etc/pam.d/system-auth"
cp $AUTH_FILE ${AUTH_FILE}.bak_$(date +%F)

sed -i '/pam_unix.so.*remember/d' $AUTH_FILE
sed -i "/password.*requisite.*pam_pwquality.so.*/a password sufficient pam_unix.so sha512 shadow remember=$PASS_HISTORY use_authtok" $AUTH_FILE

# 4. Aplicar caducidad de contraseñas con chage
for LOGIN in $(cut -d: -f1 /etc/passwd); do
   USERID=$(id -u "$LOGIN" 2>/dev/null)
   if [ "$USERID" -ge 1000 ] 2>/dev/null; then
      echo "[*] Aplicando política de expiración a: $LOGIN"
      chage -m 2 -M 730 -W 12 "$LOGIN"
   fi
done


# 5. Deshabilitar la cuenta root
echo "[+] Deshabilitando el acceso directo a root..."
passwd -l root

echo
echo -e "${GREEN}------------------------------------------------------------------------------"
echo -e " CCN-STIC-610 Directivas de credenciales: CONFIGURACIÓN APLICADA"
echo -e " Es posible que para aplicar ciertos cambios sea necesario reiniciar el sistema"
echo -e "------------------------------------------------------------------------------${NC}"

read -n1 -r -p "Pulse cualquier tecla para finalizar..."