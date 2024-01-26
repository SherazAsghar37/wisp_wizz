import express from "express";
import Validation from "../middlewares/validation";
import { container } from "tsyringe";
import UserController from "../controllers/user_controller";
const userRouter = express.Router();
const validation = container.resolve(Validation);
const userController = container.resolve(UserController);

userRouter
  .route("/getUser")
  .post(validation.phoneNumberValidator, userController.getUser)
  .get((req, res) => {
    res.end("hi");
  });

export default userRouter;
