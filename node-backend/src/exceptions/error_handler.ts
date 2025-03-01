import { Response } from "express";
import CustomError from "./custom_error";
import HttpStatusCode from "../utils/http_status_codes";
import { singleton } from "tsyringe";

@singleton()
export class ErrorHandler {
  private isTrustedError(error: Error): boolean {
    return error instanceof CustomError;
  }

  private handleTrustedError(error: CustomError, response: Response): void {
    response.status(error.statusCode).json({ message: error.message });
  }

  private handleCriticalError(
    error: Error | CustomError,
    response?: Response
  ): void {
    if (response) {
      console.trace(error);
      response
        .status(HttpStatusCode.INTERNAL_SERVER_ERROR)
        .json({ message: "Internal server error" });
    }

    console.log("Application encountered a critical error".red);
    // process.exit(1);
  }

  public handleError(
    error: Error | CustomError | any,
    response?: Response
  ): void {
    if (this.isTrustedError(error) && response) {
      this.handleTrustedError(error as CustomError, response);
    } else {
      console.log("!!!Criticial Error!!!", error);
      this.handleCriticalError(error, response);
    }
  }
}
