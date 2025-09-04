
import { Router } from "express";
import { obtenerClientes } from "../controllers/clientes.controller.js";

const router = Router();

// Ruta para obtener todos los clientes
router.get("/clientes", obtenerClientes);

export default router;
// Note: The function name and the route path should be consistent with the functionality they provide.