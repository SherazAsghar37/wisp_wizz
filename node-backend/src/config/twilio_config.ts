import { Twilio } from "twilio";
import { CountryCodes } from "../utils/enums";
import CustomError from "../exceptions/custom_error";
import HttpStatusCode from "../utils/http_status_codes";
import dotenv from "dotenv";
dotenv.config();
const accountSid = process.env.TWILIO_SID as string;
const authToken = process.env.TWILIO_AUTH_TOKEN as string;
const client = new Twilio(accountSid, authToken);

export default function sendMessage(
  countryCode: CountryCodes,
  phoneNumber: number,
  message: string
) {
  client.messages
    .create({
      body: message,
      to: `${countryCode}${phoneNumber}`,
      from: process.env.TWILIO_NUMBER as string,
    })
    .then((message) => console.log(message.sid))
    .catch((error) => {
      throw new CustomError(
        "Unable to send Messagea",
        HttpStatusCode.INTERNAL_SERVER_ERROR
      );
    });
}
