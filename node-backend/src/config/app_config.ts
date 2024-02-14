import { Application } from "express";
import express from "express";

export default function appConfig(): Application {
  const app: Application = express();

  app.use(express.json({ limit: "10mb" }));
  app.use(express.urlencoded({ extended: false }));

  return app;
}
