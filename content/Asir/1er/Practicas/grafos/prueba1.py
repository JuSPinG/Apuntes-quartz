import networkx as nx
import matplotlib.pyplot as plt

# Crear un grafo
G = nx.Graph()

# Agregar nodos
G.add_node("A")
G.add_node("B")
G.add_node("C")

# Agregar aristas
G.add_edge("A", "B")
G.add_edge("B", "C")
G.add_edge("A", "C")

# Mostrar el grafo
nx.draw(G, with_labels=True)
plt.show()