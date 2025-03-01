import express from "express";
import path from "path";

const staticRouter = express.Router();

staticRouter.route("/profile:id").get((req, res) => {
  const id = req.params.id;
  console.log(id);
  return res.sendFile(path.resolve(`../node-backend/src/public/${id}.png`));
});

export default staticRouter;
