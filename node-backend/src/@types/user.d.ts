import { CountryCodes } from "../utils/enums";
type BufferImage = {
  data: Buffer;
  contentType: string;
};

type User = {
  name: string;
  image: BufferImage;
  phoneNumber: string;
  status: Boolean;
  lastSeen: Date;
};

export { User, BufferImage };
