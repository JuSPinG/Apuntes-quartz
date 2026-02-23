with open("texto2.txt", "r") as file:
    for linea in file:
        if ": " in linea:  # Filtramos las líneas que contienen relaciones
            persona, seguidores = linea.strip().split(": ")
            seguidores = seguidores.split(", ")  # Convertimos seguidores a lista
            if persona == "a.flpzz":
                print(len(seguidores))