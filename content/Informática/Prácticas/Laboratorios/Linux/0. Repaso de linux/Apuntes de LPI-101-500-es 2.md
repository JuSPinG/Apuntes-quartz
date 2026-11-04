Enlace: [[LPI-101-500-es 2.pdf]].

Únicamente apuntaré lo que no sepa o me parezca interesante.
# Lección 101.1: Determinar y configurar el _hardware_
Enlace: [[LPI-101-500-es 2.pdf#page=13&selection=0,0,0,15|LPI-101-500-es 2, página 13]].

## Comandos de interés

| Comando    | Utilidad                                                                 | Ejemplo                 | Enlace                                                                                |
| ---------- | ------------------------------------------------------------------------ | ----------------------- | ------------------------------------------------------------------------------------- |
| `lspci`    | Muestra los dispositivos enganchados al [[1.4.2 Estructura de bus\|bus]] | `lspci`                 | [[LPI-101-500-es 2.pdf#page=15&selection=10,0,37,24\|LPI-101-500-es 2, página 15]]    |
| `lsusb`    | Muestra los dispositivos enganchados al usb                              | `lsusb`                 | [[LPI-101-500-es 2.pdf#page=15&selection=39,0,66,51\|LPI-101-500-es 2, página 15]]    |
| `lsmod`    | Muestra todos los módulos cargados del kernel                            | `lsmod`                 | [[LPI-101-500-es 2.pdf#page=18&selection=258,54,262,39\|LPI-101-500-es 2, página 18]] |
| `modprobe` | Interactúa con el módulo cargado en el kernel                            | `modprobe -r hv_netvsc` | [[LPI-101-500-es 2.pdf#page=20&selection=33,61,57,16\|LPI-101-500-es 2, página 20]]   |

^64614a

| `init` | Inicia o apaga el equipo en condiciones especiales | `init 0/1/3/5/6` | [[LPI-101-500-es 2.pdf#page=48&selection=129,0,148,21\|LPI-101-500-es 2, página 48]] |
| ------ | -------------------------------------------------- | ---------------- | ------------------------------------------------------------------------------------ |
## Ejercicios Guiados

1. Supongamos que un sistema operativo no puede iniciarse después de agregar un segundo disco SATA al sistema. Sabiendo que ninguno de los dispositivos está defectuoso, ¿cuál podría ser la posible causa de este error?

> [!info]- Propuesta.
> Fallo en los drivers o en el kernel. Asumiendo, por ejemplo, que enchufo un USB 3.2 a un puerto USB 1.0 (de hace muchos años), sin un diseño perspicaz, el equipo podría no detectar correctamente el dispositivo. Para ver cuál es la causa del error, se podría:
>
>1. `modinfo` si es del kernel.
>2. `lspci` para ver la conexión.
>3. `ls /etc/dev/` para ver si el equipo lo reconoce.
>4. Revisar la BIOS en busca de cargadores de _hardware_ desactivados.

2. Suponga que desea asegurarse de que la tarjeta de video externa conectada al bus PCI de su computadora de escritorio recién adquirida realmente sea la anunciada por el fabricante, pero al abrir el cajón de la computadora anularía la garantía. ¿Qué comando podría usarse para enumerar los detalles de la tarjeta de video, tal como fueron detectados por el sistema operativo?

> [!info]- Propuesta.
> El comando `lspci` nos muestra todos los componentes enganchados al [[1.4.2 Estructura de bus|bus]], por lo que lo suyo sería ejecutar el comando y verificar si se lista la tarjeta de video externa.


3. La siguiente línea es parte de la salida generada por el comando `lspci`:
   ```sh
   03:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS 2208 [Thunderbolt] (rev 05)
   ```
   ¿Qué comando debe ejecutar para identificar el módulo del núcleo del sistema operativo en uso para este dispositivo específico?


> [!info]- Propuesta.
> Usaría los parámetros `-v -d` del mismo comando `lspci`:
> ```sh
> lspci -v -s 03:00.0
> ```

4. Un administrador del sistema quiere probar diferentes parámetros para el módulo del kernel bluetooth sin reiniciar el sistema. Sin embargo, cualquier intento de descargar el módulo con `modprobe -r bluetooth` da como resultado el siguiente error:
   ```sh
   modprobe: FATAL: Module bluetooth is in use.
   ```
   ¿Cuál es la posible causa de este error?


> [!info]- Propuesta.
> El módulo está en uso, por lo que si está haciendo alguna operación medianamente crítica, no podrá desconectarse sin un buen motivo. Un cirujano no puede irse en mitad de la operación para atender a un familiar. Le recomiendo al administrador que reinicie el equipo. Si el fallo persiste, que meta su implementación del kernel en la lista negra de módulo que no se van a aplicar para luego poder tenerlo liberado.

# Lección 101.2: Arranque del sistema

Enlace: [[LPI-101-500-es 2.pdf#page=31&selection=0,0,0,14|LPI-101-500-es 2, página 31]].

En el cargador de arranque (GRUB) se pueden modificar algunos parámetros si uno pulsa la tecla "e" mientras inicia el equipo:

1. `acpi`: Habilita/deshabilita el soporte ACPI.  
	- `acpi=off` deshabilitará la compatibilidad con ACPI.
2. `init`: Establece un iniciador de sistema alternativo.  
	- Ejemplo: `init=/bin/bash` iniciará una sesión de shell justo después del arranque del kernel.
3. `systemd.unit`: Define el objetivo (target) de systemd que se activará.  
	- Ejemplo: `systemd.unit=graphical.target`.  
	- También acepta [[#^64614a|niveles de ejecución de SysV]] (por ejemplo, `1` o `S` para modo single).
4. `mem`: Establece la cantidad de RAM disponible para el sistema.  
	- Ejemplo: `mem=512M` limita la RAM a 512 MB.
5. `maxcpus`: Limita el número de procesadores o núcleos visibles para el sistema.  
	- Ejemplo: `maxcpus=2` limita a dos CPUs.  
	- `maxcpus=0` desactiva soporte multiprocesador (equivalente a `nosmp`).
6. `quiet`: Oculta la mayoría de los mensajes de arranque.
7. `vga`: Selecciona un modo de video.  
	- Ejemplo: `vga=ask` muestra una lista de modos disponibles.
8. `root`: Establece la partición raíz.  
	- Ejemplo: `root=/dev/sda3`.
9. `rootflags`: Define opciones de montaje para el sistema de archivos raíz.
10. `ro`: Monta inicialmente el sistema de archivos raíz en modo solo lectura.
11. `rw`: Permite escritura en el sistema de archivos raíz durante el montaje inicial.