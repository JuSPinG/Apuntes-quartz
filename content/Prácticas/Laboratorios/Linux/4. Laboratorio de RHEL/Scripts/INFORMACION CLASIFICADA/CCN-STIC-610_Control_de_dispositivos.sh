#!/bin/bash

# Colores
CYAN='\033[1;36m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m'

clear


echo -e "${CYAN}---------------------------------------------------------------------------"
echo -e "   CCN-STIC-610 - Protección ante Dispositivos Extraíbles en RHEL"
echo -e "---------------------------------------------------------------------------"
echo
echo -e "Este script aplica medidas de protección contra el uso no autorizado de"
echo -e "dispositivos USB. Configura USBGuard para bloquear los nuevos dispositivos"
echo -e "y mantener habilitados los que ya están conectados al sistema."
echo
echo -e "Requisitos:"
echo -e "  - Ejecutarlo como root"
echo -e "  - Paquetes necesarios para la configuración"
echo
echo -e "---------------------------------------------------------------------------${NC}"

read -n1 -r -p "Pulse cualquier tecla para continuar..."

update-crypto-policies --set DEFAULT 2>/dev/null

# Verificación de root
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}[ERROR] Este script debe ejecutarse como root.${NC}"
  exit 1
fi

# Verificar si usbguard está instalado
if ! command -v usbguard &>/dev/null; then
  echo -e "${YELLOW}[!] usbguard no está instalado. Instalando...${NC}"
  dnf install -y usbguard || { echo -e "${RED}[ERROR] Falló la instalación de usbguard.${NC}"; exit 1; }
else
  echo -e "${GREEN}[OK] usbguard ya está instalado.${NC}"
fi

# Configurar SELinux (si está activo)
if command -v getenforce &>/dev/null && [ "$(getenforce)" != "Disabled" ]; then
  semanage fcontext -a -t usbguard_etc_t "/etc/usbguard(/.*)?"
  restorecon -Rv /etc/usbguard
fi

# Backup de configuración si existe
CONFIG_FILE="/etc/usbguard/usbguard-daemon.conf"
if [ -f "$CONFIG_FILE" ]; then
  cp "$CONFIG_FILE" "${CONFIG_FILE}.bak_$(date +%F_%T)"
fi

# Configuración personalizada
echo "[+] Escribiendo configuración en usbguard-daemon.conf..."
cat > "$CONFIG_FILE" << 'EOF'
# Configuración CCN-STIC-610 - Protección de Dispositivos USB
RuleFile=/etc/usbguard/rules.conf
ImplicitPolicyTarget=block

PresentDevicePolicy=keep
PresentControllerPolicy=apply-policy
InsertedDevicePolicy=apply-policy

RestoreControllerDeviceState=false
DeviceManagerBackend=uevent

IPCAllowedUsers=root
IPCAllowedGroups=wheel
IPCAccessControlFiles=/etc/usbguard/IPCAccessControl.d/

DeviceRulesWithPort=false

AuditBackend=FileAudit
AuditFilePath=/var/log/usbguard/usbguard-audit.log
EOF

# Si no hay reglas, crear reglas de tipo allow para dispositivos actuales
RULES_FILE="/etc/usbguard/rules.conf"
if [ ! -f "$RULES_FILE" ]; then
  echo "[+] Generando reglas para permitir dispositivos actualmente conectados..."
  usbguard generate-policy --insert-policy=allow > "$RULES_FILE"
fi

# Activar y reiniciar el servicio
echo "[+] Activando y reiniciando usbguard.service..."
systemctl enable --now usbguard.service
systemctl restart usbguard.service

systemctl status usbguard.service --no-pager

update-crypto-policies --set FUTURE 2>/dev/null


echo
echo -e "${GREEN}---------------------------------------------------------------"
echo -e " CCN-STIC-610 Protección USB: CONFIGURACIÓN APLICADA"
echo -e " Los dispositivos actualmente conectados se han permitido"
echo -e "---------------------------------------------------------------${NC}"


read -n1 -r -p "Pulse cualquier tecla para finalizar..."
