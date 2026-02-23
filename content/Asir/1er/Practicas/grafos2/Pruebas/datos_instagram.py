from instaloader import Instaloader, Profile
import pickle
from time import sleep
import networkx as nx
from pyvis.network import Network
from random import uniform

# Crear el grafo dirigido
grafo = nx.DiGraph()

# Usuario de Instagram
USUARIO = "choripaannnn"

# Límite de usuarios procesados en esta ejecución
LIMITE_USUARIOS = 2
usuarios_procesados_en_ejecucion = 0

# Cargar Instaloader
L = Instaloader()

# Cargar sesión
#L.load_session_from_file(USUARIO)
L.login(USUARIO, "instagram2")
L.save_session_to_file()

# Recuperar o inicializar el progreso
try:
    with open("progreso.pkl", "rb") as f:
        progreso = pickle.load(f)
        print("Progreso cargado exitosamente.")
except FileNotFoundError:
    progreso = {"procesados": set(), "grafo": {}}  # Inicializar progreso
    print("Archivo de progreso no encontrado. Iniciando desde cero.")

# Cargar perfil principal
profile = Profile.from_username(L.context, USUARIO)

# Recorrer seguidores
try:
    for seguidor in profile.get_followers():
        username = seguidor.username

        # Saltar si ya fue procesado
        if username in progreso["procesados"]:
            continue

        print(f"Procesando: {username} ({seguidor.followers.numerator} seguidores)")

        # Intentar obtener los seguidores del seguidor
        try:
            perfilSeguidor = Profile.from_username(L.context, username)
            progreso["grafo"][username] = []

            for seguidorseguidor in perfilSeguidor.get_followers():
                progreso["grafo"][username].append(seguidorseguidor.username)
                grafo.add_edge(username, seguidorseguidor.username)

            # Marcar como procesado
            progreso["procesados"].add(username)

        except Exception as e:
            print(f"Error procesando {username}: {e}")
            sleep(uniform(10, 15))  # Esperar antes de continuar

        usuarios_procesados_en_ejecucion += 1

        # Guardar progreso después de procesar cada usuario
        with open("progreso.pkl", "wb") as f:
            pickle.dump(progreso, f)
            print("Progreso guardado.")

        # Salir si alcanzamos el límite de usuarios en esta ejecución
        if usuarios_procesados_en_ejecucion >= LIMITE_USUARIOS:
            print(f"Límite de {LIMITE_USUARIOS} usuarios alcanzado. Deteniendo ejecución.")
            break

        sleep(uniform(7, 14))  # Pausa entre solicitudes

except KeyboardInterrupt:
    print("Ejecución interrumpida manualmente. Guardando progreso...")
finally:
    # Guardar el progreso y el grafo al finalizar
    with open("progreso.pkl", "wb") as f:
        pickle.dump(progreso, f)
        print("Progreso guardado exitosamente.")

    # Crear visualización interactiva del grafo
    net = Network(notebook=True, directed=True)
    net.from_nx(grafo)
    net.show("grafo_instagram.html")
    nx.write_gexf(grafo, "grafo_instagram.gexf")  # Compatible con Gephi
    print("Visualización y grafo exportados.")
