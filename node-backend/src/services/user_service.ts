import { singleton, inject } from "tsyringe";
import { ThrowCriticalError } from "../exceptions/critical_error";
import UserRepository from "../repositories/user_repository";

@singleton()
export default class UserService {
  constructor(
    @inject(UserRepository)
    private readonly _userRepository: UserRepository
  ) {}

  //   public signUpLocal = async (
  //     full_name: string,
  //     email: string,
  //     password: string,
  //     gender: Genders
  //   ): Promise<string> => {
  //     try {
  //       const salt = null;
  //       const user = await this._userRepository.createByLocal({
  //         salt,
  //         full_name,
  //         email,
  //         password,
  //         gender,
  //       });
  //       const jwt = new JWT_Utils();
  //       return jwt.generateUserToken(user);
  //     } catch (error) {
  //       if (error instanceof CustomError) {
  //         throw error;
  //       } else {
  //         throw new ThrowCriticalError(error);
  //       }
  //     }
  //   };
}
