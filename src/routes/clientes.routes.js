
import { Router } from "express";
import { obtenerClientes, obtenerCliente, registrarCliente } from "../controllers/clientes.controller.js";

const router = Router();

// Ruta para obtener todos los clientes
router.get("/clientes", obtenerClientes);

// Ruta para obtener un cliente por su ID
router.get("/clientes/:ID_Cliente", obtenerCliente);

// Ruta para registrar una nueva Categoría
router.post('/registrarCliente', registrarCliente);

export default router;
// Note: The function name and the route path should be consistent with the functionality they provide.