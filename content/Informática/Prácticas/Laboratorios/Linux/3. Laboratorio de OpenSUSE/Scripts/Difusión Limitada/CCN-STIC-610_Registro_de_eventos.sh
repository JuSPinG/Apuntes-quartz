#!/bin/bash
# ---------------------------------------------------------------
# CCN-STIC-610 - Configuración de Auditoría y Registros
# ---------------------------------------------------------------

source "$(dirname "$0")/lib.sh"

clear

echo -e "${CYAN}------------------------------------------------------------------"
echo -e "  CCN-STIC-610 - Configuración de Registro de Eventos en OpenSUSE"
echo -e "------------------------------------------------------------------"
echo
echo -e "Este script configura:"
echo -e "  - Conservación de registros de seguridad (auditd)"
echo -e "  - Métodos de retención mediante logrotate y políticas locales"
echo
echo -e "Debe ejecutarse como root."
echo -e "------------------------------------------------------------------${NC}"

read -n1 -r -p "Pulse cualquier tecla para continuar..."

# 1. Verificaciones iniciales
check_root
check_pkg "audit" "auditd"

#------------------------------------------------------------
# Configuración de auditd (registro de seguridad)
#------------------------------------------------------------
# 2. Configuración de auditd.conf
AUDITD_CONF="/etc/audit/auditd.conf"
do_backup "$AUDITD_CONF"
log_info "Ajustando parámetros de retención en $AUDITD_CONF..."

replace_in_file "^max_log_file[[:space:]]*=.*" "max_log_file = 100" "$AUDITD_CONF"
replace_in_file "^num_logs[[:space:]]*=.*" "num_logs = 100" "$AUDITD_CONF"
replace_in_file "^max_log_file_action[[:space:]]*=.*" "max_log_file_action = ROTATE" "$AUDITD_CONF"
replace_in_file "^admin_space_left_action[[:space:]]*=.*" "admin_space_left_action = SUSPEND" "$AUDITD_CONF"
replace_in_file "^space_left_action[[:space:]]*=.*" "space_left_action = SYSLOG" "$AUDITD_CONF"

# 3. Reglas de auditoría
log_info "Olvidando reglas actuales..."
if auditctl -D &>/dev/null; then
	log_success "Reglas olvidadas exitosamente."
else
	log_warn "No se ha podido olivar las reglas, lo que es clave para luego recargarlas."
fi

log_info "Cargando reglas de auditoría dinámicas..."
if augenrules --load &>/dev/null; then
    log_success "Reglas cargadas."
else
    log_warn "No se pudieron cargar reglas mediante augenrules. Usando auditctl..."
    auditctl -R /etc/audit/audit.rules 2>/dev/null
fi

# 4. Reinicio del servicio (Auditd es especial)
# A veces 'systemctl restart' falla en auditd por diseño de seguridad. 
# 'service auditd restart' o 'restart_auditd' es más fiable.
log_info "Reiniciando auditd..."
service auditd restart &>/dev/null || systemctl restart auditd &>/dev/null

if systemctl is-active --quiet auditd; then
    log_success "Servicio auditd operativo."
else
    log_error "Fallo al reiniciar auditd. Revise la sintaxis de $AUDITD_CONF."
fi

# 5. Configuración de Logrotate
log_info "Configurando política global de rotación de logs..."
do_backup "/etc/logrotate.conf"

if find /etc/logrotate.d/*.bak* &>/dev/null; then
    log_warn "Se han detectado copias de seguridad extra en /etc/logrotate.d/. Pueden interferir en la configuración."
    log_info "Moviendo a /var/backups/logrotate/."
    mkdir -p /var/backups/logrotate/
    if mv /etc/logrotate.d/syslog.bak_* /var/backups/logrotate/; then
        log_success "Se han movido los archivos correctamente. No habrá más interferencias por ahora."
    else
        log_error "No se han podido mover los archivos (¿está el directorio creado y configurado con permisos adecuados?)."
    fi
fi

# Aseguramos compresión y retención de 12 semanas (3 meses aprox)
replace_in_file "^#\?compress" "compress" "/etc/logrotate.conf"
replace_in_file "^#\?weekly" "weekly" "/etc/logrotate.conf"
replace_in_file "^rotate[[:space:]]\+.*" "rotate 12" "/etc/logrotate.conf"
replace_in_file "^#\?create" "create" "/etc/logrotate.conf"

# 6. Verificación de logrotate
log_info "Validando configuración de logrotate..."
if logrotate -f /etc/logrotate.conf; then
    log_success "Configuración de logrotate válida."
else
    log_warn "Logrotate detectó inconsistencias (ignórelo si son permisos de archivos inexistentes). Se recomienda ejecutar: logrotate -df $LOGROTATE_CONF para más detalles."
fi

echo
echo -e "${GREEN}--------------------------------------------------------------------"
echo -e " CCN-STIC-610 Registro de eventos: CONFIGURACIÓN APLICADA "
echo -e " Revise manualmente las configuraciones aplicadas"
echo -e "--------------------------------------------------------------------${NC}"

read -n1 -r -p "Pulse cualquier tecla para continuar..."
