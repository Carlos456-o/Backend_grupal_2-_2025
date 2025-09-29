
import { Router } from "express";
import { obtenerVentas, obtenerVenta, registrarVenta, eliminarVenta } from "../controllers/ventas.controller.js";

const router = Router();

// Ruta para obtener todos los usuarios
router.get("/ventas", obtenerVentas);

// Ruta para obtenr un usuario por su ID
router.get("/ventas/:ID_Venta", obtenerVenta);

// Ruta para registrar una nueva Categoría
router.post('/registrarVenta', registrarVenta);

//ruta para eliminar una venta por su ID
router.delete('/eliminarventa/:id_venta', eliminarVenta);


export default router;