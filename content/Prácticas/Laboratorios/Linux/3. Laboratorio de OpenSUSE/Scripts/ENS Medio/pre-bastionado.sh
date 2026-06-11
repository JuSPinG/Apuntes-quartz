#!/bin/bash
# ==============================================================================
# CCN-STIC-610 - Auditoría Global de Configuración en OpenSUSE
# Script de sólo escritura para guardar los archivos a ser modificados
# ==============================================================================
set -u

# Colores
CYAN='\033[1;36m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m'

clear

echo -e "${CYAN}----------------------------------------------------------------------------"
echo -e "  Script de pre-bastionado desarrollado por Marcos"
echo -e "----------------------------------------------------------------------------"
echo
echo -e "Este script permite identificar rápidamente qué archivos relativos a"
echo -e "contraseñas, PAM, auditoría, servicios, red, SSH, archivos, permisos"
echo -e "se van a modificar tras la posterior ejecución de scripts de bastionado"
echo
echo -e "Debe ejecutarse como root."
echo -e "----------------------------------------------------------------------------${NC}"
echo

# Comprobación de root
if [[ $EUID -ne 0 ]]; then
  echo -e "${RED}[ERROR] Debe ejecutar este script como root (sudo).${NC}"
  exit 1
fi


# Lista de archivos a ser modificados
# Se recomienda ejecutar antes el comando `grep -rE '["'\'']?((/|\./|\.\./)[^"'\''[:space:]]+)["'\'']?' /CARPETA` para ver casi tosos los archivos que se van a modificar
ARCHIVOS=(
		"/etc/grub.d/40_custom"
		"/boot/grub2/grub.cfg"
		"/boot/efi/EFI/suse/grub.cfg"
		"/etc/sysctl.conf"
		"/etc/audit/rules.d/audit.rules"
		"/etc/audit/auditd.conf"
		"/etc/audit/audit.rules"
		"/etc/passwd"
		"/etc/dconf/db/local.d"
		"/etc/dconf/db/gdm.d"
		"/etc/dconf/profile/user"
		"/etc/pam.d/login"
		"/etc/pam.d/su"
		"/etc/pam.d/gdm"
		"/etc/pam.d/common-password"
		"/etc/pam.d/common-auth"
		"/etc/pam.d/common-login"
		"/etc/security/pwquality.conf"
		"/etc/login.defs"
		"/etc/fstab"
		"/etc/ssh/sshd_config"
		"/etc/sddm.conf.d"
		"/usr/share/sddm/themes/breeze-corporativo/Main.qml"
		"/etc/sddm.conf.d/10-theme.conf"
		"/etc/xdg/kscreenlockerrc"
		"/etc/profile.d/90-tmout.sh"
		"/etc/xdg/kdeglobals"
		"/etc/xdg/kded5rc"
		"/etc/xdg/kded6rc"
		"/etc/xdg/kwinrc"
		"/etc/issue"
		"/etc/issue.net"
		"/etc/motd"
)

# Función principal de backup
backup() {
        local f="$1"

        if [[ ! -e "$f" ]]; then
                echo -e "${YELLOW}[WARN] No existe: $f${NC}"
                return 1
        fi

        local dest="${f}.bak_$(date +%F_%H%M%S)"
        cp -a "$f" "$dest"

        echo -e "${GREEN}[OK] Backup: $dest${NC}"
}

# For para recorrer todos los archivos
for archivo in "${ARCHIVOS[@]}"; do
        backup "$archivo"
done

echo
echo -e "${CYAN}[INFO] Ejecute \`sudo find /etc -name '*.bak_$(date +%F)*'\` para ver todas las copias.${NC}"