import mongoose from "mongoose";

export default function mongooseConfig() {
  mongoose
    .connect(process.env.DATABASE_URL as string)
    .then((e) => console.log("MongoDB Connected"))
    .catch((error) => {
      console.log("MonogDB connection error : ", error);
    });
}
