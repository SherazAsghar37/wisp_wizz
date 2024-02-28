import { NextFunction, Request, Response } from "express";
import { inject, singleton } from "tsyringe";
import UserService from "../services/user_service";
import HttpStatusCode from "../utils/http_status_codes";
import { ErrorHandler } from "../exceptions/error_handler";
import { User } from "../@types/user";

@singleton()
export default class AuthController {
  constructor(
    @inject(UserService)
    private readonly _userServices: UserService,
    private readonly _errorHandler: ErrorHandler
  ) {}

  public signUp = async (req: Request, res: Response, next: NextFunction) => {
    try {
      var { name, phoneNumber, image } = req.body;
      const bufferImage: Buffer = Buffer.from(image, "base64");
      const user: any = await this._userServices.signUpLocal(
        name,
        phoneNumber,
        bufferImage
      );
      console.log(user);
      return res.status(HttpStatusCode.OK).json(
        JSON.stringify({
          user: {
            id: user.id,
            name: user.name,
            phoneNumber: user.phoneNumber,
            status: user.status,
            lastSeen: user.lastSeen,
            image: user.image.toString("base64"),
          },
        })
      );

      // return res.status(HttpStatusCode.OK).json(
      //   JSON.stringify({
      //     user,
      //   })
      // );
    } catch (error) {
      this._errorHandler.handleError(error, res);
    }
  };
}
