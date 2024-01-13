import { Schema, model } from "mongoose";

const messageSchema = new Schema(
  {
    senderId: {
      type: Schema.Types.ObjectId,
      required: true,
      ref: "user",
    },

    content: {
      type: String,
      required: true,
      trim: true,
    },
    chat: {
      type: Schema.Types.ObjectId,
      required: true,
      ref: "chat",
    },
  },
  { timestamps: true }
);

const messageModel = model("message", messageSchema);
export default messageModel;
