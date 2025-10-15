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
      [ID_Cliente]
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

// Eliminar una categoría por su ID
export const eliminarCliente = async (req, res) => {
  try {
    const id_cliente = req.params.id_cliente;
    const [result] = await pool.query(
      'DELETE FROM Clientes WHERE id_cliente = ?',
      [id_cliente]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        mensaje: `Error al eliminar el cliente. El ID ${id_cliente} no fue encontrado.`
      });
    }

    // Respuesta sin contenido para indicar éxito
    res.status(204).send();
  } catch (error) {
    return res.status(500).json({
      mensaje: 'Ha ocurrido un error al eliminar el cliente.',
      error: error
    });
  }
};

//Controlador para actualizar un cliente por su ID
export const actualizarClientePatch = async (req, res) => {
  try {
    const id_cliente = req.params.id_cliente;
    const { Nombre1
      , Nombre2,
      Apellidos1,
      Apellidos2, Cedula
      ,Telefono } = req.body;
    const [result] = await pool.query(
      'UPDATE clientes SET Nombre1 = IFNULL(?, Nombre1), Nombre2 = IFNULL(?, Nombre2), Apellidos1 = IFNULL(?, Apellidos1), Apellidos2 = IFNULL(?, Apellidos2), cedula = IFNULL(?, cedula), telefono = IFNULL(?, telefono) WHERE id_cliente = ?',
      [Nombre1
        , Nombre2, Apellidos1, Apellidos2, Cedula, Telefono, id_cliente]
    );
    if (result.affectedRows === 0) {
      return res.status(404).json({
        mensaje: `Error al actualizar el Cliente. El ID ${id_cliente} no fue encontrado.`,
      });
    }
    res.status(200).json({
    mensaje: `Cliente con ID ${id_cliente} actualizado correctamente.`
    });
  }
  catch (error) {
    return res.status(500).json({
      mensaje: 'Ha ocurrido un error al actualizar el Cliente.',
      error: error
    });
  }
};