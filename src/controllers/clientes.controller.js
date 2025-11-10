import { pool } from "../../db_connection.js";

//  Obtener todos los clientes
export const obtenerClientes = async (req, res) => {
  try {
    const [result] = await pool.query("SELECT * FROM Clientes");
    res.json(result);
  } catch (error) {
    return res.status(500).json({
      mensaje: "Ha ocurrido un error al leer los datos.",
      error: error.message,
    });
  }
};

//  Obtener un cliente por su ID
export const obtenerCliente = async (req, res) => {
  try {
    const { id_cliente } = req.params;
    const [result] = await pool.query(
      "SELECT * FROM Clientes WHERE ID_Cliente = ?",
      [id_cliente]
    );

    if (result.length === 0) {
      return res.status(404).json({
        mensaje: `No se encontró un cliente con el ID ${id_cliente}.`,
      });
    }

    res.json(result[0]);
  } catch (error) {
    return res.status(500).json({
      mensaje: "Ha ocurrido un error al leer los datos del cliente.",
      error: error.message,
    });
  }
};

//  Registrar un nuevo cliente
export const registrarCliente = async (req, res) => {
  try {
    const { Nombre1, Nombre2, Apellidos1, Apellidos2, Cedula, Telefono } = req.body;

    const [result] = await pool.query(
      `INSERT INTO Clientes (Nombre1, Nombre2, Apellidos1, Apellidos2, Cedula, Telefono)
       VALUES (?, ?, ?, ?, ?, ?)`,
      [Nombre1, Nombre2, Apellidos1, Apellidos2, Cedula, Telefono]
    );

    res.status(201).json({ ID_Cliente: result.insertId });
  } catch (error) {
    return res.status(500).json({
      mensaje: "Ha ocurrido un error al registrar el cliente.",
      error: error.message,
    });
  }
};

//  Eliminar un cliente por su ID
export const eliminarCliente = async (req, res) => {
  try {
    const { id_cliente } = req.params;
    const [result] = await pool.query(
      "DELETE FROM Clientes WHERE ID_Cliente = ?",
      [id_cliente]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        mensaje: `No se encontró un cliente con el ID ${id_cliente}.`,
      });
    }

    res.status(204).send(); // Eliminado correctamente (sin contenido)
  } catch (error) {
    return res.status(500).json({
      mensaje: "Ha ocurrido un error al eliminar el cliente.",
      error: error.message,
    });
  }
};

// Actualizar parcialmente un cliente por su ID
export const actualizarClientePatch = async (req, res) => {
  try {
    const { id_cliente } = req.params;
    const datos = req.body;

    const [result] = await pool.query(
      "UPDATE Clientes SET ? WHERE ID_Cliente = ?",
      [datos, id_cliente]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        mensaje: `No se encontró un cliente con el ID ${id_cliente}.`,
      });
    }

    res.status(200).json({
      mensaje: `Cliente con ID ${id_cliente} actualizado correctamente.`,
    });
  } catch (error) {
    res.status(500).json({
      mensaje: "Error al actualizar el cliente.",
      error: error.message,
    });
  }
};
