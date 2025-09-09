
import { Router } from "express";
import { obtenerProducto, obtenerProductos, registrarProducto } from "../controllers/producto.controller.js";

const router = Router();

// Ruta para obtener todos los productos
router.get("/productos", obtenerProductos);

// Ruta para obtener un cliente por su ID
router.get('/productos/:id_producto', obtenerProducto);

// Ruta para registrar una nueva Categoría
router.post('/registrarProducto', registrarProducto);


export default router;
