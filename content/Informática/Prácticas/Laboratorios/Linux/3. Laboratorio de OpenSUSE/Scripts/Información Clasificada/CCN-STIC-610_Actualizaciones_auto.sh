#!/bin/bash

source "$(dirname "$0")/lib.sh"

clear

echo -e "${CYAN}------------------------------------------------------------------"
echo -e "  CCN-STIC-610 - Actualizaciones Automáticas en OpenSUSE"
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

check_root

# Verificar si cron está activo
check_service cron

# Crear script de actualización
UPDATE_SCRIPT="/usr/local/sbin/auto_update.sh"

log_info "Creando script de actualización automática..."
create_script "$UPDATE_SCRIPT" <<EOF
#!/bin/bash
# CCN-STIC-610 - Actualización automática
/usr/bin/zypper -n update
EOF

chmod +x "$UPDATE_SCRIPT"

# Crear cron job cada 15 días
CRON_FILE="/etc/cron.d/ccn_actualizacion"

log_info "Configurando cronjob para ejecutar cada 15 días..."
create_script "$CRON_FILE" <<EOF
# CCN-STIC-610 - Actualizaciones automáticas cada 15 días
0 7 */15 * * root $UPDATE_SCRIPT
EOF

chmod 644 "$CRON_FILE"

echo
echo -e "${GREEN}----------------------------------------------------------------"
echo -e " CCN-STIC-610 Actualizaciones: CONFIGURACIÓN APLICADA"
echo -e " Se ejecutará: /usr/bin/zypper -n update cada 15 días a las 07:00"
echo -e "----------------------------------------------------------------${NC}"

read -n1 -r -p "Pulse cualquier tecla para finalizar..."
