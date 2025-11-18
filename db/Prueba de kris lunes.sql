-- La universidad necesita diseñar una base de datos para registrar a los estudiantes, las asignaturas y los profesores. Se sabe que:

-- Los estudiantes tienen un carné de identificación y se deben guardar sus datos personales.
-- Los profesores se registran a través de su número de INSS además de sus datos personales.
-- De las asignaturas se debe registrar el nombre y la cantidad de horas de duración.
-- Se solicita:

-- Realizar el diseño del diagrama Entidad-Relación (ER) considerando que la relación entre alumno y asignatura se da a través de un curso.
-- Escribir el script para ejecutar en MySQL.
-- Realizar los procedimientos almacenados necesarios para el CRUD (Crear, Leer, Actualizar, Eliminar) de estudiantes.
-- Ingresar datos de prueba y eliminar uno de ellos

CREATE DATABASE GESTION_ESCUELA;
USE GESTION_ESCUELA;

CREATE TABLE ESTUDIANTE(
ID_ESTUDIANTE INT AUTO_INCREMENT PRIMARY KEY,
PRIMER_NOMBRE VARCHAR(35) NOT NULL,
SEGUNDO_NOMBRE   VARCHAR(35),
Apellidos1 VARCHAR(35) NOT NULL,
Apellidos2 VARCHAR(35),
 Telefono VARCHAR(12)
);

CREATE TABLE MAESTROS(
INSS INT AUTO_INCREMENT PRIMARY KEY,
PRIMER_NOMBRE VARCHAR(35) NOT NULL,
SEGUNDO_NOMBRE   VARCHAR(35),
Apellidos1 VARCHAR(35) NOT NULL,
Apellidos2 VARCHAR(35),
Telefono VARCHAR(12),
DIRECCION VARCHAR(11)
);

CREATE TABLE CURSO(
ID_CURSO INT AUTO_INCREMENT PRIMARY KEY,
BASE_de_DATOS VARCHAR(10),
DESCRIPCION VARCHAR (10)
);


CREATE TABLE ASIGNATURA(
ID_ASIGNATURA INT AUTO_INCREMENT PRIMARY KEY,
NOMBRE_ASIGNATURA VARCHAR(12),
DURACION_HORA INT,
INSS INT,
FOREIGN KEY (INSS) REFERENCES MAESTROS (INSS)
);

CREATE TABLE DETALLE_CURSO(
ID_DETALLE_CURSO INT PRIMARY KEY,
ID_ESTUDIANTE INT NOT NULL,
ID_CURSO INT NOT NULL,
ID_ASIGNATURA INT NOT NULL,
FOREIGN KEY (ID_CURSO) REFERENCES CURSO (ID_CURSO) ON DELETE restrict, -- Regla de integridad referencial en MySQL que impide eliminar un registro si está siendo usado por otra tabla.
FOREIGN KEY (ID_ESTUDIANTE) REFERENCES ESTUDIANTE (ID_ESTUDIANTE) ON DELETE restrict,
FOREIGN KEY (ID_ASIGNATURA) REFERENCES ASIGNATURA (ID_ASIGNATURA) ON DELETE restrict
);


