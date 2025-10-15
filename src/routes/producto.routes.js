
import { Router } from "express";
import { obtenerProductos, obtenerProducto, registrarProducto, eliminarProducto, actualizarProductoPatch } from "../controllers/producto.controller.js";

const router = Router();

// Ruta para obtener todos los productos
router.get("/productos", obtenerProductos);

// Ruta para obtener un cliente por su ID
router.get("/producto/:ID_Producto", obtenerProducto);

// Ruta para registrar una nueva Categoría
router.post('/registrarproducto', registrarProducto);

//ruta para eliminar un producto por su ID
router.delete('/eliminarproducto/:ID_Producto', eliminarProducto);

router.delete('/actualizarproducto/:ID_Producto', actualizarProductoPatch);

export default router;
