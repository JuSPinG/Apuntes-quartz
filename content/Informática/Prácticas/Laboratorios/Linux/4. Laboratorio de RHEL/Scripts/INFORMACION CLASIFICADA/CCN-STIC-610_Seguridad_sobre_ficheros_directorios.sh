#!/bin/bash

# Colores
CYAN='\033[1;36m'
GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m' 


clear

echo -e "${CYAN}--------------------------------------------------------------------------------------"
echo -e "  CCN-STIC-610 - Seguridad en Ficheros y Directorios del Sistema en RHEL"
echo -e "--------------------------------------------------------------------------------------"
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
echo -e "--------------------------------------------------------------------------------------${NC}"

read -n1 -r -p "Pulse cualquier tecla para continuar..."

echo
echo "[+] Estableciendo permisos seguros..."

# /etc/shadow: solo root puede leerlo
chmod 000 /etc/shadow && chown root:root /etc/shadow \
  && echo -e "${GREEN}  → /etc/shadow protegido${NC}" \
  || echo -e "${RED}  [✗] Error al proteger /etc/shadow${NC}"

# /etc/passwd: lectura pública permitida
chmod 644 /etc/passwd && chown root:root /etc/passwd \
  && echo -e "${GREEN}  → /etc/passwd seguro${NC}" \
  || echo -e "${RED}  [✗] Error al configurar /etc/passwd${NC}"

# /etc/group: lectura pública permitida
chmod 644 /etc/group && chown root:root /etc/group \
  && echo -e "${GREEN}  → /etc/group seguro${NC}" \
  || echo -e "${RED}  [✗] Error al configurar /etc/group${NC}"

# /etc/sudoers: solo lectura para root
chmod 440 /etc/sudoers && chown root:root /etc/sudoers \
  && echo -e "${GREEN}  → /etc/sudoers seguro${NC}" \
  || echo -e "${RED}  [✗] Error al proteger /etc/sudoers${NC}"

# /root: acceso exclusivo a root
chmod 700 /root && chown root:root /root \
  && echo -e "${GREEN}  → /root protegido${NC}" \
  || echo -e "${RED}  [✗] Error al proteger /root${NC}"

# /etc/fstab: lectura general, escritura solo root
chmod 644 /etc/fstab && chown root:root /etc/fstab \
  && echo -e "${GREEN}  → /etc/fstab seguro${NC}" \
  || echo -e "${RED}  [✗] Error al configurar /etc/fstab${NC}"

echo
echo -e "${GREEN}---------------------------------------------------------------"
echo -e " CCN-STIC-610 Permisos de archivos: CONFIGURACIÓN APLICADA "
echo -e "---------------------------------------------------------------${NC}"

read -n1 -r -p "Pulse cualquier tecla para finalizar..."
