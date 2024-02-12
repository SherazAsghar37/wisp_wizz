import { NextFunction, Request, Response } from "express";
import { inject, singleton } from "tsyringe";
import UserService from "../services/user_service";
import HttpStatusCode from "../utils/http_status_codes";
import { ErrorHandler } from "../exceptions/error_handler";
import { User } from "../@types/user";

@singleton()
export default class UserController {
  constructor(
    @inject(UserService)
    private readonly _userServices: UserService,
    private readonly _errorHandler: ErrorHandler
  ) {}
  public getUser = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { phoneNumber } = req.body;
      const user: any | null = await this._userServices.getUser(phoneNumber);
      console.log(user);
      if (user) {
        return res.status(HttpStatusCode.OK).json(
          JSON.stringify({
            user: {
              _id: user["_id"],
              name: user.name,
              phoneNumber: user.phoneNumber,
              status: user.status,
              lastSeen: user.lastSeen,
              image: user.image.data.toString("base64"),
            },
          })
        );
      } else {
        return res.status(HttpStatusCode.OK).json(
          JSON.stringify({
            user: null,
          })
        );
      }
    } catch (error) {
      this._errorHandler.handleError(error, res);
    }
  };
  public updateUser = async (
    req: Request,
    res: Response,
    next: NextFunction
  ) => {
    try {
      const data = req.body;
      const user: any | null = await this._userServices.updateUser(data);
      console.log(data);
      var newRec: Record<string, any> = {};
      if (data.name) {
        newRec.name = data.name;
      }
      if (data.image) {
        const bufferImage: Buffer = Buffer.from(data.image, "base64");
        newRec.image = { data: bufferImage, contentType: "image/png" };
      }
      return res.status(HttpStatusCode.OK).json(
        JSON.stringify({
          user: {
            _id: user["_id"],
            name: user.name,
            phoneNumber: user.phoneNumber,
            status: user.status,
            lastSeen: user.lastSeen,
            image: user.image.data.toString("base64"),
          },
        })
      );
    } catch (error) {
      this._errorHandler.handleError(error, res);
    }
  };
}
