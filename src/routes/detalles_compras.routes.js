
import { Router } from "express";
import { obtenerDetalleCompra, obtenerDetallesCompras, registrarDetallecompra } from "../controllers/Detalles_compras.controller.js";

const router = Router();

// Ruta para obtener todos los detalles de ventas
router.get("/detallescompras", obtenerDetallesCompras);

// Ruta para obtenr un detalle de venta por su ID
router.get("/detallecompras/:id_detalle_compra", obtenerDetallesCompra);

// Ruta para registrar una nueva Categoría
router.post('/registrarDetallecompra', registrarDetallecompra);


export default router;
