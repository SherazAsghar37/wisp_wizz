import { Schema, model } from "mongoose";

const userSchema = new Schema(
  {
    phoneNumber: {
      type: Number,
      required: true,
      trim: true,
      unique: true,
    },
    countryCode: {
      type: String,
      enum: ["+92"],
      default: "+92",
      trim: true,
    },
    name: {
      type: String,
      trim: true,
    },
    status: {
      type: Boolean,
      required: true,
    },
    lastSeen: {
      type: Date,
      required: true,
    },
    profilePictureUrl: {
      type: String,
      default: "profile.png",
    },
  },
  { timestamps: true }
);

userSchema.pre("save", function (next) {
  if (!this.name) {
    this.name = `${this.countryCode}${this.phoneNumber}`;
  }
  next();
});

const userModel = model("user", userSchema);
export default userModel;
