#!/bin/bash
# ---------------------------------------------------------------
# CCN-STIC-610 - Límites de Recursos y Limpieza de Cuentas
# ---------------------------------------------------------------

source "$(dirname "$0")/lib.sh"

clear

echo -e "${CYAN}----------------------------------------------------------------------"
echo -e "  CCN-STIC-610 - Directiva de Privilegios de Usuario en OpenSUSE"
echo -e "----------------------------------------------------------------------"
echo
echo -e "Este script aplica las siguientes directivas de seguridad:"
echo -e "    - Restricciones de recursos (CPU, memoria, ficheros, sesiones)"
echo -e "    - Eliminación de usuarios innecesarios"
echo
echo -e "Antes de ejecutar este script debe asegurarse de:"
echo -e "    - Ejecutarlo con privilegios de root"
echo -e "    - Tener backup de /etc/security/limits.conf"
echo -e "    - Comprobar si hay servicios que dependan de cuentas específicas"
echo
echo -e "----------------------------------------------------------------------${NC}"
echo

read -n1 -r -p "Pulse cualquier tecla para continuar..."

# 1. Verificaciones y Backup
check_root
do_backup "/etc/security/limits.conf"

# 2. Configuración de Límites de Recursos
# Definimos los valores
QUOTA_MEM_PROC="8388608"
MAX_OPEN_FILES="50000"
MAX_PROCESSES="4096"
MAX_SESIONES="4"
MAX_FILE_SIZE="10485760"

LIMITS_CONTENT="# CCN-STIC-610 - Límites de seguridad para usuarios
# Impide que un usuario agote los recursos del sistema

* hard    rss             ${QUOTA_MEM_PROC}
* hard    nofile          ${MAX_OPEN_FILES}
* hard    nproc           ${MAX_PROCESSES}
* hard    fsize           ${MAX_FILE_SIZE}
* hard    maxlogins       ${MAX_SESIONES}
"

log_info "Aplicando límites de recursos..."
create_script "/etc/security/limits.conf" <<< "$LIMITS_CONTENT"

USUARIOS_ELIMINAR=("tcpdump" "flatpak" "wsdd" "games" "operator" "mail" "halt")
log_info "Iniciando limpieza de cuentas de sistema..."

for user in ${USUARIOS_ELIMINAR[@]}; do
	if id "$user"; then
		log_warn "Eliminando usuario: $user"
		# -r elimina también su home y spool de correo
		userdel -r "$user" 2>/dev/null || true
		log_success "Usuario $user eliminado."
	else
		log_info "El usuario $user no existe. Saltando..."
	fi
done


echo
echo -e "${GREEN}---------------------------------------------------------------"
echo -e " CCN-STIC-610 Privilegios: CONFIGURACIÓN APLICADA "
echo -e " Revise manualmente las configuraciones aplicadas"
echo -e "---------------------------------------------------------------${NC}"

read -n1 -r -p "Pulse cualquier tecla para finalizar..."
