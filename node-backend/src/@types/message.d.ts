type Message = {
  chatId: string;
  message: string;
  senderId: string;
  recipientId: string;
  repliedToId: string?;
  repliedMessage: string?;
  messageStatus: MessageStatus;
  messageId: string;
};

enum MessageStatus {
  Sending = "Sending",
  Sent = "Sent",
  Delivered = "Delivered",
  Seen = "Seen",
}
export default { Message, MessageStatus };
