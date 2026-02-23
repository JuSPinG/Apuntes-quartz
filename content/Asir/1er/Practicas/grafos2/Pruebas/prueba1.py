import networkx as nx
from pyvis.network import Network

# Crear el grafo
grafo = nx.DiGraph()  # Grafo dirigido porque seguimos relaciones de "siguiendo"

# Datos de ejemplo
usuarios = {
    "usuario1": ["usuario2", "usuario3"],
    "usuario2": ["usuario3", "usuario4"],
    "usuario3": ["usuario1"],
    "usuario4": ["usuario5"],
    "usuario5": ["usuario1", "usuario2"],
}

# Añadir nodos y relaciones (aristas)
for usuario, seguidos in usuarios.items():
    for seguido in seguidos:
        grafo.add_edge(usuario, seguido)

# Visualizar el grafo
net = Network(notebook=True, directed=True)
net.show_buttons(filter_=["physics"])  # Muestra opciones interactivas para cambiar la física en tiempo real
net.toggle_physics(True)

net.from_nx(grafo)
net.show("grafo_instagram.html")
nx.write_gexf(grafo, "grafo_instagram.gexf")  # Compatible con Gephi
