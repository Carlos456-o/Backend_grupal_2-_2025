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

// ✅ Eliminar un producto
router.delete("/eliminarproducto/:ID_Producto", eliminarProducto);

export default router;
