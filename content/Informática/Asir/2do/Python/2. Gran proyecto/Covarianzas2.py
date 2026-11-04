import pandas as pd
import numpy as np
from os import listdir
from collections import defaultdict
from glob import glob
from itertools import combinations

RUTA = "Datos"
paths = [f"{RUTA}/{fn}" for fn in listdir(RUTA) if fn.lower().endswith(".csv")]
n_files = len(paths)
print(f"{n_files} archivos encontrados.")

# --- Configuración (ajusta estos valores según tus datos) ---
SAMPLE_ROWS = 1000                # filas a leer por archivo para inferir tipos
FRAC_NUMERIC_IN_SAMPLE = 0.9     # si >= 90% de la muestra coercean a num -> candidate numeric
FRAC_DATETIME_IN_SAMPLE = 0.9    # si >= 90% coercean a datetime -> candidate datetime
FRAC_FILES_THRESHOLD = 0.6       # si >= 60% de archivos indican tipo -> lo adoptamos
MIN_PAIRS_FOR_CORR = 50          # mínimo observaciones conjuntas para aceptar correlación
INCLUDE_CATEGORICALS = False     # si True: factoriza categóricas (advertencia: interpretabilidad)
ENCODING = "UTF-8"

# --- 1) Inferir columnas y tipos a partir de una muestra por archivo (leer como str para evitar DtypeWarning) ---
col_stats = defaultdict(lambda: {"files_with_col": 0, "numeric_votes": 0, "datetime_votes": 0, "nonnull_samples": 0})

for p in paths:
    try:
        sample = pd.read_csv(p, nrows=SAMPLE_ROWS, dtype=str, encoding=ENCODING)
    except Exception as e:
        print(f"Error leyendo muestra de {p}: {e}")
        continue
    sample = sample.apply(lambda s: s.str.strip() if s.dtype == object else s)  # limpiar espacios
    for col in sample.columns:
        ser = sample[col].dropna()
        if ser.empty:
            continue
        col_stats[col]["files_with_col"] += 1
        col_stats[col]["nonnull_samples"] += len(ser)

        # intento numérico
        coerced_num = pd.to_numeric(ser, errors="coerce")
        num_nonnull = coerced_num.notna().sum()
        if num_nonnull >= FRAC_NUMERIC_IN_SAMPLE * len(ser):
            col_stats[col]["numeric_votes"] += 1

        # intento datetime
        coerced_dt = pd.to_datetime(ser, errors="coerce", infer_datetime_format=True)
        dt_nonnull = coerced_dt.notna().sum()
        if dt_nonnull >= FRAC_DATETIME_IN_SAMPLE * len(ser):
            col_stats[col]["datetime_votes"] += 1

# Decide tipo final por columna
decided_type = {}
for col, stats in col_stats.items():
    files_with = stats["files_with_col"]
    if files_with == 0:
        continue
    if stats["numeric_votes"] >= FRAC_FILES_THRESHOLD * files_with:
        decided_type[col] = "numeric"
    elif stats["datetime_votes"] >= FRAC_FILES_THRESHOLD * files_with:
        decided_type[col] = "datetime"
    else:
        decided_type[col] = "other"

# Reporte corto
n_num = sum(1 for t in decided_type.values() if t == "numeric")
n_dt = sum(1 for t in decided_type.values() if t == "datetime")
n_other = sum(1 for t in decided_type.values() if t == "other")
print(f"Columnas detectadas: {len(decided_type)} (numeric={n_num}, datetime={n_dt}, other={n_other})")

# --- 2) Elegir variables a usar (por defecto: todas detectadas como numeric o datetime) ---
variables_num_dt = [c for c, t in decided_type.items() if t in ("numeric", "datetime")]
print(f"Usaré {len(variables_num_dt)} columnas (num+dt) para correlación. Ej: {variables_num_dt[:10]}")

# --- 3) Leer todos los archivos UNA vez y convertir columnas según el tipo decidido ---
frames = []
converted_log = {"numeric_converted": set(), "datetime_converted": set(), "dropped": set()}

for p in paths:
    try:
        # leer solo las columnas que este archivo contiene (como str para luego convertir)
        sample_cols = pd.read_csv(p, nrows=0, encoding=ENCODING).columns.tolist()
    except Exception as e:
        print(f"Error leyendo headers de {p}: {e}")
        continue
    cols_to_read = [c for c in sample_cols if c in variables_num_dt]
    if not cols_to_read:
        continue

    df_part = pd.read_csv(p, usecols=cols_to_read, dtype=str, encoding=ENCODING)
    df_part = df_part.apply(lambda s: s.str.strip() if s.dtype == object else s)

    # convertir columnas según tipo
    for col in cols_to_read:
        t = decided_type.get(col, "other")
        if t == "numeric":
            df_part[col] = pd.to_numeric(df_part[col], errors="coerce")
            converted_log["numeric_converted"].add(col)
        elif t == "datetime":
            # convertir a datetime y luego a enteros (segundos desde epoch) para correlacionar
            dtser = pd.to_datetime(df_part[col], errors="coerce", infer_datetime_format=True)
            # pasar a int64 ns, luego a float segundos, y normalizar NaT a NaN
            ints = pd.Series(dtser.view("int64"), index=dtser.index).astype("float64")
            # Pandas representa NaT como very negative number; lo convertimos a NaN
            ints[ints < -8e18] = np.nan
            df_part[col] = ints / 1_000_000_000.0  # segundos como float
            converted_log["datetime_converted"].add(col)
        else:
            # columna no numérica ni datetime (la descartamos ahora). Si quieres incluir, cambia INCLUDE_CATEGORICALS=True
            df_part.drop(columns=[col], inplace=True)
            converted_log["dropped"].add(col)

    frames.append(df_part)

if not frames:
    raise SystemExit("No se han leído columnas convertibles. Revisa la detección de tipos o ajusta los umbrales.")

# concatenar y asegurar columnas en el orden deseado
df = pd.concat(frames, ignore_index=True, sort=False)
df = df.reindex(columns=sorted(set(df.columns)))  # ordenar columnas

# --- 4) Si el usuario quiere incluir categóricas: factorizarlas AHORA sobre el df concatenado ---
if INCLUDE_CATEGORICALS:
    # encontrar columnas restantes que siguen dtype object y factorizarlas
    for col in df.select_dtypes(include=["object"]).columns.tolist():
        codes = pd.Categorical(df[col]).codes.astype("float64")
        codes[codes == -1] = np.nan  # -1 es NaN en Categorical.codes
        df[col] = codes
        converted_log.setdefault("factorized", set()).add(col)

# --- 5) Crear matriz de correlación (pandas hará pairwise) ---
print("Calculando matriz de correlación (usa memoria: p x p)...")
corr = df.corr()

# --- 6) calcular conteo de pares válidos y filtrar por MIN_PAIRS_FOR_CORR ---
notna = df.notna().astype(int)
counts = notna.T.dot(notna)
mask = counts >= MIN_PAIRS_FOR_CORR
corr_filtered = corr.where(mask)

# --- 7) guardar resultados (solo pares con valor definido) ---
resultados = {}
vars_list = corr_filtered.columns.tolist()
for a, b in combinations(vars_list, 2):
    val = corr_filtered.loc[a, b]
    if pd.notna(val):
        resultados[f"{a} - {b}"] = float(val)

items_sorted = sorted(resultados.items(), key=lambda x: x[1], reverse=True)
with open("resultados.txt", "w", encoding=ENCODING) as f:
    for k, v in items_sorted:
        f.write(f"{k}: {v}\n")

# --- 8) reporte sobre conversiones ---
with open("reporte_conversiones.txt", "w", encoding=ENCODING) as f:
    f.write(f"Archivos leídos: {n_files}\n")
    f.write(f"Columnas detectadas totales: {len(decided_type)}\n")
    f.write(f"Numeric convertidas ({len(converted_log['numeric_converted'])}):\n")
    for c in sorted(converted_log["numeric_converted"]):
        f.write("  " + c + "\n")
    f.write(f"\nDatetime convertidas ({len(converted_log['datetime_converted'])}):\n")
    for c in sorted(converted_log["datetime_converted"]):
        f.write("  " + c + "\n")
    f.write(f"\nDescartadas por ser no-numéricas ({len(converted_log['dropped'])}):\n")
    for c in sorted(converted_log["dropped"]):
        f.write("  " + c + "\n")
    if INCLUDE_CATEGORICALS and "factorized" in converted_log:
        f.write(f"\nFactorizadas ({len(converted_log['factorized'])}):\n")
        for c in sorted(converted_log["factorized"]):
            f.write("  " + c + "\n")

print("Listo. archivos generados: resultados.txt y reporte_conversiones.txt")
