import { Router } from "express";
import { obtenerProveedores, obtenerProveedor, registrarProveedores } from "../controllers/proveedores.controller.js";

const router = Router();

// Ruta para obtener todos los detalles de ventas
router.get("/proveedores", obtenerProveedores);

// Ruta para obtener un cliente por su ID
router.get('/proveedores/:id_producto', obtenerProveedor);

// Ruta para registrar una nueva Categoría
router.post('/registrarProveedores', registrarProveedores);

export default router;
