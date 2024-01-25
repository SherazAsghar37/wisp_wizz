import express from "express";
import Validation from "../middlewares/validation";
import { container } from "tsyringe";
import AuthController from "../controllers/auth_controller";
const authRouter = express.Router();
const validation = container.resolve(Validation);
const authController = container.resolve(AuthController);

authRouter
  .route("/verification/sendOtp")
  .post(validation.phoneNumberValidator, authController.sendVerificationCode);
authRouter
  .route("/verification/verifyOtp")
  .post(validation.phoneNumberValidator, authController.sendVerificationCode);
authRouter
  .route("/login")
  .post(validation.phoneNumberValidator, authController.sendVerificationCode);

export default authRouter;
