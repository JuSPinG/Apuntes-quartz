#!/bin/bash

# Colores
CYAN='\033[1;36m'
GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m'

clear

echo -e "${CYAN}----------------------------------------------------------------------------"
echo -e "  CCN-STIC-610 - Instalación y Configuración Segura de ClamAV en RHEL"
echo -e "----------------------------------------------------------------------------"
echo
echo -e "Este script automatiza la instalación, configuración y programación"
echo -e "de escaneos diarios con ClamAV en sistemas RHEL"
echo
echo -e "Incluye:"
echo -e "  - Instalación de ClamAV y dependencias"
echo -e "  - Configuración de clamd y freshclam"
echo -e "  - Activación del servicio clamd@scan"
echo -e "  - Creación de script de escaneo diario"
echo -e "  - Creación de unidad systemd y temporizador"
echo
echo -e "Debe ejecutarse como root."
echo -e "Si no se dispone de una conexión a internet es necesario disponer de los paquetes descargados previamente"
echo -e "----------------------------------------------------------------------------${NC}"

read -n1 -r -p "Pulsa cualquier tecla para continuar..."


update-crypto-policies --set DEFAULT 2>/dev/null

# Instalar EPEL y ClamAV
echo -e "\n${GREEN}[+] Instalando ClamAV y dependencias...${NC}"
dnf install -y epel-release
dnf install -y clamav clamav-update clamd

# Configuración de scan.conf
echo -e "${GREEN}[+] Configurando /etc/clamd.d/scan.conf...${NC}"
cp -f /etc/clamd.d/scan.conf /etc/clamd.d/scan.conf.bak_$(date +%F_%T)
sed -i 's/^Example/#Example/' /etc/clamd.d/scan.conf
sed -i 's|^#LogFile .*|LogFile /var/log/clamd.scan|' /etc/clamd.d/scan.conf
sed -i 's|^#LocalSocket .*|LocalSocket /run/clamd.scan/clamd.sock|' /etc/clamd.d/scan.conf

# Configurar freshclam
echo -e "${GREEN}[+] Configurando freshclam (actualización de firmas)...${NC}"
cp -f /etc/freshclam.conf /etc/freshclam.conf.bak_$(date +%F_%T)
sed -i 's/^Example/#Example/' /etc/freshclam.conf

echo -e "${GREEN}[+] Ejecutando freshclam para descargar base de firmas...${NC}"
freshclam || { echo -e "${RED}[ERROR] No se pudo descargar la base de firmas. Verifica tu conexión.${NC}"; exit 1; }

# Habilitar clamd (después de tener firmas)
echo -e "${GREEN}[+] Habilitando servicio clamd@scan...${NC}"
systemctl enable --now clamd@scan.service || {
  echo -e "${RED}[ERROR] Falló la activación de clamd. Verifica que la base de firmas esté en /var/lib/clamav.${NC}"
  exit 1
}

# Crear script de escaneo diario
echo -e "${GREEN}[+] Creando script de escaneo diario...${NC}"
mkdir -p /opt/clamav /var/log/clamav

cat > /opt/clamav/clamav_scan.sh << 'EOF'
#!/bin/bash
LOGFILE="/var/log/clamav/scan-$(date +%F).log"
clamscan -r -i --exclude-dir="^/sys" --exclude-dir="^/proc" --exclude-dir="^/dev" / > "$LOGFILE"
EOF

chmod +x /opt/clamav/clamav_scan.sh

# Crear unidad systemd para el escaneo
cat > /etc/systemd/system/clamav-scan.service << EOF
[Unit]
Description=Escaneo antivirus diario con ClamAV

[Service]
Type=oneshot
ExecStart=/opt/clamav/clamav_scan.sh
EOF

cat > /etc/systemd/system/clamav-scan.timer << EOF
[Unit]
Description=Temporizador diario para ClamAV

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
EOF

# Activar temporizador
echo -e "${GREEN}[+] Activando escaneo automático diario...${NC}"
systemctl daemon-reload
systemctl enable --now clamav-scan.timer

update-crypto-policies --set FUTURE 2>/dev/null

echo
echo -e "${GREEN}----------------------------------------------------------------"
echo -e " CCN-STIC-610 ClamAV: INSTALACIÓN Y CONFIGURACIÓN APLICADA"
echo -e " Revise el log: /var/log/clamav/scan-YYYY-MM-DD.log"
echo -e "----------------------------------------------------------------${NC}"

read -n1 -r -p "Pulsa cualquier tecla para finalizar..."
