function defaultApps()
  -- local defApps = {}
  -- for k, v in pairs(LAPTOP_APPS) do
  -- 	if not v.canUninstall then
  -- 		table.insert(defApps, v.name)
  -- 	end
  -- end
  -- return {
  -- 	installed = defApps,
  -- 	home = defApps,
  -- }

  return {
    installed = {
      "settings",
      "files",
      "internet",
      "bizwiz",
      "teams",
      "lsunderground",
    },
    home = {
      "settings",
      "files",
      "internet",
      "bizwiz",
      "teams",
      "lsunderground",
    },
  }
end

function hasValue(tbl, value)
  for k, v in ipairs(tbl) do
    if v == value or (type(v) == "table" and hasValue(v, value)) then
      return true
    end
  end
  return false
end

function table.copy(t)
  local u = {}
  for k, v in pairs(t) do
    u[k] = v
  end
  return setmetatable(u, getmetatable(t))
end

function defaultSettings()
  return {
    wallpaper = "wallpaper",
    texttone = "notification.ogg",
    colors = {
      accent = "#1a7cc1",
    },
    zoom = 75,
    volume = 100,
    notifications = true,
    appNotifications = {},
  }
end

local defaultPermissions = {
  redline = {
    create = false,
  },
  lsunderground = {
    admin = false,
  },
}

AddEventHandler("onResourceStart", function(resource)
  if resource == GetCurrentResourceName() then
    TriggerClientEvent("Laptop:Client:SetApps", -1, LAPTOP_APPS)
  end
end)

AddEventHandler("Laptop:Shared:DependencyUpdate", RetrieveComponents)

function RetrieveComponents()
  Fetch = exports['core']:FetchComponent("Fetch")

  Callbacks = exports['core']:FetchComponent("Callbacks")
  Logger = exports['core']:FetchComponent("Logger")
  Utils = exports['core']:FetchComponent("Utils")
  Chat = exports['core']:FetchComponent("Chat")
  Middleware = exports['core']:FetchComponent("Middleware")
  Execute = exports['core']:FetchComponent("Execute")
  Config = exports['core']:FetchComponent("Config")
  MDT = exports['core']:FetchComponent("MDT")
  Jobs = exports['core']:FetchComponent("Jobs")
  Labor = exports['core']:FetchComponent("Labor")
  Crypto = exports['core']:FetchComponent("Crypto")
  VOIP = exports['core']:FetchComponent("VOIP")
  Generator = exports['core']:FetchComponent("Generator")
  Properties = exports['core']:FetchComponent("Properties")
  Vehicles = exports['core']:FetchComponent("Vehicles")
  Inventory = exports['core']:FetchComponent("Inventory")
  Loot = exports['core']:FetchComponent("Loot")
  Loans = exports['core']:FetchComponent("Loans")
  Billing = exports['core']:FetchComponent("Billing")
  Banking = exports['core']:FetchComponent("Banking")
  Reputation = exports['core']:FetchComponent("Reputation")
  Robbery = exports['core']:FetchComponent("Robbery")
  Wallet = exports['core']:FetchComponent("Wallet")
  Sequence = exports['core']:FetchComponent("Sequence")
  Phone = exports['core']:FetchComponent("Phone")
  Laptop = exports['core']:FetchComponent("Laptop")
  RegisterChatCommands()
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies("Laptop", {
    "Fetch",

    "Callbacks",
    "Logger",
    "Utils",
    "Chat",
    "Laptop",
    "Middleware",
    "Execute",
    "Config",
    "MDT",
    "Jobs",
    "Labor",
    "Crypto",
    "VOIP",
    "Generator",
    "Properties",
    "Vehicles",
    "Inventory",
    "Loot",
    "Loans",
    "Billing",
    "Banking",
    "Reputation",
    "Robbery",
    "Wallet",
    "Sequence",
    "Phone",
  }, function(error)
    if #error > 0 then
      return
    end
    -- Do something to handle if not all dependencies loaded
    RetrieveComponents()
    Startup()
    TriggerEvent("Laptop:Server:RegisterMiddleware")
    TriggerEvent("Laptop:Server:RegisterCallbacks")

    Inventory.Items:RegisterUse("laptop", "Laptop", function(source, itemData)
      TriggerClientEvent("Laptop:Client:Open", source)
    end)

    Reputation:Create("Chopping", "Vehicle Chopping", {
      { label = "Rank 1",  value = 1000 },
      { label = "Rank 2",  value = 2500 },
      { label = "Rank 3",  value = 5000 },
      { label = "Rank 4",  value = 10000 },
      { label = "Rank 5",  value = 25000 },
      { label = "Rank 6",  value = 50000 },
      { label = "Rank 7",  value = 100000 },
      { label = "Rank 8",  value = 250000 },
      { label = "Rank 9",  value = 500000 },
      { label = "Rank 10", value = 1000000 },
    }, true)

    Reputation:Create("Boosting", "Boosting", {
      { label = "D",  value = 0 },
      { label = "C",  value = 6000 },
      { label = "B",  value = 15000 },
      { label = "A",  value = 50000 },
      { label = "A+", value = 120000 }, -- Get Scratching
      { label = "S+", value = 150000 },
    }, true)

    RemoveEventHandler(setupEvent)
  end)
end)

AddEventHandler("Laptop:Server:RegisterMiddleware", function()
  Middleware:Add("Characters:Spawning", function(source)
    Laptop:UpdateJobData(source)
    TriggerClientEvent("Laptop:Client:SetApps", source, LAPTOP_APPS)

    local char = exports['core']:FetchSource(source):GetData("Character")
    local myPerms = char:GetData("LaptopPermissions") or {}
    local modified = false
    for app, perms in pairs(defaultPermissions) do
      if myPerms[app] == nil then
        myPerms[app] = perms
        modified = true
      else
        for perm, state in pairs(perms) do
          if myPerms[app][perm] == nil then
            myPerms[app][perm] = state
            modified = true
          end
        end
      end
    end

    if modified then
      char:SetData("LaptopPermissions", myPerms)
    end

    if not char:GetData("LaptopSettings") or next(char:GetData("LaptopSettings")) == nil then
      char:SetData("LaptopSettings", defaultSettings())
    end

    if not char:GetData("LaptopApps") or next(char:GetData("LaptopApps")) == nil then
      char:SetData("LaptopApps", defaultApps())
    end
  end, 1)
  Middleware:Add("Laptop:UIReset", function(source)
    Laptop:UpdateJobData(source)
    TriggerClientEvent("Laptop:Client:SetApps", source, LAPTOP_APPS)
  end)
  Middleware:Add("Characters:Creating", function(source, cData)
    local t = Middleware:TriggerEventWithData("Laptop:CharacterCreated", source, cData)

    return {
      {
        LaptopApps = defaultApps(),
        LaptopSettings = defaultSettings(),
        LaptopPermissions = defaultPermissions,
      },
    }
  end)
end)

RegisterNetEvent("Laptop:Server:UIReset", function()
  exports['core']:MiddlewareTriggerEvent("Laptop:UIReset", source)
end)

AddEventHandler("Laptop:Server:RegisterCallbacks", function()
  exports['core']:CallbacksRegisterServer("Laptop:Permissions", function(src, data, cb)
    local char = exports['core']:FetchSource(src):GetData("Character")

    if char ~= nil then
      local perms = char:GetData("LaptopPermissions")

      for k, v in pairs(data) do
        for k2, v2 in ipairs(v) do
          if not perms[k][v2] then
            cb(false)
            return
          end
        end
      end
      cb(true)
    else
      cb(false)
    end
  end)
end)