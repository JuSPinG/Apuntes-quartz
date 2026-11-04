### https://jutge.org/problems/P11875_en/pdf ###

from itertools import permutations

while True:

	cant = int(input("Introduce la cantidad de números que quieres introducir (1=<x<=9): "))

	if 1 > cant or cant > 9:
		print("Número inválido")
	else: break

num = [] #["2", "4", "6", "8"]

for i in range(cant):
	num.append(int(input("Introduce el dígito: ")))

num = sorted(num)

permutaciones = list(permutations(num))

for tupla in permutaciones:
	numero = int("".join(map(str, tupla)))

	if not (numero % 7):
		print(numero)