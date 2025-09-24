  import { pool } from "../../db_connection.js";

  // Obtener todas las detalles de ventas
  export const obtenerDetallesVentas = async (req, res) => {
    try {
      const [result] = await pool.query("SELECT * FROM Detalle_Ventas");
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
      const ID_Detalle_ven = req.params.ID_Detalle_ven;
      const [result] = await pool.query(
        "SELECT * FROM Detalles_Ventas WHERE ID_Detalle_ven= ?",
        [ID_Detalle_ven]
      );
      if (result.length <= 0) {
        return res.status(404).json({
          mensaje: `Error al leer los datos. ID ${ID_Detalle_ven} no encontrado.`,
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
      const { ID_Venta, ID_Producto, Cantidad_ven, Precio_Ven } = req.body;
      const [result] = await pool.query(
        "INSERT INTO Detalles_Ventas (ID_Venta, ID_Producto, Cantidad_ven, Precio_Ven) VALUES (?, ?, ?, ?)",
        [ID_Venta, ID_Producto, Cantidad_ven, Precio_Ven]
      );
      res.json({
        mensaje: "Detalle de Venta registrado exitosamente.",
        ID_Detalle_ven: result.insertId,  
        ID_Venta,
        ID_Producto,
        Cantidad_ven,
        Precio_Ven
      });
    } catch (error) {
      return res.status(500).json({
        mensaje: "Ha ocurrido un error al registrar el detalle de venta.",
        error: error,
      });
    }
  };

    // Eliminar un detalle de compra por su ID
export const eliminarDetalleVenta = async (req, res) => {
  try {
    const id_detalle_venta = req.params.id_detalle_venta;
    const [result] = await pool.query(
      'DELETE FROM Detalles_Ventas WHERE id_detalle_venta = ?',
      [id_detalle_venta]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        mensaje: `Error al eliminar el detalle venta. El ID ${id_detalle_venta} no fue encontrado.`
      });
    }

    // Respuesta sin contenido para indicar éxito
    res.status(204).send();
  } catch (error) {
    return res.status(500).json({
      mensaje: 'Ha ocurrido un error al eliminar el detalle venta.',
      error: error
    });
  }
};