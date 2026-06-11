#!/bin/bash


# Colores
CYAN='\033[1;36m'
GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m'

clear

echo -e "${CYAN}------------------------------------------------------------------"
echo -e "    CCN-STIC-610 - Directiva de Auditoría en RHEL"
echo -e "------------------------------------------------------------------"
echo
echo -e "Este script aplica las siguientes directivas de seguridad:"
echo -e "    - Control de sesiones"
echo -e "    - Auditoría de accesos y configuraciones del sistema"
echo -e "    - Auditoría de ejecución de comandos y uso de privilegios"
echo
echo -e "Antes de ejecutar este script debe asegurarse de:"
echo -e "    - Ejecutarlo con privilegios de root"
echo -e "    - Tener backup de /etc/audit/ y /etc/audit.rules"
echo -e "    - Tener auditd instalado y habilitado"
echo -e "------------------------------------------------------------------${NC}"
echo

read -n1 -r -p "Pulse cualquier tecla para continuar..."

# Verificar root
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}[ERROR] Este script debe ejecutarse como root.${NC}"
  exit 1
fi

AUDITD_CONF="/etc/audit/auditd.conf"
AUDIT_RULES="/etc/audit/rules.d/ccn_audit.rules"

echo "[+] Habilitando auditd en el arranque..."
systemctl enable auditd

# Crear carpeta si no existe
mkdir -p /etc/audit/rules.d

# Copia de seguridad y limpieza de otras reglas
echo "[+] Eliminando reglas antiguas excepto ccn_audit.rules..."
find /etc/audit/rules.d/ -type f -name '*.rules' ! -name 'ccn_audit.rules' -delete

# Escribir reglas modernas
echo "[+] Aplicando reglas de auditoría modernas a $AUDIT_RULES..."
cat > "$AUDIT_RULES" << 'EOF'
-D
-b 8192

# Inicio de sesión
-w /var/log/lastlog -p wa -k inicio_sesion
-w /var/run/faillock/ -p wa -k intento_fallido

# Archivos críticos del sistema
-w /etc/passwd -p wa -k config_usuarios
-w /etc/shadow -p wa -k config_claves
-w /etc/group -p wa -k config_grupos
-w /etc/gshadow -p wa -k config_grupos_sombra
-w /etc/sudoers -p wa -k sudoers
-w /etc/sudoers.d/ -p wa -k sudoers_incl
-w /etc/pam.d/ -p wa -k config_pam

# Cron y tareas automatizadas
-w /etc/cron.allow -p wa -k cron_allow
-w /etc/cron.deny -p wa -k cron_deny
-w /etc/crontab -p wa -k crontab
-w /etc/cron.hourly/ -p wa -k cron_hourly
-w /etc/cron.daily/ -p wa -k cron_daily
-w /etc/cron.weekly/ -p wa -k cron_weekly
-w /etc/cron.monthly/ -p wa -k cron_monthly
-w /etc/anacrontab -p wa -k anacron

# Ejecución de comandos como root
-a always,exit -F arch=b64 -F euid=0 -S execve -k root_cmds

# Dispositivos externos
-w /media/ -p wa -k dispositivos_extraibles
-w /run/media/ -p wa -k dispositivos_extraibles

# Cambios de permisos
-a always,exit -F arch=b64 -S chmod,chown,fchmod,fchown -k cambios_permisos

# Configuración de red
-w /etc/hosts -p wa -k red_config
-w /etc/resolv.conf -p wa -k red_config
EOF

# Aplicar reglas
echo "[+] Cargando reglas con augenrules..."
auditctl -D 
augenrules --load 

echo "[+] Verificando reglas cargadas..."
auditctl -l

echo "[+] Verificando estado de auditd..."
auditctl -s

service auditd reload

echo
echo -e "${GREEN}---------------------------------------------------------------"
echo -e " CCN-STIC-610 Auditoría: CONFIGURACIÓN APLICADA "
echo -e " Puede revisar eventos con: ausearch, aureport, auditctl -l "
echo -e "---------------------------------------------------------------${NC}"

read -n1 -r -p "Pulse cualquier tecla para finalizar el script..."
