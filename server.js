import express from "express";
import cors from "cors";
import productoRoutes from "./routes/producto.routes.js";

const app = express();

app.use(cors());
app.use(express.json());

// ✅ Montar las rutas
app.use("/api", productoRoutes);

app.listen(3000, () => {
  console.log("Servidor corriendo en http://localhost:3000");
});
