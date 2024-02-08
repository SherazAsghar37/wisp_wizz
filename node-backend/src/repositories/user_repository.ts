import { User } from "../@types/user";
import CustomError from "../exceptions/custom_error";
import userModel from "../models/user";
import HttpStatusCode from "../utils/http_status_codes";

export default class UserRepository {
  public createByLocal = async (data: User): Promise<User> => {
    try {
      console.log("Before creating user...");

      const newUser = await userModel.create({
        name: data.name,
        phoneNumber: data.phoneNumber as number,
        image: data.image,
        status: data.status,
        lastSeen: data.lastSeen,
      });

      console.log("After creating user...");

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

  public updateUser = async (data: User): Promise<User> => {
    try {
      console.log("Before updating user...");

      const newUser = await userModel.findOneAndUpdate(
        {
          phoneNumber: data.phoneNumber,
        },
        {
          name: data.name,
          phoneNumber: data.phoneNumber as number,
          image: data.image,
          status: data.status,
          lastSeen: data.lastSeen,
        }
      );

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
  public findByPhoneNumber = async (
    phoneNumber: number
  ): Promise<User | null> => {
    try {
      console.log("Before finding user...");

      const newUser = await userModel.findOne({
        phoneNumber: phoneNumber,
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
