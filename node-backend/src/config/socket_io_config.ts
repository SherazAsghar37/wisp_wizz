import { Server, Socket } from "socket.io";
import http from "http";
export default function socketIoConfig(server: http.Server) {
  const io = new Server(server);
  // Socket.io
  io.on("connection", (socket) => {
    console.log("connected");

    socket.on("message", (message) => {
      console.log(`message recieved and data : ${message}`.blue);
    });
  });
}
