
import { Router } from "express";
import { obtenerProducto } from "../controllers/producto.controller.js";

const router = Router();

// Ruta para obtener todos los productos
router.get("/producto", obtenerProducto);

export default router;
