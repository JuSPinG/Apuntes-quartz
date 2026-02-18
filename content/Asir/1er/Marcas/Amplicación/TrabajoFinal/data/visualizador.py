import csv
import numpy as np
import matplotlib.pyplot as plt
import umap

# Leer los embeddings del archivo CSV
nombres = []
embeddings = []

with open(r"E:\Obsidian\Conocimiento\Asir\Marcas\Amplicación\TrabajoFinal\data\embeddings.csv", mode="r", newline="") as file:
    reader = csv.reader(file)
    header = next(reader)  # Leer la cabecera
    for row in reader:
        nombres.append(row[0])
        embeddings.append([float(x) for x in row[1:]])

embeddings = np.array(embeddings)

# Visualizar los embeddings usando UMAP
umap_model = umap.UMAP(n_neighbors=15, min_dist=0.1)
umap_embeddings = umap_model.fit_transform(embeddings)

plt.figure(figsize=(10, 8))
for i in range(len(umap_embeddings)):
    plt.scatter(umap_embeddings[i, 0], umap_embeddings[i, 1])
    plt.text(umap_embeddings[i, 0], umap_embeddings[i, 1], nombres[i], fontsize=9)
plt.title("Embeddings de Videojuegos Visualizados con UMAP")
plt.xlabel("Dimensión 1")
plt.ylabel("Dimensión 2")
plt.show()