import "reflect-metadata";
import http from "http";
import appConfig from "./src/config/app_config";
import dotenv from "dotenv";
// import mongooseConfig from "./src/config/mongoose_config";
import colors from "colors";
import authRouter from "./src/routes/auth";
import userRouter from "./src/routes/user";
import socketIoConfig from "./src/config/socket_io_config";

colors;
dotenv.config();

const port = Number.parseInt(process.env.PORT as string) || 8000;
const socketPort = Number.parseInt(process.env.SOCKET_PORT as string) || 8001;
const ip = process.env.IP as string;

const app = appConfig();

const server = http.createServer(app);
socketIoConfig(server);

app.listen(port, ip, () => {
  console.log(`Server is listening on port ${ip}:${port}`.yellow.bold);
});
server.listen(socketPort, ip, () => {
  console.log(`Server is listening on port ${ip}:${socketPort}`.yellow.bold);
});

// Register routes
app.use("/auth", authRouter);
app.use("/user", userRouter);

//mongooseConfig();
