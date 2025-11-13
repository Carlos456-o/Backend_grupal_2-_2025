import { pool } from "../../db_connection.js";

//  Obtener todos los empleados
export const obtenerEmpleados = async (req, res) => {
  try {
    const [result] = await pool.query("SELECT * FROM Empleados");
    res.json(result);
  } catch (error) {
    return res.status(500).json({
      mensaje: "Ha ocurrido un error al leer los datos.",
      error: error.message,
    });
  }
};

//  Obtener un empleado por su ID
export const obtenerEmpleado = async (req, res) => {
  try {
    const { ID_Empleado } = req.params;
    const [result] = await pool.query(
      "SELECT * FROM Empleados WHERE ID_Empleado = ?",
      [ID_Empleado]
    );

    if (result.length === 0) {
      return res.status(404).json({
        mensaje: `No se encontró un empleado con el ID ${ID_Empleado}.`,
      });
    }

    res.json(result[0]);
  } catch (error) {
    return res.status(500).json({
      mensaje: "Ha ocurrido un error al leer los datos del empleado.",
      error: error.message,
    });
  }
};

//  Registrar un nuevo empleado
export const registrarEmpleado = async (req, res) => {
  try {
    const { Nombre, Apellido, Telefono, Email, Cargo } = req.body;

    const [result] = await pool.query(
      `INSERT INTO Empleados (Nombre, Apellido, Telefono, Email, Cargo)VALUES (?, ?, ?, ?, ?)`,
      [Nombre, Apellido, Telefono, Email, Cargo]
    );

    res.status(201).json({ ID_Empleado: result.insertId });
  } catch (error) {
    return res.status(500).json({
      mensaje: "Ha ocurrido un error al registrar el empleado.",
      error: error.message,
    });
  }
};

//  Eliminar un empleado por su ID
export const eliminarEmpleado = async (req, res) => {
  try {
    const { ID_Empleado } = req.params;
    const [result] = await pool.query(
      "DELETE FROM Empleados WHERE ID_Empleado = ?",
      [ID_Empleado]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        mensaje: `No se encontró un empleado con el ID ${ID_Empleado}.`,
      });
    }

    res.status(204).send(); // Eliminado correctamente (sin contenido)
  } catch (error) {
    return res.status(500).json({
      mensaje: "Ha ocurrido un error al eliminar el empleado.",
      error: error.message,
    });
  }
};

// Actualizar parcialmente un cliente por su ID
export const actualizarEmpleadoPatch = async (req, res) => {
  try {
    const { ID_Empleado } = req.params;
    const datos = req.body;

    const [result] = await pool.query(
      "UPDATE Empleados SET ? WHERE ID_Empleado = ?",
      [datos, ID_Empleado]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        mensaje: `No se encontró un Empleado con el ID ${ID_Empleado}.`,
      });
    }

    res.status(200).json({
      mensaje: `Empleado con ID ${ID_Empleado} actualizado correctamente.`,
    });
  } catch (error) {
    res.status(500).json({
      mensaje: "Error al actualizar el Empleado.",
      error: error.message,
    });
  }
};
