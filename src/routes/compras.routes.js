
import { Router } from "express";
import { obtenerCompras, obtenerCompra, registrarCompra } from "../controllers/compra.controller.js";

const router = Router();

// Ruta para obtener todos los compras
router.get("/compras", obtenerCompras);

// Ruta para obtener un cliente por su ID
router.get('/compra/:id_compra', obtenerCompra);

// Ruta para registrar una nueva Categoría
router.post('/registrarcompra', registrarCompra);


export default router;
