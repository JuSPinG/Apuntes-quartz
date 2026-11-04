```powershell
PS C:\Users\mspineiro> ping lanic.net

Haciendo ping a lanic.net [208.91.197.132] con 32 bytes de datos:
Respuesta desde 208.91.197.132: bytes=32 tiempo=133ms TTL=242
Respuesta desde 208.91.197.132: bytes=32 tiempo=134ms TTL=242
Respuesta desde 208.91.197.132: bytes=32 tiempo=132ms TTL=242
Respuesta desde 208.91.197.132: bytes=32 tiempo=141ms TTL=242

PS C:\Users\mspineiro> ping afrinic.net

Haciendo ping a afrinic.net [196.216.3.4] con 32 bytes de datos:
Respuesta desde 196.216.3.4: bytes=32 tiempo=189ms TTL=45
Respuesta desde 196.216.3.4: bytes=32 tiempo=187ms TTL=45
Respuesta desde 196.216.3.4: bytes=32 tiempo=186ms TTL=45
Respuesta desde 196.216.3.4: bytes=32 tiempo=186ms TTL=45

PS C:\Users\mspineiro> ping apnic.net

Haciendo ping a apnic.net [202.12.29.1] con 32 bytes de datos:
Respuesta desde 202.12.29.1: bytes=32 tiempo=347ms TTL=44
Respuesta desde 202.12.29.1: bytes=32 tiempo=344ms TTL=44
Respuesta desde 202.12.29.1: bytes=32 tiempo=345ms TTL=44
Respuesta desde 202.12.29.1: bytes=32 tiempo=344ms TTL=44

PS C:\Users\mspineiro> ping www.ripe.net

Haciendo ping a www.ripe.net.cdn.cloudflare.net [104.18.4.245] con 32 bytes de datos:
Respuesta desde 104.18.4.245: bytes=32 tiempo=19ms TTL=55
Respuesta desde 104.18.4.245: bytes=32 tiempo=25ms TTL=55
Respuesta desde 104.18.4.245: bytes=32 tiempo=18ms TTL=55
Respuesta desde 104.18.4.245: bytes=32 tiempo=24ms TTL=55

PS C:\Users\mspineiro> ping

Uso: ping [-t] [-a] [-n count] [-l size] [-f] [-i TTL] [-v TOS]
          [-r count] [-s count] [[-j host-list] | [-k host-list]]
          [-w timeout] [-R] [-S srcaddr] [-c compartment] [-p]
          [-4] [-6] nombre_destino

Opciones:
 -t                  Hacer ping al host especificado hasta que se detenga.
                     Para ver estadísticas y continuar, presione
                     Ctrl-Interrumpir; para detener, presione Ctrl+C.
 -a                  Resolver direcciones en nombres de host.
 -n count            Número de solicitudes de eco para enviar.
 -l size             Enviar tamaño de búfer.
 -f                  Establecer marca No fragmentar en paquetes (solo IPv4).
 -i TTL              Período de vida.
 -v TOS              Tipo de servicio (solo IPv4. Esta opción está desusada y
                     no tiene ningún efecto sobre el campo de tipo de servicio
                     del encabezado IP).
 -r count            Registrar la ruta de saltos de cuenta (solo IPv4).
 -s count            Marca de tiempo de saltos de cuenta (solo IPv4).
 -j host-list        Ruta de origen no estricta para lista-host (solo IPv4).
 -k host-list        Ruta de origen estricta para lista-host (solo IPv4).
 -w timeout          Tiempo de espera en milisegundos para cada respuesta.
 -R                  Usar encabezado de enrutamiento para probar también
                     la ruta inversa (solo IPv6).
                     Por RFC 5095 el uso de este encabezado de enrutamiento ha
                     quedado en desuso. Es posible que algunos sistemas anulen
                     solicitudes de eco si usa este encabezado.
    -S srcaddr       Dirección de origen que se desea usar.
    -c compartment   Enrutamiento del identificador del compartimiento.
    -p               Hacer ping a la dirección del proveedor de Virtualización
                     de red de Hyper-V.
    -4               Forzar el uso de IPv4.
    -6               Forzar el uso de IPv6.

PS C:\Users\mspineiro> ping -n 25 lanic.net > lanic.txt
PS C:\Users\mspineiro> ping -n 25 afrinic.net > afrinic.txt
PS C:\Users\mspineiro> ping -n 25 apnic.net > apnic.txt
PS C:\Users\mspineiro> ping -n 25 www.ripe.net > ripe.txt
PS C:\Users\mspineiro> dir *.txt


    Directorio: C:\Users\mspineiro


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        12/03/2025      9:51           3540 afrinic.txt
-a----        12/03/2025      9:52           3536 apnic.txt
-a----        12/03/2025      9:48           3748 lanic.txt
-a----        12/03/2025     10:10           3522 ripe.txt

PS C:\Users\mspineiro> more .\lanic.txt

Haciendo ping a lanic.net [208.91.197.132] con 32 bytes de datos:
Respuesta desde 208.91.197.132: bytes=32 tiempo=134ms TTL=242
Respuesta desde 208.91.197.132: bytes=32 tiempo=134ms TTL=242
Respuesta desde 208.91.197.132: bytes=32 tiempo=133ms TTL=242
Respuesta desde 208.91.197.132: bytes=32 tiempo=134ms TTL=242
Respuesta desde 208.91.197.132: bytes=32 tiempo=134ms TTL=242
Respuesta desde 208.91.197.132: bytes=32 tiempo=134ms TTL=242
Respuesta desde 208.91.197.132: bytes=32 tiempo=139ms TTL=242
Respuesta desde 208.91.197.132: bytes=32 tiempo=134ms TTL=242
Respuesta desde 208.91.197.132: bytes=32 tiempo=139ms TTL=242
Respuesta desde 208.91.197.132: bytes=32 tiempo=133ms TTL=242
Respuesta desde 208.91.197.132: bytes=32 tiempo=133ms TTL=242
Respuesta desde 208.91.197.132: bytes=32 tiempo=134ms TTL=242
Respuesta desde 208.91.197.132: bytes=32 tiempo=133ms TTL=242
Respuesta desde 208.91.197.132: bytes=32 tiempo=138ms TTL=242
Respuesta desde 208.91.197.132: bytes=32 tiempo=133ms TTL=242
Respuesta desde 208.91.197.132: bytes=32 tiempo=133ms TTL=242
Respuesta desde 208.91.197.132: bytes=32 tiempo=134ms TTL=242
Respuesta desde 208.91.197.132: bytes=32 tiempo=133ms TTL=242
Respuesta desde 208.91.197.132: bytes=32 tiempo=134ms TTL=242
Respuesta desde 208.91.197.132: bytes=32 tiempo=139ms TTL=242
Respuesta desde 208.91.197.132: bytes=32 tiempo=134ms TTL=242
Respuesta desde 208.91.197.132: bytes=32 tiempo=134ms TTL=242
Respuesta desde 208.91.197.132: bytes=32 tiempo=135ms TTL=242
Respuesta desde 208.91.197.132: bytes=32 tiempo=133ms TTL=242
Respuesta desde 208.91.197.132: bytes=32 tiempo=134ms TTL=242

Estadísticas de ping para 208.91.197.132:
    Paquetes: enviados = 25, recibidos = 25, perdidos = 0
    (0% perdidos),
Tiempos aproximados de ida y vuelta en milisegundos:
    Mínimo = 133ms, Máximo = 139ms, Media = 134ms
    
PS C:\Users\mspineiro> tracert lacnic.net > traceroute_lacnic.txt
PS C:\Users\mspineiro> tracert afrinic.net > traceroute_afrinic.txt
PS C:\Users\mspineiro> tracert apnic.net > traceroute_apnic.txt

PS C:\Users\mspineiro> more traceroute_*.txt

Traza a la dirección afrinic.net [196.216.3.4]
sobre un máximo de 30 saltos:

  1    <1 ms    <1 ms    <1 ms  192.168.2.254
  2    <1 ms    <1 ms    <1 ms  192.168.1.69
  3     2 ms    <1 ms    <1 ms  192.168.144.1
  4     *        *        *     Tiempo de espera agotado para esta solicitud.
  5     *        4 ms     2 ms  74.red-81-46-67.customer.static.ccgg.telefonica.net [81.46.67.74]
  6     3 ms     3 ms     5 ms  ae12-400-grtmadte3.net.telefonicaglobalsolutions.com [216.184.113.52]
  7     4 ms     5 ms     5 ms  lag-18.ear1.mad2.sp.lumen.tech [4.68.39.33]
  8    49 ms    21 ms    18 ms  ae2.3605.edge4.mrs1.neo.colt.net [171.75.8.225]
  9    17 ms    18 ms    19 ms  213.242.115.14
 10   184 ms   184 ms   185 ms  cr1-lhx-et32.wolcomm.net [41.78.188.132]
 11   189 ms   184 ms   185 ms  esr1-isd-cr1-te0-0-26.wolcomm.net [197.157.77.97]
 12   186 ms   187 ms   186 ms  197.157.64.195
 13   186 ms   186 ms   187 ms  lb.iso.afrinic.net [196.216.3.4]

Traza completa.

Traza a la dirección www.apnic.net.cdn.cloudflare.net [104.18.236.68]
sobre un máximo de 30 saltos:

  1    <1 ms    <1 ms    <1 ms  192.168.2.254
  2    14 ms    14 ms    13 ms  192.168.1.69
  3     3 ms    <1 ms     2 ms  192.168.144.1
  4     *        *        *     Tiempo de espera agotado para esta solicitud.
  5     *        *        *     Tiempo de espera agotado para esta solicitud.
  6     *        *        *     Tiempo de espera agotado para esta solicitud.
  7     *        *        3 ms  216.184.113.248
  8     3 ms     4 ms     3 ms  81.173.106.39
  9     2 ms     2 ms     3 ms  188.114.108.57
 10     3 ms     4 ms     2 ms  104.18.236.68

Traza completa.

Traza a la dirección lacnic.net [200.3.14.10]
sobre un máximo de 30 saltos:

  1    <1 ms    <1 ms    <1 ms  192.168.2.254
  2    <1 ms    <1 ms    <1 ms  192.168.1.69
  3     2 ms     1 ms     1 ms  192.168.144.1
  4     *        2 ms     2 ms  6.red-81-46-67.customer.static.ccgg.telefonica.net [81.46.67.6]
  5     *        *        *     Tiempo de espera agotado para esta solicitud.
  6     *        *        *     Tiempo de espera agotado para esta solicitud.
  7     *        *        *     Tiempo de espera agotado para esta solicitud.
  8    35 ms    36 ms    38 ms  213.140.37.122
  9    27 ms    30 ms    29 ms  ae-22.a02.londen12.uk.bb.gin.ntt.net [129.250.9.213]
 10    29 ms    29 ms    29 ms  ae-10.r22.londen12.uk.bb.gin.ntt.net [129.250.5.156]
 11   137 ms   136 ms   137 ms  ae-7.r22.nwrknj03.us.bb.gin.ntt.net [129.250.6.147]
 12   192 ms   193 ms   196 ms  ae-1.a00.saplbr02.br.bb.gin.ntt.net [129.250.2.13]
 13   193 ms   191 ms   193 ms  ae1-1326.gw1.nu.registro.br [200.15.9.95]
 14   193 ms   193 ms   192 ms  et-0-1-5-0.core1.nu.registro.br [200.160.0.160]
 15   193 ms   191 ms   192 ms  ae0-0.ar3.nu.registro.br [200.160.0.249]
 16   192 ms   193 ms   193 ms  ae0-0.gw1.jd.lacnic.net [200.160.0.212]
 17   194 ms   192 ms   191 ms  200.3.12.34
 18   192 ms   192 ms   193 ms  registro.lacnic.net [200.3.14.10]

Traza completa.

Traza a la dirección www.ripe.net.cdn.cloudflare.net [104.18.5.245]
sobre un máximo de 30 saltos:

  1     1 ms     1 ms     1 ms  192.168.2.254
  2    20 ms    20 ms    21 ms  192.168.1.69
  3    17 ms    17 ms    16 ms  192.168.144.1
  4    22 ms    23 ms    22 ms  1.red-81-46-67.customer.static.ccgg.telefonica.net [81.46.67.1]
  5    17 ms    16 ms    15 ms  74.red-81-46-67.customer.static.ccgg.telefonica.net [81.46.67.74]
  6    34 ms    27 ms    24 ms  205.red-81-46-0.customer.static.ccgg.telefonica.net [81.46.0.205]
  7     *       25 ms     *     gramadix2-ae10.net.telefonicaglobalsolutions.com [216.184.113.182]
  8    27 ms    38 ms    36 ms  81.173.106.39
  9    17 ms    16 ms    16 ms  188.114.108.23
 10    21 ms    22 ms    22 ms  104.18.5.245

Traza completa.

```

Conclusión: Cuanto más lejos está el continente, por más lugares tiene que pasar el paquete. Esto tiene sentido, porque, en cierto modo, la topología física guarda relación con la lógica.

```powershell
PS C:\Users\mspineiro> tracert -d www.lacnic.net > traceroute_d_lacnic.txt
PS C:\Users\mspineiro> tracert -d www.afrinic.net > traceroute_d_afrinic.txt
PS C:\Users\mspineiro> tracert -d www.apnic.net > traceroute_d_apnic.txt
PS C:\Users\mspineiro> tracert -d www.ripe.net > traceroute_d_ripe.txt

PS C:\Users\mspineiro> more traceroute_d_*.txt

Traza a la dirección www.afrinic.net [196.216.3.4]
sobre un máximo de 30 saltos:

  1    <1 ms    <1 ms    <1 ms  192.168.2.254
  2    <1 ms    <1 ms    <1 ms  192.168.1.69
  3     1 ms     2 ms     2 ms  192.168.144.1
  4     3 ms     1 ms     2 ms  81.46.67.1
  5     3 ms     3 ms     3 ms  81.46.67.74
  6     6 ms     6 ms     7 ms  216.184.113.52
  7     4 ms     3 ms     5 ms  4.68.39.33
  8    25 ms    29 ms    29 ms  171.75.8.225
  9    24 ms    18 ms    18 ms  213.242.115.14
 10   184 ms   184 ms   183 ms  41.78.188.132
 11   184 ms   183 ms   182 ms  197.157.77.97
 12   187 ms   186 ms   188 ms  197.157.64.195
 13   187 ms   186 ms   188 ms  196.216.3.4

Traza completa.

Traza a la dirección www.apnic.net.cdn.cloudflare.net [104.18.235.68]
sobre un máximo de 30 saltos:

  1     1 ms     1 ms     1 ms  192.168.2.254
  2    <1 ms    <1 ms    <1 ms  192.168.1.69
  3     2 ms     2 ms     2 ms  192.168.144.1
  4     *        *        5 ms  81.46.67.6
  5     *        2 ms     1 ms  81.46.67.82
  6     1 ms     3 ms     1 ms  81.46.0.205
  7     2 ms     3 ms     2 ms  216.184.113.250
  8     7 ms     5 ms     3 ms  213.140.39.3
  9     4 ms     4 ms     3 ms  188.114.108.21
 10     2 ms     3 ms     3 ms  104.18.235.68

Traza completa.

Traza a la dirección www.lacnic.net [200.3.14.145]
sobre un máximo de 30 saltos:

  1    <1 ms    <1 ms    <1 ms  192.168.2.254
  2    <1 ms    <1 ms    <1 ms  192.168.1.69
  3     2 ms     2 ms    <1 ms  192.168.144.1
  4     *        *        1 ms  81.46.67.1
  5     *        *        2 ms  81.46.67.74
  6    37 ms    39 ms    38 ms  213.140.37.110
  7    31 ms    36 ms    31 ms  129.250.9.213
  8    32 ms    32 ms    32 ms  129.250.5.156
  9   144 ms   146 ms   145 ms  129.250.6.147
 10   200 ms   200 ms   199 ms  129.250.2.13
 11   201 ms   200 ms   210 ms  200.15.9.95
 12   201 ms   201 ms   201 ms  200.160.0.157
 13   201 ms   200 ms   201 ms  200.160.0.249
 14   202 ms   201 ms   201 ms  200.160.0.212
 15   200 ms   200 ms   199 ms  200.3.12.34
 16   201 ms   200 ms   201 ms  200.3.14.145

Traza completa.

Traza a la dirección www.ripe.net.cdn.cloudflare.net [104.18.5.245]
sobre un máximo de 30 saltos:

  1    <1 ms    <1 ms    <1 ms  192.168.2.254
  2    <1 ms    <1 ms    <1 ms  192.168.1.69
  3     3 ms     2 ms    <1 ms  192.168.144.1
  4     *        *        *     Tiempo de espera agotado para esta solicitud.
  5     *        *        *     Tiempo de espera agotado para esta solicitud.
  6     2 ms     4 ms     4 ms  81.46.0.205
  7     3 ms     *        3 ms  216.184.113.182
  8    20 ms    16 ms    12 ms  81.173.106.39
  9     4 ms     3 ms     5 ms  188.114.108.23
 10     3 ms     5 ms     3 ms  104.18.5.245

Traza completa.
```

Conclusión: He notado que ya no aparece el nombre del dominio si no la IP directamente.
# Preguntas de reflexión

1. Los resultados de `tracert` y `ping` pueden proporcionar información importante sobre la latencia de la red. ¿Qué debe hacer si desea una representación precisa de la línea de base de la latencia de su red?
	1. Si quisiese tener una representación precisa, le mandaría la información a un fichero de Python, y con la librería `SciPy`, luego buscaría relaciones entre las latencias y otros datos obtenidos
2. ¿Cómo puede utilizar la información de línea de base?
	1. ¿Qué línea de base? ¿De qué hablas?