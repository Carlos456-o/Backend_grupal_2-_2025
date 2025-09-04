import { Router } from "express";
import { obtenerProveedores } from "../controllers/proveedores.controller.js";

const router = Router();

// Ruta para obtener todos los detalles de ventas
router.get("/proveedores", obtenerProveedores);

export default router;
