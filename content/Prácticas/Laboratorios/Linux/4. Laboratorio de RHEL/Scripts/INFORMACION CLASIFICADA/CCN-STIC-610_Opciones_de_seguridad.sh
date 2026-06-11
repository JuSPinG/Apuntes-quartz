#!/bin/bash

# Colores
CYAN='\033[1;36m'
GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m'

clear

# Comprobación de root
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}[ERROR] Este script debe ejecutarse como root.${NC}"
  exit 1
fi

echo -e "${CYAN}------------------------------------------------------------------"
echo -e "    CCN-STIC-610 - Opciones de Seguridad en RHEL"
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

#--------------------------
# Control de privilegios
#--------------------------
echo "Configurar sudo para requerir contraseña siempre..."
echo 'Defaults timestamp_timeout=0' > /etc/sudoers.d/seguridad

#--------------------------
# Restricción de historial
#--------------------------
echo "Restringir historial de bash (persistente)..."
cat > /etc/profile.d/hist_restrict.sh << EOF
export HISTFILESIZE=0
export HISTSIZE=0
EOF
chmod 644 /etc/profile.d/hist_restrict.sh

#--------------------------
# Seguridad de cuentas
#--------------------------
#echo "Bloquear cambio de contraseñas del sistema (opcional)..."
#chattr +i /etc/shadow

echo "Deshabilitar cuenta root..."
passwd -l root

echo "Deshabilitar cuenta guest (si existe)..."
if id "guest" &>/dev/null; then
  usermod -L guest
  echo "[+] Cuenta guest bloqueada."
else
  echo "[i] No existe la cuenta 'guest'."
fi

#--------------------------
# Inactividad
#--------------------------
echo "Establecer límite de inactividad (5 min)..."
echo 'TMOUT=300' > /etc/profile.d/timeout.sh
chmod 644 /etc/profile.d/timeout.sh

#--------------------------
# Ocultar usuarios y mostrar banner en GDM
#--------------------------
echo "Ocultar usuarios y configurar banner..."

mkdir -p /etc/dconf/db/gdm.d/

# Ocultar nombres de usuario en la pantalla de inicio de sesión GNOME
echo "[+] Ocultando lista de usuarios en GDM..."
mkdir -p /etc/dconf/db/gdm.d/

cat > /etc/dconf/db/gdm.d/01-banner-message << 'EOF'
[org/gnome/login-screen]
disable-user-list=true
banner-message-enable=true
banner-message-text='AVISO IMPORTANTE DE SEGURIDAD.\n Está usted accediendo a un equipo propiedad de la Organización el cual gestiona información asociada al mismo.\n Todo aquel usuario que tenga derecho de acceso al presente Equipo está sujeto a los requerimientos especificados por la normativa de seguridad establecida.\n El acceso no autorizado podrá dar lugar a las correspondientes acciones legales.\n El uso de este sistema implica la aceptación de dichas condiciones.'
EOF

dconf update

echo "[+] Estableciendo límite de inactividad en GDM..."
mkdir -p /etc/dconf/db/gdm.d/
cat > /etc/dconf/db/local.d/00-screensaver << EOF
[org/gnome/desktop/session]
idle-delay=uint32 300

[org/gnome/desktop/screensaver]
lock-enabled=true
lock-delay=uint32 0
EOF


dconf update

# Banner de advertencia
echo "[+] Creando banner de advertencia..."
cat <<EOF > /etc/issue
AVISO IMPORTANTE DE SEGURIDAD
 
Está usted accediendo a un equipo propiedad de la Organización el cual gestiona información asociada al mismo.
Todo aquel usuario que tenga derecho de acceso al presente Equipo, está sujeto a todos los requerimientos especificados por la normativa de seguridad establecida.
El acceso no autorizado podrá dar lugar a las correspondientes acciones legales. El acceso al Equipo implica la aceptación expresa de las condiciones anteriores.
El uso de la navegación web del Equipo está restringido al uso de servicios relacionados con la gestión de la organización, páginas necesarias para la funcionalidad de la entidad y/o la prestación de servicios a terceros.
Al igual que la navegación Web, el uso del correo electrónico queda restringido de forma exclusiva a las necesidades de la organización, mediante el servicio autorizado.
EOF
chmod 644 /etc/issue

cat <<EOF > /etc/issue.net
AVISO IMPORTANTE DE SEGURIDAD
 
Está usted accediendo a un equipo propiedad de la Organización el cual gestiona información asociada al mismo.
Todo aquel usuario que tenga derecho de acceso al presente Equipo, está sujeto a todos los requerimientos especificados por la normativa de seguridad establecida.
El acceso no autorizado podrá dar lugar a las correspondientes acciones legales. El acceso al Equipo implica la aceptación expresa de las condiciones anteriores.
El uso de la navegación web del Equipo está restringido al uso de servicios relacionados con la gestión de la organización, páginas necesarias para la funcionalidad de la entidad y/o la prestación de servicios a terceros.
Al igual que la navegación Web, el uso del correo electrónico queda restringido de forma exclusiva a las necesidades de la organización, mediante el servicio autorizado.
EOF
chmod 644 /etc/issue.net

#--------------------------
# Geolocalización
#--------------------------
echo "[+] Desactivando geolocalización..."

if rpm -q geoclue2 &>/dev/null; then
  systemctl stop geoclue.service 2>/dev/null
  systemctl disable geoclue.service 2>/dev/null
  systemctl mask geoclue.service 2>/dev/null
  echo "[+] Servicio geoclue2 enmascarado."
else
  echo "[i] El paquete geoclue2 no está instalado."
fi

#--------------------------
# Servicios innecesarios
#--------------------------
echo "Enmascarar servicios innecesarios..."

systemctl mask telnet.socket 2>/dev/null || true
systemctl mask cups.socket 2>/dev/null || true


#--------------------------
# Políticas criptográficas y red
#--------------------------
echo "Aplicar políticas criptográficas seguras..."
update-crypto-policies --set FUTURE

echo "Deshabilitar respuesta ICMP (ping)..."
echo "net.ipv4.icmp_echo_ignore_all = 1" >> /etc/sysctl.conf
sysctl -p


echo
echo -e "${GREEN}-------------------------------------------------------------------------"
echo -e " CCN-STIC-610 Opciones de seguridad: CONFIGURACIÓN APLICADA "
echo -e " Es posible que para aplicar ciertos cambios sea necesario reiniciar el sistema."
echo -e "-------------------------------------------------------------------------${NC}"

read -n1 -r -p "Pulse cualquier tecla para finalizar..."
