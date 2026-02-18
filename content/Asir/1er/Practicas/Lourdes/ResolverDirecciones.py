import socket
import subprocess
import os
import re
import csv
from datetime import datetime
from scapy.all import ARP, Ether, srp

def obtener_dispositivos_red(subred):
    # Escanea la red usando ARP para obtener IPs y MACs
    arp = ARP(pdst=subred)
    ether = Ether(dst="ff:ff:ff:ff:ff:ff")
    paquete = ether/arp
    resultado = srp(paquete, timeout=3, verbose=0)[0]
    
    dispositivos = []
    for enviado, recibido in resultado:
        ip = recibido.psrc
        mac = recibido.hwsrc
        try:
            nombre = socket.gethostbyaddr(ip)[0]
        except socket.herror:
            nombre = "No encontrado"
        dispositivos.append({'IP': ip, 'MAC': mac, 'Nombre': nombre})
    
    return dispositivos

def guardar_csv(dispositivos, archivo="dispositivos_red.csv"):
    # Guarda los datos en un CSV
    with open(archivo, 'w', newline='') as f:
        campos = ['IP', 'MAC', 'Nombre']
        writer = csv.DictWriter(f, fieldnames=campos)
        writer.writeheader()
        writer.writerows(dispositivos)

if __name__ == "__main__":
    # Define la subred (ej: 192.168.1.0/24). ¡Ajusta esto a tu red!
    subred = "192.168.1.0/24"  # CAMBIAR A TU SUBRED
    
    # Escanea y guarda
    dispositivos = obtener_dispositivos_red(subred)
    guardar_csv(dispositivos)
    
    print(f"¡Listo! Datos guardados en 'dispositivos_red.csv'.")