import csv
import numpy as np
import tensorflow as tf
from tensorflow.keras.models import Model
from tensorflow.keras.layers import Input, Dense
from tensorflow.keras.regularizers import l2
from sklearn.preprocessing import StandardScaler

# Leer y preparar los datos
nombres = []
generos = []
data = []

with open("data/data.csv", encoding="UTF-8") as csvfile:
    reader = csv.reader(csvfile)
    nombres = next(reader)[1:]  # Obtener los nombres de los juegos
    for row in reader:
        generos.append(row[0])  # Obtener los géneros
        data.append(row[1:])    # Obtener los datos de género

# Convertir a array numpy y transponer
data = np.array(data).astype(int).T

# Escalar los datos
scaler = StandardScaler()
data_scaled = scaler.fit_transform(data)

# Construir el autoencoder con regularización
input_dim = data.shape[1]
encoding_dim = 4  # Incrementar la dimensionalidad del embedding

input_layer = Input(shape=(input_dim,))
encoded = Dense(encoding_dim, activation='relu', activity_regularizer=l2(0.01))(input_layer)  # Regularización L2
decoded = Dense(input_dim, activation='sigmoid')(encoded)

autoencoder = Model(input_layer, decoded)
encoder = Model(input_layer, encoded)

# Compilar el modelo
autoencoder.compile(optimizer='adam', loss='binary_crossentropy')

# Entrenar el modelo
autoencoder.fit(data_scaled, data_scaled, epochs=1000, batch_size=32, shuffle=True, verbose=1)

# Obtener los embeddings
embeddings = encoder.predict(data_scaled)

# Guardar los embeddings en un archivo CSV
with open("embeddings.csv", mode="w", newline="") as file:
    writer = csv.writer(file)
    writer.writerow(["Juego"] + [f"Dim_{i+1}" for i in range(encoding_dim)])  # Escribir la cabecera
    for i, name in enumerate(nombres):
        writer.writerow([name] + list(embeddings[i]))

print("Embeddings guardados en 'embeddings2.csv'")