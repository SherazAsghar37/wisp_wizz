import "reflect-metadata";
import http from "http";
import appConfig from "./src/config/app_config";
import dotenv from "dotenv";
import mongooseConfig from "./src/config/mongoose_config";
import colors from "colors";
import authRouter from "./src/routes/auth";
import userRouter from "./src/routes/user";
import socketIoConfig from "./src/config/socket_io_config";

colors;
dotenv.config();
const port = Number.parseInt(process.env.PORT as string) || 8000;

//config
const app = appConfig();
const server: http.Server = http.createServer(app);
socketIoConfig(server);

//server
app.listen(port, "192.168.1.104", () => {
  console.log(`Server is listening on ${port}`.yellow.bold);
});

//routes
app.use("/auth", authRouter);
app.use("/user", userRouter);

//mongooose config
mongooseConfig();
