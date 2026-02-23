import pandas as pd
from os import listdir
from collections import Counter
from itertools import combinations

ruta = "Datos"
paths = [(ruta + "/" + fn) for fn in listdir(ruta) if fn.lower().endswith(".csv")] # Almacena los csv
n_files = len(paths)
print(str(n_files) + " archivos encontrados")

# Leer los headers
headers_map = {}
for p in paths:
    cols = pd.read_csv(p, nrows=0, encoding="UTF-8").columns.tolist()[9:] # Se omiten ciertas columnas redundantes
    cols = [c.strip() for c in cols] # Se quitan los espacios y se mapean
    headers_map[p] = set(cols) # Los sets son menos pesados que las listas, además, se saca del for

# calcular intersección, unión y frecuencia, esto me lo hizo chatgpt
all_sets = list(headers_map.values())
intersection_cols = set.intersection(*all_sets) if all_sets else set()
union_cols = set.union(*all_sets) if all_sets else set()

# frecuencia por columna (cuántos archivos la contienen)
counter = Counter() # Muy útil para construir diccionarios rápidos
for s in all_sets:
    counter.update(s)

variables = sorted(union_cols)
print("Usando " + str(len(variables)) + " variables")

frames = []
for p in paths:
    cols_available = headers_map[p] & set(variables)
    if not cols_available:
        continue # Importante para mejorar el rendimiento
    cols_this = sorted(cols_available)
    # Lee solo las columnas que existen en ese fichero (evita error si faltan)
    df_part = pd.read_csv(p, usecols=cols_this, encoding="UTF-8")
    df_part.columns = [c.strip() for c in df_part.columns] # Normalizar nombres
    frames.append(df_part)

if not frames:
    raise SystemExit("No hay columnas comunes") # Si no hay columnas

df = pd.concat(frames, ignore_index=True, sort=False) # ¡DataFrame!
print(df)
df = df.reindex(columns=variables) # Asegura que el DataFrame tenga todas las columnas en 'variables'
corr = df.corr(method="pearson") # También está kendall

notna = df.notna().astype(int)
counts = notna.T.dot(notna) # Así se maneja las columnas p_x X p_x donde el resolutado es NaN

min_pairs = 100 # Umbral para las correlaciones con pocos datos
mask = counts >= min_pairs # Si la máscara se activa o no
corr_filtered = corr.where(mask) # Valores donde counts < min_pairs serán NaN

# Convertir a lista de pares
resultados = {}
for a, b in combinations(variables, 2): # La trenzam, solo 2 variables, además
    val = corr_filtered.loc[a, b] # ordenando
    if pd.notna(val):
        resultados[f"{a} - {b}"] = float(val)

items_sorted = sorted(resultados.items(), key=lambda x: x[1], reverse=True)
with open("resultados.txt0", "w", encoding="UTF-8") as f:
    for k, v in items_sorted:
        f.write(f"{k}: {v}\n")

print("Todo bien")
