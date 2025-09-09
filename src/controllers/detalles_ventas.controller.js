  import { pool } from "../../db_connection.js";

  // Obtener todas las detalles de ventas
  export const obtenerDetallesVentas = async (req, res) => {
    try {
      const [result] = await pool.query("SELECT * FROM Detalles_Ventas");
      res.json(result);
    } catch (error) {
      return res.status(500).json({
        mensaje: "Ha ocurrido un error al leer los datos.",
        error: error,
      });
    }
  };

  
  // Obtener una detalle de venta por su ID
  export const obtenerDetalleVenta = async (req, res) => {
    try {
      const id_detalle_venta = req.params.id_detalle_venta;
      const [result] = await pool.query(
        "SELECT * FROM detalles_ventas WHERE id_detalle_venta= ?",
        [id_detalle_venta]
      );
      if (result.length <= 0) {
        return res.status(404).json({
          mensaje: `Error al leer los datos. ID ${id_detalle_venta} no encontrado.`,
        });
      }
      res.json(result[0]);
    } catch (error) {
      return res.status(500).json({
        mensaje: "Ha ocurrido un error al leer los datos de los detalles de ventas.",
      });
    }
  };

   // Registrar un nuevo Detalle de Venta
  export const registrarDetalleVenta = async (req, res) => {
    try {
      const { ID_Detalle_ven, ID_Venta, ID_Producto, Cantidad_ven, Precio_Ven } = req.body;
      const [result] = await pool.query(
        'INSERT INTO detalles_ventas (ID_Detalle_ven, ID_Venta, ID_Producto, Cantidad_ven, Precio_Ven) VALUES (?, ?, ?, ?)',
        [ID_Detalle_ven, ID_Venta, ID_Producto, Cantidad_ven,  Precio_Ven]
      );
      res.status(201).json({ id_detalle_venta: result.insertId });
    } catch (error) {
      return res.status(500).json({
        mensaje: 'Ha ocurrido un error al registrar el detalle de venta.',
        error: error
      });
    }
  };