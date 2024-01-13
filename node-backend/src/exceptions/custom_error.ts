import HttpStatusCode from "../utils/http_status_codes";

export default class CustomError extends Error {
  httpCode(httpCode: any) {
    throw new Error("Method not implemented.");
  }
  public message: string;
  public statusCode: HttpStatusCode;

  constructor(message: string, statusCode: HttpStatusCode) {
    super();
    this.message = message;
    this.statusCode = statusCode;
    Object.setPrototypeOf(this, CustomError.prototype);
  }
}
