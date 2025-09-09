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
    const id_compra = req.params.id_compra;
    const [result] = await pool.query(
      "SELECT * FROM compras WHERE id_compra= ?",
      [id_compra]
    );
    if (result.length <= 0) {
      return res.status(404).json({
        mensaje: `Error al leer los datos. ID ${id_compra} no encontrado.`,
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
      const { ID_Compra, Fecha_compra, Cantidad, ID_Proveedor } = req.body;
      const [result] = await pool.query(
        'INSERT INTO compras (ID_Compra, fecha_compra, Cantidad,ID_Proveedor ) VALUES (?, ?, ?)',
        [ID_Compra, fecha_compra, Cantidad,ID_Proveedor ]
      );
      res.status(201).json({ id_compra: result.insertId });
    } catch (error) {
      return res.status(500).json({
        mensaje: 'Ha ocurrido un error al registrar la compra.',
        error: error
      });
    }   
  };