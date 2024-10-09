-- CreateTable
CREATE TABLE "Users" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "identifier" TEXT NOT NULL,
    "priority" INTEGER NOT NULL DEFAULT 0,
    "groups" TEXT[],
    "name" TEXT NOT NULL,
    "joined" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "account" SERIAL NOT NULL,
    "tokens" TEXT[],
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Characters" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "User" INTEGER NOT NULL,
    "SID" SERIAL NOT NULL,
    "First" TEXT NOT NULL,
    "Last" TEXT NOT NULL,
    "Gender" INTEGER NOT NULL,
    "New" BOOLEAN NOT NULL DEFAULT true,
    "Origin" JSONB NOT NULL,
    "Apps" JSONB NOT NULL DEFAULT '{}',
    "Wardrobe" JSONB NOT NULL DEFAULT '[]',
    "DOB" BIGINT NOT NULL,
    "Cash" INTEGER NOT NULL DEFAULT 0,
    "LastPlayed" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "Jobs" JSONB NOT NULL DEFAULT '[]',
    "Apartment" INTEGER NOT NULL DEFAULT 1,
    "PhoneSettings" JSONB NOT NULL DEFAULT '{}',
    "Phone" TEXT NOT NULL,
    "LaptopApps" JSONB NOT NULL DEFAULT '{}',
    "LaptopSettings" JSONB NOT NULL DEFAULT '{}',
    "LaptopPermissions" JSONB NOT NULL DEFAULT '{}',
    "Crypto" JSONB NOT NULL DEFAULT '{}',
    "Licenses" JSONB NOT NULL DEFAULT '{}',
    "Alias" JSONB NOT NULL DEFAULT '{}',
    "PhonePermissions" JSONB NOT NULL DEFAULT '{}',
    "Addiction" JSONB NOT NULL DEFAULT '{}',
    "Animations" JSONB NOT NULL DEFAULT '{}',
    "Armor" INTEGER NOT NULL DEFAULT 0,
    "BankAccount" INTEGER,
    "CryptoWallet" TEXT,
    "HP" INTEGER NOT NULL DEFAULT 200,
    "InventorySettings" JSONB NOT NULL DEFAULT '{}',
    "States" JSONB NOT NULL DEFAULT '{}',
    "Callsign" INTEGER,
    "Mugshot" TEXT,
    "MDTHistory" JSONB NOT NULL DEFAULT '{}',
    "MDTSuspension" JSONB NOT NULL DEFAULT '{}',
    "MDTSystemAdmin" BOOLEAN NOT NULL DEFAULT false,
    "Qualifications" JSONB NOT NULL DEFAULT '{}',
    "LastClockOn" JSONB NOT NULL DEFAULT '{}',
    "Salary" JSONB NOT NULL DEFAULT '{}',
    "TimeClockedOn" JSONB NOT NULL DEFAULT '{}',
    "Reputations" JSONB NOT NULL DEFAULT '{}',
    "GangChain" JSONB NOT NULL DEFAULT '{}',
    "Bio" TEXT,
    "ICU" JSONB NOT NULL DEFAULT '{}',
    "Jailed" JSONB NOT NULL DEFAULT '{}',
    "Status" JSONB NOT NULL DEFAULT '{}',
    "Parole" JSONB NOT NULL DEFAULT '{}',
    "LSUNDGBan" JSONB NOT NULL DEFAULT '{}',
    "Deleted" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "Characters_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BankAccounts" (
    "id" SERIAL NOT NULL,
    "account" INTEGER NOT NULL,
    "type" TEXT NOT NULL,
    "owner" TEXT NOT NULL,
    "balance" INTEGER NOT NULL DEFAULT 0,
    "name" TEXT NOT NULL,

    CONSTRAINT "BankAccounts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BankAccountsPermissions" (
    "id" SERIAL NOT NULL,
    "account" INTEGER NOT NULL,
    "type" INTEGER NOT NULL,
    "jointOwner" VARCHAR(255),
    "job" VARCHAR(255),
    "workplace" VARCHAR(255),
    "jobPermissions" VARCHAR(1024),

    CONSTRAINT "BankAccountsPermissions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BankAccountTransaction" (
    "id" SERIAL NOT NULL,
    "type" TEXT NOT NULL,
    "account" INTEGER NOT NULL,
    "amount" INTEGER NOT NULL DEFAULT 0,
    "timestamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "title" TEXT NOT NULL DEFAULT '',
    "description" TEXT NOT NULL DEFAULT '',
    "data" VARCHAR(1024),

    CONSTRAINT "BankAccountTransaction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "bans" (
    "id" SERIAL NOT NULL,
    "account" TEXT NOT NULL DEFAULT '0',
    "identifier" TEXT,
    "expires" TIMESTAMP(3) NOT NULL,
    "reason" TEXT,
    "issuer" TEXT,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "started" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "tokens" TEXT[],

    CONSTRAINT "bans_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BenchSchematics" (
    "bench" TEXT NOT NULL,
    "schematic" TEXT NOT NULL,

    CONSTRAINT "BenchSchematics_pkey" PRIMARY KEY ("bench","schematic")
);

-- CreateTable
CREATE TABLE "Billboards" (
    "id" SERIAL NOT NULL,
    "billboardId" TEXT NOT NULL,
    "billboardUrl" TEXT NOT NULL,

    CONSTRAINT "Billboards_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "business_documents" (
    "id" SERIAL NOT NULL,
    "job" TEXT NOT NULL,
    "author" JSONB,
    "report" JSONB,
    "title" TEXT,
    "notes" TEXT,
    "history" JSONB,
    "pinned" BOOLEAN DEFAULT false,

    CONSTRAINT "business_documents_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "business_notices" (
    "id" SERIAL NOT NULL,
    "job" TEXT,
    "author" JSONB,
    "description" TEXT,
    "title" TEXT,
    "date" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "business_notices_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "business_receipts" (
    "id" SERIAL NOT NULL,
    "job" TEXT,
    "customerName" TEXT,
    "author" JSONB,
    "content" JSONB,
    "lastUpdated" JSONB,
    "history" JSONB,

    CONSTRAINT "business_receipts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BusinessTvs" (
    "id" SERIAL NOT NULL,
    "tv" INTEGER NOT NULL,
    "link" TEXT NOT NULL,

    CONSTRAINT "BusinessTvs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CasinoBigwins" (
    "ID" SERIAL NOT NULL,
    "Type" TEXT,
    "Time" INTEGER,
    "SID" TEXT,
    "First" TEXT,
    "Last" TEXT,
    "Prize" INTEGER,
    "MetaData" JSONB NOT NULL,

    CONSTRAINT "CasinoBigwins_pkey" PRIMARY KEY ("ID")
);

-- CreateTable
CREATE TABLE "CasinoConfig" (
    "id" SERIAL NOT NULL,
    "key" VARCHAR(255),
    "data" JSONB NOT NULL,

    CONSTRAINT "CasinoConfig_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CasinoStatistics" (
    "SID" TEXT NOT NULL,
    "TotalAmountWon" INTEGER DEFAULT 0,
    "TotalAmountLost" INTEGER DEFAULT 0,
    "AmountWon_blackjack" INTEGER DEFAULT 0,
    "AmountLost_blackjack" INTEGER DEFAULT 0,
    "AmountWon_roulette" INTEGER DEFAULT 0,
    "AmountLost_roulette" INTEGER DEFAULT 0,
    "AmountWon_slots" INTEGER DEFAULT 0,
    "AmountLost_slots" INTEGER DEFAULT 0,
    "LastUpdated" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "CasinoStatistics_pkey" PRIMARY KEY ("SID")
);

-- CreateTable
CREATE TABLE "CharacterContacts" (
    "id" SERIAL NOT NULL,
    "sid" INTEGER NOT NULL,
    "number" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "avatar" TEXT,
    "color" TEXT,
    "favorite" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "CharacterContacts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CharacterDocuments" (
    "id" SERIAL NOT NULL,
    "owner" TEXT,
    "time" INTEGER,
    "title" TEXT,
    "content" TEXT,
    "sharedWith" TEXT,
    "sharedBy" TEXT,
    "signed" TEXT,

    CONSTRAINT "CharacterDocuments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CharacterEmails" (
    "id" SERIAL NOT NULL,
    "owner" VARCHAR(255),
    "sender" VARCHAR(255),
    "time" BIGINT,
    "subject" TEXT,
    "body" TEXT,
    "unread" BOOLEAN,
    "flags" JSONB NOT NULL,

    CONSTRAINT "CharacterEmails_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CharacterParole" (
    "SID" INTEGER NOT NULL,
    "end" TIMESTAMP(3) NOT NULL,
    "total" INTEGER NOT NULL DEFAULT 0,
    "parole" INTEGER NOT NULL DEFAULT 0,
    "sentence" INTEGER NOT NULL DEFAULT 0,
    "fine" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "CharacterParole_pkey" PRIMARY KEY ("SID")
);

-- CreateTable
CREATE TABLE "CharacterPhotos" (
    "id" SERIAL NOT NULL,
    "sid" INTEGER NOT NULL,
    "time" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "image_url" TEXT NOT NULL,

    CONSTRAINT "CharacterPhotos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CraftingCooldowns" (
    "bench" TEXT NOT NULL,
    "id" TEXT NOT NULL,
    "expires" BIGINT NOT NULL,

    CONSTRAINT "CraftingCooldowns_pkey" PRIMARY KEY ("bench")
);

-- CreateTable
CREATE TABLE "DealerData" (
    "Id" SERIAL NOT NULL,
    "dealership" TEXT NOT NULL,
    "data" JSONB NOT NULL,

    CONSTRAINT "DealerData_pkey" PRIMARY KEY ("Id")
);

-- CreateTable
CREATE TABLE "DealerRecords" (
    "id" SERIAL NOT NULL,
    "dealership" TEXT NOT NULL,
    "seller_first" TEXT,
    "seller_last" TEXT,
    "buyer_first" TEXT,
    "buyer_last" TEXT,
    "vehicle_make" TEXT,
    "vehicle_model" TEXT,
    "vehicle_category" TEXT,
    "time" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "DealerRecords_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DealerRecordsBuybacks" (
    "id" SERIAL NOT NULL,
    "dealership" TEXT NOT NULL,
    "seller_first" TEXT,
    "seller_last" TEXT,
    "buyer_first" TEXT,
    "buyer_last" TEXT,
    "vehicle_make" TEXT,
    "vehicle_model" TEXT,
    "vehicle_category" TEXT,
    "time" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "DealerRecordsBuybacks_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DealerShowrooms" (
    "Id" SERIAL NOT NULL,
    "dealership" TEXT NOT NULL,
    "showroom" JSONB NOT NULL,

    CONSTRAINT "DealerShowrooms_pkey" PRIMARY KEY ("Id")
);

-- CreateTable
CREATE TABLE "DealerStock" (
    "Id" SERIAL NOT NULL,
    "dealership" TEXT NOT NULL,
    "vehicle" TEXT NOT NULL,
    "modelType" TEXT NOT NULL,
    "data" JSONB NOT NULL,
    "quantity" INTEGER NOT NULL,
    "lastStocked" TEXT NOT NULL,
    "lastPurchase" BIGINT NOT NULL,

    CONSTRAINT "DealerStock_pkey" PRIMARY KEY ("Id")
);

-- CreateTable
CREATE TABLE "Defaults" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "collection" TEXT,
    "date" TIMESTAMP(3),

    CONSTRAINT "Defaults_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EntityTypes" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,

    CONSTRAINT "EntityTypes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Firearms" (
    "police_id" SERIAL NOT NULL,
    "serial" TEXT NOT NULL,
    "scratched" BOOLEAN NOT NULL DEFAULT false,
    "purchased" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "model" TEXT NOT NULL,
    "item" TEXT NOT NULL,
    "owner_sid" INTEGER,
    "owner_name" TEXT,
    "police_filed" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "Firearms_pkey" PRIMARY KEY ("police_id")
);

-- CreateTable
CREATE TABLE "FirearmsFlags" (
    "id" INTEGER NOT NULL,
    "serial" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "author_sid" INTEGER,
    "author_first" TEXT NOT NULL,
    "author_last" TEXT NOT NULL,
    "author_callsign" TEXT NOT NULL,

    CONSTRAINT "FirearmsFlags_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FirearmsProjectiles" (
    "Id" TEXT NOT NULL,
    "WeaponSerial" TEXT NOT NULL,
    "Coords" TEXT NOT NULL,
    "AmmoType" TEXT NOT NULL,

    CONSTRAINT "FirearmsProjectiles_pkey" PRIMARY KEY ("Id")
);

-- CreateTable
CREATE TABLE "Inventory" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "slot" INTEGER NOT NULL,
    "item_id" TEXT NOT NULL,
    "quality" INTEGER NOT NULL,
    "information" JSONB NOT NULL,
    "dropped" BOOLEAN NOT NULL DEFAULT false,
    "creationDate" BIGINT NOT NULL DEFAULT 0,
    "expiryDate" BIGINT NOT NULL DEFAULT -1,

    CONSTRAINT "Inventory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "InventoryShopLogs" (
    "id" SERIAL NOT NULL,
    "date" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "inventory" TEXT NOT NULL,
    "item" TEXT NOT NULL,
    "count" INTEGER NOT NULL,
    "itemId" BIGINT NOT NULL,
    "buyer" INTEGER NOT NULL DEFAULT 0,
    "metadata" JSONB NOT NULL,

    CONSTRAINT "InventoryShopLogs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "IrcChannels" (
    "id" SERIAL NOT NULL,
    "slug" TEXT NOT NULL,
    "joined" BIGINT NOT NULL,
    "character" TEXT NOT NULL,

    CONSTRAINT "IrcChannels_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "IrcMessages" (
    "id" SERIAL NOT NULL,
    "from" TEXT NOT NULL,
    "channel" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "time" BIGINT NOT NULL,

    CONSTRAINT "IrcMessages_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Jobs" (
    "id" SERIAL NOT NULL,
    "Id" TEXT NOT NULL,
    "Name" TEXT NOT NULL,
    "Type" TEXT NOT NULL,
    "Workplaces" JSONB NOT NULL,
    "Grades" JSONB NOT NULL,
    "Salary" INTEGER,
    "SalaryTier" INTEGER,
    "LastUpdated" TEXT NOT NULL,
    "Owner" TEXT NOT NULL,

    CONSTRAINT "Jobs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Loans" (
    "id" SERIAL NOT NULL,
    "SID" INTEGER NOT NULL,
    "AssetIdentifier" TEXT NOT NULL,
    "Type" TEXT NOT NULL,
    "Remaining" INTEGER NOT NULL,
    "Defaulted" BOOLEAN NOT NULL,
    "InterestRate" INTEGER NOT NULL,
    "Total" INTEGER NOT NULL,
    "Paid" INTEGER NOT NULL,
    "PaidPayments" INTEGER NOT NULL,
    "DownPayment" INTEGER NOT NULL,
    "MissablePayments" INTEGER NOT NULL,
    "MissedPayments" INTEGER NOT NULL,
    "TotalPayments" INTEGER NOT NULL,
    "TotalMissedPayments" INTEGER NOT NULL,
    "NextPayment" TIMESTAMP(3) NOT NULL,
    "LastPayment" TIMESTAMP(3) NOT NULL,
    "LastMissedPayment" TIMESTAMP(3) NOT NULL,
    "Creation" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Loans_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "LoansCreditScores" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "SID" INTEGER NOT NULL,
    "Score" INTEGER NOT NULL,

    CONSTRAINT "LoansCreditScores_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Locations" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "Coords" JSONB NOT NULL,
    "Heading" INTEGER,
    "Type" TEXT NOT NULL,
    "Name" TEXT NOT NULL,
    "default" BOOLEAN NOT NULL,

    CONSTRAINT "Locations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Logs" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "insertId" SERIAL NOT NULL,
    "level" TEXT NOT NULL,
    "component" TEXT NOT NULL,
    "log" TEXT NOT NULL,
    "data" TEXT NOT NULL,
    "date" TIMESTAMP(3),

    CONSTRAINT "Logs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MdtCharges" (
    "id" SERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "creator" INTEGER NOT NULL,
    "fine" INTEGER NOT NULL,
    "jail" INTEGER NOT NULL,
    "points" INTEGER NOT NULL,

    CONSTRAINT "MdtCharges_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MdtLibrary" (
    "id" SERIAL NOT NULL,
    "label" TEXT NOT NULL,
    "link" TEXT NOT NULL,
    "job" TEXT NOT NULL,
    "workplace" TEXT NOT NULL,

    CONSTRAINT "MdtLibrary_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MdtNotices" (
    "id" SERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "author" TEXT NOT NULL,
    "restricted" TEXT NOT NULL,
    "created" TIMESTAMP(3) NOT NULL,
    "creator" INTEGER NOT NULL,

    CONSTRAINT "MdtNotices_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MdtReports" (
    "id" SERIAL NOT NULL,
    "type" INTEGER NOT NULL,
    "title" TEXT NOT NULL,
    "notes" TEXT NOT NULL,
    "creatorSID" INTEGER NOT NULL,
    "creatorName" TEXT NOT NULL,
    "creatorCallsign" TEXT NOT NULL,
    "allowAttorney" BOOLEAN NOT NULL,
    "created" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "MdtReports_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MdtReportsEvidence" (
    "id" SERIAL NOT NULL,
    "report" TEXT NOT NULL,
    "value" TEXT NOT NULL,
    "type" INTEGER NOT NULL,
    "label" TEXT NOT NULL,

    CONSTRAINT "MdtReportsEvidence_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MdtReportsPeople" (
    "id" SERIAL NOT NULL,
    "report" TEXT,
    "type" TEXT,
    "SID" INTEGER,
    "First" TEXT,
    "Last" TEXT,
    "Callsign" INTEGER,
    "charges" TEXT,
    "plea" TEXT,
    "Licenses" TEXT,
    "sentenced" BOOLEAN NOT NULL DEFAULT false,
    "sentencedAt" BIGINT,
    "parole" INTEGER,
    "warrant" BOOLEAN NOT NULL DEFAULT false,
    "jail" INTEGER,
    "reduction" TEXT,
    "revoked" TEXT,
    "doc" BOOLEAN NOT NULL DEFAULT false,
    "expunged" BOOLEAN NOT NULL DEFAULT false,
    "points" INTEGER,
    "fine" INTEGER,

    CONSTRAINT "MdtReportsPeople_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MdtWarrants" (
    "id" SERIAL NOT NULL,
    "title" TEXT,
    "creatorSID" INTEGER,
    "creatorName" TEXT,
    "creatorCallsign" TEXT,
    "state" TEXT,
    "report" TEXT,
    "suspect" TEXT,
    "notes" TEXT,
    "issued" INTEGER,
    "expires" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "MdtWarrants_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MethTables" (
    "id" BIGSERIAL NOT NULL,
    "tier" INTEGER NOT NULL DEFAULT 1,
    "created" TIMESTAMP(3) NOT NULL,
    "cooldown" BIGINT NOT NULL,
    "recipe" TEXT NOT NULL,
    "active_cook" TEXT NOT NULL,

    CONSTRAINT "MethTables_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Peds" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "char" UUID NOT NULL,
    "ped" TEXT NOT NULL,

    CONSTRAINT "Peds_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PhoneCalls" (
    "id" SERIAL NOT NULL,
    "owner" VARCHAR(255),
    "number" VARCHAR(255),
    "time" BIGINT,
    "duration" INTEGER,
    "method" BOOLEAN,
    "limited" BOOLEAN,
    "anonymous" BOOLEAN,
    "decryptable" BOOLEAN,
    "unread" BOOLEAN,
    "deleted" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "PhoneCalls_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PhoneMessages" (
    "id" SERIAL NOT NULL,
    "owner" TEXT,
    "number" TEXT,
    "message" TEXT,
    "time" BIGINT,
    "method" INTEGER,
    "unread" BOOLEAN,
    "deleted" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "PhoneMessages_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PlacedMethTables" (
    "table_id" INTEGER NOT NULL,
    "owner" BIGINT,
    "placed" BIGINT NOT NULL,
    "expires" BIGINT NOT NULL,
    "coords" TEXT NOT NULL,
    "heading" DOUBLE PRECISION NOT NULL DEFAULT 0,

    CONSTRAINT "PlacedMethTables_pkey" PRIMARY KEY ("table_id")
);

-- CreateTable
CREATE TABLE "PlacedProps" (
    "id" SERIAL NOT NULL,
    "model" VARCHAR(255) NOT NULL DEFAULT '',
    "coords" VARCHAR(255) NOT NULL,
    "heading" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "creator" BIGINT NOT NULL,
    "is_frozen" BOOLEAN NOT NULL DEFAULT false,
    "is_enabled" BOOLEAN NOT NULL DEFAULT true,
    "type" INTEGER NOT NULL DEFAULT 0,
    "name_override" VARCHAR(64),

    CONSTRAINT "PlacedProps_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Properties" (
    "id" SERIAL NOT NULL,
    "type" VARCHAR(50) NOT NULL,
    "label" VARCHAR(255) NOT NULL,
    "price" INTEGER NOT NULL DEFAULT 0,
    "sold" BOOLEAN NOT NULL DEFAULT false,
    "owner" TEXT,
    "location" JSONB NOT NULL,
    "upgrades" JSONB NOT NULL,
    "soldAt" TEXT,
    "data" TEXT,
    "foreClosed" BOOLEAN,
    "keys" TEXT,
    "foreclosedTime" INTEGER,

    CONSTRAINT "Properties_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PropertiesFurniture" (
    "property" INTEGER NOT NULL,
    "furniture" JSONB NOT NULL,
    "updatedTime" INTEGER NOT NULL,
    "updatedBy" VARCHAR(255) NOT NULL,

    CONSTRAINT "PropertiesFurniture_pkey" PRIMARY KEY ("property")
);

-- CreateTable
CREATE TABLE "Roles" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "Permission" JSONB NOT NULL,
    "Queue" JSONB NOT NULL,
    "Abv" TEXT,
    "Name" TEXT,

    CONSTRAINT "Roles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Scenes" (
    "id" SERIAL NOT NULL,
    "coords" TEXT NOT NULL,
    "length" INTEGER,
    "expires" BIGINT,
    "staff" BOOLEAN,
    "distance" DOUBLE PRECISION,
    "route" INTEGER,

    CONSTRAINT "Scenes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Sequence" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "current" INTEGER,
    "key" TEXT,

    CONSTRAINT "Sequence_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "StorageUnits" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "label" TEXT,
    "owner" INTEGER DEFAULT -1,
    "level" TEXT,
    "location" TEXT,
    "managedBy" INTEGER,
    "lastAccessed" TIMESTAMP(3),
    "passcode" TEXT,

    CONSTRAINT "StorageUnits_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "StoreBankAccounts" (
    "id" SERIAL NOT NULL,
    "Shop" INTEGER NOT NULL,
    "Account" INTEGER NOT NULL,

    CONSTRAINT "StoreBankAccounts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Tracks" (
    "id" SERIAL NOT NULL,
    "Name" TEXT,
    "Distance" TEXT,
    "Type" TEXT,
    "Checkpoints" JSONB NOT NULL,
    "Fastest" JSONB NOT NULL,
    "History" JSONB NOT NULL,

    CONSTRAINT "Tracks_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TracksPd" (
    "id" TEXT NOT NULL,
    "Name" TEXT,
    "Distance" TEXT,
    "Type" TEXT,
    "Checkpoints" JSONB NOT NULL,
    "Fastest" JSONB NOT NULL,
    "History" JSONB NOT NULL,

    CONSTRAINT "TracksPd_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Vehicles" (
    "id" SERIAL NOT NULL,
    "VIN" TEXT NOT NULL,
    "Type" INTEGER,
    "Vehicle" INTEGER,
    "RegisteredPlate" TEXT NOT NULL,
    "FakePlate" BOOLEAN NOT NULL DEFAULT false,
    "Fuel" INTEGER,
    "Owner" JSONB NOT NULL,
    "Storage" JSONB NOT NULL,
    "Make" TEXT,
    "Model" TEXT,
    "Class" TEXT,
    "Value" INTEGER,
    "FirstSpawn" BOOLEAN,
    "Properties" JSONB NOT NULL,
    "RegistrationDate" TEXT,
    "Mileage" INTEGER,
    "DirtLevel" DOUBLE PRECISION,
    "Damage" JSONB,
    "DamagedParts" JSONB,
    "Flags" JSONB,
    "Strikes" JSONB,
    "GovAssigned" BOOLEAN DEFAULT false,
    "Polish" JSONB,
    "Harness" INTEGER,
    "Nitrous" INTEGER,
    "NeonsDisabled" BOOLEAN DEFAULT false,
    "FakePlateData" JSONB,
    "LastSave" BIGINT,

    CONSTRAINT "Vehicles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Weed" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "isMale" BOOLEAN NOT NULL DEFAULT false,
    "location" JSONB NOT NULL,
    "growth" INTEGER NOT NULL DEFAULT 0,
    "output" INTEGER NOT NULL DEFAULT 1,
    "material" TEXT NOT NULL,
    "planted" TEXT NOT NULL,
    "water" DOUBLE PRECISION NOT NULL DEFAULT 100,

    CONSTRAINT "Weed_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Users_identifier_key" ON "Users"("identifier");

-- CreateIndex
CREATE UNIQUE INDEX "Users_account_key" ON "Users"("account");

-- CreateIndex
CREATE INDEX "Users_account_idx" ON "Users"("account");

-- CreateIndex
CREATE UNIQUE INDEX "Characters_SID_key" ON "Characters"("SID");

-- CreateIndex
CREATE UNIQUE INDEX "BankAccounts_account_key" ON "BankAccounts"("account");

-- CreateIndex
CREATE INDEX "BankAccountsPermissions_job_idx" ON "BankAccountsPermissions"("job");

-- CreateIndex
CREATE INDEX "BankAccountsPermissions_workplace_idx" ON "BankAccountsPermissions"("workplace");

-- CreateIndex
CREATE INDEX "BankAccountsPermissions_jointOwner_idx" ON "BankAccountsPermissions"("jointOwner");

-- CreateIndex
CREATE INDEX "BankAccountsPermissions_account_idx" ON "BankAccountsPermissions"("account");

-- CreateIndex
CREATE INDEX "BankAccountTransaction_account_idx" ON "BankAccountTransaction"("account");

-- CreateIndex
CREATE INDEX "PRIMARY" ON "bans"("id");

-- CreateIndex
CREATE UNIQUE INDEX "BenchSchematics_bench_key" ON "BenchSchematics"("bench");

-- CreateIndex
CREATE INDEX "BenchSchematics_bench_idx" ON "BenchSchematics"("bench");

-- CreateIndex
CREATE UNIQUE INDEX "Billboards_billboardId_key" ON "Billboards"("billboardId");

-- CreateIndex
CREATE INDEX "Billboards_billboardId_idx" ON "Billboards"("billboardId");

-- CreateIndex
CREATE INDEX "business_receipts_id_idx" ON "business_receipts"("id");

-- CreateIndex
CREATE UNIQUE INDEX "BusinessTvs_tv_key" ON "BusinessTvs"("tv");

-- CreateIndex
CREATE INDEX "BusinessTvs_tv_idx" ON "BusinessTvs"("tv");

-- CreateIndex
CREATE UNIQUE INDEX "CasinoConfig_key_key" ON "CasinoConfig"("key");

-- CreateIndex
CREATE UNIQUE INDEX "Peds_char_key" ON "Peds"("char");

-- CreateIndex
CREATE INDEX "Peds_char_idx" ON "Peds"("char");

-- CreateIndex
CREATE UNIQUE INDEX "Vehicles_VIN_key" ON "Vehicles"("VIN");

-- AddForeignKey
ALTER TABLE "Characters" ADD CONSTRAINT "Characters_User_fkey" FOREIGN KEY ("User") REFERENCES "Users"("account") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BankAccountsPermissions" ADD CONSTRAINT "BankAccountsPermissions_account_fkey" FOREIGN KEY ("account") REFERENCES "BankAccounts"("account") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BankAccountTransaction" ADD CONSTRAINT "BankAccountTransaction_account_fkey" FOREIGN KEY ("account") REFERENCES "BankAccounts"("account") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Peds" ADD CONSTRAINT "Peds_char_fkey" FOREIGN KEY ("char") REFERENCES "Characters"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
