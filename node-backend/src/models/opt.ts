import { Schema, model } from "mongoose";

const otpSchema = new Schema({
  phoneNumber: {
    type: Number,
    required: true,
  },
  otp: {
    type: Number,
    required: true,
  },
  createdAt: {
    type: Date,
    default: Date.now(),
    expires: "10m",
  },
});

const otpModel = model("otp", otpSchema);
export default otpModel;
