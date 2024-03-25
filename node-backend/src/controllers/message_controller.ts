import { NextFunction, Request, Response } from "express";
import { inject, singleton } from "tsyringe";
import UserService from "../services/user_service";
import HttpStatusCode from "../utils/http_status_codes";
import { ErrorHandler } from "../exceptions/error_handler";
import { Socket } from "socket.io";

@singleton()
export default class MessageController {
  constructor() {}
  //   public sendMessage = async (socket:Socket,message:any) => {
  //     try {

  //     } catch (error) {
  //       return "something went woring"
  //     }
  //   };
}
