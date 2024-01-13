import { Otp } from "../@types/otp";
import CustomError from "../exceptions/custom_error";
import otpModel from "../models/opt";
import HttpStatusCode from "../utils/http_status_codes";

export default class OtpRepository {
  public createOtp = async (data: Otp): Promise<Otp> => {
    try {
      console.log("Before creating otp...");

      const newOtp = await otpModel.create({
        phoneNumber: data.phoneNumber,
        otp: data.otp,
      });

      console.log("After creating user...");

      if (newOtp) {
        return newOtp as Otp;
      } else {
        throw new CustomError(
          "Failed to create Opt, Kindly generate again",
          HttpStatusCode.INTERNAL_SERVER_ERROR
        );
      }
    } catch (error) {
      throw new CustomError(`${error}`, HttpStatusCode.INTERNAL_SERVER_ERROR);
    }
  };

  public findByPhoneNumber = async (phoneNumber: number): Promise<Otp> => {
    try {
      console.log("Before finding user...");

      const newOtp = await otpModel.findOne({
        phoneNumber,
      });

      if (newOtp) {
        return newOtp as Otp;
      } else {
        throw new CustomError(
          "Otp is expired, kindly generate again",
          HttpStatusCode.NOT_FOUND
        );
      }
    } catch (error) {
      throw new CustomError(
        `Error : ${error}`,
        HttpStatusCode.INTERNAL_SERVER_ERROR
      );
    }
  };
}
