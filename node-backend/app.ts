import appConfig from "./src/config/app_config";
import dotenv from "dotenv";
import mongooseConfig from "./src/config/mongoose_config";

dotenv.config();

const port = process.env.PORT || 8000;

//config
const app = appConfig();
mongooseConfig();

app.listen(port, () => {
  console.log(`Server is listening on ${port}`);
});
