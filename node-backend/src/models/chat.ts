import { Schema, model } from "mongoose";

const chatSchema = new Schema(
  {
    chatName: {
      type: String,
      required: true,
      trim: true,
    },
    users: [
      {
        type: Schema.Types.ObjectId,
        required: true,
        ref: "user",
      },
    ],
    admin: {
      type: Schema.Types.ObjectId,
      required: true,
      ref: "user",
    },
    latestMessage: {
      type: Schema.Types.ObjectId,
      ref: "message",
    },
    isGroupChat: {
      type: Boolean,
      required: true,
    },
  },
  { timestamps: true }
);

const chatModel = model("chat", chatSchema);
export default chatModel;
