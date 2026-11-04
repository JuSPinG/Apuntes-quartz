### https://jutge.org/problems/P25832_en ###

num = 5

fibbonacci = [0, 1]
cont = 1

while fibbonacci[-1] <= num:

	fibbonacci.append(fibbonacci[cont-2] + fibbonacci[cont-1])
	cont += 1

maxFibonacci = len(fibbonacci)

# Se calcula el fibonacci tradicional para poder saber cuántas iteraciones van a ser necesarias.
# Debido a que se usa la mínima progresión, [0, 1], se puede saber cuántas iteraciones, como mucho se van a necesitar
# Esto se usa para saber hasta dónde se necesita volver a atrás

numA = 0
numB = 1

cant = 0

while numA <= maxFibonacci:
	while numB <= maxFibonacci:
		fibbonacci = [numA, numB]
		cont = 1

		while fibbonacci[-1] <= num:

			fibbonacci.append(fibbonacci[cont-2] + fibbonacci[cont-1])
			cont += 1

			if fibbonacci[-1] == num and len(fibbonacci) >= 4:
				print("Número encontrado: " + str(num) + " -- " + str(fibbonacci))
				cant += 1

		numB += 1
	numB = 0
	numA += 1
print(cant)