ENLACE_DIRECTO = 100
datos = {}
distancia = {}
grado = []

with open("texto.txt", "r") as file:
    for linea in file:
        persona, seguidores = linea.strip().split(": ")

        datos[persona] = seguidores.split(", ")
#while True: # input("Continuar? (S/N): ").upper() == "S"
tarjet = "mateoselena04"

#########################
#        GRADO 1
#########################

for keys, values in datos.items():
    if keys == tarjet:
        for value in values:
            if value not in distancia:
                distancia[value] = 0
            distancia[value] += 10
            grado.append(value)

#########################
#        GRADO 2
#########################

for keys, values in datos.items():
    for i in grado:
        for value in values:
            if i == value:
                distancia[value] += 5

orden = dict(sorted(distancia.items(), key=lambda item: item[1]))
print(orden)