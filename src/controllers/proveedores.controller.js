import { pool } from "../../db_connection.js";

//  Obtener todos los proveedores
export const obtenerProveedores = async (req, res) => {
  try {
    const [result] = await pool.query("SELECT * FROM Proveedores");
    res.json(result);
  } catch (error) {
    return res.status(500).json({
      mensaje: "Ha ocurrido un error al leer los datos.",
      error: error.message,
    });
  }
};

//  Obtener un proveedor por su ID
export const obtenerProveedor = async (req, res) => {
  try {
    const { ID_Proveedor } = req.params;
    const [result] = await pool.query(
      "SELECT * FROM Proveedores WHERE ID_Proveedor = ?",
      [ID_Proveedor]
    );

    if (result.length === 0) {
      return res.status(404).json({
        mensaje: `Proveedor con ID ${ID_Proveedor} no encontrado.`,
      });
    }

    res.json(result[0]);
  } catch (error) {
    return res.status(500).json({
      mensaje: "Ha ocurrido un error al leer los datos del proveedor.",
      error: error.message,
    });
  }
};

//  Registrar un nuevo proveedor
export const registrarProveedor = async (req, res) => {
  try {
    const { Nombre_Prov, Contacto, Email } = req.body;

    const [result] = await pool.query(
      "INSERT INTO Proveedores (Nombre_Prov, Contacto, Email) VALUES (?, ?, ?)",
      [Nombre_Prov, Contacto, Email]
    );

    res.status(201).json({
      mensaje: "Proveedor registrado exitosamente.",
      ID_Proveedor: result.insertId,
    });
  } catch (error) {
    return res.status(500).json({
      mensaje: "Ha ocurrido un error al registrar el proveedor.",
      error: error.message,
    });
  }
};

//  Eliminar un proveedor por su ID
export const eliminarProveedor = async (req, res) => {
  try {
    const { ID_Proveedor } = req.params;

    const [result] = await pool.query(
      "DELETE FROM Proveedores WHERE ID_Proveedor = ?",
      [ID_Proveedor]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        mensaje: `Proveedor con ID ${ID_Proveedor} no encontrado.`,
      });
    }

    res.status(200).json({
      mensaje: `Proveedor con ID ${ID_Proveedor} eliminado correctamente.`,
    });
  } catch (error) {
    return res.status(500).json({
      mensaje: "Ha ocurrido un error al eliminar el proveedor.",
      error: error.message,
    });
  }
};

//  Actualizar un proveedor (PATCH)
export const actualizarProveedoresPatch = async (req, res) => {
  try {
    const { ID_Proveedor } = req.params;
    const datos = req.body;

    const [result] = await pool.query(
      "UPDATE Proveedores SET ? WHERE ID_Proveedor = ?",
      [datos, ID_Proveedor]
    );

    if (result.affectedRows === 0) {
      return res
        .status(404)
        .json({ mensaje: `Proveedor con ID ${ID_Proveedor} no encontrado.` });
    }

    res
      .status(200)
      .json({ mensaje: `Proveedor con ID ${ID_Proveedor} actualizado correctamente.` });
  } catch (error) {
    res.status(500).json({
      mensaje: "Error al actualizar el proveedor.",
      error: error.message,
    });
  }
};
