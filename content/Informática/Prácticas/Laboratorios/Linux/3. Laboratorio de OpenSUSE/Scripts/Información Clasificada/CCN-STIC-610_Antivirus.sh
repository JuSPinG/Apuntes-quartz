#!/bin/bash

source "$(dirname "$0")/lib.sh"

clear

echo -e "${CYAN}----------------------------------------------------------------------------"
echo -e "  CCN-STIC-610 - Instalación y Configuración Segura de ClamAV en OpenSUSE"
echo -e "----------------------------------------------------------------------------"
echo
echo -e "Este script automatiza la instalación, configuración y programación"
echo -e "de escaneos diarios con ClamAV en sistemas OpenSUSE"
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

check_root

# 1. Gestión de Crypto-Policies (Usando tu nueva función de lib.sh)
# En lugar de llamar al comando que no existe, usamos la función de la lib
set_crypto_policy "DEFAULT"

# 2. Instalar ClamAV (Sin EPEL)
log_info "Instalando ClamAV y dependencias..."
# Usamos tu función check_pkg de la lib para aumentar la consistencia
check_pkg "clamav" "clamscan"

# 3. Configuración de clamd.conf (Ruta corregida para OpenSUSE)
log_info "Configurando /etc/clamd.conf..."
CLAMCONF="/etc/clamd.conf"
do_backup $CLAMCONF

# En OpenSUSE el archivo suele venir ya sin "Example", pero aseguramos:
replace_in_file "^Example" "#Example" "$CLAMCONF"
replace_in_file "^#LogFile .*" "LogFile /var/log/clamd.log" "$CLAMCONF"
replace_in_file "^#LocalSocket .*" "LocalSocket /run/clamd.sock" "$CLAMCONF"

# 4. Configurar freshclam
FRESHCONF="/etc/freshclam.conf"
do_backup $FRESHCONF
replace_in_file "^Example" "#Example" $FRESHCONF

log_info "Actualizando firmas (esto puede tardar)..."
freshclam || log_warn "Freshclam falló, puede ser actualizaciones recientes."

# 5. Habilitar clamd (Nombre de servicio corregido)
check_service clamd

# 6. Crear script de escaneo diario
log_info "Creando script de escaneo diario..."
mkdir -p /opt/clamav /var/log/clamav

create_script "/opt/clamav/clamav_scan.sh" <<EOF
#!/bin/bash
LOGFILE="/var/log/clamav/scan-\$(date +%F).log"
clamscan -r -i --exclude-dir="^/sys" --exclude-dir="^/proc" --exclude-dir="^/dev" / > "\$LOGFILE"
EOF

chmod +x /opt/clamav/clamav_scan.sh

# Crear unidad systemd para el escaneo
create_script "/etc/systemd/system/clamav-scan.service" << EOF
[Unit]
Description=Escaneo antivirus diario con ClamAV

[Service]
Type=oneshot
ExecStart=/opt/clamav/clamav_scan.sh
EOF

create_script "/etc/systemd/system/clamav-scan.timer" << EOF
[Unit]
Description=Temporizador diario para ClamAV

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
EOF

# Activar temporizador
log_info "Activando escaneo automático diario..."
systemctl daemon-reload
systemctl enable --now clamav-scan.timer

set_crypto_policy "FUTURE"

echo
echo -e "${GREEN}----------------------------------------------------------------"
echo -e " CCN-STIC-610 ClamAV: INSTALACIÓN Y CONFIGURACIÓN APLICADA"
echo -e " Revise el log: /var/log/clamav/scan-YYYY-MM-DD.log"
echo -e "----------------------------------------------------------------${NC}"

read -n1 -r -p "Pulsa cualquier tecla para finalizar..."
