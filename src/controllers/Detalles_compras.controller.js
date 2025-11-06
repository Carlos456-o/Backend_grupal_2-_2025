  import { pool } from "../../db_connection.js";

  // Obtener todas las detalles de compras 
  export const obtenerDetallesCompras = async (req, res) => {
    try {
      const [result] = await pool.query("SELECT * FROM ID_Detalles_Com");
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
      const ID_Detalles_Com = req.params.ID_Detalles_Com;
      const [result] = await pool.query(
        "SELECT * FROM Detalle_Compras WHERE ID_Detalles_Com= ?",
        [ID_Detalles_Com]
      );  
      if (result.length <= 0) {
        return res.status(404).json({
          mensaje: `Error al leer los datos. ID ${ID_Detalles_Com} no encontrado.`,
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
  export const registrarDetalleCompra = async (req, res) => {
    try {
      const { ID_Compra, ID_Producto, Cantidad_com, Precio_Com } = req.body;
      const [result] = await pool.query(
        'INSERT INTO Detalle_Compras ( ID_Compra, ID_Producto, Cantidad_com, Precio_Com) VALUES (?, ?, ?, ?)',
        [ ID_Compra, ID_Producto, Cantidad_com, Precio_Com]
      );
      res.status(201).json({ ID_Detalles_Com: result.insertId });
    } catch (error) {
      return res.status(500).json({
        mensaje: 'Ha ocurrido un error al registrar el detalle compra.',
        error: error
      });
    }
  };

   // Eliminar un detalle de compra por su ID
export const eliminarDetalleCompra = async (req, res) => {
  try {
    const ID_Detalles_Com = req.params.ID_Detalles_Com;
    const [result] = await pool.query(
      'DELETE FROM Detalle_Compras WHERE ID_Detalles_Com = ?',
      [ID_Detalles_Com]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        mensaje: `Error al eliminar el detalle compra. El ID ${ID_Detalles_Com} no fue encontrado.`
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


export const actualizarParcialDetalleCompra = async (req, res) => {
  try {
    const { ID_Detalles_Com } = req.params;
    const datos = req.body;

    const [result] = await pool.query(
      'UPDATE Detalle_Compras SET ? WHERE ID_Detalles_Com = ?',
      [datos, ID_Detalles_Com]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ mensaje: `Detalle Compra con ID ${ID_Detalles_Com} no encontrada.` });
    }

    res.status(200).json({ mensaje: `Detalle compra con ID ${ID_Detalles_Com} actualizada.` });
  } catch (error) {
    res.status(500).json({ mensaje: 'Error al actualizar el detalle.', error });
  }
};


