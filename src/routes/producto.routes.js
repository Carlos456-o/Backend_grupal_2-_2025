
import { Router } from "express";
import { obtenerProductos, obtenerProducto, registrarProducto, eliminarProducto } from "../controllers/producto.controller.js";

const router = Router();

// Ruta para obtener todos los productos
router.get("/productos", obtenerProductos);

// Ruta para obtener un cliente por su ID
router.get("/compras/:ID_Compra", obtenerProducto);

// Ruta para registrar una nueva Categoría
router.post('/registrarProducto', registrarProducto);

//ruta para eliminar un producto por su ID
router.delete('/eliminarproducto/:id_producto', eliminarProducto);

export default router;
