import { Router } from "express";
import { obtenerDetallesVentas, obtenerDetalleVenta, registrarDetalleVenta, eliminarDetalleVenta, actualizarDetalleVentaPatch } from "../controllers/detalles_ventas.controller.js";

const router = Router();

// Ruta para obtener todos los detalles de ventas
router.get("/detallesventas", obtenerDetallesVentas);

// Ruta para obtenr un detalle de venta por su ID
router.get("/detallesventa/:ID_DetalleVenta", obtenerDetalleVenta);

// Ruta para registrar una nueva Categoría
router.post('/registrarDetalleVenta', registrarDetalleVenta);

//ruta para eliminar un detalle de compra por su ID
router.delete('/eliminardetalleventa/:ID_Detalle_ven', eliminarDetalleVenta);

router.put('/actualizardetalleventa/:ID_Detalle_ven', actualizarDetalleVentaPatch);

export default router;
