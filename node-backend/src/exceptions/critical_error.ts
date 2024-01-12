import HttpStatusCode from "../utils/http_status_codes";
import CustomError from "./custom_error";

export class ThrowCriticalError extends Error {
  constructor(error: any) {
    super();
    throw new CustomError(
      (error?.message as string) || "Internal Server Error",
      error?.httpCode || HttpStatusCode.INTERNAL_SERVER_ERROR
    );
  }
}
