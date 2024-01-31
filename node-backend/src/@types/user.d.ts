import { CountryCodes } from "../utils/enums";
type User = {
  name: string;
  image: string;
  phoneNumber: number;
  countryCode: string;
  status: Boolean;
  lastSeen: Date;
};

export { User };
