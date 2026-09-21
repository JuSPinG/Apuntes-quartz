Crear las siguientes tablas: olivas, aceitunos, fabricas, vareadores.
Crear relaciones entre, fabricas-vareadores, vareadores-aceitunos, aceitunos-olivas.

CREATE TABLE Olivas(
    id INT PRIMARY KEY AUTO_INCREMENT,
    tipo INT NULL,
    cantidad INT NOT NULL,
    id_arbol INT NOT NULL,
    FOREIGN KEY (id_arbol) REFERENCES Aceitunos(id)
);

CREATE TABLE Aceitunos(
    id INT PRIMARY KEY AUTO_INCREMENT,
    años NUMERIC(4, 0) NULL DEFAULT 0,
    posiciónX INT NOT NULL,
    posiciónY INT NOT NULL,
    últimoVareadoAño NUMERIC(4, 0) NULL,
    últimoVareadoMes NUMERIC(2, 0) NULL,
    últimoVareadoDia NUMERIC(2, 0) NULL,
    id_vareadoPor INT NULL,
    descripción VARCHAR(50) NULL,
    FOREIGN KEY (id) REFERENCES Vareadores(id)
);

CREATE TABLE Vareadores(
    id INT PRIMARY KEY AUTO_INCREMENT,
    dni INT UNIQUE NULL,
    años NUMERIC(2, 0) NULL,
    sueldo NUMERIC(6, 2) NULL,
    id_fábrica INT NULL,
    FOREIGN KEY (id_fábrica) REFERENCES Fabricas(id)
);

CREATE TABLE Fabricas(
    id INT PRIMARY KEY AUTO_INCREMENT,
    dirección VARCHAR(40) UNIQUE NOT NULL
);