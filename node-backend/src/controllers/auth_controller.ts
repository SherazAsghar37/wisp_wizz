import { NextFunction, Request, Response } from "express";
import { inject, singleton } from "tsyringe";
import UserService from "../services/user_service";
import HttpStatusCode from "../utils/http_status_codes";
import { ErrorHandler } from "../exceptions/error_handler";
import { v4 as uuidv4 } from "uuid";
import ImageService from "../services/image_service";

@singleton()
export default class AuthController {
  constructor(
    @inject(UserService)
    private readonly _userServices: UserService,
    @inject(ImageService)
    private readonly _imageServices: ImageService,
    private readonly _errorHandler: ErrorHandler
  ) {}

  public signUp = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const uuid = uuidv4();
      var { name, phoneNumber, image } = req.body;
      let path: string = `/image/profile1`;
      if (image) {
        const bufferImage: Buffer = Buffer.from(image, "base64");
        path = await this._imageServices.saveImage(bufferImage, uuid);
      }
      const user: any = await this._userServices.signUpLocal(
        uuid,
        name,
        phoneNumber,
        path
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
            image: user.image,
          },
        })
      );
    } catch (error) {
      this._errorHandler.handleError(error, res);
    }
  };
}
