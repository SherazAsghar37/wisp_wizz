import "reflect-metadata";
import appConfig from "./src/config/app_config";
import dotenv from "dotenv";
import mongooseConfig from "./src/config/mongoose_config";
import colors from "colors";
import authRouter from "./src/routes/auth";
import userRouter from "./src/routes/user";
colors;
dotenv.config();
const port = Number.parseInt(process.env.PORT as string) || 8000;
console.log(process.env.TWILIO_SID);
//config
const app = appConfig();
app.listen(port, "192.168.1.104", () => {
  console.log(`Server is listening on ${port}`.yellow.bold);
});
app.use("/auth", authRouter);
app.use("/user", userRouter);
mongooseConfig();
