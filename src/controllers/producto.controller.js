  import { pool } from "../../db_connection.js";

  // Obtener todas las productos
  export const obtenerProductos = async (req, res) => {
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
  export const obtenerProducto = async (req, res) => {
    try {
      const ID_Producto = req.params.ID_Producto;
      const [result] = await pool.query(
        "SELECT * FROM Productos WHERE ID_Producto= ?",
        [ID_Producto]
      );
      if (result.length <= 0) {
        return res.status(404).json({
          mensaje: `Error al leer los datos. ID ${ID_Producto} no encontrado.`,
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
      const { Nombre_P, Descripcion, Cantidad, Preciodecom, Preciodeven } = req.body;
      const [result] = await pool.query(
        'INSERT INTO productos ( Nombre_P, Descripcion, Cantidad, Preciodecom, Preciodeven) VALUES (?, ?, ?, ?, ?, ?)',
        [ Nombre_P, Descripcion, Cantidad, Preciodecom, Preciodeven]
      );
      res.status(201).json({ id_producto: result.insertId });
    } catch (error) {
      return res.status(500).json({
        mensaje: 'Ha ocurrido un error al registrar el producto.',
        error: error
      });
    }
  };

   // Eliminar un detalle de compra por su ID
export const eliminarProducto = async (req, res) => {
  try {
    const ID_Producto = req.params.ID_Producto;
    const [result] = await pool.query(
      'DELETE FROM Productos WHERE ID_Producto = ?',
      [ID_Producto]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        mensaje: `Error al eliminar el Empleado. El ID ${ID_Producto} no fue encontrado.`
      });
    }

    // Respuesta sin contenido para indicar éxito
    res.status(204).send();
  } catch (error) {
    return res.status(500).json({
      mensaje: 'Ha ocurrido un error al eliminar el Producto.',
      error: error
    });
  }
};

export const actualizarProductoPatch = async (req, res) => {
  try {
    const { ID_Producto } = req.params;
    const datos = req.body;

    const [result] = await pool.query(
      'UPDATE Productos SET ? WHERE ID_Producto = ?',
      [datos, ID_Producto]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ mensaje: `Producto con ID ${ID_Producto} no encontrada.` });
    }

    res.status(200).json({ mensaje: `Producto con ID ${ID_Producto} actualizada.` });
  } catch (error) {
    res.status(500).json({ mensaje: 'Error al actualizar el producto.', error });
  }
};