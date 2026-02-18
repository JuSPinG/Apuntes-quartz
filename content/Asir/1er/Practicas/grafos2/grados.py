import matplotlib as plt

ENLACE_DIRECTO = 100
datos = {}
distancia = {}
visitados = set()

# Cargar los datos
with open("texto2.txt", "r") as file:
    for linea in file:
        persona, seguidores = linea.strip().split(": ")
        datos[persona] = seguidores.split(", ")

# Target inicial
tarjet = "rdrigzzdm"

# Inicializamos el primer grado
grado_actual = [tarjet]
distancia[tarjet] = ENLACE_DIRECTO  # Puntaje máximo para el objetivo
grado_nivel = 1

while grado_actual:
    siguiente_grado = []  # Para almacenar las conexiones del siguiente grado

    for persona in grado_actual:
        if persona in datos:  # Solo iteramos si la persona tiene seguidores registrados
            num_seguidores = len(datos[persona])  # Número de seguidores de la persona
            for seguidor in datos[persona]:
                if seguidor not in visitados:
                    if seguidor not in distancia:
                        distancia[seguidor] = 0
                    
                    # Ajuste del puntaje considerando seguidores, pero no diluyendo excesivamente
                    peso = ENLACE_DIRECTO / (grado_nivel**5 * num_seguidores**0.5)  # Evitar divisor demasiado pequeño
                    distancia[seguidor] += peso

                    # Añadir al siguiente grado si no se ha visitado ya
                    if seguidor not in siguiente_grado:
                        siguiente_grado.append(seguidor)

    # Marcamos como visitados a los actuales
    visitados.update(grado_actual)

    # Pasamos al siguiente grado
    grado_actual = siguiente_grado
    grado_nivel += 1

# Ordenamos los resultados por puntaje de mayor a menor
orden = dict(sorted(distancia.items(), key=lambda item: item[1], reverse=True))

# Mostramos los resultados
for persona, valor in orden.items():
    if valor <= 0.5:
        break
    print(f"{persona}: {round(valor, 3)}")
