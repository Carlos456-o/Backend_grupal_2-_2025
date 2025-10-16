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
      'INSERT INTO Clientes ( Nombre1, Nombre2, Apellidos1, Apellidos2, Cedula, Telefono ) VALUES (?, ?, ?, ?, ?, ?)',
      [ Nombre1, Nombre2, Apellidos1, Apellidos2, Cedula, Telefono ]
    );
    res.status(201).json({ ID_Cliente: result.insertId });
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
    const ID_Cliente = req.params.ID_Cliente;
    const [result] = await pool.query(
      'DELETE FROM Clientes WHERE ID_Cliente = ?',
      [ID_Cliente]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        mensaje: `Error al eliminar el cliente. El ID ${ID_Cliente} no fue encontrado.`
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
    const ID_Cliente = req.params.ID_Cliente;
    const { Nombre1
      , Nombre2,
      Apellidos1,
      Apellidos2, Cedula
      ,Telefono } = req.body;
    const [result] = await pool.query(
      'UPDATE clientes SET Nombre1 = IFNULL(?, Nombre1), Nombre2 = IFNULL(?, Nombre2), Apellidos1 = IFNULL(?, Apellidos1), Apellidos2 = IFNULL(?, Apellidos2), Cedula = IFNULL(?, Cedula), Telefono = IFNULL(?, Telefono) WHERE ID_Cliente = ?',
      [Nombre1
        , Nombre2, Apellidos1, Apellidos2, Cedula, Telefono, ID_Cliente]
    );
    if (result.affectedRows === 0) {
      return res.status(404).json({
        mensaje: `Error al actualizar el Cliente. El ID ${ID_Cliente} no fue encontrado.`,
      });
    }
    res.status(200).json({
    mensaje: `Cliente con ID ${ID_Cliente} actualizado correctamente.`
    });
  }
  catch (error) {
    return res.status(500).json({
      mensaje: 'Ha ocurrido un error al actualizar el Cliente.',
      error: error
    });
  }
};