  import { pool } from "../../db_connection.js";

  // Obtener todas las compras
  export const obtenerCompras = async (req, res) => {
    try {
      const [result] = await pool.query("SELECT * FROM compras");
      res.json(result);
    } catch (error) {
      return res.status(500).json({
        mensaje: "Ha ocurrido un error al leer los datos.",
        error: error,
      });
    }
  };