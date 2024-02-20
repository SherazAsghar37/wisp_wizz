import { Server, Socket } from "socket.io";
import http from "http";
export default function socketIoConfig(server: http.Server) {
  const io = new Server(server, {
    cors: {
      origin: "*",
    },
  });
  io.on("connection", (socket: Socket) => {
    console.log("A User Connected");
    socket.on("disconnect", () => {
      console.log("A User Disconnected");
    });
  });
}
