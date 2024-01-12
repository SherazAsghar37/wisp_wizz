import { CountryCodes } from "../utils/enums";
type User = {
  name: string;
  profilePictureUrl: string;
  phoneNumber: number;
  countryCode: CountryCodes;
  status: Boolean;
  lastSeen: Date;
};

export { User };
