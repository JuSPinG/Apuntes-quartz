import igraph as ig
import matplotlib.pyplot as plt

# Crear un grafo aleatorio de Erdős-Rényi
n = 10000  # Número de nodos
m = 50000  # Número de aristas
g = ig.Graph.Erdos_Renyi(n=n, m=m)

# Configurar el layout para la visualización
layout = g.layout("fr")  # Usar el layout de Fruchterman-Reingold

# Visualizar el grafo
fig, ax = plt.subplots(figsize=(10, 10))
ig.plot(g, layout=layout, target=ax, vertex_size=1, vertex_color="blue", edge_color="gray", bbox=(0, 0, 1000, 1000), margin=20)

plt.title("Visualización de un grafo aleatorio con 10,000 nodos")
plt.show()