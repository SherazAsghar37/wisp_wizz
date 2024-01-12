import { User } from "../@types/user";
import CustomError from "../exceptions/custom_error";
import userModel from "../models/user";
import HttpStatusCode from "../utils/http_status_codes";

export default class UserRepository {
  public createByLocal = async (data: User): Promise<User> => {
    try {
      console.log("Before creating user...");

      const newUser = await userModel.create({
        name: data.name as string,
        profilePictureUrl: data.profilePictureUrl as string,
        phoneNumber: data.phoneNumber,
        countryCode: data.countryCode,
        status: data.status,
        lastSeen: data.lastSeen,
      });

      console.log("After creating user...");

      if (newUser) {
        return newUser as User;
      } else {
        throw new CustomError(
          "Failed to create user",
          HttpStatusCode.INTERNAL_SERVER_ERROR
        );
      }
    } catch (error) {
      throw new CustomError(`${error}`, HttpStatusCode.INTERNAL_SERVER_ERROR);
    }
  };

  public findByPhoneNumber = async (phoneNumber: number): Promise<User> => {
    try {
      console.log("Before finding user...");

      const newUser = await userModel.findOne({
        phoneNumber,
      });

      if (newUser) {
        return newUser as User;
      } else {
        throw new CustomError("Unable to find user", HttpStatusCode.NOT_FOUND);
      }
    } catch (error) {
      throw new CustomError(
        `Error : ${error}`,
        HttpStatusCode.INTERNAL_SERVER_ERROR
      );
    }
  };
}
