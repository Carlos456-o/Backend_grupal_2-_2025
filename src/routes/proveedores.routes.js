import { Router } from "express";
import { obtenerProveedores, obtenerProveedor, registrarProveedor } from "../controllers/proveedores.controller.js";

const router = Router();

// Ruta para obtener todos los detalles de ventas
router.get("/proveedor", obtenerProveedores);

// Ruta para obtener un cliente por su ID
router.get('/proveedores/:id_proveedor', obtenerProveedor);

// Ruta para registrar una nueva Categoría
router.post('/registrarProveedores', registrarProveedor);

export default router;
