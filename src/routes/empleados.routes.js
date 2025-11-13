import { Router } from "express";
import { obtenerEmpleados, obtenerEmpleado, registrarEmpleado, eliminarEmpleado, actualizarEmpleadoPatch} from "../controllers/empleados.controller.js";

const router = Router();

// Ruta para obtener todos los detalles de ventas
router.get("/empleados", obtenerEmpleados);

// Ruta para obtenr un detalle de venta por su ID
router.get("/empleado/:ID_Empleado", obtenerEmpleado);

// Ruta para registrar una nueva Categoría
router.post('/registrarempleado', registrarEmpleado);

//ruta para eliminar un detalle de compra por su ID
router.delete('/eliminarempleado/:ID_Empleado', eliminarEmpleado);

// Ruta para actualizar un detalle de compra por su ID
router.put('/actualizarempleado/:ID_Empleado', actualizarEmpleadoPatch);

export default router;