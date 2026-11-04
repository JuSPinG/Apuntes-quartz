````sql

CREATE DATABASE academia_fp;
USE academia_fp;

CREATE TABLE Cursos(
	idCurso INT PRIMARY KEY AUTO_INCREMENT,
	nombreCurso VARCHAR(100) NOT NULL,
	duraciónHoras INT
);

CREATE TABLE Alumnos(
	idAlumno INT PRIMARY KEY AUTO_INCREMENT,
	nombre VARCHAR(50) NOT NULL,
	edad INT,
	ciudad VARCHAR(50),
	idCurso INT,
	FOREIGN KEY (idCurso) REFERENCES Cursos(idCurso)
	ON DELETE CASCADE
	ON UPDATE CASCADE
);

INSERT INTO Cursos (nombreCurso, duraciónHoras) VALUES
	("1ºASIR", 255),
	("2ºASIR", 255),
	("1ºEI", 255),
	("2ºEI", 300),
	("1ºSMR", 200);

INSERT INTO Alumnos (nombre, edad, ciudad, idCurso) VALUES
	("Marcos", 17, "Madrid", 3),
	("Marina", 19, "Córdoba", 2),
	("Luis", 18, "Jaén", 1),
	("Miralles", 18, "Ceuta", 1),
	("IsmaPrime", 17, "Pontevedra", 4);
```