#!/bin/bash

# Colores
CYAN='\033[1;36m'
GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m'

clear

echo -e "${CYAN}------------------------------------------------------------------"
echo -e "  CCN-STIC-610 - Actualizaciones Automáticas en RHEL"
echo -e "------------------------------------------------------------------"
echo
echo -e "Este script configura:"
echo -e "  - Actualizaciones automáticas cada 15 días usando cron"
echo
echo -e "Requisitos:"
echo -e "  - Ejecutar como root"
echo -e "  - Sistema con cron habilitado"
echo -e "------------------------------------------------------------------${NC}"

read -n1 -r -p "Pulse cualquier tecla para continuar..."

# Verificar si cron está activo
echo -e "\n[+] Verificando el servicio crond..."
if ! systemctl is-active --quiet crond; then
    echo "[+] Activando crond..."
    systemctl enable --now crond
else
    echo "[✓] crond ya está activo."
fi

# Crear script de actualización
UPDATE_SCRIPT="/usr/local/sbin/auto_update.sh"

echo "[+] Creando script de actualización automática en $UPDATE_SCRIPT..."
cat > "$UPDATE_SCRIPT" <<EOF
#!/bin/bash
# CCN-STIC-610 - Actualización automática
/usr/bin/dnf -y update
EOF

chmod +x "$UPDATE_SCRIPT"

# Crear cron job cada 15 días
CRON_FILE="/etc/cron.d/ccn_actualizacion"

echo "[+] Configurando cronjob para ejecutar cada 15 días..."
cat > "$CRON_FILE" <<EOF
# CCN-STIC-610 - Actualizaciones automáticas cada 15 días
0 7 */15 * * root $UPDATE_SCRIPT
EOF

chmod 644 "$CRON_FILE"

echo
echo -e "${GREEN}----------------------------------------------------------------"
echo -e " CCN-STIC-610 Actualizaciones: CONFIGURACIÓN APLICADA"
echo -e " Se ejecutará: /usr/bin/dnf -y update cada 15 días a las 07:00"
echo -e "----------------------------------------------------------------${NC}"

read -n1 -r -p "Pulse cualquier tecla para finalizar..."
