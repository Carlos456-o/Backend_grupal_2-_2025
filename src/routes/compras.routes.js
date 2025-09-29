
import { Router } from "express";
import { obtenerCompras, obtenerCompra, registrarCompra, eliminarCompra } from "../controllers/compra.controller.js";

const router = Router();

// Ruta para obtener todos los compras
router.get("/compras", obtenerCompras);

// Ruta para obtener un cliente por su ID
router.get("/compras/:ID_Compra", obtenerCompra);

// Ruta para registrar una nueva Categoría
router.post('/registrarCompra', registrarCompra);

// Ruta para eliminar una compra por su ID
router.delete('/eliminarcompra/:id_compra', eliminarCompra);


export default router;
