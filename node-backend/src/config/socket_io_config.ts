import { Server, Socket } from "socket.io";

import http from "http";
import { container } from "tsyringe";
import SocketIOManager from "../services/socket_io_manager";
export default function socketIoConfig(server: http.Server) {
  const io = new Server(server);
  const socketIOManager: SocketIOManager = container.resolve(SocketIOManager);
  // Socket.io
  io.on("connection", (socket: Socket) => {
    console.log(`connected ${socket.id}`);

    socket.on("message", (message) => {
      console.log(`message recieved and data : ${message}`.blue);
    });
    socket.on("disconnect", (data) => {
      console.log(`disconnected ${socket.id}`);
    });
  });
}
