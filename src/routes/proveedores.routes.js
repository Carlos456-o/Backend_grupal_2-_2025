import { Router } from "express";
import {
  obtenerProveedores,
  obtenerProveedor,
  registrarProveedor,
  eliminarProveedor,
  actualizarProveedoresPatch,
} from "../controllers/proveedores.controller.js";

const router = Router();

//  Obtener todos los proveedores
router.get("/proveedores", obtenerProveedores);

//  Obtener un proveedor por su ID
router.get("/proveedor/:ID_Proveedor", obtenerProveedor);

//  Registrar un nuevo proveedor
router.post("/registrarProveedores", registrarProveedor);

//  Eliminar un proveedor por su ID
router.delete("/eliminarProveedores/:ID_Proveedor", eliminarProveedor);

//  Actualizar un proveedor (parcialmente)
router.patch("/actualizarProveedores/:ID_Proveedor", actualizarProveedoresPatch);

export default router;

