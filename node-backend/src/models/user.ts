import { Schema, model } from "mongoose";

const userSchema = new Schema(
  {
    phoneNumber: {
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
      data: Buffer,
      contentType: String,
    },
  },
  { timestamps: true }
);

userSchema.pre("save", function (next) {
  if (!this.name) {
    this.name = `${this.phoneNumber}`;
  }
  next();
});

const userModel = model("user", userSchema);
export default userModel;
