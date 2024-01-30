import { NextFunction, Request, Response } from "express";
import { inject, singleton } from "tsyringe";
import UserService from "../services/user_service";
import HttpStatusCode from "../utils/http_status_codes";
import { ErrorHandler } from "../exceptions/error_handler";

@singleton()
export default class UserController {
  constructor(
    @inject(UserService)
    private readonly _userServices: UserService,
    private readonly _errorHandler: ErrorHandler
  ) {}
  public getUser = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { countryCode, phoneNumber } = req.body;
      const user = await this._userServices.getUser(phoneNumber, countryCode);
      return res.status(HttpStatusCode.OK).json(JSON.stringify({ user: user }));
    } catch (error) {
      this._errorHandler.handleError(error, res);
    }
  };
}
