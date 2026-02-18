ENLACE_DIRECTO = 100
datos = {}
distancia = {}

with open("texto.txt", "r") as file:
    for linea in file:
        persona, seguidores = linea.strip().split(": ")

        datos[persona] = seguidores.split(", ")
#while True: # input("Continuar? (S/N): ").upper() == "S"
tarjet = "mateoselena04"

for keys, values in datos.items():
    if keys == tarjet:
        for value in values:
            if value not in distancia:
                distancia[value] = 0
            distancia[value] += 100
    else:
        for value in values:
            if value not in distancia:
                distancia[value] = 0
            distancia[value] += 1

orden = dict(sorted(distancia.items(), key=lambda item: item[1]))
print(orden)