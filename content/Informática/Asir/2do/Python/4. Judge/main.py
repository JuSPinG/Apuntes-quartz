### https://jutge.org/problems/P11875_en/pdf ###

cant = 4 # int(input("Introduce la cantidad de números que quieres introducir (<=9): "))
num = ["2", "4", "6", "8"]

# for i in range(cant):
# 	num.append(int(input("Introduce el dígito: ")))

num = sorted(num)

cantPerm = cant

for i in range(1, len(num)):
	cantPerm *= i

numExt = []
num_t = num
pos1 = 0
pos2 = 0

for i in range(cantPerm):

	print(f"{i%2**2}{i%2**1}")

	numExt.append()

	# if pos1 >= cant:
	# 	pos1 = 0
	# 	pos2 += 1

	# if pos2 >= cant:
	# 	pos2 = 0

	# ### TEXTOS ###

	# num_t[pos1], num_t[pos2] = num_t[pos2], num_t[pos1]

	# print(num_t)

	# numExt.append(num_t)

	# pos1 += 1

	# if pos1 == pos2:
	# 	pos1 += 1

print(numExt)

exit()
contMin = 1
print(contMin)

while True:
	cont_T = cont
	print(cont_T // 7)
	cont += 1