- Crear un usuario: `adduser {nombre}`
- Crear grupo: `addgroup {nombre}`
- Modificar valores del usuario: `usermod {nombre} [flags]`
- Mete a un usuario en un grupo: `usermod -aG {grupo} {nombre}`
- Sacar a un usuario de un grupo: `groupdel {nombre} {grupo}`
- Eliminar un usuario: `deluser {nombre}`
- Eliminar un grupo: `delgroup {grupo}`
- Obtener información de un usuario: `id {nombre}`
- Obtener información de un grupo: `gorups {grupo}`

Carpetas donde encontrar información relacionada:

En "/etc/group" se encuentra información de los grupos, y en "/etc/passwd" se encuentran los archivos de configuración de los usuarios y grupos del sistema. Con `cat {group | passwd}` se puede mostrar dicho archivo. Con `id {nombre}`, se puede obtener la información de un usuario.