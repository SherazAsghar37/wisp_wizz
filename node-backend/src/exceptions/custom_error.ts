import HttpStatusCode from "../utils/http_status_codes";

export default class CustomError extends Error {
  public message: string;
  public statusCode: HttpStatusCode;

  constructor(message: string, statusCode: HttpStatusCode) {
    super();
    this.message = message;
    this.statusCode = statusCode;
    Object.setPrototypeOf(this, CustomError.prototype);
  }

  httpCode(httpCode: any) {
    throw new Error("Method not implemented.");
  }
}
