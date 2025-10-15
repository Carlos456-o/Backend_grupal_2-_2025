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

  // Obtener un Proveedor por su ID
export const obtenerProveedor = async (req, res) => {
  try {
    const ID_Proveedor = req.params.ID_Proveedor;
    const [result] = await pool.query(
      "SELECT * FROM Proveedores WHERE ID_Proveedor= ?",
      [ID_Proveedor]
    );
    if (result.length <= 0) {
      return res.status(404).json({
        mensaje: `Error al leer los datos. ID ${ID_Proveedor} no encontrado.`,
      });
    }
    res.json(result[0]);
  } catch (error) {
    return res.status(500).json({
      mensaje: "Ha ocurrido un error al leer los datos de los Proveedores.",
    });
  }
};

// Registrar una nuevo Proveedor
export const registrarProveedor = async (req, res) => {
  try {
    const { Nombre_Prov,  Contacto, Email } = req.body;
    const [result] = await pool.query(
      'INSERT INTO Proveedor ( Nombre_Prov, Contacto, Email ) VALUES (?, ?, ?, ?, ?, ?)',
      [ Nombre_Prov, Contacto, Email ]
    );
    res.status(201).json({ ID_Proveedor: result.insertId });
  } catch (error) {
    return res.status(500).json({
      mensaje: 'Ha ocurrido un error al registrar el Proveedor.',
      error: error
    });
  } 
};

// Eliminar un proveedor por su ID
export const eliminarProveedor = async (req, res) => {
  try {
    const ID_Proveedor = req.params.ID_Proveedor;
    const [result] = await pool.query(
      'DELETE FROM Proveedor WHERE ID_Proveedor = ?',
      [ID_Proveedor]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        mensaje: `Error al eliminar el proveedor. El ID ${id_venta} no fue encontrado.`
      });
    }

    // Respuesta sin contenido para indicar éxito
    res.status(204).send();
  } catch (error) {
    return res.status(500).json({
      mensaje: 'Ha ocurrido un error al eliminar el proveedor.',
      error: error
    });
  }
};

export const actualizarProveedoresPatch = async (req, res) => {
  try {
    const ID_Proveedor = req.params.ID_Proveedor;
    const { Nombre_Prov, Contacto, Email} = req.body;
    const [result] = await pool.query(
      'UPDATE Proveedores SET Nombre_Prov = IFNULL(?, Nombre_Prov), Contacto = IFNULL(?, Contacto), Email = IFNULL(?, Email) WHERE ID_Proveedor = ?',
      [Nombre_Prov, Contacto, Email, ID_Proveedor]
    );
    if (result.affectedRows === 0) {
      return res.status(404).json({
        mensaje: `Error al actualizar el Proveedor. El ID ${ID_Proveedor} no fue encontrado.`,
      });
    }
    res.status(200).json({
      mensaje: `Proveedor con ID ${ID_Proveedor} actualizada correctamente.`
    });
  } catch (error) {
    return res.status(500).json({
      mensaje: 'Ha ocurrido un error al actualizar la Proveedor.',
      error: error
    });
  }
};