/*
  Warnings:

  - Changed the type of `ped` on the `Peds` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.

*/
-- AlterTable
ALTER TABLE "Peds" DROP COLUMN "ped",
ADD COLUMN     "ped" JSONB NOT NULL;
