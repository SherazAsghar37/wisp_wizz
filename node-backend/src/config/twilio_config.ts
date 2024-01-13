import { Twilio } from "twilio";
import { CountryCodes } from "../utils/enums";
import CustomError from "../exceptions/custom_error";
import HttpStatusCode from "../utils/http_status_codes";

const accountSid = process.env.TWILIO_SID;
const authToken = process.env.TWILIO_AUTH_TOKEN;

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
      from: process.env.TWILIO_NUMBER,
    })
    .then((message) => console.log(message.sid))
    .catch((error) => {
      throw new CustomError(
        "Unable to send Messagea",
        HttpStatusCode.INTERNAL_SERVER_ERROR
      );
    });
}
