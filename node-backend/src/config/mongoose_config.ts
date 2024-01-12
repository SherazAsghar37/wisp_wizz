import mongoose from "mongoose";

export default function mongooseConfig(): Promise<void> {
  return mongoose
    .connect(process.env.DATABASE_URL!)
    .then((e) => console.log("MongoDB Connected"))
    .catch((error) => {
      console.log("MonogDB connection error : ", error);
    });
}
