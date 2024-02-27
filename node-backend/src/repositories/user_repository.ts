import { User } from "../@types/user";
import CustomError from "../exceptions/custom_error";
import userModel from "../models/user";
import db from "../utils/db.server";
import HttpStatusCode from "../utils/http_status_codes";

export default class UserRepository {
  public createByLocal = async (
    data: Pick<User, "name" | "phoneNumber" | "image">
  ): Promise<User> => {
    try {
      console.log("Before creating user...");

      const newUser = await db.user.create({
        data: {
          name: data.name,
          phoneNumber: data.phoneNumber,
          image: data.image == undefined ? null : data.image,
        },
      });

      if (newUser) {
        return newUser as User;
      } else {
        console.log("here");
        throw new CustomError("Failed to create user", HttpStatusCode.CONFLICT);
      }
    } catch (error) {
      console.log(error);
      throw new CustomError(`${error}`, HttpStatusCode.INTERNAL_SERVER_ERROR);
    }
  };

  public updateUser = async (
    data: Pick<User, "name" | "phoneNumber" | "image">
  ): Promise<User> => {
    try {
      console.log(`Before updating user... ${data}`);
      const newUser = await db.user.update({
        where: {
          phoneNumber: data.phoneNumber,
        },
        data: {
          name: data.name,
          phoneNumber: data.phoneNumber,
          image: data.image,
        },
      });

      console.log("After updating user...");

      if (newUser) {
        return newUser as User;
      } else {
        console.log("here");
        throw new CustomError("Failed to update user", HttpStatusCode.CONFLICT);
      }
    } catch (error) {
      console.log(error);
      throw new CustomError(`${error}`, HttpStatusCode.INTERNAL_SERVER_ERROR);
    }
  };
  public updateUserData = async (data: Record<string, any>): Promise<User> => {
    try {
      console.log(`Before updating user... ${data}`);

      const newUser = await db.user.update({
        where: { id: data.id },
        data: data,
      });

      console.log("After updating user...");

      if (newUser) {
        return newUser as User;
      } else {
        console.log(newUser);
        throw new CustomError("Failed to update user", HttpStatusCode.CONFLICT);
      }
    } catch (error) {
      console.log(error);
      throw new CustomError(`${error}`, HttpStatusCode.INTERNAL_SERVER_ERROR);
    }
  };

  public findByPhoneNumber = async (
    phoneNumber: string
  ): Promise<User | null> => {
    try {
      console.log("Before finding user...");

      const newUser = await db.user.findUnique({
        where: { phoneNumber },
      });

      if (newUser) {
        return newUser as User;
      } else {
        return null;
      }
    } catch (error) {
      throw new CustomError(
        `Error : ${error}`,
        HttpStatusCode.INTERNAL_SERVER_ERROR
      );
    }
  };
}
