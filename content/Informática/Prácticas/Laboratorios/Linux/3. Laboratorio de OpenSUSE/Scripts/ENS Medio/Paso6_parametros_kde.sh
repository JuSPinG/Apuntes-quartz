#!/bin/bash

# =================================================================
# CONFIGURACIÓN DE BANNER Y PARÁMETROS DE SEGURIDAD (KDE PLASMA)
# =================================================================

# Definición del Banner Legal
BANN="ATENCION: El acceso a este sistema esta restringido a personal autorizado. Toda actividad es monitoreada."
BANN_ESC=${BANN//\'/\'"\'"\'} # Escapado para scripts
BANN_QML=${BANN//\"/\\\"}    # Escapado para QML (SDDM)

echo "-----------------------------------------------------------"
echo "-- 1. CONFIGURANDO BANNERS LEGALES (SSH, TTY, MOTD)      --"
echo "-----------------------------------------------------------"

# Banner para TTY (Local)
echo "$BANN" > /etc/issue

# Banner para SSH (Remoto previo al login)
echo "$BANN" > /etc/issue.net

# Banner MOTD (Post-login)
echo "$BANN" > /etc/motd

# Configurar SSHD para usar el banner
sed -i 's|^#Banner.*|Banner /etc/issue.net|' /etc/ssh/sshd_config 2>/dev/null || echo "Banner /etc/issue.net" >> /etc/ssh/sshd_config
systemctl restart sshd || systemctl restart sshd

echo "-----------------------------------------------------------"
echo "-- 2. CONFIGURANDO PANTALLA DE LOGIN (SDDM)              --"
echo "-----------------------------------------------------------"

# Ocultar lista de usuarios y forzar login manual
install -d -m 755 /etc/sddm.conf.d
cat >/etc/sddm.conf.d/00-login-screen.conf <<'EOF'
[Theme]
DisableAvatars=true
[Users]
RememberLastUser=false
HideUsers=*
HideAllUsers=true
EOF

# Inyección del Banner Gráfico en el tema Breeze
THEME_DIR="/usr/share/sddm/themes/breeze-corporativo"
if [ -d "/usr/share/sddm/themes/breeze" ]; then
   cp -a /usr/share/sddm/themes/breeze "$THEME_DIR"
   # Insertar componente de texto antes del cierre del archivo Main.qml
   head -n -1 "$THEME_DIR/Main.qml" > "$THEME_DIR/Main.qml.tmp"
   cat >> "$THEME_DIR/Main.qml.tmp" <<EOF
   	   Text {
 	   	   text: "$BANN_QML"
 	   	   color: "white"
 	   	   anchors.bottom: parent.bottom
 	   	   anchors.horizontalCenter: parent.horizontalCenter
 	   	   anchors.bottomMargin: 50
 	   	   font.pointSize: 10
 	   	   horizontalAlignment: Text.AlignHCenter
 	   	   wrapMode: Text.WordWrap
 	   	   width: parent.width * 0.8
   	   }
}
EOF

   mv "$THEME_DIR/Main.qml.tmp" "$THEME_DIR/Main.qml"

# Activar el tema modificado
cat >/etc/sddm.conf.d/10-theme.conf <<EOF
[Theme]
Current=breeze-corporativo
EOF
fi

echo "-----------------------------------------------------------"
echo "-- 3. LIMITANDO TIEMPOS DE INACTIVIDAD (KIOSK MODE)      --"
echo "-----------------------------------------------------------"

# Inactividad de Pantalla (10 min) y Bloqueo Inmediato
# Usamos [$i] para que el usuario no pueda cambiarlo en Preferencias del Sistema
install -d -m 755 /etc/xdg
cat >/etc/xdg/kscreenlockerrc <<'EOF'
[Daemon][$i]
Autolock=true
Timeout=10
LockGrace=1
EOF

# TMOUT para Terminal (Shells interactivas)
install -m 644 /dev/null /etc/profile.d/90-tmout.sh
cat >/etc/profile.d/90-tmout.sh <<'EOF'
case $- in
	   *i*) TMOUT=600; readonly TMOUT; export TMOUT ;;
esac
EOF

echo "-----------------------------------------------------------"
echo "-- 4. POLÍTICAS DE PRIVACIDAD Y RECURSOS                 --"
echo "-----------------------------------------------------------"

# Deshabilitar documentos recientes y automontaje de USB
cat >>/etc/xdg/kdeglobals <<'EOF'
[KDE Action Restrictions][$i]
action/recent_documents=false
EOF

cat >/etc/xdg/kded5rc <<'EOF'
[Module-device_automounter][$i]
autoload=false
EOF
cp /etc/xdg/kded5rc /etc/xdg/kded6rc 2>/dev/null || true

# Forzar 1 solo Escritorio Virtual
cat >>/etc/xdg/kwinrc <<'EOF'
[Desktops][$i]
Number=1
EOF

echo "-----------------------------------------------------------"
echo "-- APLICANDO CAMBIOS                                     --"
echo "-----------------------------------------------------------"

# Reiniciar el gestor de pantalla para ver cambios en el login
systemctl restart display-manager || true

echo "Configuración completada exitosamente."