#!/bin/bash

# Colores
CYAN='\033[1;36m'
GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m'

clear

echo -e "${CYAN}----------------------------------------------------------------------------"
echo -e "  CCN-STIC-610 - Protección ante Código Dañino en RHEL"
echo -e "----------------------------------------------------------------------------"
echo -e
echo -e "Este script aplica las siguientes medidas de seguridad:"
echo -e "  - Deshabilitar compiladores del sistema para usuarios no root"
echo -e "  - Habilitar SELinux en modo 'enforcing'"
echo -e
echo -e "Debe ejecutarse como root. Verifique previamente que su sistema no"
echo -e "depende de compilaciones manuales o herramientas de desarrollo."
echo -e "----------------------------------------------------------------------------${NC}"

read -n1 -r -p "Pulse cualquier tecla para continuar..."

# Comprobar si se ejecuta como root
if [ "$EUID" -ne 0 ]; then
  echo -e "\n${RED}[ERROR] Este script debe ejecutarse como root.${NC}"
  exit 1
fi

#------------------------------------------------------------
# Deshabilitar compiladores del sistema
#------------------------------------------------------------
echo -e "\n${GREEN}[+] Deshabilitando compiladores del sistema para usuarios no root...${NC}"

COMPILADORES=("/usr/bin/gcc" "/usr/bin/cc" "/usr/bin/make")

for comp in "${COMPILADORES[@]}"; do
  if [ -f "$comp" ]; then
    chmod 700 "$comp"
    echo "  [OK] Permisos restringidos: $comp"
  else
    echo "  [INFO] No encontrado: $comp"
  fi
done

#------------------------------------------------------------
# Comprobación y habilitación de SELinux
#------------------------------------------------------------
echo -e "\n${GREEN}[+] Verificando y configurando SELinux...${NC}"

SELINUX_CONF="/etc/selinux/config"
CURRENT_MODE=$(getenforce 2>/dev/null)

if [ "$CURRENT_MODE" != "Enforcing" ]; then
  echo "  [INFO] SELinux no está en modo Enforcing (actual: $CURRENT_MODE)"
  echo "  [INFO] Estableciendo SELINUX=enforcing en $SELINUX_CONF..."

  if grep -q '^SELINUX=' "$SELINUX_CONF"; then
    sed -i 's/^SELINUX=.*/SELINUX=enforcing/' "$SELINUX_CONF"
  else
    echo 'SELINUX=enforcing' >> "$SELINUX_CONF"
  fi

  # Aplicar cambio en tiempo real
  setenforce 1 2>/dev/null && echo "  [OK] SELinux activado en tiempo real" || echo "  [!] Requiere reinicio para aplicar"
else
  echo "  [OK] SELinux ya está en modo Enforcing"
fi

# Final
echo -e "\n${GREEN}----------------------------------------------------------------"
echo " CCN-STIC-610 Protección contra código dañino: CONFIGURACIÓN APLICADA"
echo -e "----------------------------------------------------------------${NC}"

read -n1 -r -p "Pulse cualquier tecla para finalizar..."