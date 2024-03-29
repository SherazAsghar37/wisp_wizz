import { singleton } from "tsyringe";
import { ThrowCriticalError } from "../exceptions/critical_error";
import { fileTypeFromBuffer } from "file-type";
import CustomError from "../exceptions/custom_error";
import fs from "node:fs";

@singleton()
export default class ImageService {
  public saveImage = async (image: Buffer, uuid: string): Promise<string> => {
    try {
      const fileType = await fileTypeFromBuffer(image);
      let path = "";
      if (fileType && fileType.ext) {
        console.log(fileType.ext);
        const outputFileName = `../public/${uuid}.${fileType.ext}`;
        path = `../image/profile/${uuid}`;
        fs.createWriteStream(outputFileName).write(image);
      }
      return path;
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
