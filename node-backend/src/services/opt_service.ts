import { singleton, inject } from "tsyringe";
import { ThrowCriticalError } from "../exceptions/critical_error";
import OtpRepository from "../repositories/otp_repository";
import { CountryCodes } from "../utils/enums";
import sendMessage from "../config/twilio_config";
import crypto from "crypto";
import CustomError from "../exceptions/custom_error";

@singleton()
export default class OtpService {
  constructor(
    @inject(OtpRepository)
    private readonly _otpRepository: OtpRepository
  ) {}

  public sendOtp = async (
    countryCode: CountryCodes,
    phoneNumber: number
  ): Promise<number> => {
    try {
      const code = crypto.randomInt(100000, 999999);
      const message = `Your verification code is : ${code}`;
      await sendMessage(countryCode, phoneNumber, message);
      return code;
    } catch (error) {
      if (error instanceof CustomError) {
        throw error;
      }
      throw new ThrowCriticalError(error);
    }
  };
  public createOtp = async (
    phoneNumber: number,
    otp: number
  ): Promise<string> => {
    try {
      await this._otpRepository.createOtp({
        phoneNumber,
        otp,
      });
      return "Verification code sent sucessfully!";
    } catch (error) {
      if (error instanceof CustomError) {
        throw error;
      } else {
        throw new ThrowCriticalError(error);
      }
    }
  };

  public verifyOtp = async (
    phoneNumber: number,
    otp: number
  ): Promise<boolean> => {
    try {
      const otpCollection = await this._otpRepository.findByPhoneNumber(
        phoneNumber
      );
      if (otp === otpCollection.otp) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      if (error instanceof CustomError) {
        throw error;
      } else {
        throw new ThrowCriticalError(error);
      }
    }
  };
}
