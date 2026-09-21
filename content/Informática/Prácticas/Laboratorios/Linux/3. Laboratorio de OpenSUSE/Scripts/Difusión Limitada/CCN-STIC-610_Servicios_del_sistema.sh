#!/bin/bash
# ---------------------------------------------------------------
# CCN-STIC-610 - Servicios del sistema
# ---------------------------------------------------------------
source "$(dirname "$0")/lib.sh"

clear

echo -e "${CYAN}------------------------------------------------------------------"
echo -e "  CCN-STIC-610 - Gestión de Servicios del Sistema en OpenSUSE"
echo -e "------------------------------------------------------------------"
echo
echo -e "Este script configura el estado de servicios del sistema."
echo -e "Incluye activación, desactivación y enmascaramiento si procede."
echo -e "Debe ejecutarse como root."
echo -e "------------------------------------------------------------------${NC}"

read -n1 -r -p "Pulse cualquier tecla para continuar..."

check_root

# -------- SERVICIOS --------

# Servicios necesarios
enable_service firewalld       "Cortafuegos dinámico (firewalld)"
enable_service auditd          "Auditoría de eventos del sistema (auditd)"
enable_service sshd            "Servidor SSH para conexión remota segura"
enable_service cron           "Gestor de tareas programadas (cron)"
enable_service chronyd         "Sincronización de tiempo de red (NTP)"
enable_service vsftpd          "Servidor FTP seguro (vsftpd)"

#Servicios deshabilitados o enmascarados por seguridad o innecesarios


mask_service bluetooth         "Soporte para dispositivos Bluetooth"
mask_service ModemManager      "Gestión de módems 3G/4G"
mask_service fprintd           "Servicio de autenticación biométrica"
mask_service cups              "Servidor de impresión (CUPS)"
mask_service avahi-daemon      "Descubrimiento de servicios en red local (Avahi)"
mask_service smb               "Compartición de archivos mediante Samba"
mask_service rpcbind           "RPCBind para servicios NFS antiguos"
mask_service postfix           "Servidor de correo saliente (Postfix)"
mask_service wpa_supplicant    "Conexión a redes Wi-Fi"
mask_service speech-dispatcherd "Síntesis de voz (Speech dispatcher)"
mask_service kpatch            "Actualizaciones del kernel en vivo"
mask_service ledmon            "Monitorización de LEDs para RAID"
mask_service microcode         "Actualización del microcódigo del procesador"
mask_service hypervvssd        "Integración de servicios Hyper-V: volumen shadow copy"
mask_service hypervkvpd        "Integración de servicios Hyper-V: gestión de claves"
mask_service hypervfcopyd      "Integración de servicios Hyper-V: copiar archivos"
mask_service realmd            "Unión a dominios de red (Realmd)"
mask_service geoclue           "Detección de ubicación geográfica"
mask_service geoclue2          "Detección de ubicación geográfica (versión 2)"
mask_service brltty            "Soporte para pantallas Braille"
mask_service canberra-system-bootup         "Sonido de inicio (Canberra)"
mask_service canberra-system-shutdown       "Sonido de apagado (Canberra)"
mask_service canberra-system-shutdown-reboot "Sonido de reinicio (Canberra)"
mask_service cockpit           "Interfaz web para gestión del sistema"
mask_service cockpit-wsinstance-https       "Instancia HTTPS de Cockpit"
mask_service cockpit-wsinstance-http        "Instancia HTTP de Cockpit"
mask_service podman            "Contenedores rootless (Podman)"
mask_service podman-auto-update "Actualización automática de contenedores"
mask_service podman-restart    "Reinicio de contenedores Podman"
mask_service nis-domainname    "Soporte para dominio NIS"
mask_service unbound-anchor    "Verificación del anclaje de DNSSEC (Unbound)"
mask_service setroubleshootd   "Herramienta de análisis de errores SELinux"
mask_service switcheroo-control "Gestión de GPU híbrida (Switcheroo)"
mask_service pcscd             "Servicios de lector de tarjetas inteligentes (PC/SC)"
mask_service low-memory-monitor "Monitor de memoria baja"
mask_service iscsid            "Gestión de conexiones iSCSI"
mask_service iscsi             "Cliente iSCSI"
mask_service iscsiuio          "Proceso auxiliar iSCSI"
mask_service iscsi-starter     "Arranque automático de iSCSI"
mask_service iscsi-onboot      "iSCSI en arranque"
mask_service rasdaemon         "Demonio de informes de errores hardware (RAS)"
mask_service mcelog            "Registro de errores de CPU (Machine Check Exception)"
mask_service packagekit        "Gestor automático de paquetes (GUI)"
mask_service packagekit-offline-update "Actualizaciones offline (PackageKit)"
mask_service sssd-ssh          "Integración de SSSD para SSH"
mask_service sssd-sudo         "Integración de SSSD para Sudo"
mask_service sssd-kcm          "Gestor de credenciales Kerberos (KCM)"
mask_service sssd-pac          "Validación PAC de Kerberos en SSSD"
mask_service sssd-autofs       "Autofs vía SSSD"


echo
echo -e "${GREEN}---------------------------------------------------------------"
echo -e " CCN-STIC-610 Servicios: CONFIGURACIÓN APLICADA "
echo -e "---------------------------------------------------------------${NC}"

read -n1 -r -p "Pulse cualquier tecla para finalizar..."
