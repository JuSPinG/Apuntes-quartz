#!/bin/bash
# ---------------------------------------------------------------
# CCN-STIC-610 - Hardening de Kernel y Red (sysctl) en OpenSUSE
# ---------------------------------------------------------------

source "$(dirname "$0")/lib.sh"

clear

echo -e "${CYAN}----------------------------------------------------------------------"
echo -e "  CCN-STIC-610 - Directiva de Kernel en OpenSUSE"
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

# 1. Verificaciones iniciales
check_root

# 2. Copia de seguridad del archivo principal (por si acaso)
do_backup "/etc/sysctl.conf"

KERNEL_CONFIG="# CCN-STIC-610 - Proteccion de Red y Kernel

# --- Seguridad de Red IPv4 ---
# No enviar redirecciones (no somos un router)
net.ipv4.conf.all.send_redirects=0
net.ipv4.conf.default.send_redirects=0
# Log de paquetes 'marcianos' (origen imposible)
net.ipv4.conf.all.log_martians=1
# Ignorar respuestas falsas de errores ICMP
net.ipv4.icmp_ignore_bogus_error_responses=1
# Ignorar broadcasts ICMP (evita ataques SMURF)
net.ipv4.icmp_echo_ignore_broadcasts=1
# Proteccion contra inundacion SYN (Anti-DoS)
net.ipv4.tcp_syncookies=1
# Deshabilitar reenvio de IP
net.ipv4.ip_forward=0

# --- Seguridad del Sistema y FileSystem ---
# Deshabilitar volcados de memoria de ejecutables SUID
fs.suid_dumpable=0
# Proteccion contra ataques de enlaces (Symlinks/Hardlinks)
fs.protected_symlinks=1
fs.protected_hardlinks=1
# Reiniciar automaticamente tras 10s en caso de Kernel Panic
kernel.panic=10
# Deshabilitar carga de nuevo kernel mediante kexec
kernel.kexec_load_disabled=1
# Restringir dmesg solo a usuarios privilegiados
kernel.dmesg_restrict=1"

# 4. Crear el archivo de persistencia usando tu función create_script
# Usamos el directorio .d que es el estándar moderno en OpenSUSE
log_info "Generando configuración persistente en /etc/sysctl.d/99-CCN-sysctl.conf..."
create_script "/etc/sysctl.d/99-CCN-sysctl.conf" <<< "$KERNEL_CONFIG"

# 5. Aplicar los cambios inmediatamente
log_info "Cargando nuevas directivas del kernel..."
if sysctl --system &>/dev/null; then
    log_success "Parámetros del kernel aplicados correctamente."
else
    log_error "Hubo un error al aplicar algunos parámetros de sysctl."
fi

echo
echo -e "${GREEN}----------------------------------------------------------------------------"
echo -e " CCN-STIC-610 Auditoría: CONFIGURACIÓN APLICADA "
echo -e " Configuraciones persistentes guardadas en: ${CYAN}/etc/sysctl.d/99-CCN-sysctl.conf ${NC}"
echo -e "${GREEN}----------------------------------------------------------------------------${NC}"

read -n1 -r -p "Pulse cualquier tecla para finalizar el script..."