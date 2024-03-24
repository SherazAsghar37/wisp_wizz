/*
  Warnings:

  - The values [Read,Unread] on the enum `Message_messageStatus` will be removed. If these variants are still used in the database, this will fail.
  - Added the required column `lastMessageId` to the `Chat` table without a default value. This is not possible if the table is not empty.
  - Added the required column `recipientId` to the `Message` table without a default value. This is not possible if the table is not empty.
  - Added the required column `senderId` to the `Message` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE `chat` ADD COLUMN `lastMessageId` VARCHAR(191) NOT NULL;

-- AlterTable
ALTER TABLE `message` ADD COLUMN `recipientId` VARCHAR(191) NOT NULL,
    ADD COLUMN `senderId` VARCHAR(191) NOT NULL,
    MODIFY `messageStatus` ENUM('Sending', 'Sent', 'Delivered', 'Seen') NOT NULL DEFAULT 'Sent';

-- AddForeignKey
ALTER TABLE `Message` ADD CONSTRAINT `Message_recipientId_fkey` FOREIGN KEY (`recipientId`) REFERENCES `User`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Message` ADD CONSTRAINT `Message_senderId_fkey` FOREIGN KEY (`senderId`) REFERENCES `User`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
