import ipaddress
import subprocess

# Define la red que deseas escanear
red = ipaddress.ip_network('192.168.2.0/24', strict=False)

# Lista para almacenar las direcciones IP activas
ips_activas = []

# Escanea cada dirección IP en la red
for ip in red.hosts():
    print(ip)
    # Realiza un ping a la dirección IP
    resultado = subprocess.run(['ping', '-c', '1', str(ip)], stdout=subprocess.PIPE)
    if resultado.returncode == 0:
        ips_activas.append(str(ip))

# Muestra las direcciones IP activas
print("Direcciones IP activas en la red:")
for ip in ips_activas:
    print(ip)