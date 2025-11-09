import { Router } from "express";
import {
  obtenerProductos,
  obtenerProducto,
  registrarProducto,
  eliminarProducto,
  actualizarProductoPatch
} from "../controllers/producto.controller.js";

const router = Router();

// ✅ Obtener todos los productos
router.get("/productos", obtenerProductos);

// ✅ Obtener un producto por su ID
router.get("/producto/:ID_Producto", obtenerProducto);

// ✅ Registrar un nuevo producto
router.post("/registrarproducto", registrarProducto);

// ✅ Actualizar un producto (PATCH)
router.patch("/actualizarproducto/:ID_Producto", actualizarProductoPatch);

<<<<<<< HEAD
// ✅ Eliminar un producto
router.delete("/eliminarproducto/:ID_Producto", eliminarProducto);
=======
router.patch('/actualizarproducto/:ID_Producto', actualizarProductoPatch);
>>>>>>> 88e98bb5de87694f7df8bb57f65161a95cdaf558

export default router;
