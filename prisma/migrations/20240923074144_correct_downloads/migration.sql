/*
  Warnings:

  - You are about to drop the column `additionLink` on the `Documents` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE `Documents` DROP COLUMN `additionLink`,
    ADD COLUMN `additionalLink` VARCHAR(191) NULL;
