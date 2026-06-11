#!/bin/bash

source "$(dirname "$0")/lib.sh"

clear

echo -e "${CYAN}------------------------------------------------------------------"
echo -e "    CCN-STIC-610 - Opciones de Seguridad en OpenSUSE"
echo -e "------------------------------------------------------------------"
echo
echo -e "Este script aplica las siguientes directivas de seguridad:"
echo -e "    - Control sobre instalaciones y privilegios"
echo -e "    - Restricciones de historial"
echo -e "    - Estado de cuentas y visibilidad de inicio de sesión"
echo -e "    - Inactividad, servicios y red"
echo
echo -e "Antes de ejecutar este script debe asegurarse de:"
echo -e "    - Ejecutarlo con privilegios de root"
echo -e "    - Disponer de copia de seguridad de los siguientes ficheros:"
echo -e "        /etc/sudoers"
echo -e "        /etc/pam.d/*"
echo -e "        /etc/default/grub"
echo -e "        /etc/sysctl.conf"
echo -e "        /etc/ssh/sshd_config"
echo
echo -e "------------------------------------------------------------------${NC}"

read -n1 -r -p "Pulse cualquier tecla para continuar..."

check_root

do_backup "/etc/sysctl.conf"
do_backup "/etc/issue"
do_backup "/etc/issue.net"

# Como el script bloquea root al final, verificamos que sudo funcionará
if grep -q "^Defaults[[:space:]]\+targetpw" /etc/sudoers; then
	log_warn "Sudo todavía pide la clave de root (targetpw)."
	log_info "Arreglando sudoers antes de continuar para evitar bloqueos..."

	sed -i 's/^Defaults targetpw/#Defaults targetpw/g' /etc/sudoers
	sed -i 's/^Defaults runaspw/#Defaults runaspw/g' /etc/sudoers
	log_success "Deshabilitado targetpw, se pedirá la contraseña del usuario."

	replace_in_file "^#[[:space:]]%wheel ALL=(ALL:ALL) ALL" "%wheel ALL=(ALL:ALL) ALL" "/etc/sudoers"
fi

#--------------------------
# Control de privilegios
#--------------------------
log_info "Configurar sudo para requerir contraseña siempre..."
create_script "/etc/sudoers.d/seguridad" << 'EOF'
Defaults timestamp_timeout=0
EOF

#--------------------------
# Restricción de historial
#--------------------------
log_info "Configurando restricciones de historial (HISTSIZE=0)..."
create_script "/etc/profile.d/hist_restrict.sh" << 'EOF'
export HISTFILESIZE=0
export HISTSIZE=0
EOF
chmod 644 /etc/profile.d/hist_restrict.sh

#--------------------------
# Seguridad de cuentas
#--------------------------
#echo "Bloquear cambio de contraseñas del sistema (opcional)..."
#chattr +i /etc/shadow

log_info "Gestionando cuentas de usuario..."
if id "guest" &>/dev/null; then
	usermod -L guest
	log_success "Cuenta 'guest' bloqueada."
else
	log_info "No existe cuenta 'guest'. Saltando..."
fi

#--------------------------
# Inactividad
#--------------------------
log_info "Establecer límite de inactividad (5 min)..."
create_script "/etc/profile.d/timeout.sh" << 'EOF'
TMOUT=300
readonly TMOUT
export TMOUT
EOF
chmod 644 /etc/profile.d/timeout.sh

#--------------------------
# Ocultar usuarios y mostrar banner en GDM
#--------------------------
# Verificamos si dconf está instalado antes de intentar usarlo
if command -v dconf &>/dev/null; then
	log_info "Configurando GDM (Banner y privacidad)..."
	mkdir -p /etc/dconf/db/gdm.d/
	
	create_script "/etc/dconf/db/gdm.d/01-banner-message" << 'EOF'
[org/gnome/login-screen]
disable-user-list=true
banner-message-enable=true
banner-message-text='AVISO IMPORTANTE DE SEGURIDAD.\nEstá usted accediendo a un equipo propiedad de la Organización.\nEl acceso no autorizado será perseguido legalmente.'
EOF

	mkdir -p /etc/dconf/db/local.d/
	create_script "/etc/dconf/db/local.d/00-screensaver" << 'EOF'
[org/gnome/desktop/session]
idle-delay=uint32 600

[org/gnome/desktop/screensaver]
lock-enabled=true
lock-delay=uint32 0
EOF
	dconf update
	log_success "Configuración dconf aplicada."
else
	log_warn "dconf no encontrado. Saltando configuración de escritorio."
fi

# Banner de advertencia
log_info "Creando banner de advertencia... (/etc/issue)"
BANNER_TEXT="AVISO IMPORTANTE DE SEGURIDAD
 
Está usted accediendo a un equipo propiedad de la Organización el cual gestiona información asociada al mismo.
Todo aquel usuario que tenga derecho de acceso al presente Equipo, está sujeto a todos los requerimientos especificados por la normativa de seguridad establecida.
El acceso no autorizado podrá dar lugar a las correspondientes acciones legales. El acceso al Equipo implica la aceptación expresa de las condiciones anteriores.
El uso de la navegación web del Equipo está restringido al uso de servicios relacionados con la gestión de la organización, páginas necesarias para la funcionalidad de la entidad y/o la prestación de servicios a terceros.
Al igual que la navegación Web, el uso del correo electrónico queda restringido de forma exclusiva a las necesidades de la organización, mediante el servicio autorizado."

create_script "/etc/issue" <<< "$BANNER_TEXT"
create_script "/etc/issue.net" <<< "$BANNER_TEXT"

#--------------------------
# Geolocalización y servicios innecesarios
#--------------------------
log_info "Enmascarando servicios innecesarios..."
SERVICES_TO_MASK=("geoclue.service" "telnet.socket" "cups.socket")

for srv in "${SERVICES_TO_MASK[@]}"; do
	mask_service $srv
done

#--------------------------
# Políticas criptográficas y red
#--------------------------
log_info "Aplicar políticas criptográficas seguras..."
set_crypto_policy "FUTURE"

log_info "Configurando red (Deshabilitar ICMP/Ping)..."
if ! grep -q "net.ipv4.icmp_echo_ignore_all" /etc/sysctl.conf; then
	echo "net.ipv4.icmp_echo_ignore_all = 1" >> /etc/sysctl.conf
else
	replace_in_file "^net.ipv4.icmp_echo_ignore_all.*" "net.ipv4.icmp_echo_ignore_all = 1" "/etc/sysctl.conf"
fi
sysctl -p

#--------------------------
# Deshabilitando root
#--------------------------
log_warn "Último paso: Deshabilitar cuenta root."
log_warn "Asegúrese de que su usuario actual puede usar 'sudo' correctamente."
read -p "¿Desea bloquear la cuenta root ahora? (s/n): " RESP
if [[ "$RESP" =~ ^[sS]$ ]]; then
	passwd -l root
	log_success "Acceso directo a root deshabilitado."
else
	log_info "Bloqueo de root cancelado por el usuario."
fi

echo
echo -e "${GREEN}-------------------------------------------------------------------------"
echo -e " CCN-STIC-610 Opciones de seguridad: CONFIGURACIÓN APLICADA "
echo -e " Es posible que para aplicar ciertos cambios sea necesario reiniciar el sistema."
echo -e "-------------------------------------------------------------------------${NC}"

read -n1 -r -p "Pulse cualquier tecla para finalizar..."
