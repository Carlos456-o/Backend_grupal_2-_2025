  import { pool } from "../../db_connection.js";

  // Obtener todas las detalles de compras 
  export const obtenerDetallesCompras = async (req, res) => {
    try {
      const [result] = await pool.query("SELECT * FROM Detalle_Compras");
      res.json(result);
    } catch (error) {
      return res.status(500).json({
        mensaje: "Ha ocurrido un error al leer los datos.",
        error: error,
      });
    }
  };

  
  // Obtener una detalle de compra por su ID
  export const obtenerDetalleCompra = async (req, res) => {
    try {
      const ID_Detales_Com = req.params.ID_Detales_Com;
      const [result] = await pool.query(
        "SELECT * FROM Detalle_Compras WHERE ID_Detales_Com= ?",
        [ID_Detales_Com]
      );  
      if (result.length <= 0) {
        return res.status(404).json({
          mensaje: `Error al leer los datos. ID ${ID_Detales_Com} no encontrado.`,
        });
      }
      res.json(result[0]);
    } catch (error) {
      return res.status(500).json({
        mensaje: "Ha ocurrido un error al leer los datos de los detalles de compras.",
      });
    }
  };

  // Registrar un nuevo detalle  Detalle de Compra
  export const registrarCompra = async (req, res) => {
    try {
      const { ID_Compra, ID_Producto, Cantidad_com, Precio_Com } = req.body;
      const [result] = await pool.query(
        'INSERT INTO compras ( ID_Compra, ID_Producto,Cantidad_com, Precio_Com  ) VALUES (?, ?, ?)',
        [ ID_Compra, ID_Producto,Cantidad_com, Precio_Com  ]
      );
      res.status(201).json({ id_compra: result.insertId });
    } catch (error) {
      return res.status(500).json({
        mensaje: 'Ha ocurrido un error al registrar el detalle de compra.',
        error: error
      });
    }   
  };

   // Eliminar un detalle de compra por su ID
export const eliminarDetalleCompra = async (req, res) => {
  try {
    const id_detalle_compra = req.params.id_detalle_compra;
    const [result] = await pool.query(
      'DELETE FROM Detalles_Compras WHERE id_detalle_compra = ?',
      [id_detalle_compra]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        mensaje: `Error al eliminar el detalle compra. El ID ${id_detalle_compra} no fue encontrado.`
      });
    }

    // Respuesta sin contenido para indicar éxito
    res.status(204).send();
  } catch (error) {
    return res.status(500).json({
      mensaje: 'Ha ocurrido un error al eliminar el detalle compra.',
      error: error
    });
  }
};