#!/bin/bash

# Colores
CYAN='\033[1;36m'
GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m' 

clear

echo -e "${CYAN}----------------------------------------------------------------------"
echo -e "  CCN-STIC-610 - Directiva de Privilegios de Usuario en RHEL"
echo -e "----------------------------------------------------------------------"
echo
echo -e "Este script aplica las siguientes directivas de seguridad:"
echo -e "    - Restricciones de recursos (CPU, memoria, ficheros, sesiones)"
echo -e "    - Eliminación de usuarios innecesarios"
echo
echo -e "Antes de ejecutar este script debe asegurarse de:"
echo -e "    - Ejecutarlo con privilegios de root"
echo -e "    - Tener backup de /etc/security/limits.conf"
echo -e "    - Comprobar si hay servicios que dependan de cuentas específicas"
echo
echo -e "----------------------------------------------------------------------${NC}"
echo

read -n1 -r -p "Pulse cualquier tecla para continuar..."

# Variables 
USUARIOS_ELIMINAR="tcpdum flatpak wsdd games operator mail halt"
QUOTA_MEM_PROC="8388608"
MAX_OPEN_FILES="50000"
MAX_PROCESSES="4096"
MAX_SESIONES="4"
MAX_FILE_SIZE="10485760"


echo "[+] Configurando límites de recursos..."

# Crear o editar /etc/security/limits.conf
cat >> /etc/security/limits.conf << EOF

# CCN-STIC - Límites de usuario
*    hard    rss             ${QUOTA_MEM_PROC}
*    hard    nofile          ${MAX_OPEN_FILES}
*    hard    nproc           ${MAX_PROCESSES}
*    hard    fsize           ${MAX_FILE_SIZE}
*    hard    maxlogins       ${MAX_SESIONES}
EOF

echo "[+] Eliminando usuarios innecesarios..."
for user in ${USUARIOS_ELIMINAR}; do
    id "$user" &>/dev/null && userdel -r "$user"
done


echo
echo -e "${GREEN}---------------------------------------------------------------"
echo -e " CCN-STIC-610 Privilegios: CONFIGURACIÓN APLICADA "
echo -e " Revise manualmente las configuraciones aplicadas"
echo -e "---------------------------------------------------------------${NC}"

read -n1 -r -p "Pulse cualquier tecla para finalizar..."
