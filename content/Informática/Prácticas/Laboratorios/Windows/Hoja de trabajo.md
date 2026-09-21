```ps1
Unblock-File .\CCN-STIC-570A25_PerfiladoSeguridadWindowsServer.ps1
powershell -ExecutionPolicy Bypass -File .\CCN-STIC-570A25_RegresionBastionado.ps1
```


- [x] 570A25.
- [x] 570A23.
- [x] 573-25.
- [x] 570A21.
- [ ] 577A21.

# Problemas con 570A25
## El SharePoint es inaccesible desde el cliente

URL: marcos-sp:21151. Los errores de acceso son múltiples:

1. No se puede acceder desde fuera de localhost.
2. No se puede acceder a la página porque falla: Se recomienda reiniciar el servidor.
3. No se puede acceder porque las credenciales no funcionan: Se recomienda usar un usuario local (provisional). ^b370c5

- [x] "marcos.loc\/\*": Cuando están las políticas de la raíz activadas.
- [ ] "marcos.loc\/Domain Controllers": Cuando las políticas de esta carpeta están activadas. **Fallo de autenticación \[[[#^b370c5|3]]]**.
	- [x] "CCN-STIC-570A25_Incremental RDP".
	- [x] "CCN-STIC-570A25_DC_AnexoF - Bitlocker (Difusion Limitada)".
	- [x] "CCN-STIC-570A25_DC_AnexoE - Control de Dispositivos".
	- [x] "CCN-STIC-570A25_DC_AnexoD - Red y Firewall (Difusion Limitada)".
	- [ ] "CCN-STIC-570A25_DC_AnexoB - Seguridad, auditoria y registros (Difusion Limitada)": **Fallo de autenticación \[[[#^b370c5|3]]]** .
	- [x] "CCN-STIC-570A25_DC_AnexoA - ADMX (Difusion Limitada)".
- [x] "marcos.loc\/\*\*": Cuando el resto de políticas están habilitadas.

**Culpable**: "marcos.loc\/Domain Controllers\/CCN-STIC-570A25_DC_AnexoB - Seguridad, auditoria y registros (Difusion Limitada)".

Contenido de la política: [[Izertis/Izertis/Laboratorios/Windows/Recursos/CCN-STIC-570A25_DC_AnexoB - Seguridad, auditoria y registros (Difusion Limitada)]].

Enmienda de la política:

1. Configuración de equipo, Directivas, Configuración de Windows, Configuración de seguridad, Directivas locales, Opciones de seguridad.
	1. Seguridad de red: Restringir NTLM: tráfico NTLM entrante. Modificado a "Permitir todo", desde "Denegar todas las cuentas".
	2. Seguridad de red: restringir NTLM: autenticación NTLM en este dominio. Modificado a "Deshabilitar", desde "Denegar para cuentas de este dominio en servidores de dominio".

La enmienda ha sido aplicada con éxito, la autenticación NTLM funciona correctamente. El SharePoint funciona, aunque un poco lento. Asumiré que en una red normal, con mejores máquinas, esto debería funcionar más rápido.

![[Izertis/Izertis/Laboratorios/Windows/Recursos/Problemas y soluciones de SharePoint.png]]
![[Izertis/Izertis/Laboratorios/Windows/Recursos/Uso excesivo de los recursos del servidor de SharePoint.png]]

Parece que estoy en lo cierto.

## Error 503 al acceder a la página de SharePoint

**Culpable**: "CCN-STIC-570A25_Servidor Miembro_AnexoB - Seguridad, auditoria y registros (Difusion Limitada)"

Contenido de la política: [[Izertis/Izertis/Laboratorios/Windows/Recursos/CCN-STIC-570A25_Servidor Miembro_AnexoB - Seguridad, auditoria y registros (Difusion Limitada)]].

Enmienda de la política:

1. Configuración del equipo, Configuración de Windows, Configuración de seguridad, Directivas locales.
	1. Asignación de derechos de usuario.
		1. Iniciar sesión como proceso por lotes. Modificado a "No esta definido", desde "Sí está definido".
		2. Iniciar sesión como servicio: Modificado a "No esta definido", desde "Sí está definido".
	2. Opciones de seguridad.
		1. Seguridad de red: restringir NTLM: autenticación NTLM en este dominio. Modificado a "Deshabilitar", desde "Denegar para cuentas de domino".
		2. Seguridad de red: restringir NTLM: trafico NTLM entrante. Modificado a "Permitir todo", desde "Denegar todas las cuentas".

http://marcos-sp2:40063/default.aspx
http://marcos-sp2/

## Para cuando se aplica la guía en otro servidor

El Anexo A elimina un montón de servicios y roles, esta es una lista que hay que añadir a la lista blanca de programas que no se van a eliminar.
### Para SharePoint

> [!Info]- Lista blanca
>```ps1
"Web-Server",
"Web-WebServer",
"Web-Common-Http",
"Web-Default-Doc",
"Web-Dir-Browsing",
"Web-Http-Errors",
"Web-Static-Content",
"Web-Http-Redirect",
"Web-Health",
"Web-Http-Logging",
"Web-Request-Monitor",
"Web-Http-Tracing",
"Web-Performance",
"Web-Stat-Compression",
"Web-Dyn-Compression",
"Web-Security",
"Web-Filtering",
"Web-Basic-Auth",
"Web-Windows-Auth",
"Web-Digest-Auth",
"Web-Client-Auth",
"Web-Cert-Auth",
"Web-IP-Security",
"Web-Url-Auth",
"Web-App-Dev",
"Web-Net-Ext45",
"Web-Asp-Net45",
"Web-ISAPI-Ext",
"Web-ISAPI-Filter",
"Web-Includes",
"Web-WebSockets",
"Web-Mgmt-Tools",
"Web-Mgmt-Console",
"NET-Framework-45-Core",
"NET-Framework-45-ASPNET",
"NET-WCF-Services45",
"NET-WCF-TCP-PortSharing45",
"Windows-Identity-Foundation",
"Server-Media-Foundation",
"NET-Framework-Core",
"NET-HTTP-Activation",
"NET-Non-HTTP-Activ",
"Web-Mgmt-Service",
"MSMQ-Server",
"MSMQ-Directory",
"WAS",
"WAS-Process-Model",
"WAS-NET-Environment",
"WAS-Config-APIs"
>```

### Para File Server

 
> [!Info]- Lista blanca
>```ps1
"FS-SMB1",
"FileAndStorage-Services",
"Storage-Services",
"File-Services",
"FS-FileServer",
"FS-Resource-Manager",
"RSAT-File-Services"
>```

# Problemas con 570A21

## El inicio de sesión con los usuarios del dominio se imposibilita

- [ ] "marcos.loc\/CCN-STIC-570A21 Incremental Servidores Miembro": Cuando la política de esta carpeta están activadas. **Imposible iniciar sesión**.
- [x] "marcos.loc\/\*\*": Cuando el resto de políticas están habilitadas.

**Culpable**: "marcos.loc\/CCN-STIC-570A21 Incremental Servidores Miembro".

Solucionado: Esa política no va ahí, por eso da fallo.

# Extra

En algún momento comprimiré los archivos para ahorrar espacio. Si es fuese el caso y no tengo permiso más adelante para que las máquinas lean sus discos, es tan fácil como ejecutar el siguiente comando:

```powershell
icacls "C:\ProgramData\Microsoft\Windows\Virtual Hard Disks\*" /grant "*S-1-5-83-0:(F)"
```