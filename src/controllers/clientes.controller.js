import { pool } from "../../db_connection.js";

// Obtener todas las clientes
export const obtenerClientes = async (req, res) => {
  try {
    const [result] = await pool.query("SELECT * FROM Clientes");
    res.json(result);
  } catch (error) {
    return res.status(500).json({
      mensaje: "Ha ocurrido un error al leer los datos.",
      error: error,
    });
  }
};

// Obtener una categoría por su ID
export const obtenerCliente = async (req, res) => {
  try {
    const ID_Cliente = req.params.ID_Cliente;
    const [result] = await pool.query(
      "SELECT * FROM Clientes WHERE ID_Cliente= ?",
      [id_cliente]
    );
    if (result.length <= 0) {
      return res.status(404).json({
        mensaje: `Error al leer los datos. ID ${ID_Cliente} no encontrado.`,
      });
    }
    res.json(result[0]);
  } catch (error) {
    return res.status(500).json({
      mensaje: "Ha ocurrido un error al leer los datos de las clientes.",
    });
  }
};

// Registrar una nueva Cliente
export const registrarCliente = async (req, res) => {
  try {
    const { Nombre1, Nombre2, Apellidos1, Apellidos2, Cedula, Telefono } = req.body;
    const [result] = await pool.query(
      'INSERT INTO clientes ( Nombre1, Nombre2, Apellidos1, Apellidos2, Cedula, Telefono ) VALUES (?, ?, ?, ?, ?, ?)',
      [ Nombre1, Nombre2, Apellidos1, Apellidos2, Cedula, Telefono ]
    );
    res.status(201).json({ id_cliente: result.insertId });
  } catch (error) {
    return res.status(500).json({
      mensaje: 'Ha ocurrido un error al registrar el cliente.',
      error: error
    });
  } 
};
