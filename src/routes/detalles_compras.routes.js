
import { Router } from "express";
import { obtenerDetalleCompra, obtenerDetallesCompras, registrarCompra, eliminarDetalleCompra,
    actualizarParcialDetalleCompra
 } from "../controllers/Detalles_compras.controller.js";

const router = Router();

// Ruta para obtener todos los detalles de ventas
router.get("/detallescompras", obtenerDetallesCompras);

// Ruta para obtenr un detalle de venta por su ID
router.get("/detallescompras/:ID_DetalleCompra", obtenerDetalleCompra);

// Ruta para registrar una nueva Categoría
router.post('/registrarDetalleCompra', registrarCompra);

//ruta para eliminar un detalle de compra por su ID
router.delete('/eliminardetallecompra/:id_detalle_compra', eliminarDetalleCompra);

// Ruta para actualizar un detalle de compra por su ID
router.put('/actualizardetallecompra/:id_detalle_compra', actualizarParcialDetalleCompra);

export default router;
