-- AlterTable
ALTER TABLE `Certificate` ADD COLUMN `startedOn` VARCHAR(191) NULL;

-- CreateTable
CREATE TABLE `EmpolymentHistory` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `company` VARCHAR(191) NOT NULL,
    `jobTitle` VARCHAR(191) NOT NULL,
    `description` VARCHAR(191) NOT NULL,
    `startedOn` VARCHAR(191) NOT NULL,
    `endOn` VARCHAR(191) NOT NULL,
    `userId` INTEGER NOT NULL,

    UNIQUE INDEX `EmpolymentHistory_userId_key`(`userId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `EmpolymentHistory` ADD CONSTRAINT `EmpolymentHistory_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
