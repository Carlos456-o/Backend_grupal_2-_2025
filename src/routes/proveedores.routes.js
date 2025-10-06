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
router.get("/proveedor", obtenerProveedores);

// Ruta para obtener un cliente por su ID
router.get("/proveedores/:id_proveedor", obtenerProveedor);

// Ruta para registrar una nueva Categoría
router.post("/registrarProveedores", registrarProveedor);

//ruta para eliminar una venta por su ID
router.delete("/eliminarproveedores/:id_proveedor", eliminarProveedor);

router.delete(
  "/actualizarproveedores/:id_proveedor",
  actualizarProveedoresPatch
);

export default router;
