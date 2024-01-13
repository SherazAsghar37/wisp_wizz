import "reflect-metadata";
import express from "express";
import Validation from "../middlewares/validation";
import { container } from "tsyringe";
import AuthController from "../controllers/auth_controller";
const authRouter = express.Router();
const validation = container.resolve(Validation);
const authController = container.resolve(AuthController);

authRouter
  .route("auth/verification/send")
  .post(validation.phoneNumberValidator, authController.sendVerificationCode);
authRouter
  .route("auth/verification/send")
  .post(validation.phoneNumberValidator, authController.sendVerificationCode);
