#!/bin/bash

CYAN='\033[1;36m'
GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m'

clear

echo -e "${CYAN}----------------------------------------------------------------------------"
echo -e "  CCN-STIC-610 - Configuración de Registro de Eventos en RHEL"
echo -e "----------------------------------------------------------------------------"
echo
echo -e "Este script configura:"
echo -e "  - Conservación de registros de seguridad (auditd)"
echo -e "  - Métodos de retención mediante logrotate y políticas locales"
echo
echo -e "Debe ejecutarse como root."
echo -e "----------------------------------------------------------------------------${NC}"

read -n1 -r -p "Pulse cualquier tecla para continuar..."

#------------------------------------------------------------
# Verificar ejecución como root
#------------------------------------------------------------
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}[ERROR] Este script debe ejecutarse como root.${NC}"
  exit 1
fi

#------------------------------------------------------------
# Configuración de auditd (registro de seguridad)
#------------------------------------------------------------
echo "[+] Configurando conservación de registros de seguridad (auditd)..."

AUDITD_CONF="/etc/audit/auditd.conf"
cp "$AUDITD_CONF" "$AUDITD_CONF.bak_$(date +%F_%T)"

set_conf_param() {
  local key="$1"
  local value="$2"
  if grep -q "^$key" "$AUDITD_CONF"; then
    sed -i "s|^$key.*|$key = $value|" "$AUDITD_CONF"
  else
    echo "$key = $value" >> "$AUDITD_CONF"
  fi
}

set_conf_param "max_log_file" "100"
set_conf_param "num_logs" "100"
set_conf_param "max_log_file_action" "ROTATE"
set_conf_param "admin_space_left_action" "SUSPEND"
set_conf_param "space_left_action" "SYSLOG"

# Validar sintaxis y recargar reglas
echo "[+] Cargando reglas de auditoría..."
augenrules --load

echo "[+] Reiniciando servicio auditd..."
if service auditd reload; then
  echo -e "${GREEN}[OK] auditd reiniciado correctamente.${NC}"
else
  echo -e "${RED}[ERROR] Error al reiniciar auditd. Verifique el archivo auditd.conf.${NC}"
fi

#------------------------------------------------------------
# Configuración de logrotate
#------------------------------------------------------------
echo "[+] Configurando conservación de registros del sistema..."

LOGROTATE_SYSLOG="/etc/logrotate.d/syslog"
[ -f "$LOGROTATE_SYSLOG" ] && cp "$LOGROTATE_SYSLOG" "$LOGROTATE_SYSLOG.bak_$(date +%F_%T)"


cp /etc/logrotate.conf /etc/logrotate.conf.bak_$(date +%F_%T)

sed -i 's/^#compress/compress/' /etc/logrotate.conf
sed -i 's/^weekly/weekly/' /etc/logrotate.conf
sed -i 's/^rotate .*/rotate 12/' /etc/logrotate.conf
sed -i 's/^#create/create/' /etc/logrotate.conf

echo "[+] Ejecutando rotación de prueba..."
logrotate -f /etc/logrotate.conf


echo
echo -e "${GREEN}--------------------------------------------------------------------"
echo -e " CCN-STIC-610 Registro de eventos: CONFIGURACIÓN APLICADA "
echo -e " Revise manualmente las configuraciones aplicadas"
echo -e "--------------------------------------------------------------------${NC}"

read -n1 -r -p "Pulse cualquier tecla para continuar..."
