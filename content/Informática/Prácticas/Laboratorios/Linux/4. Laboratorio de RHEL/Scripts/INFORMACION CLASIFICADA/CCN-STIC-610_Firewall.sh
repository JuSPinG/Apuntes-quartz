#!/bin/bash

# Colores
CYAN='\033[1;36m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m'

clear

echo -e "${CYAN}------------------------------------------------------------------"
echo -e "  CCN-STIC-610 - Configuración del Firewall en RHEL"
echo -e "------------------------------------------------------------------"
echo
echo -e "Este script verifica y aplica las siguientes configuraciones:"
echo -e "  - Comprobación del estado del firewall"
echo -e "  - Control de conexiones salientes"
echo -e "  - Reglas específicas para IMAP, IMAPS, POP3, HTTP y HTTPS"
echo -e "  - Mitigación básica de ataques DoS en puerto 80"
echo
echo -e "Debe ejecutarse como root. Asegúrese de tener una copia de seguridad"
echo -e "de su configuración de red antes de aplicar cambios en firewalld."
echo -e "------------------------------------------------------------------${NC}"

read -n1 -r -p "Pulse cualquier tecla para continuar..."

# Verificación de ejecución como root
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}[ERROR] Este script debe ejecutarse como root.${NC}"
  exit 1
fi

#------------------------------------------------------------
# Verificar y activar firewalld
#------------------------------------------------------------
echo "[+] Verificando el estado de firewalld..."

if ! command -v firewall-cmd &>/dev/null; then
  echo -e "${RED}[ERROR] firewalld no está instalado. Instálalo con: dnf install firewalld${NC}"
  exit 1
fi

if ! systemctl is-active --quiet firewalld; then
    echo "[-] El firewall no está activo. Activando..."
    systemctl enable --now firewalld
else
    echo "[OK] firewalld está activo."
fi

#------------------------------------------------------------
# Zona predeterminada
#------------------------------------------------------------
DEFAULT_ZONE=$(firewall-cmd --get-default-zone 2>/dev/null)

if [ -z "$DEFAULT_ZONE" ]; then
  echo -e "${RED}[ERROR] No se pudo obtener la zona predeterminada.${NC}"
  exit 1
fi

echo "[i] Zona activa detectada: $DEFAULT_ZONE"
echo "[i] Servicios permitidos actualmente:"
firewall-cmd --zone="$DEFAULT_ZONE" --list-services
firewall-cmd --zone="$DEFAULT_ZONE" --list-ports

#------------------------------------------------------------
# Configuración de servicios permitidos
#------------------------------------------------------------
echo "[+] Estableciendo servicios permitidos (HTTP, HTTPS, IMAP, IMAPS, POP3)..."

for service in http https imap imaps pop3; do
  echo "→ Añadiendo servicio permitido: $service"
  firewall-cmd --zone="$DEFAULT_ZONE" --add-service="$service" --permanent || {
    echo -e "${RED}[ERROR] No se pudo añadir $service${NC}"
  }
done

#------------------------------------------------------------
# Protección básica contra ataques DoS en puerto 80
#------------------------------------------------------------
echo "[+] Aplicando protección básica contra ataques DoS en puerto 80 (limitación de conexión)..."

firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -p tcp --dport 80 -m limit --limit 25/minute --limit-burst 100 -j ACCEPT

#------------------------------------------------------------
# Recargar configuración
#------------------------------------------------------------
echo "[+] Recargando firewalld para aplicar los cambios..."
firewall-cmd --reload

# Mostrar configuración final
echo
echo "[i] Servicios permitidos tras configuración:"
firewall-cmd --zone="$DEFAULT_ZONE" --list-services
echo "[i] Reglas directas actuales:"
firewall-cmd --direct --get-all-rules

echo
echo -e "${GREEN}----------------------------------------------------------------"
echo -e " CCN-STIC-610 Firewall : CONFIGURACIÓN APLICADA "
echo -e "----------------------------------------------------------------${NC}"

read -n1 -r -p "Pulse cualquier tecla para finalizar..."
