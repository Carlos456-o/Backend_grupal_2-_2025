import { Router } from "express";
import { obtenerDetallesVentas,obtenerDetalleVenta,registrardetalleventa } from "../controllers/detalles_ventas.controller.js";

const router = Router();

// Ruta para obtener todos los detalles de ventas
router.get("/detallesventas", obtenerDetallesVentas);

// Ruta para obtenr un detalle de venta por su ID
router.get("/detalleventa/:id_detalle_venta", obtenerDetalleVenta);

// Ruta para registrar una nueva Categoría
router.post('/registrardetalleventa', registrardetalleventa);

export default router;
