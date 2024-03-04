import { singleton, inject } from "tsyringe";
import { ThrowCriticalError } from "../exceptions/critical_error";
import UserRepository from "../repositories/user_repository";
import CustomError from "../exceptions/custom_error";
import { User, BufferImage } from "../@types/user";

@singleton()
export default class UserService {
  constructor(
    @inject(UserRepository)
    private readonly _userRepository: UserRepository
  ) {}

  public getUser = async (phoneNumber: string): Promise<User | null> => {
    try {
      const user: User | null = await this._userRepository.findByPhoneNumber(
        phoneNumber
      );
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
  public signUpLocal = async (
    name: string,
    phoneNumber: string,
    image: Buffer
  ): Promise<User> => {
    try {
      var user: User | null = await this._userRepository.findByPhoneNumber(
        phoneNumber
      );
      if (!user) {
        user = await this._userRepository.createByLocal({
          name,
          phoneNumber,
          image,
        });
      } else {
        user = user = await this._userRepository.updateUser({
          name,
          phoneNumber,
          image,
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
  public updateUser = async (
    data: Record<string, any>
  ): Promise<User | null> => {
    try {
      const user: User | null = await this._userRepository.updateUserData(data);
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

  public fetchContacts = async (
    contacts: Array<string>
  ): Promise<Array<User>> => {
    try {
      const users: Array<User> =
        await this._userRepository.findManyByPhoneNumbers(contacts);
      return users;
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
