
import { Router } from "express";
import { obtenerVentas } from "../controllers/ventas.controller.js";

const router = Router();

// Ruta para obtener todos los usuarios
router.get("/ventas", obtenerVentas);

// Ruta para obtenr una venta por su ID
router.get("/venta/:id_venta", obtenerVenta);

// Ruta para registrar una nueva Categoría
router.post('/registrarVenta', registrarVenta);

export default router;