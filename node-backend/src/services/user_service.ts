import { singleton, inject } from "tsyringe";
import { ThrowCriticalError } from "../exceptions/critical_error";
import UserRepository from "../repositories/user_repository";
import CustomError from "../exceptions/custom_error";
import { User } from "../@types/user";

@singleton()
export default class UserService {
  constructor(
    @inject(UserRepository)
    private readonly _userRepository: UserRepository
  ) {}

  public getUser = async (
    phoneNumber: number,
    countryCode: string
  ): Promise<User | null> => {
    try {
      console.log(countryCode);
      const user: User | null = await this._userRepository.findByPhoneNumber(
        phoneNumber,
        countryCode
      );
      return user;
    } catch (error) {
      if (error instanceof CustomError) {
        throw error;
      } else {
        throw new ThrowCriticalError(error);
      }
    }
  };
  public signUpLocal = async (
    name: string,
    phoneNumber: number,
    countryCode: string,
    image: string,
    status: boolean,
    lastSeen: Date
  ): Promise<User> => {
    try {
      var user: User | null = await this._userRepository.findByPhoneNumber(
        phoneNumber,
        countryCode
      );
      if (!user) {
        user = await this._userRepository.createByLocal({
          name,
          phoneNumber,
          countryCode,
          image,
          status,
          lastSeen,
        });
      } else {
        user = user = await this._userRepository.updateUser({
          name,
          phoneNumber,
          countryCode,
          image,
          status,
          lastSeen,
        });
      }

      return user;
    } catch (error) {
      if (error instanceof CustomError) {
        throw error;
      } else {
        console.log("!!!Criticial Error!!!", error);
        throw new ThrowCriticalError(error);
      }
    }
  };
}
