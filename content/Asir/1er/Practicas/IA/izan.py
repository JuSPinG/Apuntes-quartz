import tensorflow as tf
import numpy as np
from tensorflow.keras import layers # type: ignore
from tensorflow.keras.callbacks import EarlyStopping # type: ignore

celsius = np.array([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99], dtype=float)
fareheit = np.array([32.0, 33.8, 35.6, 37.4, 39.2, 41.0, 42.8, 44.6, 46.4, 48.2, 50.0, 51.8, 53.6, 55.4, 57.2, 59.0, 60.8, 62.6, 64.4, 66.2, 68.0, 69.8, 71.6, 73.4, 75.2, 77.0, 78.8, 80.6, 82.4, 84.2, 86.0, 87.8, 89.6, 91.4, 93.2, 95.0, 96.8, 98.6, 100.4, 102.2, 104.0, 105.8, 107.6, 109.4, 111.2, 113.0, 114.8, 116.6, 118.4, 120.2, 122.0, 123.8, 125.6, 127.4, 129.2, 131.0, 132.8, 134.6, 136.4, 138.2, 140.0, 141.8, 143.6, 145.4, 147.2, 149.0, 150.8, 152.6, 154.4, 156.2, 158.0, 159.8, 161.6, 163.4, 165.2, 167.0, 168.8, 170.6, 172.4, 174.2, 176.0, 177.8, 179.6, 181.4, 183.2, 185.0, 186.8, 188.6, 190.4, 192.2, 194.0, 195.8, 197.6, 199.4, 201.2, 203.0, 204.8, 206.6, 208.4, 210.2], dtype=float)


modelo = tf.keras.Sequential([
    layers.Dense(3, activation='relu', input_shape=[1]),
    layers.Dense(1)
])

modelo.compile(
    optimizer=tf.keras.optimizers.Adam(0.01),
    loss="mean_squared_error"
)

early_stopping = EarlyStopping(
    monitor='loss',
    patience=50,
    min_delta=0.0001,
    restore_best_weights=True
)

modelo.fit(celsius, fareheit, epochs=10000, verbose=True, callbacks=[early_stopping])


while True:
    res = float(input("Pon un número: "))
    # Corrección: Convertir a arreglo 2D con reshape(-1, 1)
    entrada = np.array([float(res)]).reshape(-1, 1)
    prediccion = modelo.predict(entrada)[0][0]
    print("Predicción:", prediccion)
    print("Respuesta correcta:", float(res*(9/5)+32))
    print("Desviación:", float(abs((res*(9/5)+32)-prediccion)/(prediccion*(res*(9/5)+32))*0.5))