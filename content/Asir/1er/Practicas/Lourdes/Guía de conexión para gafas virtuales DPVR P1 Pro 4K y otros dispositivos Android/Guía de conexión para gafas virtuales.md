---
aliases:
  - Guía de conexión para gafas virtuales DPVR P1 Pro 4K y otros dispositivos Android
---
# Índice

- [[#Inicio]].
- [[#Archivos a descargar]].
- [[#Instalación]].
    - [[#En Windows]].
    - [[#En Linux (Debian/Ubuntu)]].
- [[#Configuración del dispositivo Android]].
    - [[#Entrar en el modo desarrollador]].
    - [[#Activar la depuración USB]].
- [[#Conexión entre los dispositivos]].
    - [[#Transmisión por cable]].
    - [[#Transmisión inalámbrica]].
        - [[#Conexión]].
        - [[#Desconexión]].
- [[#Posibles problemas]].
- [[#Un ejemplo práctico]].


# Inicio

Esta guía va a estar pensada para ordenadores con Windows 10 con potencia baja o media. No se requiere de ningún _software_ instalado previamente.

Algunos enlaces de interés:

- [GitHub de "Scrcpy"](https://github.com/Genymobile/scrcpy?tab=readme-ov-file).

# Archivos a descargar

Va a ser necesaria la instalación de "Scrcpy" junto con "adb". La página web de GitHub que recomiendo usar para instalar "Scrcpy" tiene incluido el "adb", por lo que no es necesario instalarlo de nuevo.

El comprimible de "Scrcpy" se puede encontrar [aquí](https://github.com/Genymobile/scrcpy/releases/download/v3.1/scrcpy-win64-v3.1.zip).

![[Decargar Scrcpy.png]]
# Instalación

## En Windows

Una vez descomprimido, será necesario agregar la carpeta con el programa a las "variables de entorno" o "Path". En lo personal, voy a guardar la carpeta en "Archivos de Programa".

![[Carpeta Scrcpy.png]]
![[Agregar Scrcpy al path.png]]
![[Entrar a las variables de entorno.png]]

![[Ver PATH.png]]

![[Guardar Scrcpy en el PATH.png]]

Es posible que sea necesario reiniciar el ordenador para que este reconozca el nuevo elemento de las variables de entorno. Para comprobar si esta acción es necesaria o no, abra la consola con "win + r" y escriba "cmd". A continuación, teclee el siguiente comando: "`scrcpy --version`".

![[Comando cmd scrcpy --version.png]]

Si no da error, entonces "Scrcpy" está instalado correctamente.

## En Linux (Debian/Ubuntu)

Para instalar Scrcpy en un sistema Debian o Ubuntu, se usa la siguiente secuencia de comandos:

```bash
#!/bin/bash

cd /
sudo apt install ffmpeg libsdl2-2.0-0 adb wget \
                 gcc git pkg-config meson ninja-build libsdl2-dev \
                 libavcodec-dev libavdevice-dev libavformat-dev libavutil-dev \
                 libswresample-dev libusb-1.0-0 libusb-1.0-0-dev
git clone https://github.com/Genymobile/scrcpy
cd scrcpy
./install_release.sh
```

Para una instalación en varias ordenadores, a falta de un servidor central que coordine los equipos, se puede crear un archivo "bash" para cargarlo en una memoria extraíble, que contenga el siguiente programa:

```bash
#!/bin/bash

sudo cp InstalarScrcpy.sh /
cd /
sudo bash InstalarScrcpy.sh
```

Donde el fichero InstalarScrcpy.sh contiene la secuencia de comandos anterior. Así, se puede ejecutar el programa, y, mientras se instala, expulsar la unidad de memoria e ir al siguiente ordenador.

# Configuración del dispositivo Android

## Entrar en el modo desarrollador

Es necesario habilitar la depuración por USB del dispositivo Andriod, para ello, hay que entrar en el modo desarrollador. Esta opción está un poco escondida, y en las gafas DPVR P1 Pro 4K del Colegio Lourdes ya estan habilitadas ambas opciones, pero si, por ejemplo, quiere hacer esto desde un nuevo dispositivo, es necesario habilitar dicha opción. En el dispositivo Android, diríjase a "Ajustes", "Sobre el teléfono/Información del sistema", "Todas las especificaciones" (en caso de que esta opción exista); por último, pulse el letrero "Versión de compilación/Versión MIUI" repetidas veces hasta que entre en el modo desarrollador.

Cabe aclarar que cada plataforma puede cambiar el método de acceso al modo desarrollador, por lo que es recomendable buscar documentación en internet si se tiene problemas.

## Activar la depuración USB

La depuración USB, como bien he dicho antes, es una opción del modo desarrollador que aparece si, y solo si, se ha activado previamente dicho modo. En "Ajustes adicionales" puede encontrar una nueva opción, llamada "Opciones de desarrollador", al pinchar, se abre un menú. Vaya bajando poco a poco hasta que dentro del subtítulo "Depuración", encuentre la opción "Depuración USB". Actívela.

# Conexión entre los dispositivos

## Transmisión por cable

Toda consexión se hace mediante el comando homonimo, es decir, el comando "`scrcpy`" detecta los dispositivos conectados a "adb" para empezar a recibir la transmisión de la pantalla.

El tipo de conexión más básica se hace mediante cable. Con ayuda de un USB cuyos extremos se conectan entre dispositivos (ordenador con "Scrcpy" y dispositivo con Android). Es importante permitir que el ordenador tenga acceso a la depuración USB, aparecerá un menú con dicha opción al introducir el cable. Al ejecutar el comando, se empezará a ver la pantalla del Andriod en el ordenador.

Es posible que la pantalla se vea con cierto retraso, a tirones o se cirre por haber fallado cada cierto tiempo. Cada conexión requiere tiene su configuración óptima, y es objetivo del informático encontrar cuál. Para ello, conocer todas las posibles configuraciones de "Scrcpy" es importante. Se puede acceder a su menú de ayuda textual con el comando "`scrcpy --help`".

## Transmisión inalámbrica

La transmisión inalámbrica requiere de varios comandos extra, incluyendo algunos del programa "adb" que se ha bajado anteriormente.

### Conexión

La secuencia de comandos y acciones es la siguiente:

- Conecte ambos dispositivos a la misma red Wi-Fi.
- Conecte los dispositivos mediante cable USB.
- `adb tcpip 5555`: Se conecta mediante TCP/IP al dispositivo.
- `adb connect 192.168.*.*`: Será necesario colocar la IP del dispositivo Andriod.
- Desconecte el cable USB.
- `scrcpy --max-size 1024 --video-bit-rate 2M --max-fps 30`: Para la conexión con las gafas DPVR P1 Pro 4K, he notado que esta es la mejor configuración. El informático puede considerar cambiar algunos parámetros así como eliminar o añadir otros.

### Desconexión

Si quiere cambiar de dispositivo con el que se conecta mediante TCP/IP, será necesario ejecutar 2 comandos, estos son:

- `adb disconnect 192.168.*.*`: Esta IP debe de coincidir con la introducida anteriormente.
- `adb disconnect 5555`.

A continuación, podrá seguir el apartado de [[#Conexión]] para volver a compartir la pantalla.

# Posibles problemas

Mientras llegaba a todos los conocimientos plasmados en esta guía, me he percatado de que los siguientes problemas suceden con frecuencia.

Unos de ellos consiste en el _crasheo_ y cierre de la pantalla debido a problemas con el audio. Esto lo he solucionado añadiendo un argumento a la ejecución del comando "`scrcpy`", este es: "`--no-audio`".

Otro problema que he experimentado sucedió cuando tenía una conexión vía TCP/IP y USB simúltaneamente con el mismo dispositivo. Al ejecutar "`scrcpy`" sin argumentos, este fallaba al no saber si tenía que conectarse por un medio o por el otro. Esto se soluciona agregando el argumento "`-d`" para la conexión por USB o "`-e`" para la conexión TCP/IP. Por otro lado, con "`adb devices`" se pueden consultar qué dispositivos están conectados.

Mientras experimentaba con los parámetros de ejecución del comando "`scrcpy`" para mejorar la calidad de imagen transmitida desde las gafas DPVR P1 Pro 4K al ordenador, me ayudó mucho el argumento "`--print-fps`", que muestra por consola los FPS de la transmisión. Esta no es una solución a un error como tal, pero me pareció interesante.

Por último, las gafas DPVR P1 Pro 4K tienen, de forma nativa con una aplicación de la empresa, una aplicación para la transmisión mediante TCP/IP, llamada "Screen Cast". A diferencia de este método, esta conexión requiere que ambos dispositivos sean Adndroid. Después de haber instalado ambos _softwares_ ("Screen Cast TV" y "Screen Cast DPVR", cada uno en su lugar), no he conseguido establecer conexión después de haber seguido todos los pasos.

# Un ejemplo práctico

Para facilitar las actividades de conexionado de varias gafas a la vez, y no tener que explicarle toda esta documentación a los alumnos o a los profesores, se me ocurrió generar un archivo "bash" que automatizase todo el proceso:

```bash
#!/bin/bash

read -p "Conecta el dispositivo al ordenador, cuando estés listo, presiona 'Enter' "
scrcpy --time-limit 1
read -p "Introduce los últimos 2 octetos de bits en formato decimal de tu IP: " octetos
adb tcpip 5555
adb connect 192.168.$octetos
adb devices
read -p "Desconecta el dispositio, cuando estés listo, presiona 'Enter' "
scrcpy --max-size 1024 --video-bit-rate 2M --max-fps 30 --no-audio --kill-adb-on-close -f --disable-screensaver --start-app=delightex.cospaces.edu
adb disconnect 192.168.$octetos
echo Chao
```

Y, así, se puede automatizar toda la tarea que se hacía de forma manual para poder hacer una presentación sobre CoSpaces.