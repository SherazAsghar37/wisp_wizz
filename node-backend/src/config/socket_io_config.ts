import { Server, Socket } from "socket.io";

import http from "http";
import { container } from "tsyringe";
import SocketIOManager from "../services/socket_io_manager";
import SocketIOController from "../controllers/socket_io_controller";
export default function socketIoConfig(server: http.Server) {
  const io = new Server(server);
  const socketIOManager: SocketIOManager = container.resolve(SocketIOManager);
  const socketIOController: SocketIOController =
    container.resolve(SocketIOController);
  // Socket.io
  io.on("connection", (socket: Socket) => {
    console.log(`connected ${socket.id}`);
    socket.on("message", (newMessage) => {
      console.log(`${newMessage}`.green);
      socketIOController.onMessage(newMessage, io);
    });
    socket.on("login", (userId) => {
      console.log(`${userId}`.yellow);
      socketIOManager.userConnected(userId, socket);
    });
    socket.on("disconnect", (data) => {
      console.log(`disconnected ${socket.id} , ${data}`.red);
      socketIOManager.userDisconnected(socket);
    });
  });
}
