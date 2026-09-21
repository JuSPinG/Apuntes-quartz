### https://jutge.org/problems/P11875_en/pdf ###

from itertools import permutations

cant = int(input(""))

num = [] #["2", "4", "6", "8"]

num = (input().split(" "))
num = sorted(num)

permutaciones = list(permutations(num))
conseguido = False

for tupla in permutaciones:
	numero = int("".join(map(str, tupla)))

	if not (numero % 7):
		print(numero)
		conseguido = True

if not conseguido:
	print("-")