import { Router } from "express";
import {
  obtenerProductos,
  obtenerProducto,
  registrarProducto,
  eliminarProducto,
  actualizarProductoPatch
} from "../controllers/producto.controller.js";

const router = Router();


router.get("/productos", obtenerProductos);


router.get("/producto/:ID_Producto", obtenerProducto);

router.post("/registrarproducto", registrarProducto);


router.patch("/actualizarproducto/:ID_Producto", actualizarProductoPatch);



router.delete("/eliminarproducto/:ID_Producto", eliminarProducto);

router.patch('/actualizarproducto/:ID_Producto', actualizarProductoPatch);


export default router;
