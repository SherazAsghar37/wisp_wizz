import { NextFunction } from "express";
import z, { ZodError } from "Zod";
import { Request, Response } from "express";
import { singleton } from "tsyringe";
import HttpStatusCode from "../utils/http_status_codes";

@singleton()
export default class Validation {
  public phoneNumberValidator = (
    req: Request,
    res: Response,
    next: NextFunction
  ) => {
    const numberSchema = z.object({
      countryCode: z.string().startsWith("+"),
      phoneNumber: z.string().min(7, "Invalid Phone number"),
    });
    try {
      numberSchema.parse({
        countryCode: req.body.phoneNumber,
        phoneNumber: req.body.phoneNumber,
      });
      console.log(req.body);
      return next();
    } catch (error) {
      if (error instanceof ZodError) return this.zodErrorHandler(error, res);
      return res
        .status(HttpStatusCode.INTERNAL_SERVER_ERROR)
        .json({ message: "some thing went wrong" });
    }
  };
  public userUpdateValidation = (
    req: Request,
    res: Response,
    next: NextFunction
  ) => {
    const userSchema = z.object({
      id: z.string(),
    });
    try {
      userSchema.parse(req.body);
      return next();
    } catch (error) {
      if (error instanceof ZodError) return this.zodErrorHandler(error, res);
      return res
        .status(HttpStatusCode.INTERNAL_SERVER_ERROR)
        .json({ message: "some thing went wrong" });
    }
  };
  public getContactsValidation = (
    req: Request,
    res: Response,
    next: NextFunction
  ) => {
    const userSchema = z.object({
      contacts: z.array(z.string()),
    });
    try {
      userSchema.parse(req.body);
      return next();
    } catch (error) {
      if (error instanceof ZodError) return this.zodErrorHandler(error, res);
      return res
        .status(HttpStatusCode.INTERNAL_SERVER_ERROR)
        .json({ message: "some thing went wrong" });
    }
  };
  public userSignUpValidator = (
    req: Request,
    res: Response,
    next: NextFunction
  ) => {
    const userSchema = z.object({
      countryCode: req.body.phoneNumber,
      phoneNumber: req.body.phoneNumber,
    });
    try {
      const user = req.body;
      console.log(user);
      userSchema.parse(user);
      return next();
    } catch (error) {
      if (error instanceof ZodError) return this.zodErrorHandler(error, res);
      return res
        .status(HttpStatusCode.INTERNAL_SERVER_ERROR)
        .json({ message: "some thing went wrong" });
    }
  };

  public zodErrorHandler = (error: ZodError, res: Response): Response => {
    const response = error.errors.map((err) => {
      return {
        field: err.path.join("."),
        message:
          err.message === "Request"
            ? `Field ${err.path.join(".")} is required`
            : err.message,
      };
    });
    return res.status(HttpStatusCode.FORBIDDEN).json({
      message: "validation failed",
      error: response,
    });
  };
}
