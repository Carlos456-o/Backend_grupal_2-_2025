
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
    Disponible BOOLEAN NOT NULL DEFAULT TRUE,      -- true=disponible, false=no disponible
    PrecioCompra DECIMAL(10,2) NOT NULL,
    PrecioVenta DECIMAL(10,2) NOT NULL
);

-- Nueva tabla Empleados
CREATE TABLE Empleados (
    ID_Empleado INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(60) NOT NULL,
    Apellido VARCHAR(60),
    Telefono VARCHAR(20),
    Email VARCHAR(100),
    Cargo VARCHAR(50)
);

-- Compras: eliminada la columna Cantidad; agregada Total_Compra y relación con Empleados
CREATE TABLE Compras (
    ID_Compra INT AUTO_INCREMENT PRIMARY KEY,
    Fecha_compra DATE NOT NULL,
    ID_Proveedor INT,
    ID_Empleado INT,
    Total_Compra DECIMAL(12,2) NOT NULL DEFAULT 0,
    FOREIGN KEY (ID_Proveedor) REFERENCES Proveedores (ID_Proveedor) ON DELETE SET NULL,
    FOREIGN KEY (ID_Empleado) REFERENCES Empleados (ID_Empleado) ON DELETE SET NULL
);

-- Ventas: agregada columna Total_Venta y relación con Empleados y Cliente
CREATE TABLE Ventas (
    ID_Venta INT AUTO_INCREMENT PRIMARY KEY,
    Fecha_Venta DATE NOT NULL,
    ID_Cliente INT,
    ID_Empleado INT,
    Total_Venta DECIMAL(12,2) NOT NULL DEFAULT 0,
    FOREIGN KEY (ID_Cliente) REFERENCES Clientes (ID_Cliente) ON DELETE SET NULL,
    FOREIGN KEY (ID_Empleado) REFERENCES Empleados (ID_Empleado) ON DELETE SET NULL
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

-- ===============================
-- TABLA DE BITÁCORA
-- Sirve para guardar los movimientos del sistema
-- (quién hizo qué, cuándo y en qué tabla)
-- ===============================
CREATE TABLE Bitacora (
    ID_Bitacora INT AUTO_INCREMENT PRIMARY KEY,  -- Identificador único
    Tabla VARCHAR(50) NOT NULL,                  -- Nombre de la tabla afectada
    Operacion VARCHAR(20) NOT NULL,              -- Tipo de acción (INSERT, UPDATE, DELETE)
    Usuario VARCHAR(100) NOT NULL,               -- Usuario que hizo el cambio
    Fecha DATETIME DEFAULT CURRENT_TIMESTAMP,    -- Momento exacto de la acción
    Detalle TEXT                                 -- Descripción o detalle adicional
);

-- Usuarios (credenciales / roles simples)
CREATE TABLE Usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    usuario VARCHAR(50),
    contraseña VARCHAR(100),
    rol ENUM('Adm','Empleado','Cliente') DEFAULT 'Empleado'
);

-- ======================================
-- TRIGGERS (mantienen stock y totales)
-- ======================================

DELIMITER //

-- BITÁCORA: GENERALES (INSERT/UPDATE/DELETE) para tablas clave
-- ==========================================
-- TRIGGER: trg_clientes_insert
-- Se activa automáticamente después de insertar un cliente nuevo
-- Guarda la acción en la tabla Bitácora
-- =========================================
-- OBJETIVO:
--   Registrar automáticamente en la tabla Bitacora cada vez 
--   que se inserte un nuevo cliente en la tabla Clientes.
--   Esto sirve para llevar un historial de acciones (auditoría)
--   y saber quién agregó un cliente, cuándo y qué datos ingresó.

-- Guarda en Bitacora cuando se inserta un cliente
CREATE TRIGGER trg_clientes_insert
AFTER INSERT ON Clientes
FOR EACH ROW
BEGIN
    -- Inserta registro en la bitácora
    INSERT INTO Bitacora (Tabla, Operacion, Usuario, Detalle)
    VALUES ('Clientes','INSERT',USER(),
            CONCAT('Cliente agregado: ', NEW.Nombre1,' ',COALESCE(NEW.Apellidos1,'')));
END;
//




-- ==========================================
-- TRIGGER: trg_clientes_update
-- Se ejecuta automáticamente después de actualizar un cliente
-- Guarda el cambio en la tabla Bitácora
-- ==========================================
CREATE TRIGGER trg_clientes_update
AFTER UPDATE ON Clientes        -- Se activa después de una actualización en Clientes
FOR EACH ROW                    -- Aplica a cada registro modificado
BEGIN
    -- Inserta en la Bitácora los datos del cliente actualizado
    INSERT INTO Bitacora (Tabla, Operacion, Usuario, Detalle)
    VALUES (
        'Clientes',             -- Tabla afectada
        'UPDATE',               -- Tipo de operación
        USER(),                 -- Usuario que realizó la acción
        CONCAT(                 -- Mensaje con información del cliente actualizado
            'Se actualizó el cliente ID ', 
            NEW.ID_Cliente, ': ', 
            NEW.Nombre1, ' ', 
            COALESCE(NEW.Apellidos1,'')  -- Evita errores si el apellido está vacío
        )
    );
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

-- COMPRAS: al insertar detalle se suma stock y se recalcula Total_Compra
CREATE TRIGGER trg_detalle_compras_insert
AFTER INSERT ON Detalle_Compras
FOR EACH ROW
BEGIN
    -- Actualizar stock del producto
    UPDATE Productos
    SET Cantidad = Cantidad + NEW.Cantidad_com,
        Disponible = (Cantidad + NEW.Cantidad_com) > 0
    WHERE ID_Producto = NEW.ID_Producto;

    -- Recalcular total de la compra (sumando todos los detalles)
    UPDATE Compras
    SET Total_Compra = (
        SELECT IFNULL(SUM(DC2.Cantidad_com * DC2.Precio_Com), 0)
        FROM Detalle_Compras DC2
        WHERE DC2.ID_Compra = NEW.ID_Compra
    )
    WHERE ID_Compra = NEW.ID_Compra;

    INSERT INTO Bitacora (Tabla, Operacion, Usuario, Detalle)
    VALUES ('Detalle_Compras', 'INSERT', USER(),
            CONCAT('Se agregó producto ID ', NEW.ID_Producto, ' a la compra ID ', NEW.ID_Compra, ' (+', NEW.Cantidad_com, ')'));
END;
//

CREATE TRIGGER trg_detalle_compras_update
AFTER UPDATE ON Detalle_Compras
FOR EACH ROW
BEGIN
    DECLARE diff INT;
    SET diff = NEW.Cantidad_com - OLD.Cantidad_com;

    -- Ajustar stock según diferencia
    UPDATE Productos
    SET Cantidad = Cantidad + diff,
        Disponible = (Cantidad + diff) > 0
    WHERE ID_Producto = NEW.ID_Producto;

    -- Recalcular total de la compra
    UPDATE Compras
    SET Total_Compra = (
        SELECT IFNULL(SUM(DC2.Cantidad_com * DC2.Precio_Com), 0)
        FROM Detalle_Compras DC2
        WHERE DC2.ID_Compra = NEW.ID_Compra
    )
    WHERE ID_Compra = NEW.ID_Compra;

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

    -- Recalcular total de la compra
    UPDATE Compras
    SET Total_Compra = (
        SELECT IFNULL(SUM(DC2.Cantidad_com * DC2.Precio_Com), 0)
        FROM Detalle_Compras DC2
        WHERE DC2.ID_Compra = OLD.ID_Compra
    )
    WHERE ID_Compra = OLD.ID_Compra;

    INSERT INTO Bitacora (Tabla, Operacion, Usuario, Detalle)
    VALUES ('Detalle_Compras', 'DELETE', USER(),
            CONCAT('Se eliminó detalle compra ID ', OLD.ID_Detalles_Com, ', producto ID ', OLD.ID_Producto));
END;
//

-- VENTAS: validar stock antes de insertar detalle y ajustar stock y totales
CREATE TRIGGER trg_detalle_ventas_before_insert
BEFORE INSERT ON Detalle_Ventas
FOR EACH ROW
BEGIN
    DECLARE stock_actual INT;
    SELECT Cantidad INTO stock_actual FROM Productos WHERE ID_Producto = NEW.ID_Producto FOR UPDATE;
    IF stock_actual IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Producto no existe';
    ELSEIF stock_actual < NEW.Cantidad_ven THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuficiente para la venta';
    ELSE
        -- Actualizar stock en la tabla Productos
        UPDATE Productos
        SET Cantidad = Cantidad - NEW.Cantidad_ven,
            Disponible = (Cantidad - NEW.Cantidad_ven) > 0
        WHERE ID_Producto = NEW.ID_Producto;
    END IF;
END;
//

CREATE TRIGGER trg_detalle_ventas_after_insert
AFTER INSERT ON Detalle_Ventas
FOR EACH ROW
BEGIN
    -- Recalcular total de la venta
    UPDATE Ventas
    SET Total_Venta = (
        SELECT IFNULL(SUM(DV2.Cantidad_ven * DV2.Precio_Ven), 0)
        FROM Detalle_Ventas DV2
        WHERE DV2.ID_Venta = NEW.ID_Venta
    )
    WHERE ID_Venta = NEW.ID_Venta;

    INSERT INTO Bitacora (Tabla, Operacion, Usuario, Detalle)
    VALUES ('Detalle_Ventas', 'INSERT', USER(),
            CONCAT('Se vendió producto ID ', NEW.ID_Producto, ' en venta ID ', NEW.ID_Venta, ' (-', NEW.Cantidad_ven, ')'));
END;
//

CREATE TRIGGER trg_detalle_ventas_update
AFTER UPDATE ON Detalle_Ventas
FOR EACH ROW
BEGIN
    -- Ajuste del stock si la cantidad cambió (no se cubre re-asignación de producto distinto aquí)
    DECLARE diff INT;
    SET diff = NEW.Cantidad_ven - OLD.Cantidad_ven;

    -- Si diff > 0 se vendió más -> restar, si diff < 0 devolver
    UPDATE Productos
    SET Cantidad = Cantidad - diff,
        Disponible = (Cantidad - diff) > 0
    WHERE ID_Producto = NEW.ID_Producto;

    -- Recalcular total de la venta
    UPDATE Ventas
    SET Total_Venta = (
        SELECT IFNULL(SUM(DV2.Cantidad_ven * DV2.Precio_Ven), 0)
        FROM Detalle_Ventas DV2
        WHERE DV2.ID_Venta = NEW.ID_Venta
    )
    WHERE ID_Venta = NEW.ID_Venta;

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

    -- Recalcular total de la venta
    UPDATE Ventas
    SET Total_Venta = (
        SELECT IFNULL(SUM(DV2.Cantidad_ven * DV2.Precio_Ven), 0)
        FROM Detalle_Ventas DV2
        WHERE DV2.ID_Venta = OLD.ID_Venta
    )
    WHERE ID_Venta = OLD.ID_Venta;

    INSERT INTO Bitacora (Tabla, Operacion, Usuario, Detalle)
    VALUES ('Detalle_Ventas', 'DELETE', USER(),
            CONCAT('Se eliminó detalle venta ID ', OLD.ID_Detalle_ven, ' producto ID ', OLD.ID_Producto, ' (+', OLD.Cantidad_ven, ')'));
END;
//

DELIMITER ;

-- ======================================
-- VISTAS (actualizadas para usar Totales)
-- ======================================

CREATE OR REPLACE VIEW Productos_Stock AS
SELECT Nombre_P, Cantidad
FROM Productos
WHERE Cantidad > 10;

CREATE OR REPLACE VIEW Productos_Bajo_Stock AS
SELECT Nombre_P, Cantidad
FROM Productos
WHERE Cantidad <= 10;

-- ==========================================
-- VISTA: Productos_Mas_Vendidos
-- Muestra los productos con mayor cantidad vendida
-- ==========================================
CREATE OR REPLACE VIEW Productos_Mas_Vendidos AS
SELECT 
    P.Nombre_P,                         -- Nombre del producto
    SUM(DV.Cantidad_ven) AS Total_Vendido -- Total de unidades vendidas
FROM Detalle_Ventas DV
JOIN Productos P 
    ON DV.ID_Producto = P.ID_Producto   -- Une ventas con productos
GROUP BY P.Nombre_P                     -- Agrupa por nombre del producto
ORDER BY Total_Vendido DESC;            -- Ordena del más vendido al menos vendido


CREATE OR REPLACE VIEW Gastos_Compras AS
SELECT 
    Co.ID_Compra,
    Co.Fecha_compra,
    P.Nombre_Prov,
    Co.Total_Compra
FROM Compras Co
LEFT JOIN Proveedores P ON Co.ID_Proveedor = P.ID_Proveedor;

-- ==========================================
-- VISTA: Productos_No_Vendidos
-- Muestra los productos que nunca se han vendido
-- ==========================================
CREATE OR REPLACE VIEW Productos_No_Vendidos AS
SELECT 
    P.ID_Producto,   -- Código del producto
    P.Nombre_P,      -- Nombre del producto
    P.Cantidad       -- Cantidad en inventario
FROM Productos P
LEFT JOIN Detalle_Ventas DV 
    ON P.ID_Producto = DV.ID_Producto  -- Une productos con sus ventas (si existen)
WHERE DV.ID_Producto IS NULL           -- Solo muestra los que no tienen ventas
ORDER BY P.Cantidad DESC;              -- Ordena por cantidad en inventario (mayor a menor)

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
       V.Total_Venta AS Total_Venta_Dia
FROM Ventas V
JOIN Detalle_Ventas DV ON V.ID_Venta = DV.ID_Venta
JOIN Productos P ON DV.ID_Producto = P.ID_Producto
GROUP BY V.Fecha_Venta, P.Nombre_P, V.Total_Venta
ORDER BY V.Fecha_Venta ASC, Total_Venta_Dia DESC;

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
-- PROCEDIMIENTOS ALMACENADOS (ajustados)
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
END;
//
-- Procedimiento almacenado para registrar un nuevo producto en la tabla Productos
CREATE PROCEDURE RegistrarProducto(
    IN p_Nombre_P VARCHAR(100),     -- Nombre del producto que se registrará
    IN p_Descripcion VARCHAR(200),  -- Descripción breve del producto
    IN p_Cantidad INT,              -- Cantidad inicial del producto en inventario
    IN p_PrecioCompra DECIMAL(10,2),-- Precio de compra para control de costos
    IN p_PrecioVenta DECIMAL(10,2)  -- Precio de venta al cliente
)
BEGIN
    -- Inserta un nuevo registro en la tabla Productos utilizando los parámetros recibidos
    INSERT INTO Productos (Nombre_P, Descripcion, Cantidad, PrecioCompra, PrecioVenta)
    VALUES (p_Nombre_P, p_Descripcion, p_Cantidad, p_PrecioCompra, p_PrecioVenta);
END;

//

CREATE PROCEDURE RegistrarProveedor(
    IN p_Nombre_Prov VARCHAR(100),
    IN p_Contacto VARCHAR(20),
    IN p_Email VARCHAR(100)
)
BEGIN
    INSERT INTO Proveedores (Nombre_Prov, Contacto, Email)
    VALUES (p_Nombre_Prov, p_Contacto, p_Email);
END;
//

-- RegistrarCompra: inserta compra y detalle, triggers actualizarán stock y Total_Compra
CREATE PROCEDURE RegistrarCompra(
    IN p_Fecha DATE,
    IN p_ID_Proveedor INT,
    IN p_ID_Empleado INT,
    IN p_ID_Producto INT,
    IN p_Cantidad INT,
    IN p_Precio DECIMAL(10,2)
)
BEGIN
    DECLARE nueva_compra_id INT;
    INSERT INTO Compras (Fecha_compra, ID_Proveedor, ID_Empleado, Total_Compra)
    VALUES (p_Fecha, p_ID_Proveedor, p_ID_Empleado, 0);
    SET nueva_compra_id = LAST_INSERT_ID();
    INSERT INTO Detalle_Compras (ID_Compra, ID_Producto, Cantidad_com, Precio_Com)
    VALUES (nueva_compra_id, p_ID_Producto, p_Cantidad, p_Precio);
    -- Trigger trg_detalle_compras_insert se encargará de actualizar Productos y Total_Compra.
END;
//

-- RegistrarVentaSimple: crea venta (Total actualizado por triggers al insertar detalle)
CREATE PROCEDURE RegistrarVentaSimple(
    IN p_ID_Cliente INT,
    IN p_Fecha DATE,
    IN p_ID_Empleado INT,
    IN p_ID_Producto INT,
    IN p_Cantidad INT,
    IN p_Precio DECIMAL(10,2)
)
BEGIN
    DECLARE nueva_venta_id INT;
    INSERT INTO Ventas (ID_Cliente, Fecha_Venta, ID_Empleado, Total_Venta)
    VALUES (p_ID_Cliente, p_Fecha, p_ID_Empleado, 0);
    SET nueva_venta_id = LAST_INSERT_ID();
    INSERT INTO Detalle_Ventas (ID_Venta, ID_Producto, Cantidad_ven, Precio_Ven)
    VALUES (nueva_venta_id, p_ID_Producto, p_Cantidad, p_Precio);
    -- Triggers se encargan de stock y Total_Venta.
END;
//

CREATE PROCEDURE EliminarCliente(
    IN p_ID_Cliente INT
)
BEGIN
    DELETE FROM Clientes
    WHERE ID_Cliente = p_ID_Cliente;
END;
//

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
END;
//

CREATE PROCEDURE ActualizarVenta(
    IN p_ID_Venta INT,
    IN p_NuevaFecha DATE,
    IN p_ID_Cliente INT,
    IN p_ID_Empleado INT
)
BEGIN
    UPDATE Ventas
    SET Fecha_Venta = p_NuevaFecha,
        ID_Cliente = p_ID_Cliente,
        ID_Empleado = p_ID_Empleado
    WHERE ID_Venta = p_ID_Venta;
    -- Si cambia detalles, Totales se recalculan por triggers.
END;
//

CREATE PROCEDURE ActualizarCompra(
    IN p_ID_Compra INT,
    IN p_NuevaFecha DATE,
    IN p_ID_Proveedor INT,
    IN p_ID_Empleado INT
)
BEGIN
    UPDATE Compras
    SET Fecha_compra = p_NuevaFecha,
        ID_Proveedor = p_ID_Proveedor,
        ID_Empleado = p_ID_Empleado
    WHERE ID_Compra = p_ID_Compra;
END;
//

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
END;
//

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
END;
//

CREATE PROCEDURE EliminarVenta(
    IN p_ID_Venta INT
)
BEGIN
    DELETE FROM Detalle_Ventas
    WHERE ID_Venta = p_ID_Venta;
    DELETE FROM Ventas
    WHERE ID_Venta = p_ID_Venta;
END;
//

CREATE PROCEDURE EliminarCompra(
    IN p_ID_Compra INT
)
BEGIN
    DELETE FROM Detalle_Compras
    WHERE ID_Compra = p_ID_Compra;
    DELETE FROM Compras
    WHERE ID_Compra = p_ID_Compra;
END;
//

CREATE PROCEDURE EliminarProducto(
    IN p_ID_Producto INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Detalle_Ventas WHERE ID_Producto = p_ID_Producto)
    AND NOT EXISTS (SELECT 1 FROM Detalle_Compras WHERE ID_Producto = p_ID_Producto) THEN
        DELETE FROM Productos
        WHERE ID_Producto = p_ID_Producto;
    END IF;
END;
//

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
END;
//

CREATE PROCEDURE ListarProductosPorProveedor(
    IN p_ID_Proveedor INT
)
BEGIN
    SELECT P.Nombre_P, DC.Cantidad_com, DC.Precio_Com, C.Fecha_compra
    FROM Detalle_Compras DC
    JOIN Compras C ON DC.ID_Compra = C.ID_Compra
    JOIN Productos P ON DC.ID_Producto = P.ID_Producto
    WHERE C.ID_Proveedor = p_ID_Proveedor;
END;
//

CREATE PROCEDURE BuscarProductoPorNombre(
    IN p_Nombre VARCHAR(100)
)
BEGIN
    SELECT *
    FROM Productos
    WHERE Nombre_P LIKE CONCAT('%', p_Nombre, '%');
END;
//

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
END;
//

CREATE PROCEDURE ActualizarStockProducto(
    IN p_ID_Producto INT,
    IN p_NuevaCantidad INT
)
BEGIN
    UPDATE Productos
    SET Cantidad = p_NuevaCantidad,
        Disponible = p_NuevaCantidad > 0
    WHERE ID_Producto = p_ID_Producto;
END;
//

DELIMITER ;

-- ======================================
-- FUNCIONES (ajustadas si aplica)
-- ======================================
DELIMITER //
-- ==========================================
-- FUNCIÓN: ObtenerNombreCompletoCliente
-- Devuelve el nombre completo de un cliente
-- ==========================================
CREATE FUNCTION ObtenerNombreCompletoCliente(p_ID_Cliente INT)
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    DECLARE nombre_completo VARCHAR(255);  -- Variable para guardar el nombre completo

    -- Selecciona y concatena todos los nombres y apellidos del cliente
    SELECT CONCAT_WS(' ', Nombre1, Nombre2, Apellidos1, Apellidos2)
    INTO nombre_completo
    FROM Clientes
    WHERE ID_Cliente = p_ID_Cliente;

    RETURN nombre_completo; -- Devuelve el nombre completo
END;
//


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
END;
//

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
END;
//

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
END;
//

CREATE FUNCTION ClienteActivo(p_ID_Cliente INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE existe INT;
    SELECT COUNT(*) INTO existe
    FROM Ventas
    WHERE ID_Cliente = p_ID_Cliente;
    RETURN existe > 0;
END;
//

CREATE FUNCTION TotalStockGlobal()
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT IFNULL(SUM(Cantidad), 0) INTO total
    FROM Productos;
    RETURN total;
END;
//

CREATE FUNCTION PromedioPrecioVenta()
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(10,2);
    SELECT IFNULL(AVG(PrecioVenta), 0) INTO promedio
    FROM Productos;
    RETURN promedio;
END;
//

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
END;
//

CREATE FUNCTION TotalComprasCliente(p_ID_Cliente INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT IFNULL(COUNT(*), 0) INTO total
    FROM Ventas
    WHERE ID_Cliente = p_ID_Cliente;
    RETURN total;
END;
//

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
END;
//
DELIMITER ;
-- ======================================
-- Eventos
-- ======================================
-- Evento: limpiar_bitacora_mensual
-- Objetivo: borrar registros antiguos de la tabla Bitacora para evitar que crezca demasiado
-- Se ejecuta automáticamente una vez al mes

CREATE EVENT IF NOT EXISTS limpiar_bitacora_mensual   -- Crea el evento solo si no existe
ON SCHEDULE EVERY 1 MONTH                              -- Indica que el evento correrá cada 1 mes
STARTS (                                               
    TIMESTAMP(CURRENT_DATE) +                           -- Convierte la fecha actual a formato timestamp
    INTERVAL 1 DAY - INTERVAL DAY(CURRENT_DATE)-1 DAY   -- Ajusta para que inicie el primer día del mes
)                                                      
DO
    DELETE FROM Bitacora                                -- Acción del evento: eliminar registros
    WHERE Fecha < NOW() - INTERVAL 6 MONTH;             -- Solo borra registros de más de 6 meses

CREATE EVENT IF NOT EXISTS generar_resumen_semanal
ON SCHEDULE EVERY 1 WEEK
DO
    INSERT INTO Resumen_Semanal (Fecha_Generacion, Total_Productos, Total_Ventas_Sem)
    SELECT NOW(), (SELECT COUNT(*) FROM Productos), 
        IFNULL((SELECT SUM(DV.Cantidad_ven*DV.Precio_Ven)
               FROM Ventas V JOIN Detalle_Ventas DV ON V.ID_Venta = DV.ID_Venta
               WHERE V.Fecha_Venta >= CURDATE() - INTERVAL 7 DAY),0);

-- ======================================
-- ROLES, USUARIOS Y PRIVILEGIOS (opcional)
-- ======================================
-- Estos comandos pueden requerir privilegios de root en el servidor.
-- Si falla, ejecutarlos manualmente con un usuario con permisos suficientes.

-- Crear roles (MySQL 8+)
 CREATE ROLE IF NOT EXISTS 'Admin', 'Empleado', 'Cliente';

-- Crear usuarios ejemplo (ajusta contraseñas en producción)
 CREATE USER IF NOT EXISTS 'admin_moto'@'localhost' IDENTIFIED BY 'Admin123';
 CREATE USER IF NOT EXISTS 'empleado_moto'@'localhost' IDENTIFIED BY 'Empleado123';
 CREATE USER IF NOT EXISTS 'cliente_moto'@'localhost' IDENTIFIED BY 'Cliente123';

 GRANT 'Admin' TO 'admin_moto'@'localhost';
 GRANT 'Empleado' TO 'empleado_moto'@'localhost';
 GRANT 'Cliente' TO 'cliente_moto'@'localhost';

 GRANT ALL PRIVILEGES ON Moto_Repuesto.* TO 'admin_moto'@'localhost' WITH GRANT OPTION;
 GRANT SELECT, INSERT, UPDATE, DELETE ON Moto_Repuesto.Ventas TO 'empleado_moto'@'localhost';
 GRANT SELECT, INSERT, UPDATE, DELETE ON Moto_Repuesto.Detalle_Ventas TO 'empleado_moto'@'localhost';
 GRANT SELECT ON Moto_Repuesto.Productos TO 'empleado_moto'@'localhost';
 GRANT SELECT ON Moto_Repuesto.Clientes TO 'cliente_moto'@'localhost';
 FLUSH PRIVILEGES;

-- ======================================
-- DATOS: INSERCIONES DE EJEMPLO (actualizadas)
-- ======================================

-- Usuarios (demo)
INSERT INTO Usuarios (usuario, contraseña, rol) VALUES
('eli', 'eli2025', 'Adm'),
('javier51', '123456', 'Empleado'),
('cruz51', '20252025', 'Empleado');

-- Empleados (nuevos)
INSERT INTO Empleados (Nombre, Apellido, Telefono, Email, Cargo) VALUES
('Miguel', 'Ramírez', '3001234567', 'miguel.r@taller.com', 'Jefe de Compras'),
('Laura', 'Gonzalez', '3012345678', 'laura.g@taller.com', 'Vendedora'),
('Pedro', 'Santos', '3023456789', 'pedro.s@taller.com', 'Auxiliar');

-- Proveedores (ejemplo)
INSERT INTO Proveedores (Nombre_Prov, Contacto, Email) VALUES
('Repuestos Rápidos', '1234567890', 'contacto@repuestosrapidos.com'),
('MotoPartes S.A.', '0987654321', 'ventas@motopartes.com'),
('Speed Moto', '1122334455', 'info@speedmoto.com');

-- Clientes (ejemplo)
INSERT INTO Clientes (Nombre1, Nombre2, Apellidos1, Apellidos2, Cedula, Telefono) VALUES
('Juan', 'Edgardo', 'Pérez', 'López', '123456789', '3216549870'),
('María', 'Isabel', 'Gómez', 'Rodríguez', '987654321', '3101234567'),
('Carlos', 'Andrés', 'Martínez', 'Sánchez', '456789123', '3112345678');

-- Productos (ejemplo)
INSERT INTO Productos (Nombre_P, Descripcion, Cantidad, PrecioCompra, PrecioVenta) VALUES
('Batería Moto X', 'Batería de 12V para motos', 50, 45.00, 70.00),
('Aceite Sintético', 'Aceite 10W-40 para motos', 100, 30.00, 50.00),
('Llantas Pirelli', 'Llantas de alta duración', 30, 100.00, 150.00),
('Casco Integral Pro', 'Casco integral de alta seguridad', 20, 150.00, 250.00),
('Juego de Pastillas de Freno', 'Pastillas de freno cerámicas', 70, 25.00, 40.00);

-- Compras (creadas con ID_Empleado) -- Total_Compra inicial 0, se llenará por triggers tras insertar Detalle_Compras
INSERT INTO Compras (Fecha_compra, ID_Proveedor, ID_Empleado, Total_Compra) VALUES
('2024-03-18', 1, 1, 0),
('2024-03-20', 2, 1, 0),
('2024-03-22', 3, 1, 0);

-- Ventas (creadas con ID_Empleado) -- Total_Venta inicial 0, se llenará por triggers tras insertar Detalle_Ventas
INSERT INTO Ventas (Fecha_Venta, ID_Cliente, ID_Empleado, Total_Venta) VALUES
('2024-03-18', 1, 2, 0),
('2024-03-20', 2, 2, 0),
('2024-03-22', 3, 2, 0);

-- Detalle_Compras (al insertarse actualizarán stock y Total_Compra por triggers)
INSERT INTO Detalle_Compras (ID_Compra, ID_Producto, Cantidad_com, Precio_Com) VALUES
(1, 1, 20, 45.00),
(2, 2, 50, 30.00),
(3, 3, 15, 100.00);

-- Detalle_Ventas (al insertarse validarán stock y actualizarán Total_Venta)
INSERT INTO Detalle_Ventas (ID_Venta, ID_Producto, Cantidad_ven, Precio_Ven) VALUES
(1, 1, 5, 70.00),
(2, 2, 10, 50.00),
(3, 3, 2, 150.00);

-- Añadimos más compras/ventas de ejemplo vinculando empleados
INSERT INTO Compras (Fecha_compra, ID_Proveedor, ID_Empleado, Total_Compra) VALUES
('2024-04-01', 1, 1, 0);
INSERT INTO Detalle_Compras (ID_Compra, ID_Producto, Cantidad_com, Precio_Com) VALUES
(LAST_INSERT_ID(), 4, 10, 2500.00);

INSERT INTO Ventas (Fecha_Venta, ID_Cliente, ID_Empleado, Total_Venta) VALUES
('2024-04-02', 2, 2, 0);
INSERT INTO Detalle_Ventas (ID_Venta, ID_Producto, Cantidad_ven, Precio_Ven) VALUES
(LAST_INSERT_ID(), 4, 1, 3000.00);

-- ======================================
-- CONSULTAS DE EJEMPLO
-- ======================================
SELECT * FROM Empleados LIMIT 10;
SELECT * FROM Proveedores LIMIT 10;
SELECT * FROM Clientes LIMIT 10;
SELECT * FROM Productos LIMIT 20;
SELECT * FROM Compras LIMIT 10;
SELECT * FROM Ventas LIMIT 10;
SELECT * FROM Detalle_Compras LIMIT 10;
SELECT * FROM Detalle_Ventas LIMIT 10;
SELECT * FROM Bitacora ORDER BY Fecha DESC LIMIT 20;
SET GLOBAL event_scheduler = ON;


-- FIN DEL SCRIPT
