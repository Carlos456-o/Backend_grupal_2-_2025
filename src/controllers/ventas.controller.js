import { pool } from "../../db_connection.js";

// Obtener todas las ventas
export const obtenerVentas = async (req, res) => {
  try {
    const [result] = await pool.query("SELECT * FROM Ventas");
    res.json(result);
  } catch (error) {
    return res.status(500).json({
      mensaje: "Ha ocurrido un error al leer los datos.",
      error: error,
    });
  }
};


  // Obtener una venta por su ID
  export const obtenerVenta = async (req, res) => {
    try {
      const ID_Venta = req.params.ID_Venta;
      const [result] = await pool.query(
        "SELECT * FROM Ventas WHERE ID_Venta= ?",
        [ID_Venta]
      );
      if (result.length <= 0) {
        return res.status(404).json({
          mensaje: `Error al leer los datos. ID ${ID_Venta} no encontrado.`,
        });
      }
      res.json(result[0]);
    } catch (error) {
      return res.status(500).json({
        mensaje: "Ha ocurrido un error al leer los datos de las ventas.",
      });
    }
  };


   // Registrar una nueva Venta
  export const registrarVenta = async (req, res) => {
    try {
      const { Fecha_Venta, ID_Cliente } = req.body;
      const [result] = await pool.query(
        'INSERT INTO ventas ( Fecha_Venta, ID_Cliente) VALUES (?, ?, ?, ?)',
        [ Fecha_Venta, ID_Cliente]
      );
      res.status(201).json({ ID_Venta: result.insertId });
    } catch (error) {
      return res.status(500).json({
        mensaje: 'Ha ocurrido un error al registrar la venta.',
        error: error
      });
    }
  };