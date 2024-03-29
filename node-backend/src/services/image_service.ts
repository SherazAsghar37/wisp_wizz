import { singleton } from "tsyringe";
import { ThrowCriticalError } from "../exceptions/critical_error";
import { fileTypeFromBuffer } from "file-type";
import CustomError from "../exceptions/custom_error";
import fs from "node:fs";
import path from "node:path";

@singleton()
export default class ImageService {
  public saveImage = async (image: Buffer, uuid: string): Promise<string> => {
    try {
      let imgPath = `/image/profile${uuid}`;
      const outputFileName = `../node-backend/src/public/${uuid}.png`;
      fs.createWriteStream(outputFileName).write(image);
      return imgPath;
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
