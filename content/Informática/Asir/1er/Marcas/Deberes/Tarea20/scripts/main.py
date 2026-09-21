import sqlite3

con = sqlite3.connect(r"Tarea20\data\data.sqlite3")
cur = con.cursor()

cur.execute("""
            CREATE TABLE IF NOT EXISTS Jugadores(
            Id INTEGER PRIMARY KEY AUTOINCREMENT,
            Civilizacion CHAR(4),
            Lider VARCHAR(30),
            Nombre VARCHAR(20),
            FormaGobierno INTEGER,
            EnGuerra INTEGER,
            FOREIGN KEY (EnGuerra) REFERENCES Jugadores(Id) 
            ON DELETE CASCADE 
            ON DELETE SET NULL
)""")

cur.execute("""
            CREATE TABLE IF NOT EXISTS Partidas(
            Id INTEGER PRIMARY KEY AUTOINCREMENT,
            Recursos INTEGER,
            Ciudades INTEGER
)""")

cur.execute("""
            CREATE TABLE IF NOT EXISTS Recursos(
            Id INTEGER PRIMARY KEY AUTOINCREMENT,
            Oro INTEGER,
            Puntaje INTEGER
)""")

cur.execute("""
            CREATE TABLE IF NOT EXISTS Ciudades(
            Id INTEGER PRIMARY KEY AUTOINCREMENT,
            Impuestos INTEGER,
            Lujo INTEGER,
            Ciencia INTEGER,  
            Ciudadanos INTEGER
)""")


con.commit()