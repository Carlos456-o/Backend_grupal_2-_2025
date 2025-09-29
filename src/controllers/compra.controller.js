  import { pool } from "../../db_connection.js";

  // Obtener todas las compras
  export const obtenerCompras = async (req, res) => {
    try {
      const [result] = await pool.query("SELECT * FROM Compras");
      res.json(result);
    } catch (error) {
      return res.status(500).json({
        mensaje: "Ha ocurrido un error al leer los datos.",
        error: error,
      });
    }
  };

  // Obtener una compra por su ID
export const obtenerCompra = async (req, res) => {
  try {
    const ID_Compra = req.params.ID_Compra;
    const [result] = await pool.query(
      "SELECT * FROM Compras WHERE ID_Compra= ?",
      [ID_Compra]
    );
    if (result.length <= 0) {
      return res.status(404).json({
        mensaje: `Error al leer los datos. ID ${ID_Compra} no encontrado.`,
      });
    }
    res.json(result[0]);
  } catch (error) {
    return res.status(500).json({
      mensaje: "Ha ocurrido un error al leer los datos de las compra.",
    });
  }
};

// Registrar una nueva Compra
  export const registrarCompra = async (req, res) => {
    try {
      const { Fecha_compra, Cantidad, ID_Proveedor } = req.body;
      const [result] = await pool.query(
        "INSERT INTO compras (Fecha_compra, Cantidad, ID_Proveedor) VALUES (?, ?, ?)",
        [Fecha_compra, Cantidad, ID_Proveedor]  
      );
      res.json({
        ID_Compra: result.insertId,
        Fecha_compra,
        Cantidad,
        ID_Proveedor
      });
    } catch (error) {
      return res.status(500).json({
        mensaje: "Ha ocurrido un error al registrar la compra.",
        error: error,
      });
    }
  };

  // Eliminar una compra por su ID
export const eliminarCompra = async (req, res) => {
  try {
    const id_compra = req.params.id_compra;
    const [result] = await pool.query(
      'DELETE FROM Compras WHERE id_compra = ?',
      [id_compra]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        mensaje: `Error al eliminar la compra. El ID ${id_compra} no fue encontrado.`
      });
    }

    // Respuesta sin contenido para indicar éxito
    res.status(204).send();
  } catch (error) {
    return res.status(500).json({
      mensaje: 'Ha ocurrido un error al eliminar la compra.',
      error: error
    });
  }
};