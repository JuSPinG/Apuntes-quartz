#!/bin/bash

# Colores
CYAN='\033[1;36m'
GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m'

clear


echo -e "${CYAN}----------------------------------------------------------------------------"
echo -e "  CCN-STIC-610 - Protección de GRUB con Usuario y Contraseña en RHEL"
echo -e "----------------------------------------------------------------------------"
echo
echo -e "Este script aplica medidas para proteger el arranque del sistema:"
echo -e "  - Añadir usuario de GRUB"
echo -e "  - Cifrar la contraseña"
echo -e "  - Restringir el acceso a opciones del kernel"
echo
echo -e "Requisitos:"
echo -e "  - Ejecutar como root"
echo -e "  - Herramienta grub2-mkpasswd-pbkdf2 instalada"
echo -e "----------------------------------------------------------------------------${NC}"
echo

read -n1 -r -p "Pulse cualquier tecla para continuar..."

# Validar requisitos
if ! command -v grub2-mkpasswd-pbkdf2 &>/dev/null; then
    echo -e "${RED}[ERROR] grub2-mkpasswd-pbkdf2 no está instalado.${NC}"
    exit 1
fi

# Crear copia de seguridad
cp -a /etc/grub.d/40_custom /etc/grub.d/40_custom.bak_$(date +%F_%T)

# Crear hash de contraseña
echo -e " A continuacion se solicitara la contraseña para GRUB"
grub2-mkpasswd-pbkdf2 | tee /tmp/hash
HASH=$(tail -n1 /tmp/hash | awk '{print $NF}')

# Obtener versión y archivo de entrada
KERNEL_VERSION=$(uname -r)
ENTRY_FILE=$(ls /boot/loader/entries/ | grep "$KERNEL_VERSION" | head -n1)
ENTRY_PATH="/boot/loader/entries/$ENTRY_FILE"

if [ ! -f "$ENTRY_PATH" ]; then
    echo -e "${RED}[ERROR] No se encontró entrada del kernel en $ENTRY_PATH${NC}"
    exit 1
fi

# Copia de seguridad de entrada original
cp "$ENTRY_PATH" "${ENTRY_PATH}.bak_$(date +%F_%T)"

# Obtener ID de entrada actual
ENTRY_ID=$(grep "^id" "$ENTRY_PATH")

# Solicitar usuario administrador
read -p "Introduzca el usuario administrador de GRUB: " GRUB_USER

# Añadir configuración al archivo 40_custom
echo "set superusers=\"$GRUB_USER\"" >> /etc/grub.d/40_custom
echo "password_pbkdf2 $GRUB_USER $HASH" >> /etc/grub.d/40_custom

# Eliminar entradas rescue si existen
echo "[*] Eliminando entradas rescue..."
rm -f /boot/*rescue* /boot/loader/entries/*rescue* 2>/dev/null

# Reescribir entrada protegida
cat > "$ENTRY_PATH" << EOF
title SISTEMA RESTRINGIDO A USUARIOS AUTORIZADOS - INICIE RHEL
version $KERNEL_VERSION
linux /vmlinuz-$KERNEL_VERSION
initrd /initramfs-$KERNEL_VERSION.img \$tuned_initrd
options \$kernelopts \$tuned_params
$ENTRY_ID
grub_users \$grub_users
grub_arg --unrestricted
grub_class kernel
EOF

# Regenerar GRUB según el tipo de sistema (BIOS o UEFI)
echo "[*] Detectando tipo de sistema y regenerando configuración de GRUB..."

# Comprobación de entorno de arranque
if [ -d /sys/firmware/efi ]; then
    echo "[+] Sistema UEFI detectado."
    GRUB_CFG_PATH="/boot/efi/EFI/rocky/grub.cfg"
    grub2-mkconfig -o "$GRUB_CFG_PATH" || {
        echo -e "${RED}[ERROR] No se pudo generar el GRUB para UEFI.${NC}"
        sleep 2
        exit 1
    }
else
    echo "[+] Sistema BIOS (legacy) detectado."
    GRUB_CFG_PATH="/boot/grub2/grub.cfg"
    grub2-mkconfig -o "$GRUB_CFG_PATH" || {
        echo -e "${RED}[ERROR] No se pudo generar el GRUB para BIOS.${NC}"
        sleep 2
        exit 1
    }
fi

# # Regenerar GRUB (Hyper-V)
# echo "[*] Regenerando configuración de GRUB..."
# GRUB_CFG_PATH="/boot/grub2/grub.cfg"

# grub2-mkconfig -o "$GRUB_CFG_PATH" || {
#     echo -e "${RED}[ERROR] No se pudo generar el GRUB correctamente.${NC}"
#     exit 1
# }

# chmod 600 "$GRUB_CFG_PATH"



# Limpiar hash temporal
rm -f /tmp/hash

echo
echo -e "${GREEN}---------------------------------------------------------------"
echo -e " CCN-STIC-610 Proteccion de GRUB: CONFIGURACIÓN APLICADA "
echo -e " Revise manualmente las configuraciones aplicadas"
echo -e "---------------------------------------------------------------${NC}"

read -n1 -r -p "Pulse cualquier tecla para finalizar..."
