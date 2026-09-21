```SQL
CREATE TABLE vehiculo(
	id INTEGER PRIMARY KEY,
	marca TEXT,
	color TEXT,
	caballos INTEGER
);

.tables
	vehiculos

INSERT INTO vehiculo(id, marca, color, caballos) VALUES 
	(1, "mercedes", "negro", 200),
	(2, "seat", "gris", 170),
	(3, "bmv", "verde", 210);

SELECT * FROM vehiculo WHERE marca = "bmv";
	3|bmv|verde|210

CREATE TABLE clientes(
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	nombre TEXT NOT NULL,
	apellido TEXT
);

INSERT INTO clientes(nombre, apellido) VALUES
	("Marcos", "Santos");
```