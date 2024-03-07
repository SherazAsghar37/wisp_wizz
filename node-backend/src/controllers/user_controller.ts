import { NextFunction, Request, Response } from "express";
import { inject, singleton } from "tsyringe";
import UserService from "../services/user_service";
import HttpStatusCode from "../utils/http_status_codes";
import { ErrorHandler } from "../exceptions/error_handler";
import { User } from "../@types/user";
import { AnyMxRecord } from "dns";
import { Readable } from "stream";
import { stdout } from "process";

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
              id: user.id,
              name: user.name,
              phoneNumber: user.phoneNumber,
              status: user.status,
              lastSeen: user.lastSeen,
              image: user.image.toString("base64"),
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
      var newRec: Record<string, any> = {};
      newRec.id = data.id;
      if (data.name) {
        newRec.name = data.name;
      }
      if (data.image) {
        const bufferImage: Buffer = Buffer.from(data.image, "base64");
        newRec.image = bufferImage;
      }
      console.log(newRec);
      const user: any | null = await this._userServices.updateUser(newRec);
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
    } catch (error) {
      this._errorHandler.handleError(error, res);
    }
  };
  public getContacts = async (
    req: Request,
    res: Response,
    next: NextFunction
  ) => {
    try {
      const { contacts } = req.body;

      const users: Array<any> = await this._userServices.fetchContacts(
        contacts
      );
      console.log(users);
      return await res.status(HttpStatusCode.OK).json(
        JSON.stringify({
          users: users.map((e) => {
            return {
              id: e.id,
              name: e.name,
              phoneNumber: e.phoneNumber,
              image: e.image.toString("base64"),
            };
          }),
        })
      );
    } catch (error) {
      this._errorHandler.handleError(error, res);
    }
  };
  // public getContacts = async (
  //   req: Request,
  //   res: Response,
  //   next: NextFunction
  // ) => {
  //   try {
  //     const { contacts } = req.body;

  //     const users: Readable = await this._userServices.fetchContacts(contacts);
  //     // res.writeHead(200, { "Content-Type": "application/json" });
  //     users.on("data", (user) => {
  //       const e = JSON.parse(user);
  //       res.send(
  //         JSON.stringify({
  //           id: e.id,
  //           name: e.name,
  //           phoneNumber: e.phoneNumber,
  //           image: e.image.toString("base64"),
  //         })
  //       );
  //     });
  //     users.on("end", () => {
  //       console.log("end");
  //       return res.end();
  //     });
  //     users.on("error", () => {
  //       this._errorHandler.handleError("something went wrong", res);
  //     });
  //   } catch (error) {
  //     this._errorHandler.handleError(error, res);
  //   }
  // };
}
