CREATE DATABASE Moto_Repuesto;

USE Moto_Repuesto;

CREATE TABLE Clientes(
    ID_Cliente INT AUTO_INCREMENT PRIMARY KEY,
    Nombre1 VARCHAR(60) NOT NULL,   
    Nombre2 VARCHAR(60) NOT NULL,
    Apellidos1 VARCHAR(60) NOT NULL,
    Apellidos2 VARCHAR(60) NOT NULL,
    Cedula VARCHAR(60),
    Telefono VARCHAR(12)
);

CREATE TABLE Productos(
    ID_Producto INT AUTO_INCREMENT PRIMARY KEY,
    Nombre_P VARCHAR(100) NOT NULL,
    Descripcion VARCHAR(100) NOT NULL,
    Cantidad INT NOT NULL,
    Preciodecom FLOAT NOT NULL,
    Preciodeven FLOAT NOT NULL
);

CREATE TABLE Proveedores(
    ID_Proveedor INT AUTO_INCREMENT PRIMARY KEY,
    Nombre_Prov VARCHAR(100) NOT NULL,
    Contacto VARCHAR(12) NOT NULL,
    Email VARCHAR(100) NOT NULL
);

CREATE TABLE Compras (
    ID_Compra INT AUTO_INCREMENT PRIMARY KEY,
    Fecha_compra DATE NOT NULL,
    Cantidad INT,
    ID_Proveedor INT,
    FOREIGN KEY (ID_Proveedor) REFERENCES Proveedores (ID_Proveedor)
);

CREATE TABLE Ventas (
    ID_Venta INT AUTO_INCREMENT PRIMARY KEY,
    Fecha_Venta DATE NOT NULL,
    ID_Cliente INT,
    FOREIGN KEY (ID_Cliente) REFERENCES Clientes (ID_Cliente)
);

CREATE TABLE Detalle_Ventas(
    ID_Detalle_ven INT AUTO_INCREMENT PRIMARY KEY,
    ID_Venta INT NOT NULL,
    ID_Producto INT NOT NULL,
    Cantidad_ven INT NOT NULL,
    Precio_Ven FLOAT NOT NULL,
    FOREIGN KEY (ID_Venta) REFERENCES Ventas (ID_Venta),
    FOREIGN KEY (ID_Producto) REFERENCES Productos (ID_Producto)
);

CREATE TABLE Detalle_Compras(
    ID_Detales_Com INT AUTO_INCREMENT PRIMARY KEY,
    ID_Compra INT NOT NULL,
    ID_Producto INT NOT NULL,
    Cantidad_com INT NOT NULL,
    Precio_Com FLOAT NOT NULL,
    FOREIGN KEY (ID_Producto) REFERENCES Productos (ID_Producto),
    FOREIGN KEY (ID_Compra) REFERENCES Compras (ID_Compra)
);

-- ======================================
-- TABLA DE BITÁCORA
-- ======================================
CREATE TABLE Bitacora (
    ID_Bitacora INT AUTO_INCREMENT PRIMARY KEY,
    Tabla VARCHAR(50) NOT NULL,
    Operacion VARCHAR(20) NOT NULL,
    ID_Registro INT NOT NULL,
    Usuario VARCHAR(100) NOT NULL,
    Fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    Detalle TEXT
);
-- ======================================
-- CLIENTES
-- ======================================
DELIMITER //
CREATE TRIGGER trg_clientes_insert
AFTER INSERT ON Clientes
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (Tabla, Operacion, ID_Registro, Usuario, Detalle)
    VALUES ('Clientes', 'INSERT', NEW.ID_Cliente, USER(),
            CONCAT('Se agregó el cliente: ', NEW.Nombre1, ' ', NEW.Apellidos1));
END;
//
CREATE TRIGGER trg_clientes_update
AFTER UPDATE ON Clientes
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (Tabla, Operacion, ID_Registro, Usuario, Detalle)
    VALUES ('Clientes', 'UPDATE', NEW.ID_Cliente, USER(),
            CONCAT('Se actualizó el cliente: ', NEW.Nombre1, ' ', NEW.Apellidos1));
END;
//
CREATE TRIGGER trg_clientes_delete
AFTER DELETE ON Clientes
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (Tabla, Operacion, ID_Registro, Usuario, Detalle)
    VALUES ('Clientes', 'DELETE', OLD.ID_Cliente, USER(),
            CONCAT('Se eliminó el cliente: ', OLD.Nombre1, ' ', OLD.Apellidos1));
END;
//
DELIMITER ;
-- ======================================
-- PRODUCTOS
-- ======================================
DELIMITER //
CREATE TRIGGER trg_productos_insert
AFTER INSERT ON Productos
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (Tabla, Operacion, ID_Registro, Usuario, Detalle)
    VALUES ('Productos', 'INSERT', NEW.ID_Producto, USER(),
            CONCAT('Se agregó el producto: ', NEW.Nombre_P));
END;
//
CREATE TRIGGER trg_productos_update
AFTER UPDATE ON Productos
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (Tabla, Operacion, ID_Registro, Usuario, Detalle)
    VALUES ('Productos', 'UPDATE', NEW.ID_Producto, USER(),
            CONCAT('Se actualizó el producto: ', NEW.Nombre_P));
END;
//
CREATE TRIGGER trg_productos_delete
AFTER DELETE ON Productos
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (Tabla, Operacion, ID_Registro, Usuario, Detalle)
    VALUES ('Productos', 'DELETE', OLD.ID_Producto, USER(),
            CONCAT('Se eliminó el producto: ', OLD.Nombre_P));
END;
//
DELIMITER ;
-- ======================================
-- PROVEEDORES
-- ======================================
DELIMITER //
CREATE TRIGGER trg_proveedores_insert
AFTER INSERT ON Proveedores
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (Tabla, Operacion, ID_Registro, Usuario, Detalle)
    VALUES ('Proveedores', 'INSERT', NEW.ID_Proveedor, USER(),
            CONCAT('Se agregó el proveedor: ', NEW.Nombre_Prov));
END;
//
CREATE TRIGGER trg_proveedores_update
AFTER UPDATE ON Proveedores
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (Tabla, Operacion, ID_Registro, Usuario, Detalle)
    VALUES ('Proveedores', 'UPDATE', NEW.ID_Proveedor, USER(),
            CONCAT('Se actualizó el proveedor: ', NEW.Nombre_Prov));
END;
//
CREATE TRIGGER trg_proveedores_delete
AFTER DELETE ON Proveedores
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (Tabla, Operacion, ID_Registro, Usuario, Detalle)
    VALUES ('Proveedores', 'DELETE', OLD.ID_Proveedor, USER(),
            CONCAT('Se eliminó el proveedor: ', OLD.Nombre_Prov));
END;
//
DELIMITER ;
-- ======================================
-- COMPRAS
-- ======================================
DELIMITER //
CREATE TRIGGER trg_compras_insert
AFTER INSERT ON Compras
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (Tabla, Operacion, ID_Registro, Usuario, Detalle)
    VALUES ('Compras', 'INSERT', NEW.ID_Compra, USER(),
            CONCAT('Se registró la compra del proveedor ID: ', NEW.ID_Proveedor));
END;
//
CREATE TRIGGER trg_compras_update
AFTER UPDATE ON Compras
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (Tabla, Operacion, ID_Registro, Usuario, Detalle)
    VALUES ('Compras', 'UPDATE', NEW.ID_Compra, USER(),
            CONCAT('Se actualizó la compra ID: ', NEW.ID_Compra));
END;
//
CREATE TRIGGER trg_compras_delete
AFTER DELETE ON Compras
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (Tabla, Operacion, ID_Registro, Usuario, Detalle)
    VALUES ('Compras', 'DELETE', OLD.ID_Compra, USER(),
            CONCAT('Se eliminó la compra ID: ', OLD.ID_Compra));
END;
//
DELIMITER ;
-- ======================================
-- VENTAS
-- ======================================
DELIMITER //
CREATE TRIGGER trg_ventas_insert
AFTER INSERT ON Ventas
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (Tabla, Operacion, ID_Registro, Usuario, Detalle)
    VALUES ('Ventas', 'INSERT', NEW.ID_Venta, USER(),
            CONCAT('Se registró la venta al cliente ID: ', NEW.ID_Cliente));
END;
//
CREATE TRIGGER trg_ventas_update
AFTER UPDATE ON Ventas
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (Tabla, Operacion, ID_Registro, Usuario, Detalle)
    VALUES ('Ventas', 'UPDATE', NEW.ID_Venta, USER(),
            CONCAT('Se actualizó la venta ID: ', NEW.ID_Venta));
END;
//
CREATE TRIGGER trg_ventas_delete
AFTER DELETE ON Ventas
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (Tabla, Operacion, ID_Registro, Usuario, Detalle)
    VALUES ('Ventas', 'DELETE', OLD.ID_Venta, USER(),
            CONCAT('Se eliminó la venta ID: ', OLD.ID_Venta));
END;
//
DELIMITER ;
-- ======================================
-- DETALLE_COMPRAS
-- ======================================
DELIMITER //
CREATE TRIGGER trg_detalle_compras_insert
AFTER INSERT ON Detalle_Compras
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (Tabla, Operacion, ID_Registro, Usuario, Detalle)
    VALUES ('Detalle_Compras', 'INSERT', NEW.ID_Detales_Com, USER(),
            CONCAT('Se agregó producto ID ', NEW.ID_Producto, ' a la compra ID ', NEW.ID_Compra));
END;
//
CREATE TRIGGER trg_detalle_compras_update
AFTER UPDATE ON Detalle_Compras
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (Tabla, Operacion, ID_Registro, Usuario, Detalle)
    VALUES ('Detalle_Compras', 'UPDATE', NEW.ID_Detales_Com, USER(),
            CONCAT('Se actualizó el detalle de compra ID ', NEW.ID_Detales_Com));
END;
//
CREATE TRIGGER trg_detalle_compras_delete
AFTER DELETE ON Detalle_Compras
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (Tabla, Operacion, ID_Registro, Usuario, Detalle)
    VALUES ('Detalle_Compras', 'DELETE', OLD.ID_Detales_Com, USER(),
            CONCAT('Se eliminó el detalle de compra ID ', OLD.ID_Detales_Com));
END;
//
DELIMITER ;
-- ======================================
-- DETALLE_VENTAS
-- ======================================
DELIMITER //
CREATE TRIGGER trg_detalle_ventas_insert
AFTER INSERT ON Detalle_Ventas
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (Tabla, Operacion, ID_Registro, Usuario, Detalle)
    VALUES ('Detalle_Ventas', 'INSERT', NEW.ID_Detalle_ven, USER(),
            CONCAT('Se agregó producto ID ', NEW.ID_Producto, ' a la venta ID ', NEW.ID_Venta));
END;
//
CREATE TRIGGER trg_detalle_ventas_update
AFTER UPDATE ON Detalle_Ventas
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (Tabla, Operacion, ID_Registro, Usuario, Detalle)
    VALUES ('Detalle_Ventas', 'UPDATE', NEW.ID_Detalle_ven, USER(),
            CONCAT('Se actualizó el detalle de venta ID ', NEW.ID_Detalle_ven));
END;
//
CREATE TRIGGER trg_detalle_ventas_delete
AFTER DELETE ON Detalle_Ventas
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (Tabla, Operacion, ID_Registro, Usuario, Detalle)
    VALUES ('Detalle_Ventas', 'DELETE', OLD.ID_Detalle_ven, USER(),
            CONCAT('Se eliminó el detalle de venta ID ', OLD.ID_Detalle_ven));
END;
//
DELIMITER ;




-- Usuarios de la base de datos 
CREATE USER 'admin_moto'@'localhost' IDENTIFIED BY 'Admin123';
GRANT ALL PRIVILEGES ON Moto_Repuesto.* TO 'admin_moto'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;


CREATE USER 'empleado_moto'@'localhost' IDENTIFIED BY 'Empleado123';
GRANT SELECT, UPDATE ON Moto_Repuesto.Ventas TO 'empleado_moto'@'localhost';
GRANT SELECT, UPDATE ON Moto_Repuesto.Detalle_Ventas TO 'empleado_moto'@'localhost';
FLUSH PRIVILEGES;


CREATE USER 'cliente_moto'@'localhost' IDENTIFIED BY 'Cliente123';
GRANT SELECT ON Moto_Repuesto.Productos TO 'cliente_moto'@'localhost';
FLUSH PRIVILEGES;


-- Insertar datos originales en Proveedores
INSERT INTO Proveedores (Nombre_Prov, Contacto, Email) VALUES
('Repuestos Rápidos', '1234567890', 'contacto@repuestosrapidos.com'),
('MotoPartes S.A.', '0987654321', 'ventas@motopartes.com'),
('Speed Moto', '1122334455', 'info@speedmoto.com');

-- Insertar 20 nuevos datos en Proveedores
INSERT INTO Proveedores (Nombre_Prov, Contacto, Email) VALUES
('AutoMotos LTDA', '3012345678', 'ventas@automotos.com'),
('Repuestos Elite', '3023456789', 'info@repuestoselite.com'),
('MotoAccesorios', '3034567890', 'contacto@motoaccesorios.com'),
('Veloz Parts', '3045678901', 'soporte@velozparts.com'),
('MotoTech', '3056789012', 'ventas@mototech.com'),
('Repuestos Pro', '3067890123', 'info@repuestospro.com'),
('Speedy Moto', '3078901234', 'contacto@speedymoto.com'),
('MotoZone', '3089012345', 'ventas@motozone.com'),
('Repuestos Dinámicos', '3090123456', 'info@repuestosdinamicos.com'),
('MotoPower', '3101234567', 'soporte@motopower.com'),
('Turbo Parts', '3112345678', 'ventas@turboparts.com'),
('MotoStar', '3123456789', 'contacto@motostar.com'),
('Repuestos Veloces', '3134567890', 'info@repuestosveloces.com'),
('MotoMundo', '3145678901', 'ventas@motomundo.com'),
('Speed Parts', '3156789012', 'soporte@speedparts.com'),
('MotoRacing', '3167890123', 'contacto@motoracing.com'),
('Repuestos Top', '3178901234', 'ventas@repuestostop.com'),
('MotoEnergy', '3189012345', 'info@motoenergy.com'),
('Fast Moto', '3190123456', 'soporte@fastmoto.com'),
('MotoPremium', '3201234567', 'ventas@motopremium.com');

-- Insertar datos originales en Clientes
INSERT INTO Clientes (Nombre1, Nombre2, Apellidos1, Apellidos2, Cedula, Telefono) VALUES
('Juan', 'Edgardo', 'Pérez', 'López', '123456789', '3216549870');

-- Insertar 20 nuevos datos en Clientes
INSERT INTO Clientes (Nombre1, Nombre2, Apellidos1, Apellidos2, Cedula, Telefono) VALUES
('María', 'Isabel', 'Gómez', 'Rodríguez', '987654321', '3101234567'),
('Carlos', 'Andrés', 'Martínez', 'Sánchez', '456789123', '3112345678'),
('Laura', 'Sofía', 'Ramírez', 'Torres', '321654987', '3123456789'),
('Diego', 'Felipe', 'Hernández', 'García', '789123456', '3134567890'),
('Ana', 'Lucía', 'Díaz', 'Moreno', '654987321', '3145678901'),
('Pedro', 'José', 'Vega', 'Castro', '147258369', '3156789012'),
('Camila', 'Valentina', 'Rojas', 'Mendoza', '258369147', '3167890123'),
('Luis', 'Fernando', 'Ortiz', 'Pineda', '369147258', '3178901234'),
('Sofía', 'Alejandra', 'Cruz', 'Vargas', '741852963', '3189012345'),
('Jorge', 'Enrique', 'Silva', 'Ríos', '852963741', '3190123456'),
('Valeria', 'Paola', 'López', 'Guzmán', '963741852', '3201234567'),
('Gabriel', 'Iván', 'Molina', 'Cárdenas', '159753486', '3212345678'),
('Daniela', 'Marcela', 'Suárez', 'Navarro', '357951468', '3223456789'),
('Andrés', 'Camilo', 'Reyes', 'Ospina', '753951486', '3234567890'),
('Clara', 'Victoria', 'Pinto', 'Mejía', '951753624', '3245678901'),
('Santiago', 'Nicolás', 'Aguilar', 'Bermúdez', '624951753', '3256789012'),
('Elena', 'Gabriela', 'Castaño', 'Quintero', '486159753', '3267890123'),
('Mateo', 'Sebastián', 'Montoya', 'Soto', '753486159', '3278901234'),
('Isabella', 'Juliana', 'Franco', 'Zapata', '159486753', '3289012345'),
('Emilio', 'Rafael', 'Gil', 'Hurtado', '321789654', '3290123456');

-- Insertar datos originales en Productos
INSERT INTO Productos (Nombre_P, Descripcion, Cantidad, Preciodecom, Preciodeven) VALUES
('Batería Moto X', 'Batería de 12V para motos', 50, 45.00, 70.00),
('Aceite Sintético', 'Aceite 10W-40 para motos', 100, 30.00, 50.00),
('Llantas Pirelli', 'Llantas de alta duración', 30, 100.00, 150.00),
('Sistema de Rodamiento', 'Rodamientos de alta calidad', 5, 2500.00, 3000.00),
('Casco Integral Pro', 'Casco integral de alta seguridad', 20, 150.00, 250.00),
('Kit de Freno ABS', 'Sistema de frenos ABS de última generación', 10, 350.00, 500.00),
('Cadena de Transmisión', 'Cadena reforzada para motos deportivas', 40, 80.00, 120.00),
('Filtro de Aire', 'Filtro de aire para motocicletas estándar', 100, 20.00, 35.00),
('Amortiguadores Racing', 'Amortiguadores ajustables de alto rendimiento', 15, 200.00, 300.00),
('Manillar Deportivo', 'Manillar ergonómico de aluminio', 30, 50.00, 80.00),
('Juego de Pastillas de Freno', 'Pastillas de freno cerámicas', 70, 25.00, 40.00),
('Luces LED Frontales', 'Luces LED de alto brillo para motos', 50, 60.00, 100.00),
('Escape Deportivo', 'Sistema de escape deportivo de acero inoxidable', 5, 400.00, 600.00),
('Protector de Tanque', 'Protector adhesivo para el tanque de combustible', 120, 15.00, 25.00),
('Aceite de Cadena', 'Lubricante especial para cadenas de motos', 90, 10.00, 18.00),
('Claxon Eléctrico', 'Claxon eléctrico de alta potencia', 25, 40.00, 70.00),
('Espejos Retrovisores', 'Par de espejos retrovisores ajustables', 60, 30.00, 55.00),
('Cubierta de Llantas', 'Cubiertas protectoras para llantas', 35, 90.00, 130.00),
('Kit de Herramientas Básicas', 'Kit con herramientas esenciales para motos', 40, 50.00, 85.00);

-- Insertar 20 nuevos datos en Productos
INSERT INTO Productos (Nombre_P, Descripcion, Cantidad, Preciodecom, Preciodeven) VALUES
('Bujías NGK', 'Bujías de alto rendimiento', 80, 12.00, 20.00),
('Guantes de Moto', 'Guantes de cuero reforzados', 50, 25.00, 45.00),
('Candado de Disco', 'Candado de seguridad para motos', 30, 35.00, 60.00),
('Cargador USB', 'Cargador USB para motos', 60, 15.00, 30.00),
('Soporte para GPS', 'Soporte universal para dispositivos GPS', 40, 20.00, 35.00),
('Chaleco Reflectivo', 'Chaleco de seguridad reflectivo', 100, 10.00, 18.00),
('Cubre Asiento', 'Cubre asiento impermeable', 70, 18.00, 30.00),
('Bolsa de Tanque', 'Bolsa magnética para tanque', 25, 50.00, 80.00),
('Intercomunicador Bluetooth', 'Sistema de comunicación Bluetooth', 15, 100.00, 150.00),
('Kit de Embrague', 'Kit de embrague reforzado', 20, 80.00, 120.00),
('Luz Trasera LED', 'Luz trasera LED de alta intensidad', 50, 25.00, 40.00),
('Cubre Manos', 'Protectores de manos para motos', 60, 30.00, 50.00),
('Tensor de Cadena', 'Tensor automático para cadenas', 40, 15.00, 25.00),
('Cilindro de Motor', 'Cilindro de repuesto para motos', 10, 200.00, 300.00),
('Radiador de Aceite', 'Radiador para enfriamiento de aceite', 8, 150.00, 220.00),
('Protector de Motor', 'Protector metálico para motor', 30, 60.00, 90.00),
('Asiento Ergonómico', 'Asiento de gel para mayor comodidad', 25, 70.00, 110.00),
('Cubre Radiador', 'Cubierta protectora para radiador', 35, 40.00, 65.00),
('Kit de Limpieza', 'Kit para limpieza y mantenimiento', 90, 20.00, 35.00),
('Portaequipaje Trasero', 'Portaequipaje de acero para motos', 20, 80.00, 120.00);

-- Insertar datos originales en Compras
INSERT INTO Compras (Fecha_compra, ID_Proveedor) VALUES
('2024-03-18', 1),
('2024-03-20', 2),
('2024-03-22', 3),
('2024-03-25', 1),
('2024-03-28', 2),
('2024-03-01', 1),
('2024-03-02', 2),
('2024-03-05', 3);

-- Insertar 20 nuevos datos en Compras
INSERT INTO Compras (Fecha_compra, ID_Proveedor) VALUES
('2024-04-01', 4),
('2024-04-05', 5),
('2024-04-10', 6),
('2024-04-15', 7),
('2024-04-20', 8),
('2024-04-25', 9),
('2024-05-01', 10),
('2024-05-05', 11),
('2024-05-10', 12),
('2024-05-15', 13),
('2024-05-20', 14),
('2024-05-25', 15),
('2024-06-01', 16),
('2024-06-05', 17),
('2024-06-10', 18),
('2024-06-15', 19),
('2024-06-20', 20),
('2024-06-25', 21),
('2024-07-01', 22),
('2024-07-05', 23);

-- Insertar datos originales en Ventas
INSERT INTO Ventas (Fecha_Venta, ID_Cliente) VALUES
('2024-03-18', 1),
('2024-03-20', 2),
('2024-03-22', 3),
('2024-03-26', 1),
('2024-03-30', 2),
('2024-03-10', 1),
('2024-03-12', 2),
('2024-03-15', 3);

-- Insertar 20 nuevos datos en Ventas
INSERT INTO Ventas (Fecha_Venta, ID_Cliente) VALUES
('2024-04-02', 2),
('2024-04-06', 3),
('2024-04-11', 4),
('2024-04-16', 5),
('2024-04-21', 6),
('2024-04-26', 7),
('2024-05-02', 8),
('2024-05-06', 9),
('2024-05-11', 10),
('2024-05-16', 11),
('2024-05-21', 12),
('2024-05-26', 13),
('2024-06-02', 14),
('2024-06-06', 15),
('2024-06-11', 16),
('2024-06-16', 17),
('2024-06-21', 18),
('2024-06-26', 19),
('2024-07-02', 20),
('2024-07-06', 21);

-- Insertar datos originales en Detalle_Compras
INSERT INTO Detalle_Compras (ID_Compra, ID_Producto, Cantidad_com, Precio_Com) VALUES
(1, 1, 20, 45.00),
(2, 2, 50, 30.00),
(3, 3, 15, 100.00);

-- Insertar 20 nuevos datos en Detalle_Compras
INSERT INTO Detalle_Compras (ID_Compra, ID_Producto, Cantidad_com, Precio_Com) VALUES
(9, 4, 10, 2500.00),
(10, 5, 15, 150.00),
(11, 6, 8, 350.00),
(12, 7, 20, 80.00),
(13, 8, 50, 20.00),
(14, 9, 12, 200.00),
(15, 10, 25, 50.00),
(16, 11, 40, 25.00),
(17, 12, 30, 60.00),
(18, 13, 5, 400.00),
(19, 14, 60, 15.00),
(20, 15, 70, 10.00),
(21, 16, 20, 40.00),
(22, 17, 35, 30.00),
(23, 18, 15, 90.00),
(24, 19, 25, 50.00),
(25, 20, 10, 12.00),
(26, 21, 30, 25.00),
(27, 22, 20, 35.00),
(28, 23, 40, 15.00);

-- Insertar datos originales en Detalle_Ventas
INSERT INTO Detalle_Ventas (ID_Venta, ID_Producto, Cantidad_ven, Precio_Ven) VALUES
(1, 1, 5, 70.00),
(2, 2, 10, 50.00),
(3, 3, 2, 150.00);

-- Insertar 20 nuevos datos en Detalle_Ventas
INSERT INTO Detalle_Ventas (ID_Venta, ID_Producto, Cantidad_ven, Precio_Ven) VALUES
(9, 4, 1, 3000.00),
(10, 5, 2, 250.00),
(11, 6, 1, 500.00),
(12, 7, 5, 120.00),
(13, 8, 10, 35.00),
(14, 9, 3, 300.00),
(15, 10, 4, 80.00),
(16, 11, 8, 40.00),
(17, 12, 5, 100.00),
(18, 13, 1, 600.00),
(19, 14, 15, 25.00),
(20, 15, 20, 18.00),
(21, 16, 3, 70.00),
(22, 17, 6, 55.00),
(23, 18, 2, 130.00),
(24, 19, 5, 85.00),
(25, 20, 4, 20.00),
(26, 21, 7, 45.00),
(27, 22, 3, 60.00),
(28, 23, 10, 30.00);

-- Ver todos los datos de la tabla Proveedores
SELECT * FROM Proveedores;

-- Ver todos los datos de la tabla Clientes
SELECT * FROM Clientes;

-- Ver todos los datos de la tabla Productos
SELECT * FROM Productos;

-- Ver todos los datos de la tabla Compras
SELECT * FROM Compras;

-- Ver todos los datos de la tabla Ventas
SELECT * FROM Ventas;

-- Ver todos los datos de la tabla Detalle_Compras
SELECT * FROM Detalle_Compras;

-- Ver todos los datos de la tabla Detalle_Ventas
SELECT * FROM Detalle_Ventas;

-- Consultas intermedias y avanzadas 

CREATE VIEW Productos_Stock AS
SELECT Nombre_P, Cantidad
FROM Productos
WHERE Cantidad > 10;

CREATE VIEW Productos_Bajo_Stock AS
SELECT Nombre_P, Cantidad
FROM Productos
WHERE Cantidad <= 10;

CREATE VIEW Productos_Mas_Vendidos AS
SELECT P.Nombre_P, SUM(DV.Cantidad_ven) AS Total_Vendido
FROM Detalle_Ventas DV
JOIN Productos P ON DV.ID_Producto = P.ID_Producto
GROUP BY P.Nombre_P
ORDER BY Total_Vendido DESC;

CREATE VIEW Gastos_Compras AS
SELECT Co.ID_Compra, Co.Fecha_compra, P.Nombre_Prov,
       SUM(DC.Cantidad_com * DC.Precio_Com) AS Total_Compra
FROM Compras Co
JOIN Proveedores P ON Co.ID_Proveedor = P.ID_Proveedor
JOIN Detalle_Compras DC ON Co.ID_Compra = DC.ID_Compra
GROUP BY Co.ID_Compra, Co.Fecha_compra, P.Nombre_Prov;

CREATE VIEW Productos_No_Vendidos AS
SELECT P.ID_Producto, P.Nombre_P, P.Cantidad
FROM Productos P
LEFT JOIN Detalle_Ventas DV ON P.ID_Producto = DV.ID_Producto
WHERE DV.ID_Producto IS NULL
ORDER BY P.Cantidad DESC;

CREATE VIEW Clientes_Frecuentes AS
SELECT C.ID_Cliente, CONCAT_WS(' ', C.Nombre1, C.Apellidos1) AS Nombre_Completo, 
       COUNT(V.ID_Venta) AS Total_Compras
FROM Clientes C
JOIN Ventas V ON C.ID_Cliente = V.ID_Cliente
GROUP BY C.ID_Cliente, C.Nombre1, C.Apellidos1
ORDER BY Total_Compras DESC;

CREATE VIEW Ventas_Por_Fecha AS
SELECT V.Fecha_Venta, P.Nombre_P AS Producto,
       SUM(DV.Cantidad_ven) AS Total_Cantidad_Vendida,
       SUM(DV.Cantidad_ven * DV.Precio_Ven) AS Total_Venta
FROM Ventas V
JOIN Detalle_Ventas DV ON V.ID_Venta = DV.ID_Venta
JOIN Productos P ON DV.ID_Producto = P.ID_Producto
GROUP BY V.Fecha_Venta, P.Nombre_P
ORDER BY V.Fecha_Venta ASC, Total_Venta DESC;

CREATE VIEW Productos_Rentables AS
SELECT ID_Producto, Nombre_P, Preciodecom, Preciodeven,
       (Preciodeven - Preciodecom) AS Margen_Ganancia
FROM Productos
ORDER BY Margen_Ganancia DESC;

CREATE VIEW Resumen_Inventario AS
SELECT SUM(Cantidad * Preciodecom) AS Total_Invertido,
       SUM(Cantidad * Preciodeven) AS Valor_Potencial_Venta,
       SUM(Cantidad * (Preciodeven - Preciodecom)) AS Ganancia_Potencial
FROM Productos;

CREATE VIEW Ventas_Por_Cliente AS
SELECT C.ID_Cliente, CONCAT_WS(' ', C.Nombre1, C.Nombre2, C.Apellidos1, C.Apellidos2) AS Nombre_Completo,
       COUNT(V.ID_Venta) AS Total_Ventas,
       SUM(DV.Cantidad_ven * DV.Precio_Ven) AS Monto_Total
FROM Clientes C
JOIN Ventas V ON C.ID_Cliente = V.ID_Cliente
JOIN Detalle_Ventas DV ON V.ID_Venta = DV.ID_Venta
GROUP BY C.ID_Cliente, C.Nombre1, C.Nombre2, C.Apellidos1, C.Apellidos2;

CREATE VIEW Proveedores_Mas_Usados AS
SELECT P.ID_Proveedor, P.Nombre_Prov, COUNT(C.ID_Compra) AS Total_Compras
FROM Proveedores P
JOIN Compras C ON P.ID_Proveedor = C.ID_Proveedor
GROUP BY P.ID_Proveedor, P.Nombre_Prov
ORDER BY Total_Compras DESC;

CREATE VIEW Ventas_Por_Mes AS
SELECT DATE_FORMAT(V.Fecha_Venta, '%Y-%m') AS Mes, P.Nombre_P,
       SUM(DV.Cantidad_ven) AS Total_Vendido
FROM Detalle_Ventas DV
JOIN Ventas V ON DV.ID_Venta = DV.ID_Venta
JOIN Productos P ON DV.ID_Producto = P.ID_Producto
GROUP BY DATE_FORMAT(V.Fecha_Venta, '%Y-%m'), P.Nombre_P
ORDER BY Mes, Total_Vendido DESC;


-- Procesos Almacenados

DELIMITER //
CREATE PROCEDURE RegistrarCliente(
    IN p_Nombre1 VARCHAR(60),
    IN p_Nombre2 VARCHAR(60),
    IN p_Apellidos1 VARCHAR(60),
    IN p_Apellidos2 VARCHAR(60),
    IN p_Cedula VARCHAR(60),
    IN p_Telefono VARCHAR(12)
)
BEGIN
    INSERT INTO Clientes (Nombre1, Nombre2, Apellidos1, Apellidos2, Cedula, Telefono)
    VALUES (p_Nombre1, p_Nombre2, p_Apellidos1, p_Apellidos2, p_Cedula, p_Telefono);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE RegistrarProducto(
    IN p_Nombre_P VARCHAR(100),
    IN p_Descripcion VARCHAR(100),
    IN p_Cantidad INT,
    IN p_Preciodecom FLOAT,
    IN p_Preciodeven FLOAT
)
BEGIN
    INSERT INTO Productos (Nombre_P, Descripcion, Cantidad, Preciodecom, Preciodeven)
    VALUES (p_Nombre_P, p_Descripcion, p_Cantidad, p_Preciodecom, p_Preciodeven);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE RegistrarProveedor(
    IN p_Nombre_Prov VARCHAR(100),
    IN p_Contacto VARCHAR(12),
    IN p_Email VARCHAR(100)
)
BEGIN
    INSERT INTO Proveedores (Nombre_Prov, Contacto, Email)
    VALUES (p_Nombre_Prov, p_Contacto, p_Email);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE RegistrarCompra(
    IN p_Fecha DATE,
    IN p_ID_Proveedor INT,
    IN p_ID_Producto INT,
    IN p_Cantidad INT,
    IN p_Precio DOUBLE
)
BEGIN
    DECLARE nueva_compra_id INT;
    INSERT INTO Compras (Fecha_compra, ID_Proveedor)
    VALUES (p_Fecha, p_ID_Proveedor);
    SET nueva_compra_id = LAST_INSERT_ID();
    INSERT INTO Detalle_Compras (ID_Compra, ID_Producto, Cantidad_com, Precio_Com)
    VALUES (nueva_compra_id, p_ID_Producto, p_Cantidad, p_Precio);
    UPDATE Productos
    SET Cantidad = Cantidad + p_Cantidad
    WHERE ID_Producto = p_ID_Producto;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE RegistrarVenta(
    IN p_Fecha DATE,
    IN p_ID_Cliente INT,
    IN p_ID_Producto INT,
    IN p_Cantidad INT,
    IN p_Precio DOUBLE
)
BEGIN
    DECLARE nueva_venta_id INT;
    INSERT INTO Ventas (Fecha_Venta, ID_Cliente)
    VALUES (p_Fecha, p_ID_Cliente);
    SET nueva_venta_id = LAST_INSERT_ID();
    INSERT INTO Detalle_Ventas (ID_Venta, ID_Producto, Cantidad_ven, Precio_Ven)
    VALUES (nueva_venta_id, p_ID_Producto, p_Cantidad, p_Precio);
    UPDATE Productos
    SET Cantidad = Cantidad - p_Cantidad
    WHERE ID_Producto = p_ID_Producto;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE EliminarCliente(
    IN p_ID_Cliente INT
)
BEGIN
    DELETE FROM Clientes
    WHERE ID_Cliente = p_ID_Cliente;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE ActualizarCliente(
    IN p_ID_Cliente INT,
    IN p_Nombre1 VARCHAR(60),
    IN p_Nombre2 VARCHAR(60),
    IN p_Apellidos1 VARCHAR(60),
    IN p_Apellidos2 VARCHAR(60),
    IN p_Cedula VARCHAR(60),
    IN p_Telefono VARCHAR(12)
)
BEGIN
    UPDATE Clientes
    SET Nombre1 = p_Nombre1,
        Nombre2 = p_Nombre2,
        Apellidos1 = p_Apellidos1,
        Apellidos2 = p_Apellidos2,
        Cedula = p_Cedula,
        Telefono = p_Telefono
    WHERE ID_Cliente = p_ID_Cliente;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE ActualizarVenta(
    IN p_ID_Venta INT,
    IN p_NuevaFecha DATE,
    IN p_ID_Cliente INT
)
BEGIN
    UPDATE Ventas
    SET Fecha_Venta = p_NuevaFecha,
        ID_Cliente = p_ID_Cliente
    WHERE ID_Venta = p_ID_Venta;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE ActualizarCompra(
    IN p_ID_Compra INT,
    IN p_NuevaFecha DATE,
    IN p_ID_Proveedor INT
)
BEGIN
    UPDATE Compras
    SET Fecha_Compra = p_NuevaFecha,
        ID_Proveedor = p_ID_Proveedor
    WHERE ID_Compra = p_ID_Compra;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE ActualizarProducto(
    IN p_ID_Producto INT,
    IN p_Nombre_P VARCHAR(100),
    IN p_Descripcion VARCHAR(100),
    IN p_Cantidad INT,
    IN p_Preciodecom DECIMAL(10,2),
    IN p_Preciodeven DECIMAL(10,2)
)
BEGIN
    UPDATE Productos
    SET Nombre_P = p_Nombre_P,
        Descripcion = p_Descripcion,
        Cantidad = p_Cantidad,
        Preciodecom = p_Preciodecom,
        Preciodeven = p_Preciodeven
    WHERE ID_Producto = p_ID_Producto;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE ActualizarProveedor(
    IN p_ID_Proveedor INT,
    IN p_Nombre_Prov VARCHAR(100),
    IN p_Contacto VARCHAR(20),
    IN p_Email VARCHAR(100)
)
BEGIN
    UPDATE Proveedores
    SET Nombre_Prov = p_Nombre_Prov,
        Contacto = p_Contacto,
        Email = p_Email
    WHERE ID_Proveedor = p_ID_Proveedor;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE EliminarVenta(
    IN p_ID_Venta INT
)
BEGIN
    DELETE FROM Detalle_Ventas
    WHERE ID_Venta = p_ID_Venta;
    DELETE FROM Ventas
    WHERE ID_Venta = p_ID_Venta;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE EliminarCompra(
    IN p_ID_Compra INT
)
BEGIN
    DELETE FROM Detalle_Compras
    WHERE ID_Compra = p_ID_Compra;
    DELETE FROM Compras
    WHERE ID_Compra = p_ID_Compra;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE EliminarProducto(
    IN p_ID_Producto INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Detalle_Ventas WHERE ID_Producto = p_ID_Producto)
    AND NOT EXISTS (SELECT 1 FROM Detalle_Compras WHERE ID_Producto = p_ID_Producto) THEN
        DELETE FROM Productos
        WHERE ID_Producto = p_ID_Producto;
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE EliminarProveedor(
    IN p_ID_Proveedor INT
)
BEGIN
    DELETE FROM Detalle_Compras
    WHERE ID_Compra IN (
        SELECT ID_Compra FROM Compras WHERE ID_Proveedor = p_ID_Proveedor
    );
    DELETE FROM Compras
    WHERE ID_Proveedor = p_ID_Proveedor;
    DELETE FROM Proveedores
    WHERE ID_Proveedor = p_ID_Proveedor;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE RegistrarVentaSimple(
    IN p_ID_Cliente INT,
    IN p_Fecha DATE,
    IN p_Total DECIMAL(10,2)
)
BEGIN
    INSERT INTO Ventas (ID_Cliente, Fecha_Venta, Total)
    VALUES (p_ID_Cliente, p_Fecha, p_Total);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE ListarProductosPorProveedor(
    IN p_ID_Proveedor INT
)
BEGIN
    SELECT P.Nombre_P, DC.Cantidad_com, DC.Precio_Com, C.Fecha_compra
    FROM Detalle_Compras DC
    JOIN Compras C ON DC.ID_Compra = C.ID_Compra
    JOIN Productos P ON DC.ID_Producto = P.ID_Producto
    WHERE C.ID_Proveedor = p_ID_Proveedor;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE BuscarProductoPorNombre(
    IN p_Nombre VARCHAR(100)
)
BEGIN
    SELECT *
    FROM Productos
    WHERE Nombre_P LIKE CONCAT('%', p_Nombre, '%');
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE VerHistorialVentasCliente(
    IN p_ID_Cliente INT
)
BEGIN
    SELECT V.ID_Venta, V.Fecha_Venta, P.Nombre_P, DV.Cantidad_ven, DV.Precio_Ven
    FROM Ventas V
    JOIN Detalle_Ventas DV ON V.ID_Venta = DV.ID_Venta
    JOIN Productos P ON DV.ID_Producto = P.ID_Producto
    WHERE V.ID_Cliente = p_ID_Cliente
    ORDER BY V.Fecha_Venta DESC;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE ActualizarStockProducto(
    IN p_ID_Producto INT,
    IN p_NuevaCantidad INT
)
BEGIN
    UPDATE Productos
    SET Cantidad = p_NuevaCantidad
    WHERE ID_Producto = p_ID_Producto;
END //
DELIMITER ;

-- Funciones 

DELIMITER //
CREATE FUNCTION ObtenerNombreCompletoCliente(p_ID_Cliente INT)
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    DECLARE nombre_completo VARCHAR(255);
    SELECT CONCAT_WS(' ', Nombre1, Nombre2, Apellidos1, Apellidos2)
    INTO nombre_completo
    FROM Clientes
    WHERE ID_Cliente = p_ID_Cliente;
    RETURN nombre_completo;
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION TotalVentasProducto(p_ID_Producto INT)
RETURNS FLOAT
DETERMINISTIC
BEGIN
    DECLARE total FLOAT;
    SELECT IFNULL(SUM(Cantidad_ven * Precio_Ven), 0)
    INTO total
    FROM Detalle_Ventas
    WHERE ID_Producto = p_ID_Producto;
    RETURN total;
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION TotalComprasProducto(p_ID_Producto INT)
RETURNS FLOAT
DETERMINISTIC
BEGIN
    DECLARE total FLOAT;
    SELECT IFNULL(SUM(Cantidad_com * Precio_Com), 0)
    INTO total
    FROM Detalle_Compras
    WHERE ID_Producto = p_ID_Producto;
    RETURN total;
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION StockProducto(p_ID_Producto INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE stock INT;
    SELECT Cantidad
    INTO stock
    FROM Productos
    WHERE ID_Producto = p_ID_Producto;
    RETURN stock;
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION ClienteActivo(p_ID_Cliente INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE existe INT;
    SELECT COUNT(*) INTO existe
    FROM Ventas
    WHERE ID_Cliente = p_ID_Cliente;
    RETURN existe > 0;
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION TotalStockGlobal()
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT IFNULL(SUM(Cantidad), 0) INTO total
    FROM Productos;
    RETURN total;
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION PromedioPrecioVenta()
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(10,2);
    SELECT IFNULL(AVG(Preciodeven), 0) INTO promedio
    FROM Productos;
    RETURN promedio;
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION DiasDesdeUltimaCompra(p_ID_Proveedor INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE fecha_ultima DATE;
    DECLARE dias INT;
    SELECT MAX(Fecha_compra) INTO fecha_ultima
    FROM Compras
    WHERE ID_Proveedor = p_ID_Proveedor;
    IF fecha_ultima IS NULL THEN
        RETURN NULL;
    END IF;
    SET dias = DATEDIFF(CURDATE(), fecha_ultima);
    RETURN dias;
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION TotalComprasCliente(p_ID_Cliente INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT IFNULL(COUNT(*), 0) INTO total
    FROM Ventas
    WHERE ID_Cliente = p_ID_Cliente;
    RETURN total;
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION TotalVentasEnFecha(p_Fecha DATE)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    DECLARE monto DECIMAL(12,2);
    SELECT IFNULL(SUM(DV.Cantidad_ven * DV.Precio_Ven), 0) INTO monto
    FROM Ventas V
    JOIN Detalle_Ventas DV ON V.ID_Venta = DV.ID_Venta
    WHERE V.Fecha_Venta = p_Fecha;
    RETURN monto;
END //
DELIMITER ;

-- Llamados

CALL RegistrarCliente('Juan', 'Carlos', 'Pérez', 'Gómez', '123456789', '3216549870');
CALL RegistrarProducto('Aceite de Motor', 'Aceite sintético 10W-40', 100, 25.00, 40.00);
CALL RegistrarProveedor('MotoRepuestos S.A.', '3001234567', 'ventas@motorepuestos.com');
CALL RegistrarCompra('2025-04-28', 1, 2, 50, 30.00);
CALL RegistrarVenta('2025-04-28', 2, 3, 5, 50.00);
CALL EliminarCliente(22);
CALL ActualizarCliente(1, 'Luis', 'Fernando', 'Martínez', 'Ramírez', '987654321', '3106549870');
CALL ListarProductosPorProveedor(1);
CALL BuscarProductoPorNombre('Cadena');
CALL VerHistorialVentasCliente(3);
CALL ActualizarStockProducto(10, 50);
CALL EliminarProducto(8);

SELECT TotalStockGlobal();
SELECT PromedioPrecioVenta();
SELECT DiasDesdeUltimaCompra(2);
SELECT TotalComprasCliente(1);
SELECT TotalVentasEnFecha('2024-03-20');





