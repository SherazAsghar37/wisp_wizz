import express from "express";
import Validation from "../middlewares/validation";
import { container } from "tsyringe";
import UserController from "../controllers/user_controller";
const userRouter = express.Router();
const validation = container.resolve(Validation);
const userController = container.resolve(UserController);

userRouter
  .route("/getUser")
  .post(validation.phoneNumberValidator, userController.getUser);
userRouter
  .route("/updateUser")
  .put(validation.userUpdateValidation, userController.updateUser);
userRouter
  .route("/getContacts")
  .post(validation.getContactsValidation, userController.getContacts);

export default userRouter;
