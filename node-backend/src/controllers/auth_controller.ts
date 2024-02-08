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
      const { name, phoneNumber, image, status, lastSeen } = req.body;

      const user: User = await this._userServices.signUpLocal(
        name,
        phoneNumber,
        image,
        status,
        lastSeen
      );
      return res.status(HttpStatusCode.OK).json(JSON.stringify({ user: user }));
    } catch (error) {
      this._errorHandler.handleError(error, res);
    }
  };
}
