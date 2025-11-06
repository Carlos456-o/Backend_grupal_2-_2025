
DROP DATABASE IF EXISTS Moto_Repuesto;
CREATE DATABASE IF NOT EXISTS Moto_Repuesto;
USE Moto_Repuesto;

-- ======================================
-- TABLAS
-- ======================================

CREATE TABLE Clientes(
    ID_Cliente INT AUTO_INCREMENT PRIMARY KEY,
    Nombre1 VARCHAR(35) NOT NULL,   
    Nombre2 VARCHAR(35),
    Apellidos1 VARCHAR(35) NOT NULL,
    Apellidos2 VARCHAR(35),
    Cedula VARCHAR(18),
    Telefono VARCHAR(12)
);

CREATE TABLE Proveedores(
    ID_Proveedor INT AUTO_INCREMENT PRIMARY KEY,
    Nombre_Prov VARCHAR(100) NOT NULL,
    Contacto VARCHAR(20) NOT NULL,
    Email VARCHAR(100) NOT NULL
);

CREATE TABLE Productos (
    ID_Producto INT AUTO_INCREMENT PRIMARY KEY,
    Nombre_P VARCHAR(100) NOT NULL,
    Descripcion VARCHAR(200),
    Cantidad INT NOT NULL DEFAULT 0,               -- cantidad real en inventario
    Disponible BOOLEAN NOT NULL DEFAULT TRUE, -- true=disponible, false=no disponible
    PrecioCompra DECIMAL(10,2) NOT NULL,
    PrecioVenta DECIMAL(10,2) NOT NULL
);

CREATE TABLE Compras (
    ID_Compra INT AUTO_INCREMENT PRIMARY KEY,
    Fecha_compra DATE NOT NULL,
    Cantidad INT DEFAULT NULL,
    ID_Proveedor INT,
    FOREIGN KEY (ID_Proveedor) REFERENCES Proveedores (ID_Proveedor) ON DELETE SET NULL
);

CREATE TABLE Ventas (
    ID_Venta INT AUTO_INCREMENT PRIMARY KEY,
    Fecha_Venta DATE NOT NULL,
    ID_Cliente INT,
    FOREIGN KEY (ID_Cliente) REFERENCES Clientes (ID_Cliente) ON DELETE SET NULL
);

CREATE TABLE Detalle_Ventas(
    ID_Detalle_ven INT AUTO_INCREMENT PRIMARY KEY,
    ID_Venta INT NOT NULL,
    ID_Producto INT NOT NULL,
    Cantidad_ven INT NOT NULL,
    Precio_Ven DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (ID_Venta) REFERENCES Ventas (ID_Venta) ON DELETE CASCADE,
    FOREIGN KEY (ID_Producto) REFERENCES Productos (ID_Producto) ON DELETE RESTRICT
);

CREATE TABLE Detalle_Compras(
    ID_Detalles_Com INT AUTO_INCREMENT PRIMARY KEY,
    ID_Compra INT NOT NULL,
    ID_Producto INT NOT NULL,
    Cantidad_com INT NOT NULL,
    Precio_Com DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (ID_Producto) REFERENCES Productos (ID_Producto) ON DELETE RESTRICT,
    FOREIGN KEY (ID_Compra) REFERENCES Compras (ID_Compra) ON DELETE CASCADE
);

-- ======================================
-- TABLA DE BITÁCORA
-- ======================================
CREATE TABLE Bitacora (
    ID_Bitacora INT AUTO_INCREMENT PRIMARY KEY,
    Tabla VARCHAR(50) NOT NULL,
    Operacion VARCHAR(20) NOT NULL,
    Usuario VARCHAR(100) NOT NULL,
    Fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    Detalle TEXT
);

-- Tabla Usuarios: almacena credenciales de acceso
CREATE TABLE Usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    usuario VARCHAR(50),
    contraseña VARCHAR(100),
    rol ENUM('Adm','Empleado','Cliente') DEFAULT 'Empleado'
);

-- ======================================
-- TRIGGERS DE BITÁCORA (INSERT/UPDATE/DELETE) CORREGIDOS
-- ======================================

DELIMITER //

-- CLIENTES
CREATE TRIGGER trg_clientes_insert
AFTER INSERT ON Clientes
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (Tabla, Operacion, Usuario, Detalle)
    VALUES ('Clientes', 'INSERT', USER(),
            CONCAT('Se agregó el cliente: ', NEW.Nombre1, ' ', COALESCE(NEW.Apellidos1,'')));
END;
//

CREATE TRIGGER trg_clientes_update
AFTER UPDATE ON Clientes
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (Tabla, Operacion, Usuario, Detalle)
    VALUES ('Clientes', 'UPDATE', USER(),
            CONCAT('Se actualizó el cliente ID ', NEW.ID_Cliente, ': ', NEW.Nombre1, ' ', COALESCE(NEW.Apellidos1,'')));
END;
//

CREATE TRIGGER trg_clientes_delete
AFTER DELETE ON Clientes
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (Tabla, Operacion, Usuario, Detalle)
    VALUES ('Clientes', 'DELETE', USER(),
            CONCAT('Se eliminó el cliente ID ', OLD.ID_Cliente, ': ', OLD.Nombre1, ' ', COALESCE(OLD.Apellidos1,'')));
END;
//

-- PRODUCTOS
CREATE TRIGGER trg_productos_insert
AFTER INSERT ON Productos
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (Tabla, Operacion, Usuario, Detalle)
    VALUES ('Productos', 'INSERT', USER(),
            CONCAT('Se agregó el producto: ', NEW.Nombre_P, ' (ID ', NEW.ID_Producto, ')'));
END;
//

CREATE TRIGGER trg_productos_update
AFTER UPDATE ON Productos
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (Tabla, Operacion, Usuario, Detalle)
    VALUES ('Productos', 'UPDATE', USER(),
            CONCAT('Se actualizó el producto ID ', NEW.ID_Producto, ': ', NEW.Nombre_P));
END;
//

CREATE TRIGGER trg_productos_delete
AFTER DELETE ON Productos
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (Tabla, Operacion, Usuario, Detalle)
    VALUES ('Productos', 'DELETE', USER(),
            CONCAT('Se eliminó el producto ID ', OLD.ID_Producto, ': ', OLD.Nombre_P));
END;
//

-- PROVEEDORES
CREATE TRIGGER trg_proveedores_insert
AFTER INSERT ON Proveedores
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (Tabla, Operacion, Usuario, Detalle)
    VALUES ('Proveedores', 'INSERT', USER(),
            CONCAT('Se agregó el proveedor: ', NEW.Nombre_Prov));
END;
//

CREATE TRIGGER trg_proveedores_update
AFTER UPDATE ON Proveedores
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (Tabla, Operacion, Usuario, Detalle)
    VALUES ('Proveedores', 'UPDATE', USER(),
            CONCAT('Se actualizó el proveedor ID ', NEW.ID_Proveedor, ': ', NEW.Nombre_Prov));
END;
//

CREATE TRIGGER trg_proveedores_delete
AFTER DELETE ON Proveedores
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (Tabla, Operacion, Usuario, Detalle)
    VALUES ('Proveedores', 'DELETE', USER(),
            CONCAT('Se eliminó el proveedor ID ', OLD.ID_Proveedor, ': ', OLD.Nombre_Prov));
END;
//

-- COMPRAS
CREATE TRIGGER trg_compras_insert
AFTER INSERT ON Compras
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (Tabla, Operacion, Usuario, Detalle)
    VALUES ('Compras', 'INSERT', USER(),
            CONCAT('Se registró la compra ID: ', NEW.ID_Compra, ' proveedor ID: ', NEW.ID_Proveedor));
END;
//

CREATE TRIGGER trg_compras_update
AFTER UPDATE ON Compras
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (Tabla, Operacion, Usuario, Detalle)
    VALUES ('Compras', 'UPDATE', USER(),
            CONCAT('Se actualizó la compra ID: ', NEW.ID_Compra));
END;
//

CREATE TRIGGER trg_compras_delete
AFTER DELETE ON Compras
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (Tabla, Operacion, Usuario, Detalle)
    VALUES ('Compras', 'DELETE', USER(),
            CONCAT('Se eliminó la compra ID: ', OLD.ID_Compra));
END;
//

-- VENTAS
CREATE TRIGGER trg_ventas_insert
AFTER INSERT ON Ventas
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (Tabla, Operacion,Usuario, Detalle)
    VALUES ('Ventas', 'INSERT', USER(),
            CONCAT('Se registró la venta ID: ', NEW.ID_Venta, ' cliente ID: ', NEW.ID_Cliente));
END;
//

CREATE TRIGGER trg_ventas_update
AFTER UPDATE ON Ventas
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (Tabla, Operacion, Usuario, Detalle)
    VALUES ('Ventas', 'UPDATE', USER(),
            CONCAT('Se actualizó la venta ID: ', NEW.ID_Venta));
END;
//

CREATE TRIGGER trg_ventas_delete
AFTER DELETE ON Ventas
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (Tabla, Operacion, Usuario, Detalle)
    VALUES ('Ventas', 'DELETE', USER(),
            CONCAT('Se eliminó la venta ID: ', OLD.ID_Venta));
END;
//

-- DETALLE_COMPRAS: al insertar suma stock y registra bitácora
CREATE TRIGGER trg_detalle_compras_insert
AFTER INSERT ON Detalle_Compras
FOR EACH ROW
BEGIN
    UPDATE Productos
    SET Cantidad = Cantidad + NEW.Cantidad_com,
        Disponible = (Cantidad + NEW.Cantidad_com) > 0
    WHERE ID_Producto = NEW.ID_Producto;
    INSERT INTO Bitacora (Tabla, Operacion, Usuario, Detalle)
    VALUES ('Detalle_Compras', 'INSERT', USER(),
            CONCAT('Se agregó producto ID ', NEW.ID_Producto, ' a la compra ID ', NEW.ID_Compra, ' (+', NEW.Cantidad_com, ')'));
END;
//

CREATE TRIGGER trg_detalle_compras_update
AFTER UPDATE ON Detalle_Compras
FOR EACH ROW
BEGIN
    -- Ajusta el stock según diferencia (nuevo - viejo)
    DECLARE diff INT;
    SET diff = NEW.Cantidad_com - OLD.Cantidad_com;
    UPDATE Productos
    SET Cantidad = Cantidad + diff,
        Disponible = (Cantidad + diff) > 0
    WHERE ID_Producto = NEW.ID_Producto;
    INSERT INTO Bitacora (Tabla, Operacion, Usuario, Detalle)
    VALUES ('Detalle_Compras', 'UPDATE', USER(),
            CONCAT('Se actualizó detalle compra ID ', NEW.ID_Detalles_Com, ', diff: ', diff));
END;
//

CREATE TRIGGER trg_detalle_compras_delete
AFTER DELETE ON Detalle_Compras
FOR EACH ROW
BEGIN
    -- Al eliminar un detalle de compra, restar lo agregado anteriormente
    UPDATE Productos
    SET Cantidad = Cantidad - OLD.Cantidad_com,
        Disponible = (Cantidad - OLD.Cantidad_com) > 0
    WHERE ID_Producto = OLD.ID_Producto;
    INSERT INTO Bitacora (Tabla, Operacion, Usuario, Detalle)
    VALUES ('Detalle_Compras', 'DELETE', USER(),
            CONCAT('Se eliminó detalle compra ID ', OLD.ID_Detalles_Com, ', producto ID ', OLD.ID_Producto));
END;
//

-- DETALLE_VENTAS: al insertar resta stock y registra bitácora
CREATE TRIGGER trg_detalle_ventas_insert
BEFORE INSERT ON Detalle_Ventas
FOR EACH ROW
BEGIN
    -- Validar stock suficiente
    DECLARE stock_actual INT;
    SELECT Cantidad INTO stock_actual FROM Productos WHERE ID_Producto = NEW.ID_Producto FOR UPDATE;
    IF stock_actual IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Producto no existe';
    ELSEIF stock_actual < NEW.Cantidad_ven THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuficiente para la venta';
    ELSE
        UPDATE Productos
        SET Cantidad = Cantidad - NEW.Cantidad_ven,
            Disponible = (Cantidad - NEW.Cantidad_ven) > 0
        WHERE ID_Producto = NEW.ID_Producto;
        -- no insertamos en bitacora aquí porque AFTER INSERT lo hará
    END IF;
END;
//

CREATE TRIGGER trg_detalle_ventas_after_insert
AFTER INSERT ON Detalle_Ventas
FOR EACH ROW
BEGIN
    INSERT INTO Bitacora (Tabla, Operacion, Usuario, Detalle)
    VALUES ('Detalle_Ventas', 'INSERT', USER(),
            CONCAT('Se vendió producto ID ', NEW.ID_Producto, ' en venta ID ', NEW.ID_Venta, ' (-', NEW.Cantidad_ven, ')'));
END;
//

CREATE TRIGGER trg_detalle_ventas_update
AFTER UPDATE ON Detalle_Ventas
FOR EACH ROW
BEGIN
    -- Ajuste simple: registrar cambio y no tocar cantidad automáticamente para evitar inconsistencias.
    INSERT INTO Bitacora (Tabla, Operacion, Usuario, Detalle)
    VALUES ('Detalle_Ventas', 'UPDATE', USER(),
            CONCAT('Se actualizó detalle venta ID ', NEW.ID_Detalle_ven, ' producto ID ', NEW.ID_Producto));
END;
//

CREATE TRIGGER trg_detalle_ventas_delete
AFTER DELETE ON Detalle_Ventas
FOR EACH ROW
BEGIN
    -- Al eliminar detalle de venta se debe devolver el stock
    UPDATE Productos
    SET Cantidad = Cantidad + OLD.Cantidad_ven,
        Disponible = (Cantidad + OLD.Cantidad_ven) > 0
    WHERE ID_Producto = OLD.ID_Producto;
    INSERT INTO Bitacora (Tabla, Operacion, Usuario, Detalle)
    VALUES ('Detalle_Ventas', 'DELETE', USER(),
            CONCAT('Se eliminó detalle venta ID ', OLD.ID_Detalle_ven, ' producto ID ', OLD.ID_Producto, ' (+', OLD.Cantidad_ven, ')'));
END;
//

DELIMITER ;

DELIMITER //

CREATE TRIGGER trg_actualizar_inventario
AFTER INSERT ON Detalle_Ventas
FOR EACH ROW
BEGIN

UPDATE Productos
SET Cantidad = Cantidad NEW.Cantidad_ven
WHERE ID_Producto = NEW.ID_Producto;

UPDATE Productos
SET Disponible = FALSE
WHERE ID_Producto = NEW.ID_Producto AND Cantidad <= 0;
END;
DELIMITER //

DELIMITER //

CREATE TRIGGER trg_validar_stock
BEFORE INSERT ON Detalle_Ventas
FOR EACH ROW
BEGIN
DECLARE stock_actual INT;


SELECT Cantidad INTO stock_actual
FROM Productos
WHERE ID_Producto = NEW.ID_Producto;

IF stock_actual < NEW.Cantidad_ven THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Error: Stock insuficiente para realizar la venta.';
END IF;
END;

DELIMITER ;

-- ======================================
-- VISTAS
-- ======================================

CREATE OR REPLACE VIEW Productos_Stock AS
SELECT Nombre_P, Cantidad
FROM Productos
WHERE Cantidad > 10;

CREATE OR REPLACE VIEW Productos_Bajo_Stock AS
SELECT Nombre_P, Cantidad
FROM Productos
WHERE Cantidad <= 10;

CREATE OR REPLACE VIEW Productos_Mas_Vendidos AS
SELECT P.Nombre_P, SUM(DV.Cantidad_ven) AS Total_Vendido
FROM Detalle_Ventas DV
JOIN Productos P ON DV.ID_Producto = P.ID_Producto
GROUP BY P.Nombre_P
ORDER BY Total_Vendido DESC;

CREATE OR REPLACE VIEW Gastos_Compras AS
SELECT Co.ID_Compra, Co.Fecha_compra, P.Nombre_Prov,
       SUM(DC.Cantidad_com * DC.Precio_Com) AS Total_Compra
FROM Compras Co
LEFT JOIN Proveedores P ON Co.ID_Proveedor = P.ID_Proveedor
LEFT JOIN Detalle_Compras DC ON Co.ID_Compra = DC.ID_Compra
GROUP BY Co.ID_Compra, Co.Fecha_compra, P.Nombre_Prov;

CREATE OR REPLACE VIEW Productos_No_Vendidos AS
SELECT P.ID_Producto, P.Nombre_P, P.Cantidad
FROM Productos P
LEFT JOIN Detalle_Ventas DV ON P.ID_Producto = DV.ID_Producto
WHERE DV.ID_Producto IS NULL
ORDER BY P.Cantidad DESC;

CREATE OR REPLACE VIEW Clientes_Frecuentes AS
SELECT C.ID_Cliente, CONCAT_WS(' ', C.Nombre1, C.Apellidos1) AS Nombre_Completo, 
       COUNT(V.ID_Venta) AS Total_Compras
FROM Clientes C
LEFT JOIN Ventas V ON C.ID_Cliente = V.ID_Cliente
GROUP BY C.ID_Cliente, C.Nombre1, C.Apellidos1
ORDER BY Total_Compras DESC;

CREATE OR REPLACE VIEW Ventas_Por_Fecha AS
SELECT V.Fecha_Venta, P.Nombre_P AS Producto,
       SUM(DV.Cantidad_ven) AS Total_Cantidad_Vendida,
       SUM(DV.Cantidad_ven * DV.Precio_Ven) AS Total_Venta
FROM Ventas V
JOIN Detalle_Ventas DV ON V.ID_Venta = DV.ID_Venta
JOIN Productos P ON DV.ID_Producto = P.ID_Producto
GROUP BY V.Fecha_Venta, P.Nombre_P
ORDER BY V.Fecha_Venta ASC, Total_Venta DESC;

CREATE OR REPLACE VIEW Productos_Rentables AS
SELECT ID_Producto, Nombre_P, PrecioCompra, PrecioVenta,
       (PrecioVenta - PrecioCompra) AS Margen_Ganancia
FROM Productos
ORDER BY Margen_Ganancia DESC;

CREATE OR REPLACE VIEW Resumen_Inventario AS
SELECT IFNULL(SUM(Cantidad * PrecioCompra),0) AS Total_Invertido,
       IFNULL(SUM(Cantidad * PrecioVenta),0) AS Valor_Potencial_Venta,
       IFNULL(SUM(Cantidad * (PrecioVenta - PrecioCompra)),0) AS Ganancia_Potencial
FROM Productos;

CREATE OR REPLACE VIEW Ventas_Por_Cliente AS
SELECT C.ID_Cliente, CONCAT_WS(' ', C.Nombre1, C.Nombre2, C.Apellidos1, C.Apellidos2) AS Nombre_Completo,
       COUNT(V.ID_Venta) AS Total_Ventas,
       IFNULL(SUM(DV.Cantidad_ven * DV.Precio_Ven),0) AS Monto_Total
FROM Clientes C
LEFT JOIN Ventas V ON C.ID_Cliente = V.ID_Cliente
LEFT JOIN Detalle_Ventas DV ON V.ID_Venta = DV.ID_Venta
GROUP BY C.ID_Cliente, C.Nombre1, C.Nombre2, C.Apellidos1, C.Apellidos2;

CREATE OR REPLACE VIEW Proveedores_Mas_Usados AS
SELECT P.ID_Proveedor, P.Nombre_Prov, COUNT(C.ID_Compra) AS Total_Compras
FROM Proveedores P
LEFT JOIN Compras C ON P.ID_Proveedor = C.ID_Proveedor
GROUP BY P.ID_Proveedor, P.Nombre_Prov
ORDER BY Total_Compras DESC;

CREATE OR REPLACE VIEW Ventas_Por_Mes AS
SELECT DATE_FORMAT(V.Fecha_Venta, '%Y-%m') AS Mes, P.Nombre_P,
       SUM(DV.Cantidad_ven) AS Total_Vendido
FROM Detalle_Ventas DV
JOIN Ventas V ON DV.ID_Venta = V.ID_Venta
JOIN Productos P ON DV.ID_Producto = P.ID_Producto
GROUP BY DATE_FORMAT(V.Fecha_Venta, '%Y-%m'), P.Nombre_P
ORDER BY Mes, Total_Vendido DESC;

-- ======================================
-- PROCEDIMIENTOS ALMACENADOS (corregidos)
-- ======================================

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


CREATE PROCEDURE RegistrarProducto(
    IN p_Nombre_P VARCHAR(100),
    IN p_Descripcion VARCHAR(200),
    IN p_Cantidad INT,
    IN p_PrecioCompra DECIMAL(10,2),
    IN p_PrecioVenta DECIMAL(10,2)
)
BEGIN
    INSERT INTO Productos (Nombre_P, Descripcion, Cantidad, PrecioCompra, PrecioVenta)
    VALUES (p_Nombre_P, p_Descripcion, p_Cantidad, p_PrecioCompra, p_PrecioVenta);
END //


CREATE PROCEDURE RegistrarProveedor(
    IN p_Nombre_Prov VARCHAR(100),
    IN p_Contacto VARCHAR(20),
    IN p_Email VARCHAR(100)
)
BEGIN
    INSERT INTO Proveedores (Nombre_Prov, Contacto, Email)
    VALUES (p_Nombre_Prov, p_Contacto, p_Email);
END //


CREATE PROCEDURE RegistrarCompra(
    IN p_Fecha DATE,
    IN p_ID_Proveedor INT,
    IN p_ID_Producto INT,
    IN p_Cantidad INT,
    IN p_Precio DECIMAL(10,2)
)
BEGIN
    DECLARE nueva_compra_id INT;
    INSERT INTO Compras (Fecha_compra, ID_Proveedor)
    VALUES (p_Fecha, p_ID_Proveedor);
    SET nueva_compra_id = LAST_INSERT_ID();
    INSERT INTO Detalle_Compras (ID_Compra, ID_Producto, Cantidad_com, Precio_Com)
    VALUES (nueva_compra_id, p_ID_Producto, p_Cantidad, p_Precio);
    UPDATE Productos
    SET Cantidad = Cantidad + p_Cantidad,
        Disponible = (Cantidad + p_Cantidad) > 0
    WHERE ID_Producto = p_ID_Producto;
END //


CREATE PROCEDURE EliminarCliente(
    IN p_ID_Cliente INT
)
BEGIN
    DELETE FROM Clientes
    WHERE ID_Cliente = p_ID_Cliente;
END //


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


CREATE PROCEDURE ActualizarCompra(
    IN p_ID_Compra INT,
    IN p_NuevaFecha DATE,
    IN p_ID_Proveedor INT
)
BEGIN
    UPDATE Compras
    SET Fecha_compra = p_NuevaFecha,
        ID_Proveedor = p_ID_Proveedor
    WHERE ID_Compra = p_ID_Compra;
END //


CREATE PROCEDURE ActualizarProducto(
    IN p_ID_Producto INT,
    IN p_Nombre_P VARCHAR(100),
    IN p_Descripcion VARCHAR(200),
    IN p_Cantidad INT,
    IN p_PrecioCompra DECIMAL(10,2),
    IN p_PrecioVenta DECIMAL(10,2)
)
BEGIN
    UPDATE Productos
    SET Nombre_P = p_Nombre_P,
        Descripcion = p_Descripcion,
        Cantidad = p_Cantidad,
        PrecioCompra = p_PrecioCompra,
        PrecioVenta = p_PrecioVenta
    WHERE ID_Producto = p_ID_Producto;
END //


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


CREATE PROCEDURE EliminarVenta(
    IN p_ID_Venta INT
)
BEGIN
    DELETE FROM Detalle_Ventas
    WHERE ID_Venta = p_ID_Venta;
    DELETE FROM Ventas
    WHERE ID_Venta = p_ID_Venta;
END //


CREATE PROCEDURE EliminarCompra(
    IN p_ID_Compra INT
)
BEGIN
    DELETE FROM Detalle_Compras
    WHERE ID_Compra = p_ID_Compra;
    DELETE FROM Compras
    WHERE ID_Compra = p_ID_Compra;
END //


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


CREATE PROCEDURE RegistrarVentaSimple(
    IN p_ID_Cliente INT,
    IN p_Fecha DATE,
    IN p_Total DECIMAL(10,2)
)
BEGIN
    -- Nota: Ventas simple asume que existe columna Total en Ventas; si no existe, omitir o ajustar
    -- Vamos a crear la columna Total si no existe (seguimos con enfoque completo)
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='Ventas' AND COLUMN_NAME='Total') THEN
        ALTER TABLE Ventas ADD COLUMN Total DECIMAL(12,2) DEFAULT 0;
    END IF;
    INSERT INTO Ventas (ID_Cliente, Fecha_Venta, Total)
    VALUES (p_ID_Cliente, p_Fecha, p_Total);
END //


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


CREATE PROCEDURE BuscarProductoPorNombre(
    IN p_Nombre VARCHAR(100)
)
BEGIN
    SELECT *
    FROM Productos
    WHERE Nombre_P LIKE CONCAT('%', p_Nombre, '%');
END //


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


CREATE PROCEDURE ActualizarStockProducto(
    IN p_ID_Producto INT,
    IN p_NuevaCantidad INT
)
BEGIN
    UPDATE Productos
    SET Cantidad = p_NuevaCantidad,
        Disponible = p_NuevaCantidad > 0
    WHERE ID_Producto = p_ID_Producto;
END //

DELIMITER ;

-- ======================================
-- FUNCIONES (corregidas)
-- ======================================
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


CREATE FUNCTION TotalVentasProducto(p_ID_Producto INT)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(12,2);
    SELECT IFNULL(SUM(Cantidad_ven * Precio_Ven), 0)
    INTO total
    FROM Detalle_Ventas
    WHERE ID_Producto = p_ID_Producto;
    RETURN total;
END //


CREATE FUNCTION TotalComprasProducto(p_ID_Producto INT)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(12,2);
    SELECT IFNULL(SUM(Cantidad_com * Precio_Com), 0)
    INTO total
    FROM Detalle_Compras
    WHERE ID_Producto = p_ID_Producto;
    RETURN total;
END //


CREATE FUNCTION StockProducto(p_ID_Producto INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE stock INT;
    SELECT Cantidad
    INTO stock
    FROM Productos
    WHERE ID_Producto = p_ID_Producto;
    RETURN IFNULL(stock,0);
END //


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


CREATE FUNCTION TotalStockGlobal()
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT IFNULL(SUM(Cantidad), 0) INTO total
    FROM Productos;
    RETURN total;
END //


CREATE FUNCTION PromedioPrecioVenta()
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(10,2);
    SELECT IFNULL(AVG(PrecioVenta), 0) INTO promedio
    FROM Productos;
    RETURN promedio;
END //


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

-- ======================================
-- ROLES, USUARIOS Y PRIVILEGIOS (opcional, puede requerir privilegios de root)
-- ======================================
-- Nota: los siguientes comandos pueden fallar si el servidor no permite crear roles/usuarios desde este script.
-- Si ocurre un error, ejecutarlos manualmente como usuario con privilegios suficientes.

-- Crear roles
CREATE ROLE IF NOT EXISTS 'Admin', 'Empleado', 'Cliente';

-- Crear usuarios y asignar roles (ejemplo)
CREATE USER IF NOT EXISTS 'admin_moto'@'localhost' IDENTIFIED BY 'Admin123';
CREATE USER IF NOT EXISTS 'empleado_moto'@'localhost' IDENTIFIED BY 'Empleado123';
CREATE USER IF NOT EXISTS 'cliente_moto'@'localhost' IDENTIFIED BY 'Cliente123';

GRANT 'Admin' TO 'admin_moto'@'localhost';
GRANT 'Empleado' TO 'empleado_moto'@'localhost';
GRANT 'Cliente' TO 'cliente_moto'@'localhost';

SET DEFAULT ROLE 'Admin' TO 'admin_moto'@'localhost';
SET DEFAULT ROLE 'Empleado' TO 'empleado_moto'@'localhost';
SET DEFAULT ROLE 'Cliente' TO 'cliente_moto'@'localhost';

-- Asignar privilegios ejemplo (ajustar según necesidad)
GRANT ALL PRIVILEGES ON Moto_Repuesto.* TO 'admin_moto'@'localhost' WITH GRANT OPTION;
GRANT SELECT, INSERT, UPDATE, DELETE ON Moto_Repuesto.Ventas TO 'empleado_moto'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON Moto_Repuesto.Detalle_Ventas TO 'empleado_moto'@'localhost';
GRANT SELECT ON Moto_Repuesto.Productos TO 'empleado_moto'@'localhost';
GRANT SELECT ON Moto_Repuesto.Clientes TO 'empleado_moto'@'localhost';
GRANT SELECT ON Moto_Repuesto.Productos TO 'cliente_moto'@'localhost';

FLUSH PRIVILEGES;

-- ======================================
-- DATOS: INSERCIONES (Se corrigieron nombres de columnas y se mantienen los datos originales)
-- ======================================

-- Usuarios
INSERT INTO Usuarios (usuario, contraseña, rol) VALUES
('eli', 'eli2025', 'Adm'),
('javier51', '123456', 'Empleado'),
('cruz51', '20252025', 'Empleado');

-- Proveedores (original + 20)
INSERT INTO Proveedores (Nombre_Prov, Contacto, Email) VALUES
('Repuestos Rápidos', '1234567890', 'contacto@repuestosrapidos.com'),
('MotoPartes S.A.', '0987654321', 'ventas@motopartes.com'),
('Speed Moto', '1122334455', 'info@speedmoto.com'),
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

-- Clientes (original + 20)
INSERT INTO Clientes (Nombre1, Nombre2, Apellidos1, Apellidos2, Cedula, Telefono) VALUES
('Juan', 'Edgardo', 'Pérez', 'López', '123456789', '3216549870'),
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

-- Productos (original + 20) CORREGIDO: columnas PrecioCompra, PrecioVenta
INSERT INTO Productos (Nombre_P, Descripcion, Cantidad, PrecioCompra, PrecioVenta) VALUES
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
('Kit de Herramientas Básicas', 'Kit con herramientas esenciales para motos', 40, 50.00, 85.00),
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

-- Compras (original + 20)
INSERT INTO Compras (Fecha_compra, ID_Proveedor) VALUES
('2024-03-18', 1),
('2024-03-20', 2),
('2024-03-22', 3),
('2024-03-25', 1),
('2024-03-28', 2),
('2024-03-01', 1),
('2024-03-02', 2),
('2024-03-05', 3),
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

-- Ventas (original + 20)
INSERT INTO Ventas (Fecha_Venta, ID_Cliente) VALUES
('2024-03-18', 1),
('2024-03-20', 2),
('2024-03-22', 3),
('2024-03-26', 1),
('2024-03-30', 2),
('2024-03-10', 1),
('2024-03-12', 2),
('2024-03-15', 3),
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

-- Detalle_Compras (original + 20)
INSERT INTO Detalle_Compras (ID_Compra, ID_Producto, Cantidad_com, Precio_Com) VALUES
(1, 1, 20, 45.00),
(2, 2, 50, 30.00),
(3, 3, 15, 100.00),
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

-- Detalle_Ventas (original + 20)
INSERT INTO Detalle_Ventas (ID_Venta, ID_Producto, Cantidad_ven, Precio_Ven) VALUES
(1, 1, 5, 70.00),
(2, 2, 10, 50.00),
(3, 3, 2, 150.00),
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

-- ======================================
-- CONSULTAS DE EJEMPLO
-- ======================================
SELECT * FROM Proveedores LIMIT 10;
SELECT * FROM Clientes LIMIT 10;
SELECT * FROM Productos LIMIT 20;
SELECT * FROM Compras LIMIT 10;
SELECT * FROM Ventas LIMIT 10;
SELECT * FROM Detalle_Compras LIMIT 10;
SELECT * FROM Detalle_Ventas LIMIT 10;


-- FIN DEL SCRIPT
