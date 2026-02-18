from random import randint
from time import time, sleep
import sqlite3

def dec2bin(numero_decimal):

    modulos = []

    while numero_decimal != 0:
        modulos.append(str(numero_decimal % 2))
        numero_decimal //= 2

    return modulos[::-1]

conn = sqlite3.connect("binario_carrera.db")
cursor = conn.cursor()

cursor.execute("""CREATE TABLE IF NOT EXISTS puntuaciones (
               id INTEGER PRIMARY KEY AUTOINCREMENT,
               nombre TEXT NOT NULL,
               puntuacion INTEGER NOT NULL               
);""")

nombre = input("¡Hola! Cuál es tu nombre?: ")

print("Preparados!")
sleep(1)
print("Listos!!")
sleep(1)
print("YAA!!!")

cont = 0
inicio = time()

while True:

    if time() - inicio >= 50:
        break
    
    num = randint(1, 15)
    res = input("Ha salido el número: " + "".join(dec2bin(num)) + ", ahora, tienes que introducir a qué base pertenece: ")

    if int(res) == num:
        print("Enhorabuena!!")
        cont += 1
    else:
        print("Oh no... Has fallado, la respuesta correcta era: " + str(num))

puntuacion = round((cont**(1.3)), 3)

print("Tu puntuación final es de: " + str(puntuacion) + ", y has tenido " + str(cont) + " aciertos en " +  str(round((time() - inicio), 3)) + " segundos")

consulta = conn.execute("SELECT puntuacion FROM puntuaciones WHERE nombre = ?", (nombre,))
resultado = consulta.fetchone()

if resultado:
    if (puntuacion - int(resultado[0])) >= 0:
        conn.execute("UPDATE puntuaciones SET puntuacion = ? WHERE nombre = ?", (puntuacion, nombre))
        print("Has batido tu récord!!")
else:
    conn.execute("INSERT INTO puntuaciones (nombre, puntuacion) VALUES (?, ?)", (nombre, puntuacion))

conn.commit()

consulta = conn.execute("SELECT * FROM puntuaciones ORDER BY puntuacion DESC")

print("----------Tabla de clasificaciones----------")

for i in consulta.fetchall():
    print(i[1] + ": " + str(i[2]))