import { inject, singleton } from "tsyringe";
import SocketIOManager from "../services/socket_io_manager";
import { v4 as uuidV4 } from "uuid";
@singleton()
class SocketIOController {
  constructor(
    @inject(SocketIOManager)
    private readonly _socketIOManager: SocketIOManager
  ) {}
  public onMessage = (newMessage: any, socket: any) => {
    const uuid = uuidV4();

    const { senderId, recipientId, chatId } = newMessage;
    newMessage["messageId"] = uuid;
    console.log(newMessage);
    const connectionStatus =
      this._socketIOManager.checkUsersConnectionStatus(recipientId);
    if (connectionStatus) {
      console.log("here");
      socket.emit(`message${recipientId}`, newMessage);
    }
    console.log(`res ${recipientId}`.blue);
    console.log(`sender ${senderId}`.blue);
    console.log(`chatId ${chatId}`.blue);
    // socket.emit(`message${recipientId}`, newMessage);
    // socket.emit(`message${recipientId}`, "test passed");
  };
}

export default SocketIOController;
