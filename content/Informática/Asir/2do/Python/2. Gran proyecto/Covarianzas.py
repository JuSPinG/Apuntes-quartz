import pandas as pd
from os import listdir

archivos = listdir("Datos")
print(archivos)
resultados = {}
claveEncontrada = False
cont = 0
variables = []

with open("Cabeceras importantes.txt", "r", encoding="UTF-8") as file:
	variablesTmp = file.readlines()[9:145]

for i in variablesTmp:
	variables.append(i.replace(", 12\n", "").replace("'", ""))

### TRENZAR ###

variablesTrenzadas = []

for i in variables:
	for e in variables:
		if i == e:
			pass

		else: variablesTrenzadas.append([i, e])

	del variables[0]

#for i in range(1, 3):
#	variables.append(input("Ingresa el nombre de la primera variable: "))
#variables = ["imwbcnt", "clsprty"]

for corr in variablesTrenzadas:

	dataframe = pd.DataFrame()

	for i in archivos:

		with open("Datos/" + i, "r", encoding="UTF-8") as file:
			dataframe = pd.concat([dataframe, pd.read_csv(file, usecols=corr)])

	resultados.update({(corr[0] + " - " + corr[1]): dataframe.corr()[corr[0]][corr[1]]})
	print(cont/len(variablesTrenzadas))
	cont += 1

with open("resultados.txt", "w", encoding="UTF-8") as file:
	file.write(("\n".join(str(sorted(resultados.items(), key=lambda item: item[1], reverse=True)).split("), ("))).replace(")]", "").replace("[(", ""))