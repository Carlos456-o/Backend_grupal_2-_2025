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
    const id_cliente = req.params.id_cliente;
    const [result] = await pool.query(
      "SELECT * FROM Clientes WHERE id_cliente= ?",
      [id_cliente]
    );
    if (result.length <= 0) {
      return res.status(404).json({
        mensaje: `Error al leer los datos. ID ${id_cliente} no encontrado.`,
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
    const { primer_nombre,
          segundo_nombre,
        primer_apellido,
      segundo_apellido, telefono, 
       cedula } 
    = req.body;
    const [result] = await pool.query(
      'INSERT INTO clientes (primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, telefono, cedula) VALUES (?, ?, ?, ?, ?, ?, ?)',
      [primer_nombre,
         segundo_nombre, primer_apellido, segundo_apellido, telefono, direccion, cedula ]
    );
    res.status(201).json({ id_categoria: result.insertId });
  } catch (error) {
    return res.status(500).json({
      mensaje: "Ha ocurrido un error al registrar la cliente.",
      error: error,
    });
  }
};
