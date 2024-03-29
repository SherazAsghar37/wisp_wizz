import express from "express";
import path from "path";
const staticRouter = express.Router();

staticRouter.route("/profile:id").get((req, res) => {
  console.log(req.params);
  return res.sendFile(path.resolve("../node-backend/src/public/profile.png"));
});

export default staticRouter;
