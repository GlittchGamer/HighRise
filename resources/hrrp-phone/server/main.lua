function defaultApps()
  local defApps = {}
  local dock = { "contacts", "phone", "messages" }
  for k, v in pairs(PHONE_APPS) do
    if not v.canUninstall then
      table.insert(defApps, v.name)
    end
  end
  return {
    installed = defApps,
    home = defApps,
    dock = dock,
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

local defaultSettings = {
  wallpaper = "wallpaper",
  ringtone = "ringtone1.ogg",
  texttone = "text1.ogg",
  colors = {
    accent = "#1a7cc1",
  },
  zoom = 75,
  volume = 100,
  notifications = true,
  appNotifications = {},
}

local defaultPermissions = {
  redline = {
    create = false,
  },
}

AddEventHandler("onResourceStart", function(resource)
  if resource == GetCurrentResourceName() then
    TriggerClientEvent("Phone:Client:SetApps", -1, PHONE_APPS)
  end
end)

AddEventHandler("Phone:Shared:DependencyUpdate", RetrieveComponents)

function RetrieveComponents()
  Fetch = exports["hrrp-base"]:FetchComponent("Fetch")

  Callbacks = exports["hrrp-base"]:FetchComponent("Callbacks")
  Logger = exports["hrrp-base"]:FetchComponent("Logger")
  Utils = exports["hrrp-base"]:FetchComponent("Utils")
  Chat = exports["hrrp-base"]:FetchComponent("Chat")
  Phone = exports["hrrp-base"]:FetchComponent("Phone")
  Middleware = exports["hrrp-base"]:FetchComponent("Middleware")
  Execute = exports["hrrp-base"]:FetchComponent("Execute")
  Config = exports["hrrp-base"]:FetchComponent("Config")
  MDT = exports["hrrp-base"]:FetchComponent("MDT")
  Jobs = exports["hrrp-base"]:FetchComponent("Jobs")
  Labor = exports["hrrp-base"]:FetchComponent("Labor")
  Crypto = exports["hrrp-base"]:FetchComponent("Crypto")
  VOIP = exports["hrrp-base"]:FetchComponent("VOIP")
  Generator = exports["hrrp-base"]:FetchComponent("Generator")
  Properties = exports["hrrp-base"]:FetchComponent("Properties")
  Vehicles = exports["hrrp-base"]:FetchComponent("Vehicles")
  Inventory = exports["hrrp-base"]:FetchComponent("Inventory")
  Loot = exports["hrrp-base"]:FetchComponent("Loot")
  Loans = exports["hrrp-base"]:FetchComponent("Loans")
  Billing = exports["hrrp-base"]:FetchComponent("Billing")
  Banking = exports["hrrp-base"]:FetchComponent("Banking")
  Reputation = exports["hrrp-base"]:FetchComponent("Reputation")
  Robbery = exports["hrrp-base"]:FetchComponent("Robbery")
  Wallet = exports["hrrp-base"]:FetchComponent("Wallet")
  Sequence = exports["hrrp-base"]:FetchComponent("Sequence")
  Vendor = exports["hrrp-base"]:FetchComponent("Vendor")
  RegisterChatCommands()
end

local startupEvent = nil
startupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports["hrrp-base"]:RequestDependencies("Phone", {
    "Fetch",

    "Callbacks",
    "Logger",
    "Utils",
    "Chat",
    "Phone",
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
    "Vendor",
  }, function(error)
    if #error > 0 then
      return
    end
    -- Do something to handle if not all dependencies loaded
    RetrieveComponents()
    Startup()
    -- * Now we can load the Race Tracks
    LoadTracks()
    LoadPDTracks()
    -- * End the loading of race tracks
    TriggerEvent("Phone:Server:RegisterMiddleware")
    TriggerEvent("Phone:Server:RegisterCallbacks")

    Reputation:Create("Racing", "LS Underground", {
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

    RemoveEventHandler(startupEvent)
  end)
end)

AddEventHandler("Phone:Server:RegisterMiddleware", function()
  Middleware:Add("Characters:Spawning", function(source)
    Phone:UpdateJobData(source)
    TriggerClientEvent("Phone:Client:SetApps", source, PHONE_APPS)

    local char = exports['hrrp-base']:FetchSource(source):GetData("Character")
    local myPerms = char:GetData("PhonePermissions")
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
      char:SetData("PhonePermissions", myPerms)
    end
  end, 1)
  Middleware:Add("Phone:UIReset", function(source)
    Phone:UpdateJobData(source)
    TriggerClientEvent("Phone:Client:SetApps", source, PHONE_APPS)
  end)
  Middleware:Add("Characters:Creating", function(source, cData)
    local t = Middleware:TriggerEventWithData("Phone:CharacterCreated", source, cData)
    local aliases = {}

    for k, v in ipairs(t) do
      aliases[v.app] = v.alias
    end

    return {
      {
        Alias = aliases,
        Apps = defaultApps(),
        PhoneSettings = defaultSettings,
        PhonePermissions = defaultPermissions,
      },
    }
  end)
end)

RegisterNetEvent("Phone:Server:UIReset", function()
  exports['hrrp-base']:MiddlewareTriggerEvent("Phone:UIReset", source)
end)

AddEventHandler("Phone:Server:RegisterCallbacks", function()
  exports['hrrp-base']:CallbacksRegisterServer("Phone:Apps:Home", function(src, data, cb)
    local char = exports['hrrp-base']:FetchSource(src):GetData("Character")
    local apps = char:GetData("Apps")
    if data.action == "add" then
      if #apps.home < 20 then
        table.insert(apps.home, data.app)
      end
    else
      local newHome = {}
      for k, v in ipairs(apps.home) do
        if v ~= data.app then
          table.insert(newHome, v)
        end
      end

      apps.home = newHome
    end
    char:SetData("Apps", apps)
  end)

  exports['hrrp-base']:CallbacksRegisterServer("Phone:Apps:Dock", function(src, data, cb)
    local char = exports['hrrp-base']:FetchSource(src):GetData("Character")
    local apps = char:GetData("Apps")
    if data.action == "add" then
      if #apps.dock < 4 then
        table.insert(apps.dock, data.app)
      end
    else
      local newDock = {}
      for k, v in ipairs(apps.dock) do
        if v ~= data.app then
          table.insert(newDock, v)
        end
      end

      apps.dock = newDock
    end
    char:SetData("Apps", apps)
  end)

  exports['hrrp-base']:CallbacksRegisterServer("Phone:Apps:Reorder", function(src, data, cb)
    local char = exports['hrrp-base']:FetchSource(src):GetData("Character")
    local apps = char:GetData("Apps")
    apps[data.type] = data.apps
    char:SetData("Apps", apps)
  end)

  exports['hrrp-base']:CallbacksRegisterServer("Phone:UpdateAlias", function(src, data, cb)
    local char = exports['hrrp-base']:FetchSource(src):GetData("Character")
    local alias = char:GetData("Alias") or {}
    if not data.unique then
      alias[data.app] = data.alias
      char:SetData("Alias", alias)
      cb(true)
      TriggerEvent("Phone:Server:AliasUpdated", src)
      return cb(true)
    end

    local fetchCharacter = MySQL.single.await('SELECT * FROM characters WHERE SID = ?', { char:GetData('SID') })
    if fetchCharacter then
      local dbAlias = json.decode(fetchCharacter.Alias)
      if dbAlias[data.app] then
        if dbAlias[data.app].name then
          dbAlias[data.app].name = data.alias.name
        else
          dbAlias[data.app] = data.alias
        end
      end

      local updateAlias = MySQL.update.await(
        'UPDATE characters SET Alias = @Alias WHERE SID = @SID', {
          ['@Alias'] = json.encode(dbAlias),
          ['@SID'] = char:GetData('SID')
        })

      alias[data.app] = data.alias
      char:SetData("Alias", alias)
      TriggerEvent("Phone:Server:AliasUpdated", src)
      return cb(true)
    end

    return cb(false)
  end)

  exports['hrrp-base']:CallbacksRegisterServer("Phone:ShareMyContact", function(src, data, cb)
    local char = exports['hrrp-base']:FetchSource(src):GetData("Character")
    local myPed = GetPlayerPed(src)
    local myCoords = GetEntityCoords(myPed)
    local myBucket = GetPlayerRoutingBucket(src)
    for k, v in pairs(Fetch:All()) do
      local tsrc = v:GetData("Source")
      local tped = GetPlayerPed(tsrc)
      local coords = GetEntityCoords(tped)
      if tsrc ~= src and #(myCoords - coords) <= 5.0 and GetPlayerRoutingBucket(tsrc) == myBucket then
        TriggerClientEvent("Phone:Client:ReceiveShare", tsrc, {
          type = "contacts",
          data = {
            name = char:GetData("First") .. " " .. char:GetData("Last"),
            number = char:GetData("Phone"),
          },
        }, os.time() * 1000)
      end
    end
  end)

  exports['hrrp-base']:CallbacksRegisterServer("Phone:Permissions", function(src, data, cb)
    local char = exports['hrrp-base']:FetchSource(src):GetData("Character")

    if char ~= nil then
      local perms = char:GetData("PhonePermissions")

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
