#!/bin/bash
# ---------------------------------------------------------------
# CCN-STIC-610 - Configuración Segura de SSH para RHEL (Interactivo)
# Versión mejorada con validación SELinux y entrada interactiva de puerto
# ---------------------------------------------------------------

CYAN='\033[1;36m'
GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m'

clear
echo -e "${CYAN}---------------------------------------------------------------"
echo -e "  CCN-STIC-610 - Seguridad del Servicio SSH en RHEL"
echo -e "---------------------------------------------------------------${NC}"
echo
echo "  - Autenticación segura y restricción de acceso"
echo "  - Banner informativo"
echo "  - Cambio de puerto SSH (interactivo)"
echo "  - Desactivación de root remoto"
echo "  - Validación SELinux y firewall"
echo
read -n1 -r -p "Pulse cualquier tecla para continuar..."

if [ "$EUID" -ne 0 ]; then
  echo -e "\n${RED}[!] Este script debe ejecutarse como root.${NC}"
  exit 1
fi

# Solicitar puerto SSH al usuario
echo
read -p "Ingrese el nuevo puerto SSH (por defecto 2301): " NEW_SSH_PORT
NEW_SSH_PORT=${NEW_SSH_PORT:-2301}

# Validar que el puerto sea numérico y válido
if ! [[ "$NEW_SSH_PORT" =~ ^[0-9]+$ ]] || [ "$NEW_SSH_PORT" -lt 1 ] || [ "$NEW_SSH_PORT" -gt 65535 ]; then
  echo -e "${RED}[!] Puerto no válido. Debe ser un número entre 1 y 65535.${NC}"
  exit 1
fi

# Variables
ALLOWED_USERS="${SUDO_USER:-$USER}"
ALLOWED_GROUPS="wheel"
BANNER_FILE="/etc/motd"

# Backup del archivo original
cp -v /etc/ssh/sshd_config /etc/ssh/sshd_config.bak_$(date +%F_%T)

# Configuración principal
sed -i -E "s/^#?Port .*/Port $NEW_SSH_PORT/" /etc/ssh/sshd_config
sed -i -E "s/^#?PermitRootLogin .*/PermitRootLogin no/" /etc/ssh/sshd_config
sed -i -E "s/^#?PermitEmptyPasswords .*/PermitEmptyPasswords no/" /etc/ssh/sshd_config
sed -i -E "s/^#?MaxAuthTries .*/MaxAuthTries 3/" /etc/ssh/sshd_config
sed -i -E "s/^#?LoginGraceTime .*/LoginGraceTime 30/" /etc/ssh/sshd_config
sed -i -E "s/^#?ClientAliveInterval .*/ClientAliveInterval 300/" /etc/ssh/sshd_config
sed -i -E "s/^#?ClientAliveCountMax .*/ClientAliveCountMax 0/" /etc/ssh/sshd_config
sed -i -E "s/^#?X11Forwarding .*/X11Forwarding no/" /etc/ssh/sshd_config
sed -i -E "s|^#?Banner .*|Banner $BANNER_FILE|" /etc/ssh/sshd_config

# Usuarios y grupos permitidos
grep -q "^AllowUsers" /etc/ssh/sshd_config && \
    sed -i -E "s/^AllowUsers.*/AllowUsers $ALLOWED_USERS/" /etc/ssh/sshd_config || \
    echo "AllowUsers $ALLOWED_USERS" >> /etc/ssh/sshd_config

grep -q "^AllowGroups" /etc/ssh/sshd_config && \
    sed -i -E "s/^AllowGroups.*/AllowGroups $ALLOWED_GROUPS/" /etc/ssh/sshd_config || \
    echo "AllowGroups $ALLOWED_GROUPS" >> /etc/ssh/sshd_config

# Banner legal
cat <<EOF > "$BANNER_FILE"
AVISO IMPORTANTE DE SEGURIDAD

Está usted accediendo a un equipo propiedad de la Organización.
El acceso no autorizado está prohibido y será registrado.
El uso del sistema implica la aceptación de las políticas de seguridad vigentes.
EOF
chmod 644 "$BANNER_FILE"

# Firewall
echo "[+] Añadiendo puerto $NEW_SSH_PORT al firewall..."
firewall-cmd --permanent --add-port=$NEW_SSH_PORT/tcp
firewall-cmd --reload

# SELinux: añadir puerto si procede
echo "[+] Comprobando configuración de SELinux..."
if command -v semanage &>/dev/null; then
    if semanage port -l | grep -q "$NEW_SSH_PORT"; then
        echo "[*] El puerto $NEW_SSH_PORT ya existe en SELinux, actualizando..."
        semanage port -m -t ssh_port_t -p tcp "$NEW_SSH_PORT"
    else
        echo "[*] Añadiendo puerto $NEW_SSH_PORT a SELinux..."
        semanage port -a -t ssh_port_t -p tcp "$NEW_SSH_PORT"
    fi
else
    echo -e "${RED}[!] Advertencia: semanage no está instalado.${NC}"
    echo "    SELinux podría bloquear el nuevo puerto ($NEW_SSH_PORT)."
    echo "    Ejecute: sudo dnf install policycoreutils-python-utils"
fi

# Reiniciar SSH
echo "[*] Reiniciando el servicio SSH..."
if systemctl restart sshd; then
    echo -e "${GREEN}[✔] SSH reiniciado correctamente.${NC}"
else
    echo -e "${RED}[✗] Error al reiniciar SSH.${NC}"
    exit 1
fi

echo
echo -e "${GREEN}---------------------------------------------------------------"
echo -e " CCN-STIC-610 Directivas SSH: CONFIGURACIÓN APLICADA "
echo -e " Puerto: $NEW_SSH_PORT"
echo -e " Usuario permitido: $ALLOWED_USERS"
echo -e " Grupo permitido: $ALLOWED_GROUPS"
echo -e " Revise /etc/ssh/sshd_config antes de cerrar la sesión."
echo -e "---------------------------------------------------------------${NC}"

read -n1 -r -p "Pulse cualquier tecla para finalizar..."
