  import { pool } from "../../db_connection.js";

  // Obtener todas las productos
  export const obtenerProducto = async (req, res) => {
    try {
      const [result] = await pool.query("SELECT * FROM Productos");
      res.json(result);
    } catch (error) {
      return res.status(500).json({
        mensaje: "Ha ocurrido un error al leer los datos.",
        error: error,
      });
    }
  };

  
  // Obtener una producto por su ID
  export const obtenerProductos = async (req, res) => {
    try {
      const id_producto = req.params.id_producto;
      const [result] = await pool.query(
        "SELECT * FROM productos WHERE id_producto= ?",
        [id_producto]
      );
      if (result.length <= 0) {
        return res.status(404).json({
          mensaje: `Error al leer los datos. ID ${id_producto} no encontrado.`,
        });
      } 
      res.json(result[0]);
    } catch (error) {
      return res.status(500).json({
        mensaje: "Ha ocurrido un error al leer los datos de los productos.",
      });
    }
  };

   // Registrar un nuevo Producto
  export const registrarProducto = async (req, res) => {
    try {
      const { ID_Producto, Nombre_P, Descripcion, Cantidad, Preciodecom, Preciodeven } = req.body;
      const [result] = await pool.query(
        'INSERT INTO productos (ID_Producto, Nombre_P, Descripcion, Cantidad, Preciodecom, Preciodeven) VALUES (?, ?, ?, ?, ?, ?)',
        [ID_Producto, Nombre_P, Descripcion, Cantidad, Preciodecom, Preciodeven]
      );
      res.status(201).json({ id_producto: result.insertId });
    } catch (error) {
      return res.status(500).json({
        mensaje: 'Ha ocurrido un error al registrar el producto.',
        error: error
      });
    }
  };