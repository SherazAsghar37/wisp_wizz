import { Schema, model } from "mongoose";

const messageSchema = new Schema(
  {
    senderId: {
      type: Schema.Types.ObjectId,
      required: true,
      ref: "user",
    },
    receiverId: {
      type: Schema.Types.ObjectId,
      required: true,
      ref: "user",
    },
    content: {
      type: String,
      required: true,
    },
  },
  { timestamps: true }
);

const messageModel = model("message", messageSchema);
export default messageModel;
