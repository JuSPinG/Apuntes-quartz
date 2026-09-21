def contador_base_4(n):
    for i in range(n):
        # Convierte el entero 'i' a una cadena en base 4
        # (Implementación manual simple para visualización)
        num = i
        res = ""
        while num > 0:
            res = str(num % 4) + res
            num //= 4
        print(res.zfill(4)) # Rellena con ceros a la izquierda
        
contador_base_4(100)