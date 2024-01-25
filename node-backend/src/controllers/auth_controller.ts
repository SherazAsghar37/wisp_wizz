import { NextFunction, Request, Response } from "express";
import { inject, singleton } from "tsyringe";
// import UserService from "../services/user_service";
import HttpStatusCode from "../utils/http_status_codes";
import { ErrorHandler } from "../exceptions/error_handler";
import OtpService from "../services/opt_service";

@singleton()
export default class AuthController {
  constructor(
    // @inject(UserService)
    // private readonly _userServices: UserService,
    @inject(OtpService)
    private readonly _otpService: OtpService,
    private readonly _errorHandler: ErrorHandler
  ) {}
  public sendVerificationCode = async (
    req: Request,
    res: Response,
    next: NextFunction
  ) => {
    try {
      const { countryCode, phoneNumber } = req.body;
      const otpCode = await this._otpService.sendOtp(countryCode, phoneNumber);
      // const message = await this._otpService.createOtp(phoneNumber, otpCode);
      return res.status(HttpStatusCode.OK).json({ message: "sent" });
    } catch (error) {
      this._errorHandler.handleError(error, res);
    }
  };

  public verifyVerificationCode = async (
    req: Request,
    res: Response,
    next: NextFunction
  ) => {
    try {
      const { otp, phoneNumber } = req.body;
      const response = await this._otpService.verifyOtp(otp, phoneNumber);
      if (response) {
        return res
          .status(HttpStatusCode.OK)
          .json({ message: "Phone number verified!" });
      } else {
        return res
          .status(HttpStatusCode.UNAUTHORIZED)
          .json({ message: "Phone number verification failed!" });
      }
    } catch (error) {
      this._errorHandler.handleError(error, res);
    }
  };

  //   public signUp = async (req: Request, res: Response, next: NextFunction) => {
  //     try {
  //       const { email, password, gender, full_name } = req.body;

  //       const token = await this._userServices.signUpLocal(
  //         full_name,
  //         email,
  //         password,
  //         gender
  //       );
  //       return res.cookie("token", token).redirect("/home");
  //     } catch (error) {
  //       this._errorHandler.handleError(error, res);
  //     }
  //   };
}
