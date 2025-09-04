//Importar las dependencias necesartas
import express from 'express';
import cors from 'cors';

//Importar las rutas
import rutasProducto from "./src/routes/producto.routes.js";
import rutasVentas from "./src/routes/ventas.routes.js";
import rutasDetallesVentas from "./src/routes/detalle_ventas.routes.js"; 
import rutasCompras from "./src/routes/compras.routes.js";
import rutasDetallesCompras from "./src/routes/detalles_compras.routes.js";
import rutasProveedores from "./src/routes/proveedores.routes.js";
import rutasClientes from "./src/routes/clientes.routes.js";

// Crear la aplicación de Express
const app = express();

// Habilitar CORS para cualquier origen
app.use(cors({
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'],
  allowedHeaders: ['Content-Type']
}));

// Middleware para parsear el cuerpo de las solicitudes
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ limit: '10mb', extended: true }));

// Rutas
app.use("/api", rutasProducto);
app.use("/api", rutasVentas);
app.use("/api", rutasDetallesVentas);
app.use("/api", rutasCompras);
app.use("/api", rutasDetallesCompras);
app.use("/api", rutasClientes);
app.use("/api", rutasProveedores);


// Manejo de rutas no encontradas
app.use((req, res, next) => {
  res.status(404).json({ message: "La ruta que ha especificado no se encuentra registrada." });
});

// Exportar la aplicación
export default app;