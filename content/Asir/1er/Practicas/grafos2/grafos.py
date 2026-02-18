import networkx as nx
from pyvis.network import Network
from math import log2

# Leer los datos del archivo
archivo = r"D3\data\texto.txt"
grafo = nx.Graph()
personas = set()

with open(archivo, "r") as file:
    for linea in file:
        if ": " in linea:  # Filtramos las líneas que contienen relaciones
            persona, seguidores = linea.strip().split(": ")
            seguidores = seguidores.split(", ")  # Convertimos seguidores a lista
            personas.add(persona)
            
            # Agregar nodos y aristas al grafo
            for seguidor in seguidores:
                grafo.add_edge(persona, seguidor)
                
# Crear visualización interactiva con pyvis
net = Network(notebook=True, height="750px", width="100%", bgcolor="#222222", font_color="white")

# Convertir el grafo y ajustar la física
net.from_nx(grafo)

for node in net.nodes:
    
    nodre_degree = grafo.degree(node["id"])

    if node["id"] in personas:
        node["color"] = "#FF0000"
        node["size"] = 10 + nodre_degree**0.75 #log2(nodre_degree)
    else:
        personas_conectadas = [n for n in grafo.neighbors(node["id"]) if n in personas]

        if len(personas_conectadas) > 1:
            node["color"] = "#FFFF00"
        else:
            node["color"] = "#D0D0D0"
        node["size"] = 10 + ((nodre_degree**0.4)*log2(nodre_degree**1.6)/(nodre_degree**0.2)) #log2(nodre_degree)

net.set_options = {"""
  "interaction": {
    "dragNodes": true,
    "dragView": true,
    "zoomView": true,
    "hover": true,
    "selectConnectedEdges": true, 
    "animation": true 
  },
  "layout": {
    "improvedLayout": true,
    "hierarchical": {
      "enabled": false,
      "levelSeparation": 150,
      "nodeSpacing": 200,
      "treeSpacing": 200,
      "direction": 'UD',
      "sortMethod": 'directed'
    }
  },
  "physics": {
    "enabled": false,
    "stabilization": {
      "enabled": true,
      "iterations": 0,
      "updateInterval": 50
    },
    "solver": "forceAtlas2Based",
    "forceAtlas2Based": {
      "gravitationalConstant": -300,
      "centralGravity": 0.1,
      "springLength": 100,
      "springConstant": 0.5,
      "avoidOverlap": 1,
      "damping": 0.4
    }
  },
  "edges": {
    "smooth": {
      "type": "continuous"
    },
    "color": {
      "color": '#848484',
      "highlight": '#ff0000',
      "hover": '#ff0000'
    },
    "width": 2
  },
  "nodes": {
    "color": {
      "background": '#97C2FC',
      "border": '#2B7CE9',
      "highlight": {
        "background": '#D2E5FF',
        "border": '#2B7CE9'
      },
      "hover": {
        "background": '#D2E5FF',
        "border": '#2B7CE9'
      }
    },
    "size": 10,
    "font": {
      "size": 14,
      "color": '#343434'
    }
  }
"""}

# Script adicional para personalizar la física de los nodos persona
net.html += """
<script type="text/javascript">
  network.once("stabilizationIterationsDone", function () {
    var nodes = network.body.data.nodes.get();
    var personas = nodes.filter(node => node.color === "#FF5733");

    personas.forEach(persona => {
      var hijos = network.getConnectedNodes(persona.id);  // Obtener nodos hijos
      hijos.forEach(hijo => {
        // Aumentar la atracción para nodos conectados (hijos)
        network.body.physics.springConstant[persona.id + "-" + hijo] = 0.6;
        network.body.physics.springLength[persona.id + "-" + hijo] = 80;
      });

      // Separar a esta persona de otras personas
      personas
        .filter(otra => otra.id !== persona.id)
        .forEach(otraPersona => {
          network.body.physics.gravitationalConstant[persona.id + "-" + otraPersona.id] = -150;
        });
    });

    network.setOptions({ physics: false }); // Desactivar físicas tras ajuste
  });
</script>
"""

net.html += """
<script type="text/javascript">
  function buscarNodo() {
    var nombre = document.getElementById("searchBox").value; // Obtener valor del cuadro de búsqueda
    var allNodes = network.body.data.nodes.get(); // Obtener todos los nodos

    // Encontrar nodo por nombre
    var nodo = allNodes.find(n => n.label.toLowerCase() === nombre.toLowerCase());
    
    if (nodo) {
      // Centrarse en el nodo encontrado
      network.focus(nodo.id, {
        scale: 2, // Zoom en el nodo
        animation: true // Animación suave
      });

      // Resaltar nodo temporalmente cambiando su color
      network.body.data.nodes.update({ id: nodo.id, color: { background: "#FFD700" } });
      setTimeout(() => {
        // Restaurar el color original después de 2 segundos
        network.body.data.nodes.update({ id: nodo.id, color: nodo.color });
      }, 2000);
    } else {
      alert("Nodo no encontrado");
    }
  }
</script>

<div style="margin: 10px; text-align: center;">
  <input id="searchBox" type="text" placeholder="Buscar nodo por nombre..." style="padding: 5px; width: 200px;" />
  <button onclick="buscarNodo()" style="padding: 5px; margin-left: 5px;">Buscar</button>
</div>
"""


net.show("grafo_interactivo1.html")
