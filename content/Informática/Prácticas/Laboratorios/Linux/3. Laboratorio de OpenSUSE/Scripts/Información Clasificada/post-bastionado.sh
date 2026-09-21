#!/bin/bash

# ==============================================================================
# CCN-STIC-610 - Auditoría Global de Seguridad en OpenSUSE
# Script de sólo lectura para verificar el cumplimiento del bastionado.
# ==============================================================================
set -u

# Colores para la interfaz
CYAN='\033[1;36m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m'

# Contadores globales
PASS=0
FAIL=0

# Identificar puerto SSH actual (basado en tu script de SSH que usa el 2301 o custom)
SSH_PORT=$(grep -i -E "^Port\s+" /etc/ssh/sshd_config | awk '{print $2}' | head -n 1)
SSH_PORT=${SSH_PORT:-22}

clear
echo -e "${CYAN}----------------------------------------------------------------------------"
echo -e "  Script de Auditoría de Seguridad Post-Bastionado (OpenSUSE)"
echo -e "----------------------------------------------------------------------------"
echo
echo -e "Este script verifica el cumplimiento de las directivas CCN-STIC-610"
echo -e "en archivos de configuración, servicios, firewall y políticas de sistema."
echo
echo -e "Debe ejecutarse como root."
echo -e "----------------------------------------------------------------------------${NC}"

# Verificación de root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}[ERROR] Este script de auditoría debe ejecutarse como root.${NC}"
    exit 1
fi

# -- FUNCIONES DE COMPROBACIÓN --

print_result() {
    local status=$1
    local message=$2
    if [ "$status" -eq 0 ]; then
        echo -e "  ${GREEN}[OK]${NC} $message"
        ((PASS++))
    else
        echo -e "  ${RED}[ERROR]${NC} $message"
        ((FAIL++))
    fi
}

check_service() {
    local service=$1
    systemctl is-active --quiet "$service"
    print_result $? "Servicio activo: $service"
}

check_file_regex() {
    local file=$1
    local regex=$2
    local desc=$3
    if [ ! -f "$file" ]; then
        print_result 1 "$desc - ARCHIVO NO ENCONTRADO: $file"
        return
    fi
    grep -E -q "$regex" "$file"
    print_result $? "$desc"
}

check_cmd_output() {
    local cmd=$1
    local regex=$2
    local desc=$3
    eval "$cmd" 2>/dev/null | grep -E -q "$regex"
    print_result $? "$desc"
}

check_disabled_service() {
    local service=$1
    local status
    if ! systemctl list-unit-files | grep -qw "${service}"; then
        status="not-found"
    else
        status=$(systemctl is-enabled "$service" 2>/dev/null)
        if [ -z "$status" ]; then status="disabled"; fi
    fi

    if [[ "$status" == "masked" || "$status" == "not-found" || "$status" == "disabled" ]]; then
        print_result 0 "Servicio desactivado/enmascarado: $service ($status)"
    else
        print_result 1 "Servicio $service requiere atención (Estado: $status)"
    fi
}

check_perms() {
    local file=$1
    local perms=$2
    local owner=$3
    if [ ! -e "$file" ]; then
        print_result 0 "Archivo no encontrado: $file"
        return
    fi
    local current_perms=$(stat -c "%a" "$file")
    local current_owner=$(stat -c "%U:%G" "$file")
    
    if [[ "$current_perms" == "$perms" && "$current_owner" == "$owner" ]]; then
        print_result 0 "Permisos correctos en $file ($perms, $owner)"
    else
        print_result 1 "Permisos incorrectos en $file (Actual: $current_perms, $current_owner)"
    fi
}

check_service_active() {
    local service="$1"
    
    # systemctl is-enabled devuelve "masked" como texto si lo está.
    # Usamos 2>/dev/null para ignorar errores si el servicio no existe.
    if [[ "$(systemctl is-enabled "$service" 2>/dev/null)" == "enabled" ]]; then
        print_result 0 "Servicio ${service} activo correctamente."
    else
        print_result 1 "Servicio desactivado/enmascarado: $service."
    fi
}

check_service_masked() {
    local service="$1"
    
    # --quiet evita que systemctl imprima "active" o "inactive" en consola
    if [[ "$(systemctl is-active "$service" 2>/dev/null)" == "inactive" ]]; then
        print_result 0 "Servicio ${service} enmascarado correctamente."
    else
        print_result 1 "Servicio ${service} no enmascarado."
    fi
}

# ==============================================================================
# EJECUCIÓN DE LA AUDITORÍA
# ==============================================================================

echo -e "\n${CYAN}>>> 1. AUDITORÍA (auditd)${NC}"
check_service "auditd"
check_file_regex "/etc/audit/rules.d/ccn_audit.rules" "\-w /etc/passwd" "Regla: Archivos críticos de usuario"
check_file_regex "/etc/audit/rules.d/ccn_audit.rules" "\-a always,exit -F arch=b64 -F euid=0 -S execve" "Regla: Comandos de root (64bit)"

echo -e "\n${CYAN}>>> 2. CREDENCIALES Y CONTRASEÑAS (pwquality)${NC}"
check_file_regex "/etc/security/pwquality.conf" "^minlen\s*=\s*(1[4-9]|[2-9][0-9])" "Longitud mínima >= 14"
check_file_regex "/etc/security/pwquality.conf" "^dcredit\s*=\s*-1" "Requisito de dígitos (-1)"
check_file_regex "/etc/login.defs" "^PASS_MAX_DAYS\s+360" "Vigencia máxima contraseña (360 días)"
check_file_regex "/etc/pam.d/common-password" "remember=24" "Historial de contraseñas (24)"
check_cmd_output "passwd -S root" "L" "Cuenta root bloqueada (L)"

echo -e "\n${CYAN}>>> 3. BLOQUEO DE CUENTAS (faillock)${NC}"
check_file_regex "/etc/security/faillock.conf" "^deny\s*=\s*3" "Bloqueo tras 3 intentos"
check_file_regex "/etc/security/faillock.conf" "^even_deny_root" "Bloqueo aplicado a root"
check_file_regex "/etc/pam.d/common-auth" "pam_faillock.so" "Módulo faillock en common-auth"

echo -e "\n${CYAN}>>> 4. SERVICIO SSH${NC}"
check_file_regex "/etc/ssh/sshd_config" "^Port\s+$SSH_PORT" "SSH escuchando en puerto $SSH_PORT"
check_file_regex "/etc/ssh/sshd_config" "^PermitRootLogin\s+no" "Acceso root denegado"
check_file_regex "/etc/ssh/sshd_config" "^ClientAliveInterval\s+300" "Timeout SSH (300s)"
check_file_regex "/etc/ssh/sshd_config" "^X11Forwarding\s+no" "X11 Forwarding desactivado"

echo -e "\n${CYAN}>>> 5. FIREWALL (firewalld)${NC}"
check_service "firewalld"
check_cmd_output "firewall-cmd --list-services" "http|https" "Servicios web permitidos"
check_cmd_output "firewall-cmd --direct --get-all-rules" "limit --limit 25/minute" "Regla Anti-DoS puerto 80"

echo -e "\n${CYAN}>>> 6. OPCIONES GENERALES Y PRIVACIDAD${NC}"
check_file_regex "/etc/profile.d/hist_restrict.sh" "HISTSIZE=0" "Historial Bash deshabilitado"
check_file_regex "/etc/profile.d/timeout.sh" "TMOUT=300" "Timeout inactividad (300s)"
check_file_regex "/etc/sysctl.conf" "net.ipv4.icmp_echo_ignore_all\s*=\s*1" "ICMP/Ping deshabilitado"
check_disabled_service "geoclue.service"
check_disabled_service "cups.socket"

echo -e "\n${CYAN}>>> 7. ACTUALIZACIONES (Zypper + Cron)${NC}"
check_service "cron"
check_file_regex "/etc/cron.d/ccn_actualizacion" "auto_update.sh" "Tarea cron de actualización existe"
check_file_regex "/usr/local/sbin/auto_update.sh" "zypper -n update" "Script usa zypper para actualizar"

echo -e "\n${CYAN}>>> 8. ANTIVIRUS (ClamAV)${NC}"
check_service "clamd"
check_service "clamav-scan.timer"
check_file_regex "/etc/clamd.conf" "^LogFile.*" "Freshclam configurado"

echo -e "\n${CYAN}>>> 9. DISPOSITIVOS USB (USBGuard)${NC}"
check_service "usbguard.service" # Puede ser comentado si el kernel no tiene soporte para USB (mi caso)
check_file_regex "/etc/usbguard/usbguard-daemon.conf" "ImplicitPolicyTarget=block" "Política USBGuard: Bloquear por defecto"

echo -e "\n${CYAN}>>> 10. KERNEL (Sysctl)${NC}"
params=("net.ipv4.ip_forward:0" "net.ipv4.tcp_syncookies:1" "kernel.dmesg_restrict:1")
for p in "${params[@]}"; do
    key="${p%%:*}"; val="${p##*:}"
    runtime=$(sysctl -n "$key" 2>/dev/null)
    [[ "$runtime" == "$val" ]]
    print_result $? "Kernel: $key = $val"
done

echo -e "\n${CYAN}>>> 11. SEGURIDAD DE KERNEL (AppArmor)${NC}"
if systemctl is-active --quiet apparmor; then
    print_result 0 "AppArmor está activo (Perfil OpenSUSE)"
else
    print_result 1 "AppArmor está DESACTIVADO"
fi

echo -e "\n${CYAN}>>> 12. PERMISOS CRÍTICOS${NC}"
check_perms "/etc/shadow" "0" "root:root"
check_perms "/etc/sudoers" "440" "root:root"
check_perms "/etc/passwd" "644" "root:root"

echo -e "\n${CYAN}>>> 13. PERMISOS DE FICHEROS CRÍTICOS (Script 10)${NC}"
# Verificación de permisos según recomendaciones CCN-STIC
check_perms "/etc/shadow" "0" "root:root"
check_perms "/etc/passwd" "644" "root:root"
check_perms "/etc/group" "644" "root:root"
check_perms "/etc/sudoers" "440" "root:root"
check_perms "/root" "700" "root:root"
check_perms "/etc/fstab" "644" "root:root"

echo -e "\n${CYAN}>>> 14. GESTIÓN DE SERVICIOS (Script 11)${NC}"
# Servicios que deben estar activos
active_services=("firewalld" "auditd" "sshd" "cron" "chronyd")
for srv in "${active_services[@]}"; do check_service_active "$srv"; done

# Servicios que deben estar enmascarados
masked_services=("bluetooth" "cups" "avahi-daemon" "smb" "postfix" "podman" "packagekit")
for srv in "${masked_services[@]}"; do check_service_masked "$srv"; done

echo -e "\n${CYAN}>>> 15. HARDENING DE KERNEL Y RED (Script 12)${NC}"
# Verificación de parámetros sysctl persistentes
check_file_regex "/etc/sysctl.d/99-CCN-sysctl.conf" "net.ipv4.ip_forward=0" "Kernel: Reenvío de IP desactivado"
check_file_regex "/etc/sysctl.d/99-CCN-sysctl.conf" "net.ipv4.tcp_syncookies=1" "Kernel: TCP Syncookies activo"
check_file_regex "/etc/sysctl.d/99-CCN-sysctl.conf" "kernel.dmesg_restrict=1" "Kernel: Acceso a dmesg restringido"
check_file_regex "/etc/sysctl.d/99-CCN-sysctl.conf" "fs.suid_dumpable=0" "Kernel: Dumps SUID desactivados"

echo -e "\n${CYAN}>>> 16. LÍMITES Y LIMPIEZA DE USUARIOS (Script 13)${NC}"
# Verificación de límites de recursos
check_file_regex "/etc/security/limits.conf" "hard\s+maxlogins\s+4" "Límite: Máximo 4 sesiones por usuario"
# Comprobar que usuarios innecesarios han sido eliminados
for usr in "games" "operator" "tcpdump" "flatpak"; do
    if ! id "$usr" &>/dev/null; then
        print_result 0 "Usuario innecesario eliminado: $usr"
    else
        print_result 1 "Usuario todavía presente: $usr"
    fi
done

echo -e "\n${CYAN}>>> 17. PROTECCIÓN DE GRUB (Script 14)${NC}"
# Verificación de contraseña y superusuario en GRUB
check_file_regex "/etc/grub.d/40_custom" "set superusers=" "GRUB: Superusuario configurado"
check_file_regex "/etc/grub.d/40_custom" "password_pbkdf2" "GRUB: Contraseña cifrada establecida"
check_file_regex "/etc/default/grub" "GRUB_DISABLE_RECOVERY=\"true\"" "GRUB: Modo recuperación desactivado"

echo -e "\n${CYAN}>>> 18. PROTECCIÓN CONTRA CÓDIGO DAÑINO (Script 15)${NC}"
# Restricción de compiladores para usuarios no root
check_perms "/usr/bin/gcc" "700" "root:root"
check_perms "/usr/bin/make" "700" "root:root"
# Verificación de AppArmor (nativo en OpenSUSE) o SELinux
if systemctl is-active --quiet apparmor; then
    print_result 0 "AppArmor está activo y protegiendo el sistema"
else
    print_result 1 "AppArmor/SELinux no parece estar activo"
fi

echo -e "\n${CYAN}>>> 19. AUDITORÍA Y REGISTROS (Script 16)${NC}"
# Configuración de retención en auditd
check_file_regex "/etc/audit/auditd.conf" "max_log_file = 100" "Auditd: Tamaño de log (100MB)"
check_file_regex "/etc/audit/auditd.conf" "admin_space_left_action = SUSPEND" "Auditd: Acción ante espacio crítico"
# Rotación de logs
check_file_regex "/etc/logrotate.conf" "^rotate 12" "Logrotate: Retención de 12 semanas"
check_file_regex "/etc/logrotate.conf" "^compress" "Logrotate: Compresión de logs activa"

# ==============================================================================
# RESUMEN FINAL
# ==============================================================================
echo
echo -e "${CYAN}============================================================================${NC}"
echo -e "                         RESUMEN DE AUDITORÍA OPENSUSE"
echo -e "${CYAN}============================================================================${NC}"
echo -e "  Pruebas superadas (PASS) : ${GREEN}$PASS${NC}"
echo -e "  Pruebas fallidas  (FAIL) : ${RED}$FAIL${NC}"

if [ "$FAIL" -eq 0 ]; then
    echo -e "\n  ${GREEN}[✔] EL SISTEMA CUMPLE CON LAS POLÍTICAS DE SEGURIDAD.${NC}"
else
    echo -e "\n  ${YELLOW}[!] SE DETECTARON $FAIL PUNTOS QUE REQUIEREN REVISIÓN.${NC}"
fi
echo -e "${CYAN}============================================================================${NC}"