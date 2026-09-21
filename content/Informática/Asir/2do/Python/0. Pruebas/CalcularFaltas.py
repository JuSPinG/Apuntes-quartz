l = [8, 8, 8, 9, 9]
f = []

horasAsignaturas = {
    "IPE": l[0]*1 + l[4]*1,
    "Redes": l[0]*2 + l[2]*1 + l[3]*2,
    "ASO": l[0]*1 + l[1]*1 + l[2]*2 + l[4]*1,
    "BDD": l[0]*1 + l[1]*1 + l[3]*1,
    "SAD": l[0]*1 + l[1]*1 + l[2]*1 + l[3]*1 + l[4]*1,
    "Digitalización": l[1]*1,
    "Sostenibilidad": l[2]*1,
    "Python": l[2]*1 + l[4]*1,
    "IAW": l[1]*1 + l[3]*1 + l[4]*1,
    "Inglés": l[1]*1 + l[4]*1
}

for i in horasAsignaturas.keys():
    f.append(float(input("¿Cuántas veces has faltado a " + i + "?: ")))

print("### RESUMEN DE FALTAS ###")
for i, e in horasAsignaturas.items():
    print("En " + i + " se pueden faltar " + str(round(e*0.2, 2)) + " veces. Te quedan " + str(round(e*0.2 - f[0], 2)) + " faltas")
    del f[0]
input("\nCálculo terminado, enter para salir... ")
