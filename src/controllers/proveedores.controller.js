  import { pool } from "../../db_connection.js";

  // Obtener todas las usuarios
  export const obtenerProveedores = async (req, res) => {
    try {
      const [result] = await pool.query("SELECT * FROM Proveedores");
      res.json(result);
    } catch (error) {
      return res.status(500).json({
        mensaje: "Ha ocurrido un error al leer los datos.",
        error: error,
      });
    }
  };

