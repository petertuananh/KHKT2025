-- CreateSchema
CREATE SCHEMA IF NOT EXISTS "public";

-- CreateEnum
CREATE TYPE "public"."UserFlags" AS ENUM ('ADMIN', 'BOT', 'BANNED', 'VERIFIED');

-- CreateEnum
CREATE TYPE "public"."UserStatus" AS ENUM ('offline', 'online', 'idle');

-- CreateEnum
CREATE TYPE "public"."TransactionStatuses" AS ENUM ('pending', 'finished', 'canceled');

-- CreateEnum
CREATE TYPE "public"."UserTransactionTypes" AS ENUM ('topup', 'withdraw', 'transfer', 'payment', 'refund');

-- CreateEnum
CREATE TYPE "public"."CompanyTransactionTypes" AS ENUM ('income', 'expense', 'withdraw', 'refund', 'fee');

-- CreateEnum
CREATE TYPE "public"."OrderStatuses" AS ENUM ('pending', 'paid', 'canceled');

-- CreateTable
CREATE TABLE "public"."Users" (
    "id" VARCHAR(255) NOT NULL,
    "username" TEXT NOT NULL,
    "email" VARCHAR(255),
    "phone_number" VARCHAR(20),
    "display_name" TEXT,
    "hashed_password" VARCHAR(255),
    "avatar_file_id" VARCHAR(255),
    "google_id" VARCHAR(255),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "modified_at" TIMESTAMP(3) NOT NULL,
    "status" "public"."UserStatus" NOT NULL DEFAULT 'offline',
    "last_active_at" TIMESTAMP(3),
    "bot_token" VARCHAR(255),
    "flags" "public"."UserFlags"[] DEFAULT ARRAY[]::"public"."UserFlags"[],
    "balance" DOUBLE PRECISION NOT NULL DEFAULT 0.0,

    CONSTRAINT "Users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Companies" (
    "id" VARCHAR(255) NOT NULL,
    "tax_id" VARCHAR(100),
    "name" TEXT NOT NULL,
    "international_name" VARCHAR(255),
    "short_name" VARCHAR(100),
    "description" TEXT,
    "address" TEXT,
    "phone" VARCHAR(20),
    "email" VARCHAR(255),
    "website" TEXT,
    "owned_by" VARCHAR(255) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "is_verified" BOOLEAN NOT NULL DEFAULT false,
    "is_deleted" BOOLEAN NOT NULL DEFAULT false,
    "logo_file_id" VARCHAR(255),
    "balance" DOUBLE PRECISION NOT NULL DEFAULT 0.0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "modified_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Companies_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Places" (
    "id" VARCHAR(255) NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "address" TEXT,
    "phone" VARCHAR(20),
    "latitude" DOUBLE PRECISION,
    "longitude" DOUBLE PRECISION,
    "company_id" VARCHAR(255),
    "user_id" VARCHAR(255),
    "creator_id" VARCHAR(255) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "modified_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Places_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Products" (
    "id" VARCHAR(255) NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "price" DOUBLE PRECISION NOT NULL,
    "stock" INTEGER NOT NULL,
    "unit_type" VARCHAR(100) NOT NULL,
    "place_id" VARCHAR(255) NOT NULL,
    "category_id" VARCHAR(255),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "modified_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Products_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Product_categories" (
    "id" VARCHAR(255) NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "modified_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Product_categories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Files" (
    "id" VARCHAR(255) NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "user_id" VARCHAR(255) NOT NULL,
    "order" INTEGER NOT NULL DEFAULT 0,
    "product_id" VARCHAR(255),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "modified_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Files_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."User_transactions" (
    "id" VARCHAR(255) NOT NULL,
    "user_id" TEXT NOT NULL,
    "to_user_id" TEXT,
    "to_company_id" TEXT,
    "order_id" TEXT,
    "amount" DECIMAL(18,2) NOT NULL,
    "type" "public"."UserTransactionTypes" NOT NULL,
    "status" "public"."TransactionStatuses" NOT NULL,
    "note" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "modified_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "User_transactions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Company_transactions" (
    "id" VARCHAR(255) NOT NULL,
    "company_id" TEXT NOT NULL,
    "from_user_id" TEXT,
    "order_id" TEXT,
    "amount" DECIMAL(18,2) NOT NULL,
    "type" "public"."CompanyTransactionTypes" NOT NULL,
    "status" "public"."TransactionStatuses" NOT NULL,
    "note" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "modified_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Company_transactions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Orders" (
    "id" VARCHAR(255) NOT NULL,
    "user_id" TEXT NOT NULL,
    "total" DECIMAL(18,2) NOT NULL,
    "status" "public"."OrderStatuses" NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "modified_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Orders_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Carts" (
    "id" VARCHAR(255) NOT NULL,
    "user_id" VARCHAR(255) NOT NULL,
    "product_id" VARCHAR(255) NOT NULL,
    "amount" DOUBLE PRECISION NOT NULL DEFAULT 0.0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "modified_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Carts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."CompanyRecruitments" (
    "id" VARCHAR(255) NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "requirements" TEXT NOT NULL,
    "location" TEXT,
    "salary_range_from" TEXT,
    "salary_range_to" TEXT,
    "employment_type" TEXT,
    "created_by" VARCHAR(255) NOT NULL,
    "company_id" VARCHAR(255) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "modified_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "CompanyRecruitments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."CompanyDeliveries" (
    "id" VARCHAR(255) NOT NULL,
    "title" TEXT NOT NULL,
    "weight" DOUBLE PRECISION NOT NULL,
    "length" DOUBLE PRECISION NOT NULL,
    "width" DOUBLE PRECISION NOT NULL,
    "height" DOUBLE PRECISION NOT NULL,
    "budget" DOUBLE PRECISION NOT NULL,
    "created_by" VARCHAR(255) NOT NULL,
    "company_id" VARCHAR(255) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "modified_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "CompanyDeliveries_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."CompanyScrapes" (
    "id" VARCHAR(255) NOT NULL,
    "name" TEXT NOT NULL,
    "quantity" INTEGER NOT NULL,
    "unit_type" VARCHAR(100) NOT NULL,
    "unit_price" DOUBLE PRECISION NOT NULL,
    "created_by" VARCHAR(255) NOT NULL,
    "company_id" VARCHAR(255) NOT NULL,

    CONSTRAINT "CompanyScrapes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Chats" (
    "id" VARCHAR(255) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "modified_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Chats_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Messages" (
    "id" VARCHAR(255) NOT NULL,
    "chat_id" VARCHAR(255) NOT NULL,
    "sender_id" VARCHAR(255) NOT NULL,
    "content" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "modified_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Messages_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Message_seens" (
    "id" VARCHAR(255) NOT NULL,
    "message_id" VARCHAR(255) NOT NULL,
    "seen_by_id" VARCHAR(255) NOT NULL,
    "seen_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Message_seens_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Message_reactions" (
    "id" VARCHAR(255) NOT NULL,
    "icon" TEXT NOT NULL,
    "message_id" VARCHAR(255) NOT NULL,
    "seen_by_id" VARCHAR(255) NOT NULL,
    "seen_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Message_reactions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."_UserChats" (
    "A" VARCHAR(255) NOT NULL,
    "B" VARCHAR(255) NOT NULL,

    CONSTRAINT "_UserChats_AB_pkey" PRIMARY KEY ("A","B")
);

-- CreateIndex
CREATE UNIQUE INDEX "Users_username_key" ON "public"."Users"("username");

-- CreateIndex
CREATE UNIQUE INDEX "email" ON "public"."Users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "phone_number" ON "public"."Users"("phone_number");

-- CreateIndex
CREATE UNIQUE INDEX "google_id" ON "public"."Users"("google_id");

-- CreateIndex
CREATE INDEX "_UserChats_B_index" ON "public"."_UserChats"("B");

-- AddForeignKey
ALTER TABLE "public"."Companies" ADD CONSTRAINT "Companies_owned_by_fkey" FOREIGN KEY ("owned_by") REFERENCES "public"."Users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Places" ADD CONSTRAINT "Places_company_id_fkey" FOREIGN KEY ("company_id") REFERENCES "public"."Companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Places" ADD CONSTRAINT "Places_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."Users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Places" ADD CONSTRAINT "Places_creator_id_fkey" FOREIGN KEY ("creator_id") REFERENCES "public"."Users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Products" ADD CONSTRAINT "Products_place_id_fkey" FOREIGN KEY ("place_id") REFERENCES "public"."Places"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Products" ADD CONSTRAINT "Products_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "public"."Product_categories"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Files" ADD CONSTRAINT "Files_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."Users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Files" ADD CONSTRAINT "Files_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."Products"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."User_transactions" ADD CONSTRAINT "User_transactions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."Users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."User_transactions" ADD CONSTRAINT "User_transactions_to_user_id_fkey" FOREIGN KEY ("to_user_id") REFERENCES "public"."Users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."User_transactions" ADD CONSTRAINT "User_transactions_to_company_id_fkey" FOREIGN KEY ("to_company_id") REFERENCES "public"."Companies"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."User_transactions" ADD CONSTRAINT "User_transactions_order_id_fkey" FOREIGN KEY ("order_id") REFERENCES "public"."Orders"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Company_transactions" ADD CONSTRAINT "Company_transactions_company_id_fkey" FOREIGN KEY ("company_id") REFERENCES "public"."Companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Company_transactions" ADD CONSTRAINT "Company_transactions_from_user_id_fkey" FOREIGN KEY ("from_user_id") REFERENCES "public"."Users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Company_transactions" ADD CONSTRAINT "Company_transactions_order_id_fkey" FOREIGN KEY ("order_id") REFERENCES "public"."Orders"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Orders" ADD CONSTRAINT "Orders_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."Users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Carts" ADD CONSTRAINT "Carts_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."Users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Carts" ADD CONSTRAINT "Carts_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."Products"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."CompanyRecruitments" ADD CONSTRAINT "CompanyRecruitments_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."Users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."CompanyRecruitments" ADD CONSTRAINT "CompanyRecruitments_company_id_fkey" FOREIGN KEY ("company_id") REFERENCES "public"."Companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."CompanyDeliveries" ADD CONSTRAINT "CompanyDeliveries_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."Users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."CompanyDeliveries" ADD CONSTRAINT "CompanyDeliveries_company_id_fkey" FOREIGN KEY ("company_id") REFERENCES "public"."Companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."CompanyScrapes" ADD CONSTRAINT "CompanyScrapes_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."Users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."CompanyScrapes" ADD CONSTRAINT "CompanyScrapes_company_id_fkey" FOREIGN KEY ("company_id") REFERENCES "public"."Companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Messages" ADD CONSTRAINT "Messages_chat_id_fkey" FOREIGN KEY ("chat_id") REFERENCES "public"."Chats"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Messages" ADD CONSTRAINT "Messages_sender_id_fkey" FOREIGN KEY ("sender_id") REFERENCES "public"."Users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Message_seens" ADD CONSTRAINT "Message_seens_message_id_fkey" FOREIGN KEY ("message_id") REFERENCES "public"."Messages"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Message_seens" ADD CONSTRAINT "Message_seens_seen_by_id_fkey" FOREIGN KEY ("seen_by_id") REFERENCES "public"."Users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Message_reactions" ADD CONSTRAINT "Message_reactions_message_id_fkey" FOREIGN KEY ("message_id") REFERENCES "public"."Messages"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Message_reactions" ADD CONSTRAINT "Message_reactions_seen_by_id_fkey" FOREIGN KEY ("seen_by_id") REFERENCES "public"."Users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."_UserChats" ADD CONSTRAINT "_UserChats_A_fkey" FOREIGN KEY ("A") REFERENCES "public"."Chats"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."_UserChats" ADD CONSTRAINT "_UserChats_B_fkey" FOREIGN KEY ("B") REFERENCES "public"."Users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

