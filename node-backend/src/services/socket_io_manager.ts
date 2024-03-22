import { Socket } from "socket.io";
import { singleton } from "tsyringe";

@singleton()
class SocketIOManager {
  constructor(
    private _connectedUsers: Record<string, any> = {},
    private _connectedSockets: Record<string, any> = {}
  ) {}
  public userConnected = (userId: string, socket: Socket) => {
    const data = {
      userId: userId,
    };
    this._connectedUsers[socket.id] = userId;
    this._connectedSockets[userId] = socket.id;
  };

  public userDisconnected = (socket: Socket) => {
    const userId = this._connectedUsers[socket.id];
    delete this._connectedUsers[socket.id];
    delete this._connectedSockets[userId];
  };

  public checkUsersConnectionStatus = (userId: string): string | undefined => {
    return this._connectedSockets[userId];
  };
}
