import { pool } from "../../db_connection.js";

// 🟩 Obtener todos los productos
export const obtenerProductos = async (req, res) => {
  try {
    const [result] = await pool.query("SELECT * FROM Productos");
    res.json(result);
  } catch (error) {
    res.status(500).json({
      mensaje: "Ha ocurrido un error al leer los datos.",
      error: error.message,
    });
  }
};

// 🟩 Obtener un producto por su ID
export const obtenerProducto = async (req, res) => {
  try {
    const { ID_Producto } = req.params;
    const [result] = await pool.query(
      "SELECT * FROM Productos WHERE ID_Producto = ?",
      [ID_Producto]
    );
    if (result.length === 0) {
      return res.status(404).json({
        mensaje: `Producto con ID ${ID_Producto} no encontrado.`,
      });
    }
    res.json(result[0]);
  } catch (error) {
    res.status(500).json({
      mensaje: "Error al obtener los datos del producto.",
      error: error.message,
    });
  }
};

// 🟩 Registrar un nuevo producto
export const registrarProducto = async (req, res) => {
  try {
    const { Nombre_P, Descripcion, Cantidad, PrecioCompra, PrecioVenta, Disponible } = req.body;

    if (!Nombre_P || !PrecioCompra || !PrecioVenta) {
      return res.status(400).json({
        mensaje: "Faltan datos requeridos para registrar el producto.",
      });
    }

<<<<<<< HEAD
    // Usa los nombres reales de tu tabla SQL
    const [result] = await pool.query(
      `INSERT INTO Productos (Nombre_P, Descripcion, Cantidad, PrecioCompra, PrecioVenta, Disponible)
       VALUES (?, ?, ?, ?, ?, ?)`,
      [Nombre_P, Descripcion, Cantidad || 0, PrecioCompra, PrecioVenta, Disponible ? 1 : 0]
    );
=======
// ➕ Registrar nuevo producto
export const registrarProducto = async (req, res) => {
  const { Nombre_P, Descripcion, Cantidad, Disponible, PrecioCompra, PrecioVenta } = req.body;

  if (!Nombre_P || PrecioCompra == null || PrecioVenta == null) {
    return res.status(400).json({ mensaje: "Faltan campos obligatorios" });
  }

  try {
    const sql = `
      INSERT INTO Productos (Nombre_P, Descripcion, Cantidad, Disponible, PrecioCompra, PrecioVenta)
      VALUES (?, ?, ?, ?, ?, ?)
    `;
    const [result] = await conexion.query(sql, [
      Nombre_P,
      Descripcion || null,
      Cantidad || 0,
      Disponible ?? true,
      PrecioCompra,
      PrecioVenta
    ]);

    res.status(201).json({ mensaje: "Producto registrado correctamente", id: result.insertId });
  } catch (error) {
    console.error("Error al registrar producto:", error);
    res.status(500).json({ mensaje: "Error al registrar producto" });
  }
}
>>>>>>> 88e98bb5de87694f7df8bb57f65161a95cdaf558

    res.status(201).json({
      mensaje: "Producto registrado correctamente.",
      id_producto: result.insertId,
    });
  } catch (error) {
    console.error("❌ Error al registrar producto:", error);
    res.status(500).json({
      mensaje: "Ha ocurrido un error al registrar el producto.",
      error: error.message,
    });
  }
};

// 🟩 Eliminar producto por ID
export const eliminarProducto = async (req, res) => {
  try {
    const { ID_Producto } = req.params;
    const [result] = await pool.query(
      "DELETE FROM Productos WHERE ID_Producto = ?",
      [ID_Producto]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        mensaje: `No se encontró el producto con ID ${ID_Producto}.`,
      });
    }

    res.status(200).json({
      mensaje: `Producto con ID ${ID_Producto} eliminado correctamente.`,
    });
  } catch (error) {
    res.status(500).json({
      mensaje: "Error al eliminar el producto.",
      error: error.message,
    });
  }
};

// 🟩 Actualizar producto
export const actualizarProductoPatch = async (req, res) => {
  try {
    const { ID_Producto } = req.params;
    const datos = req.body;

    const [result] = await pool.query(
      "UPDATE Productos SET ? WHERE ID_Producto = ?",
      [datos, ID_Producto]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        mensaje: `Producto con ID ${ID_Producto} no encontrado.`,
      });
    }

    res.status(200).json({
      mensaje: `Producto con ID ${ID_Producto} actualizado correctamente.`,
    });
  } catch (error) {
    res.status(500).json({
      mensaje: "Error al actualizar el producto.",
      error: error.message,
    });
  }
};
