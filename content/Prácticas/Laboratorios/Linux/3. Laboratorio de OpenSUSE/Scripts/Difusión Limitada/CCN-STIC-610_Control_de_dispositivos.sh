#!/bin/bash

source "$(dirname "$0")/lib.sh"

clear

echo -e "${CYAN}---------------------------------------------------------------------------"
echo -e "   CCN-STIC-610 - Protección ante Dispositivos Extraíbles en OpenSUSE"
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

check_root

# Verificar si crypto-policies está instalado
check_pkg "crypto-policies" "update-crypto-policies"
set_crypto_policy "DEFAULT"

# Verificar si usbguard está instalado
check_pkg "usbguard-tools" "usbguard"

# Configurar AppArmor (si está activo)
check_pkg "apparmor" "aa-status"

# Backup de configuración si existe
CONFIG_FILE="/etc/usbguard/usbguard-daemon.conf"
do_backup $CONFIG_FILE

# Configuración personalizada
create_script "$CONFIG_FILE" << 'EOF'
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
	log_info "Generando reglas para permitir dispositivos actualmente conectados..."
	usbguard generate-policy --insert-policy=allow > "$RULES_FILE"
fi

# Activar y reiniciar el servicio
log_info "Activando y reiniciando usbguard.service..."
sudo chmod 0600 /etc/usbguard/usbguard-daemon.conf
sudo chmod 0600 /etc/usbguard/rules.conf 2>/dev/null || true
sudo chown root:root /etc/usbguard/usbguard-daemon.conf
systemctl enable --now usbguard.service
systemctl restart usbguard.service

systemctl status usbguard.service --no-pager

set_crypto_policy "FUTURE"

echo
echo -e "${GREEN}---------------------------------------------------------------"
echo -e " CCN-STIC-610 Protección USB: CONFIGURACIÓN APLICADA"
echo -e " Los dispositivos actualmente conectados se han permitido"
echo -e "---------------------------------------------------------------${NC}"


read -n1 -r -p "Pulse cualquier tecla para finalizar..."
