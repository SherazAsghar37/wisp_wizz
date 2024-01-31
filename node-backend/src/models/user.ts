import { Timestamp } from "mongodb";
import { Schema, model } from "mongoose";

const userSchema = new Schema(
  {
    phoneNumber: {
      type: Number,
      required: true,
      trim: true,
    },
    countryCode: {
      type: String,
      required: true,
      trim: true,
    },
    name: {
      type: String,
      trim: true,
    },
    status: {
      type: Boolean,
      default: true,
    },
    lastSeen: {
      type: Date,
      default: Date.now,
    },
    image: {
      type: String,
      default: "profile.png",
      required: true,
    },
  },
  { timestamps: true }
);
userSchema.index({ phoneNumber: 1, countryCode: 1 }, { unique: true });

userSchema.pre("save", function (next) {
  if (!this.name) {
    this.name = `${this.countryCode}${this.phoneNumber}`;
  }

  next();
});

const userModel = model("user", userSchema);
export default userModel;
