#!/bin/bash
# ==============================================================================
# CCN-STIC-610 - Auditoría Global de Configuración en RHEL
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
	"/etc/sysctl.d/*"
	"/etc/sysctl.conf"
	"/etc/ssh/sshd_config"
	"/etc/audit/rules.d/audit.rules"
	"/etc/pam.d/*"
	"/etc/pam.d/password-auth"
	"/etc/pam.d/system-auth"
	"/etc/security/limits.conf"
	"/etc/login.defs"
	"/etc/security/pwquality.conf"
	"/etc/modprobe.d/limites_archivos.conf"
	"/etc/modprobe.d/limites-wireless.conf"
	"/etc/usbguard/usbguard-daemon.conf"
)

# Función principal de backup
backup() {
    [[ $# -eq 0 ]] && return 1

    local f="$1"
    local timestamp=$(date +%F_%H%M%S)

    # 1. Detectamos si la ruta termina literalmente en "/*"
    if [[ "$f" == *"/*" ]]; then
        
        # Extraemos la ruta real (quitamos el "/*" del final)
        local target_dir="${f%/*}"

        # Comprobamos que el directorio base exista
        if [[ ! -d "$target_dir" ]]; then
            echo -e "${YELLOW}[WARN] El directorio base no existe: $target_dir${NC}"
            return 1
        fi

        # Creamos la carpeta destino con el sufijo de tiempo (Ej: /etc/sysctl.d_2026...)
        local dest="${target_dir}_$timestamp"
        mkdir -p "$dest"

        # Copiamos todo el contenido al nuevo destino
        # Usar "/." copia todo lo de dentro (incluyendo archivos ocultos) sin fallar si está vacío
        cp -a "$target_dir/." "$dest/"
        
        echo -e "${GREEN}[OK] Backup de directorio completado: $dest${NC}"
        return 0
    fi

    # 2. Lógica normal para archivos individuales o rutas normales
    if [[ ! -e "$f" ]]; then
        echo -e "${YELLOW}[WARN] No existe: $f${NC}"
        return 1
    fi

    local dest="${f}.bak_$timestamp"
    cp -a "$f" "$dest"
    echo -e "${GREEN}[OK] Backup individual: $dest${NC}"
}

# For para recorrer todos los archivos
for archivo in "${ARCHIVOS[@]}"; do
	backup "$archivo"
done

echo
echo -e "${CYAN}[INFO] Ejecute \`sudo find /etc -name '*.bak_$(date +%F)*'\` para ver todas las copias.${NC}"