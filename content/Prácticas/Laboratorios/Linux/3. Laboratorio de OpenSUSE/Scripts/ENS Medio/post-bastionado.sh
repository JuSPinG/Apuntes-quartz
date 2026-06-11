#!/bin/bash
# ==============================================================================
# AUDITORÍA GLOBAL DE BASTIONADO - OpenSUSE (Basado en Pasos 1-10)
# Script de sólo lectura para verificar el cumplimiento del bastionado.
# ==============================================================================
set -u

# Colores
CYAN='\033[1;36m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m'

# Contadores globales
PASS=0
FAIL=0

clear

echo -e "${CYAN}----------------------------------------------------------------------------"
echo -e "  Script de Auditoría de Seguridad Post-Bastionado (OpenSUSE)"
echo -e "----------------------------------------------------------------------------"
echo -e "Este script verifica que las configuraciones de los Scripts 1 al 10"
echo -e "se hayan aplicado correctamente."
echo -e "----------------------------------------------------------------------------${NC}"

# Verificación de root
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}[ERROR] Este script de auditoría debe ejecutarse como root.${NC}"
  exit 1
fi

#-- FUNCIONES DE COMPROBACIÓN --#

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

check_file_regex() {
    local file=$1; local regex=$2; local desc=$3
    if [ ! -f "$file" ]; then
        print_result 1 "$desc - ARCHIVO NO ENCONTRADO: $file"
        return
    fi
    # El "--" es vital para que grep no confunda el patrón "-w ..." con una opción
    grep -E -q -- "$regex" "$file"
    print_result $? "$desc"
}

check_cmd_output() {
    local cmd=$1
    local regex=$2
    local desc=$3
    # Usamos -z para que grep vea el archivo como una sola cadena larga (incluyendo saltos de línea)
    # y -P para poder usar \n (salto de línea)
    if eval "$cmd" 2>/dev/null | grep -zPq -- "$regex"; then
        print_result 0 "$desc"
    else
        print_result 1 "$desc"
    fi
}

# Verifica valores numéricos (mejor o igual)
# Modo "min": El valor actual debe ser >= al requerido (ej. longitud pass)
# Modo "max": El valor actual debe ser <= al requerido (ej. días de caducidad)
check_numeric_threshold() {
    local file=$1; local key=$2; local required=$3; local mode=$4; local desc=$5
    if [ ! -f "$file" ]; then print_result 1 "$desc (Falta $file)"; return; fi
    
    # Buscamos la línea, quitamos espacios y extraemos solo los números del final
    # Esto ignora si hay un "=" o no entre la clave y el valor
    local current=$(grep -E "^[[:space:]]*$key" "$file" | grep -oE '[0-9]+$' | head -n 1)
    
    # Validamos que 'current' sea realmente un número antes de comparar
    if [[ ! "$current" =~ ^[0-9]+$ ]]; then
        print_result 1 "$desc (No se pudo leer el valor numérico de $key)"
    else
        if [[ "$mode" == "min" ]]; then
            if [ "$current" -ge "$required" ]; then print_result 0 "$desc (Actual: $current, Requerido min: $required)";
            else print_result 1 "$desc (Actual: $current, Insuficiente)"; fi
        else
            if [ "$current" -le "$required" ]; then print_result 0 "$desc (Actual: $current, Requerido max: $required)";
            else print_result 1 "$desc (Actual: $current, Excesivo)"; fi
        fi
    fi
}

#-- INICIO DE PRUEBAS --#

echo -e "\n${YELLOW}>> 1. CONTRASEÑA DE GRUB (Paso 1)${NC}"
check_file_regex "/etc/grub.d/40_custom" "set superusers=\"root\"" "Superusuario GRUB configurado"
check_file_regex "/etc/grub.d/40_custom" "password_pbkdf2 root grub.pbkdf2.sha512" "Hash de contraseña GRUB presente"
check_cmd_output "stat -c %a /boot/grub2/grub.cfg" "600" "Permisos seguros en grub.cfg (600)"

echo -e "\n${YELLOW}>> 2. PAQUETES Y SERVICIOS INNECESARIOS (Paso 2)${NC}"
check_cmd_output "systemctl is-enabled wickedd-dhcp6 2>/dev/null || echo masked" "masked" "Servicio wickedd-dhcp6 enmascarado"

echo -e "\n${YELLOW}>> 3. PARÁMETROS DEL KERNEL - SYSCTL (Paso 3)${NC}"
for param in "net.ipv4.conf.all.send_redirects=0" "net.ipv4.tcp_syncookies=1" "fs.suid_dumpable=0" "net.ipv6.conf.all.disable_ipv6=1"; do
    key=$(echo $param | cut -d= -f1); val=$(echo $param | cut -d= -f2)
    check_cmd_output "sysctl $key" "$val" "Kernel: $key es $val"
done

echo -e "\n${YELLOW}>> 4. REGLAS DE AUDITORÍA (Paso 4)${NC}"
check_file_regex "/etc/audit/rules.d/audit.rules" "-w /etc/passwd -p wa -k passwd_changes" "Regla: Vigilancia de /etc/passwd"
check_file_regex "/etc/audit/rules.d/audit.rules" "-w /etc/sudoers -p wa -k actions" "Regla: Vigilancia de /etc/sudoers"
check_numeric_threshold "/etc/audit/auditd.conf" "max_log_file" 10 "min" "Auditd: Tamaño max log >= 10MB"
check_file_regex "/etc/audit/auditd.conf" "max_log_file_action = ROTATE" "Auditd: Acción ROTATE configurada"

echo -e "\n${YELLOW}>> 5. USUARIOS DEL SISTEMA (Paso 5)${NC}"
check_cmd_output "getent passwd games || echo ELIMINADO" "ELIMINADO" "Usuario 'games' eliminado"
check_cmd_output "grep '^nobody:' /etc/passwd" "/bin/false" "Usuario 'nobody' tiene shell /bin/false"
# Verificar que usuarios con UID < 1000 no tengan shell válida (ejemplo con bin)
check_cmd_output "grep '^bin:' /etc/passwd" "/bin/false" "Usuario 'bin' (UID < 1000) tiene shell /bin/false"

echo -e "\n${YELLOW}>> 6. ENTORNO Y BANNERS (Paso 6)${NC}"
check_file_regex "/etc/issue" "personal autorizado" "Banner legal TTY configurado"
check_file_regex "/etc/ssh/sshd_config" "^Banner /etc/issue.net" "SSH configurado para usar Banner"
check_file_regex "/etc/profile.d/90-tmout.sh" "TMOUT=600" "Timeout de sesión (TMOUT=600) en profile.d"
check_file_regex "/etc/xdg/kscreenlockerrc" "Autolock=true" "KDE: Bloqueo de pantalla automático activado"

echo -e "\n${YELLOW}>> 7. INTENTOS FALLIDOS - PAM (Paso 7)${NC}"
check_file_regex "/etc/pam.d/login" "pam_tally2.so deny=8" "PAM Login: Bloqueo tras 8 intentos"
check_file_regex "/etc/security/pwquality.conf" "minlen = 12" "PAM: Complejidad - Longitud mínima 12"
check_cmd_output "pam-config -q --pwhistory" "remember=24" "PAM: Historial de contraseñas (24)"

echo -e "\n${YELLOW}>> 8. LÍMITES Y LOGIN.DEFS (Paso 8)${NC}"
check_file_regex "/etc/security/limits.conf" "^soft[[:space:]]+core[[:space:]]+0" "Límites: Core dumps desactivados (soft)"
check_file_regex "/etc/security/limits.conf" "^hard[[:space:]]+core[[:space:]]+0" "Límites: Core dumps desactivados (hard)"
check_numeric_threshold "/etc/login.defs" "PASS_MAX_DAYS" 90 "max" "Caducidad contraseña <= 90 días"
check_numeric_threshold "/etc/login.defs" "PASS_MIN_DAYS" 10 "min" "Días mínimos entre cambios >= 10"
check_cmd_output "grep '^UMASK' /etc/login.defs" "02[0-7]" "UMASK configurado en 027 o más restrictivo"

echo -e "\n${YELLOW}>> 9. PERMISOS DE PARTICIONES (Paso 9)${NC}"
if findmnt /boot > /dev/null; then
    # Nota: Tu fstab actual dice 'data=ordered', si el bastionado funcionó, debería decir 'ro'
    check_cmd_output "findmnt -n -o OPTIONS /boot" "ro" "Partición /boot montada como Read-Only"
else
    print_result 1 "Partición /boot no encontrada"
fi

# 2. Comprobar /boot/efi (La partición UEFI)
if findmnt /boot/efi > /dev/null; then
    check_cmd_output "findmnt -n -o OPTIONS /boot/efi" "ro" "Partición /boot/efi montada como Read-Only"
else
    print_result 1 "Partición /boot/efi no encontrada"
fi

echo -e "\n${YELLOW}>> 10. CONFIGURACIÓN SSH (Paso 10)${NC}"
check_file_regex "/etc/ssh/sshd_config" "^PermitRootLogin no" "SSH: Login de root deshabilitado"
check_file_regex "/etc/ssh/sshd_config" "^MaxAuthTries [1-8]" "SSH: Máximo de intentos de auth <= 8"
check_file_regex "/etc/ssh/sshd_config" "^PasswordAuthentication yes" "SSH: Autenticación por contraseña permitida (según script)"
check_file_regex "/etc/ssh/sshd_config" "^X11Forwarding no" "SSH: X11Forwarding deshabilitado"

#-- RESUMEN FINAL --#
echo -e "\n${CYAN}=================================================================="
echo -e " RESULTADOS DE LA AUDITORÍA OPENSUSE"
echo -e "==================================================================${NC}"
echo -e " Controles superados:  ${GREEN}$PASS${NC}"
echo -e " Controles fallados:   ${RED}$FAIL${NC}"

if [ "$FAIL" -eq 0 ]; then
    echo -e "\n ${GREEN}[OK] El sistema cumple con el bastionado de los 10 pasos.${NC}"
else
    echo -e "\n ${RED}[ERROR] Se detectaron $FAIL vulnerabilidades o fallos de configuración.${NC}"
fi