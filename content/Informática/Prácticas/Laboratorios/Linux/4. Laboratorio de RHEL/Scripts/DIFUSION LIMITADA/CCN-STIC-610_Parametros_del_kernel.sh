#!/bin/bash

# Colores 
CYAN='\033[1;36m'
GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m' 

clear

echo -e "${CYAN}----------------------------------------------------------------------"
echo -e "  CCN-STIC-610 - Directiva de Kernel en RHEL"
echo -e "----------------------------------------------------------------------"
echo
echo -e "Este script aplica las siguientes directivas de seguridad:"
echo -e "    - Restricción de comportamientos peligrosos en red y kernel"
echo -e "    - Control de exposición de procesos, BPF, dumps y trazas"
echo
echo -e "Antes de ejecutar este script debe asegurarse de:"
echo -e "    - Ejecutarlo con privilegios de root"
echo
echo -e "----------------------------------------------------------------------${NC}"


read -n1 -r -p "Pulse cualquier tecla para continuar..."

# Crear copia de seguridad
cp /etc/sysctl.conf /etc/sysctl.conf.bak.$(date +%F_%T)

# Hardening sysctl
sysctl -w net.ipv4.conf.all.send_redirects=0
sysctl -w net.ipv4.conf.all.log_martians=1
sysctl -w net.ipv4.icmp_ignore_bogus_error_responses=1
sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=1
sysctl -w net.ipv4.tcp_syncookies=1
sysctl -w net.ipv4.ip_forward=0

sysctl -w fs.suid_dumpable=0
sysctl -w fs.protected_symlinks=1
sysctl -w fs.protected_hardlinks=1
sysctl -w kernel.panic=10
sysctl -w kernel.kexec_load_disabled=1
sysctl -w kernel.dmesg_restrict=1

# Persistencia en /etc/sysctl.d
cat > /etc/sysctl.d/99-CCN-sysctl.conf <<EOF
# CCN-STIC-610 - Proteccion de Red y Kernel

# Red IPv4
net.ipv4.conf.all.send_redirects=0
net.ipv4.conf.all.log_martians=1
net.ipv4.icmp_ignore_bogus_error_responses=1
net.ipv4.icmp_echo_ignore_broadcasts=1
net.ipv4.tcp_syncookies=1
net.ipv4.ip_forward=0

# Kernel y sistema
fs.suid_dumpable=0
fs.protected_symlinks=1
fs.protected_hardlinks=1
kernel.panic=10
kernel.kexec_load_disabled=1
kernel.dmesg_restrict=1
EOF

# Aplicar cambios
sysctl --system

echo
echo -e "${GREEN}----------------------------------------------------------------------------"
echo -e " CCN-STIC-610 Auditoría: CONFIGURACIÓN APLICADA "
echo -e " Configuraciones persistentes guardadas en: ${CYAN}/etc/sysctl.d/99-CCN-sysctl.conf ${NC}"
echo -e "${GREEN}----------------------------------------------------------------------------${NC}"

read -n1 -r -p "Pulse cualquier tecla para finalizar el script..."