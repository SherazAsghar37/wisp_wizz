import User from "../@types/user";
import CustomError from "../exceptions/custom_error";
import db from "../utils/db.server";
import HttpStatusCode from "../utils/http_status_codes";

export default class UserRepository {
  public createByLocal = async (
    id: string,
    name: string,
    phoneNumber: string,
    image: string
  ): Promise<User> => {
    try {
      console.log("Before creating user...");

      const newUser = await db.user.create({
        data: {
          id: id,
          name: name,
          phoneNumber: phoneNumber,
          image: image,
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
      console.log(`${error}`.red);
      throw new CustomError(
        `Error : ${error}`,
        HttpStatusCode.INTERNAL_SERVER_ERROR
      );
    }
  };

  public findManyByPhoneNumbers = async (
    contacts: Array<string>
  ): Promise<Array<User>> => {
    try {
      console.log("Before finding user...");
      const newUser = await db.user.findMany({
        where: {
          phoneNumber: {
            in: contacts,
          },
        },
      });

      if (newUser) {
        return newUser as Array<User>;
      } else {
        console.log(newUser);
        throw new CustomError(
          "Failed to fetch contacts",
          HttpStatusCode.CONFLICT
        );
      }
    } catch (error) {
      console.log(`${error}`.red);
      throw new CustomError(
        `Error : ${error}`,
        HttpStatusCode.INTERNAL_SERVER_ERROR
      );
    }
  };
  // public findManyByPhoneNumbers = async (
  //   contacts: Array<string>
  // ): Promise<Readable> => {
  //   console.log("Before finding user...");
  //   const batchSize = 10;
  //   var cursorId: string | undefined = undefined;

  //   return new Readable({
  //     objectMode: true,
  //     highWaterMark: batchSize,
  //     async read() {
  //       try {
  //         const items = await db.user.findMany({
  //           take: batchSize,
  //           skip: cursorId ? 1 : 0,
  //           cursor: cursorId ? { id: cursorId } : undefined,

  //           where: {
  //             phoneNumber: {
  //               in: contacts,
  //             },
  //           },
  //         });
  //         if (items.length === 0) {
  //           this.push(null);
  //         } else {
  //           for (const item of items) {
  //             this.push(JSON.stringify(item));
  //           }
  //           cursorId = items[items.length - 1].id;
  //         }
  //       } catch (error) {
  //         this.destroy(error as Error);
  //         console.log(`${error}`.red);
  //         throw new CustomError(
  //           `Error : ${error}`,
  //           HttpStatusCode.INTERNAL_SERVER_ERROR
  //         );
  //       }
  //     },
  //   });
  // };
}
