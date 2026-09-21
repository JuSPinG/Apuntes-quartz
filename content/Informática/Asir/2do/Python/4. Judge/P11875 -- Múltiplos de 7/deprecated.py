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
cadena = []

for i in range(cantPerm):
        cont = i
        res = ""
        while cont > 0:
            res = str(cont % cant) + res
            cont //= cant
        print(list(res.zfill(cant))) # Rellena con ceros a la izquierda

exit()
contMin = 1
print(contMin)

while True:
	cont_T = cont
	print(cont_T // 7)
	cont += 1