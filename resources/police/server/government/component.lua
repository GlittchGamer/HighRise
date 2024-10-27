AddEventHandler("Handcuffs:Shared:DependencyUpdate", GovernmentComponents)
function GovernmentComponents()
  Fetch = exports['core']:FetchComponent("Fetch")
  Callbacks = exports['core']:FetchComponent("Callbacks")
  Logger = exports['core']:FetchComponent("Logger")
  Execute = exports['core']:FetchComponent("Execute")
  Wallet = exports['core']:FetchComponent("Wallet")
  Inventory = exports['core']:FetchComponent("Inventory")
  Middleware = exports['core']:FetchComponent("Middleware")
end

_licenses = {
  drivers = { key = "Drivers", price = 1000 },
  weapons = { key = "Weapons", price = 2000 },
  hunting = { key = "Hunting", price = 800 },
  fishing = { key = "Fishing", price = 800 },
}

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies("Handcuffs", {
    "Callbacks",
    "Logger",
    "Fetch",
    "Execute",
    "Wallet",
    "Inventory",
    "Middleware",
  }, function(error)
    if #error > 0 then
      return
    end -- Do something to handle if not all dependencies loaded
    GovernmentComponents()

    exports['core']:CallbacksRegisterServer("Government:BuyID", function(source, data, cb)
      local char = exports['core']:FetchSource(source):GetData("Character")
      if Wallet:Modify(source, -500) then
        Inventory:AddItem(char:GetData("SID"), "govid", 1, {}, 1)
      else
        exports['core']:ExecuteClient(source, "Notification", "Error", "Not Enough Cash")
      end
    end)

    exports['core']:CallbacksRegisterServer("Government:BuyLicense", function(source, data, cb)
      if _licenses[data] ~= nil then
        local char = exports['core']:FetchSource(source):GetData("Character")
        local licenses = char:GetData("Licenses")
        if Wallet:Modify(source, -_licenses[data].price) then
          if licenses[_licenses[data].key] ~= nil and not licenses[_licenses[data].key].Active then
            licenses[_licenses[data].key].Active = true
            char:SetData("Licenses", licenses)

            exports['core']:MiddlewareTriggerEvent("Characters:ForceStore", source)
          else
            exports['core']:ExecuteClient(source, "Notification", "Error", "Unable To Purchase License")
          end
        else
          exports['core']:ExecuteClient(source, "Notification", "Error", "Not Enough Cash")
        end
      else
        exports['core']:LoggerError(
          "Government",
          string.format("%s Tried To Buy Invalid License Type %s", char:GetData("SID"), data),
          {
            console = true,
            discord = true,
          }
        )
        exports['core']:ExecuteClient(source, "Notification", "Error", "Unable To Purchase License")
      end
    end)

    exports['core']:CallbacksRegisterServer("Government:Client:DoWeaponsLicenseBuyPolice", function(source, data, cb)
      local char = exports['core']:FetchSource(source):GetData("Character")
      if exports['jobs']:JobsPermissionsHasJob(source, "police") and char then
        local licenses = char:GetData("Licenses")
        if Wallet:Modify(source, -20) then
          licenses["Weapons"].Active = true
          char:SetData("Licenses", licenses)
          exports['core']:MiddlewareTriggerEvent("Characters:ForceStore", source)
        else
          exports['core']:ExecuteClient(source, "Notification", "Error", "Not Enough Cash")
        end
      else
        exports['core']:ExecuteClient(source, "Notification", "Error", "You are Not PD")
      end
    end)

    -- Inventory.Poly:Create({
    -- 	id = "doj-chief-justice-safe",
    -- 	type = "box",
    -- 	coords = vector3(-586.32, -213.18, 42.84),
    -- 	width = 0.6,
    -- 	length = 1.0,
    -- 	options = {
    -- 		heading = 30,
    -- 		--debugPoly=true,
    -- 		minZ = 41.84,
    -- 		maxZ = 44.24,
    -- 	},
    -- 	data = {
    -- 		inventory = {
    -- 			invType = 46,
    -- 			owner = "doj-chief-justice-safe",
    -- 		},
    -- 	},
    -- })

    Inventory.Poly:Create({
      id = "doj-storage",
      type = "box",
      coords = vector3(-586.64, -203.5, 38.23),
      length = 0.8,
      width = 1.4,
      options = {
        heading = 30,
        --debugPoly=true,
        minZ = 37.23,
        maxZ = 39.43
      },
      data = {
        inventory = {
          invType = 116,
          owner = "doj-storage",
        },
      },
    })

    RemoveEventHandler(setupEvent)
  end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
  exports['core']:RegisterComponent("Government", _GOVT)
end)

_GOVT = {}

RegisterNetEvent("Government:Server:Gavel", function()
  TriggerClientEvent("Government:Client:Gavel", -1)
end)
