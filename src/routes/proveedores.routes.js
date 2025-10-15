import { Router } from "express";
import {
  obtenerProveedores,
  obtenerProveedor,
  registrarProveedor,
  eliminarProveedor,
  actualizarProveedoresPatch,
} from "../controllers/proveedores.controller.js";

const router = Router();

// Ruta para obtener todos los detalles de ventas
router.get("/proveedores", obtenerProveedores);

// Ruta para obtener un cliente por su ID
router.get("/proveedor/:ID_Proveedor", obtenerProveedor);

// Ruta para registrar una nueva Categoría
router.post("/registrarProveedores", registrarProveedor);

//ruta para eliminar una venta por su ID
router.delete("/eliminarproveedores/:ID_Proveedor", eliminarProveedor);

router.delete(
  "/actualizarproveedores/:id_proveedor",
  actualizarProveedoresPatch
);

export default router;
