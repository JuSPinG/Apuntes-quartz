salarioMensual = int(input("Salario mensual sin prorratear: "))
añosTrabajados = int(input("Años trabajados: "))
mesesTrabajados = int(input("Meses trabajados: "))
diasTrabajados = int(input("Días trabajados: "))

tiempoTrabajadoAños = añosTrabajados+(mesesTrabajados/12)+(diasTrabajados/365.25)

salarioMensualTotal = salarioMensual+(salarioMensual/6)
salarioAnual = salarioMensualTotal*12
salarioDiario = salarioAnual / 365.25
# Datos finales
dineroGanadoFiniquito = 0
dineroGanadoFiniquito += salarioDiario*diasTrabajados # pues le despiden un 12 de abril
dineroGanadoFiniquito += salarioDiario*2.5*mesesTrabajados # pues hay varios días no disfrutados

dineroGanadoFiniquito += añosTrabajados*tiempoTrabajadoAños*salarioDiario
input(dineroGanadoFiniquito)
