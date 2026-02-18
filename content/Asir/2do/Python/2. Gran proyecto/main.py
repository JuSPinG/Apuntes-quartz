import csv
from os import listdir

archivos = listdir("Datos")
print(archivos)
clavesCont = {}
claveEncontrada = False
cont = 0

for i in archivos:

	with open("Datos/" + i, "r", encoding="UTF-8") as file:
		spamreader = csv.reader(file, delimiter=' ', quotechar="|")

		claves = (str(list(spamreader)[0]).replace('"', '').replace("'", "").replace("[", "").replace("]", "")).split(",")

		if i == "ESS1e06_7.csv":
			for clave in claves:
				clavesCont.update({clave: 1})

		else:
			for clave in claves:
				for claveCont in clavesCont.keys():
					if clave == claveCont:
						clavesCont.update({clave: clavesCont[claveCont] + 1})
			cont += 1
			print(11 - cont)
	
	
with open("Cabeceras importantes.txt", "w", encoding="UTF-8") as file:
	file.write(("\n".join(str(sorted(clavesCont.items(), key=lambda item: item[1], reverse=True)).split("), ("))).replace(")]", "").replace("[(", ""))