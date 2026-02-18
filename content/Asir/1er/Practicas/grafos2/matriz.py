datos = {}
contador = {}

with open("texto2.txt", "r") as file:
    for linea in file:
        if ": " in linea:  # Filtramos las líneas que contienen relaciones
            persona, seguidores = linea.strip().split(": ")
            seguidores = seguidores.split(", ")  # Convertimos seguidores a lista
            datos[persona] = seguidores

            if True: # persona != "choripaannnn"
                for seguidor in seguidores:

                    if seguidor != "choripaannnn":
                        if seguidor not in contador:
                            contador[seguidor] = []
                        contador[seguidor] += [persona]

orden = dict(sorted(contador.items(), key=lambda item: len(item[1])))

final = {}

for keys, values in orden.items():
    if len(values) != 1:
        
        if keys not in final:
            final[keys] = []
        final[keys] += values

with open("final.txt", "w") as file:
    
    for keys, values in final.items():
        file.write(keys + ": " + ", ".join(values) + "\n")