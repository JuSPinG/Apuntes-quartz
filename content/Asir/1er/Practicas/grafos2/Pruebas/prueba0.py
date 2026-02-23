import networkx as nx
from pyvis.network import Network

grafo = nx.erdos_renyi_graph(100, 0.05)  # Crea un grafo aleatorio con 100 nodos

net = Network()

net = Network(notebook=True, directed=True)
net.from_nx(grafo)  # Convierte el grafo de NetworkX a Pyvis
net.show("grafo_interactivo2.html")
