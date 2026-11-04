#!/bin/bash
# ---------------------------------------------------------------
# CCN-STIC-610 - Configuración de Firewall en OpenSUSE
# ---------------------------------------------------------------

source "$(dirname "$0")/lib.sh"

clear

echo -e "${CYAN}------------------------------------------------------------------"
echo -e "  CCN-STIC-610 - Configuración del Firewall en OpenSUSE"
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

# 1. Verificaciones iniciales
check_root

#------------------------------------------------------------
# Verificar y activar firewalld
#------------------------------------------------------------
check_pkg "firewalld" "firewall-cmd"
check_service firewalld

#------------------------------------------------------------
# Zona predeterminada
#------------------------------------------------------------
DEFAULT_ZONE=$(firewall-cmd --get-default-zone 2>/dev/null)
if [ -z "$DEFAULT_ZONE" ]; then
    log_error "No se pudo determinar la zona activa."
    exit 1
fi
log_info "Zona activa detectada: $DEFAULT_ZONE"

log_info "Servicios permitidos actualmente:"
firewall-cmd --zone="$DEFAULT_ZONE" --list-services
firewall-cmd --zone="$DEFAULT_ZONE" --list-ports

#------------------------------------------------------------
# Configuración de servicios permitidos
#------------------------------------------------------------
SERVICES=("http" "https" "imap" "imaps" "pop3")
log_info "Configurando servicios permitidos en zona $DEFAULT_ZONE..."

for svc in "${SERVICES[@]}"; do
    # Verificamos si el servicio ya está permitido para no repetir
    if firewall-cmd --zone="$DEFAULT_ZONE" --query-service="$svc" --permanent &>/dev/null; then
        log_info "Servicio $svc ya estaba permitido. Saltando..."
    else
        log_info "Añadiendo servicio: $svc..."
        firewall-cmd --zone="$DEFAULT_ZONE" --add-service="$svc" --permanent &>/dev/null
        log_success "Servicio $svc ha sido permitido correctamente."
    fi
done

#------------------------------------------------------------
# Protección básica contra ataques DoS en puerto 80
#------------------------------------------------------------
log_info "Aplicando mitigación DoS en puerto 80 (limite 25/min)..."

firewall-cmd --permanent --direct --remove-rule ipv4 filter INPUT 0 -p tcp --dport 80 -m limit --limit 25/minute --limit-burst 100 -j ACCEPT &>/dev/null
if firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -p tcp --dport 80 -m limit --limit 25/minute --limit-burst 100 -j ACCEPT; then
    log_success "Regla DoS aplicada correctamente."
else
    log_error "Hubo un problema al aplicar la regla directa DoS."
fi
#------------------------------------------------------------
# Recargar configuración
#------------------------------------------------------------
log_info "Recargando configuración de firewalld..."
firewall-cmd --reload &>/dev/null

# Mostrar configuración final
echo
log_info "Servicios permitidos tras configuración:"
log_info "$Servicios activos: $(firewall-cmd --list-services)"
log_info "Reglas DoS:"
firewall-cmd --direct --get-all-rules
echo

echo
echo -e "${GREEN}----------------------------------------------------------------"
echo -e " CCN-STIC-610 Firewall : CONFIGURACIÓN APLICADA "
echo -e "----------------------------------------------------------------${NC}"

read -n1 -r -p "Pulse cualquier tecla para finalizar..."
