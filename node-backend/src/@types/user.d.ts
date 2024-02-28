import { CountryCodes } from "../utils/enums";
type BufferImage = {
  data: Buffer;
  contentType: string;
};

type User = {
  name: string;
  image: Buffer;
  phoneNumber: string;
  status: boolean;
  lastSeen: Date;
};

export { User, BufferImage };
