
import { Router } from "express";
import { obtenerEmpleados } from "../controllers/empleado.controller.js";

const router = Router();

// Ruta para obtener todos los empleados
router.get("/empleado", obtenerEmpleados);

export default router;
