#!/bin/bash
# ---------------------------------------------------------------
# CCN-STIC-610 - Seguridad sobre ficheros y directorios
# ---------------------------------------------------------------
source "$(dirname "$0")/lib.sh"

clear

# Encabezado
echo -e "${CYAN}----------------------------------------------------------------------------"
echo -e "  CCN-STIC-610 - Seguridad en Ficheros y Directorios del Sistema en OpenSUSE"
echo -e "----------------------------------------------------------------------------"
echo
echo -e "Este script refuerza los permisos de los siguientes archivos y directorios:"
echo -e "  - /etc/shadow"
echo -e "  - /etc/passwd"
echo -e "  - /etc/group"
echo -e "  - /etc/sudoers"
echo -e "  - /root/"
echo -e "  - /etc/fstab"
echo
echo -e "Debe ejecutarse como root. Se aplicarán los permisos recomendados."
echo -e "----------------------------------------------------------------------------${NC}"

read -n1 -r -p "Pulse cualquier tecla para continuar..."

check_root

log_info "Estableciendo permisos seguros..."

# /etc/shadow: solo root puede leerlo
chmod 000 /etc/shadow && chown root:root /etc/shadow \
  && log_success "/etc/shadow protegido." \
  || log_info "Error al proteger /etc/shadow."

# /etc/passwd: lectura pública permitida
chmod 644 /etc/passwd && chown root:root /etc/passwd \
  && log_success "/etc/passwd seguro." \
  || log_info "Error al configurar /etc/passwd."

# /etc/group: lectura pública permitida
chmod 644 /etc/group && chown root:root /etc/group \
  && log_success "/etc/group seguro." \
  || log_info "Error al configurar /etc/group."

# /etc/sudoers: solo lectura para root
chmod 440 /etc/sudoers && chown root:root /etc/sudoers \
  && log_success "/etc/sudoers seguro." \
  || log_info "Error al proteger /etc/sudoers."

# /root: acceso exclusivo a root
chmod 700 /root && chown root:root /root \
  && log_success "/root protegido." \
  || log_info "Error al proteger /root."

# /etc/fstab: lectura general, escritura solo root
chmod 644 /etc/fstab && chown root:root /etc/fstab \
  && log_success "/etc/fstab seguro." \
  || log_info "Error al configurar /etc/fstab."

echo
echo -e "${GREEN}---------------------------------------------------------------"
echo -e " CCN-STIC-610 Permisos de archivos: CONFIGURACIÓN APLICADA "
echo -e "---------------------------------------------------------------${NC}"

read -n1 -r -p "Pulse cualquier tecla para finalizar..."
