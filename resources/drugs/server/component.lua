_DRUGS = _DRUGS or {}
local _addictionTemplate = {
  Meth = {
    LastUse = false,
    Factor = 0.0,
  },
  Coke = {
    LastUse = false,
    Factor = 0.0,
  },
}

AddEventHandler("Drugs:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Fetch = exports['core']:FetchComponent("Fetch")
  Logger = exports['core']:FetchComponent("Logger")
  Callbacks = exports['core']:FetchComponent("Callbacks")
  Middleware = exports['core']:FetchComponent("Middleware")
  Execute = exports['core']:FetchComponent("Execute")
  Chat = exports['core']:FetchComponent("Chat")
  Inventory = exports['core']:FetchComponent("Inventory")
  Crypto = exports['core']:FetchComponent("Crypto")
  Vehicles = exports['core']:FetchComponent("Vehicles")
  Drugs = exports['core']:FetchComponent("Drugs")
  Vendor = exports['core']:FetchComponent("Vendor")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies("Drugs", {
    "Fetch",
    "Logger",
    "Callbacks",
    "Middleware",
    "Execute",
    "Chat",
    "Inventory",
    "Crypto",
    "Vehicles",
    "Drugs",
    "Vendor",
  }, function(error)
    if #error > 0 then
      exports['core']:FetchComponent("Logger"):Critical("Drugs", "Failed To Load All Dependencies")
      return
    end
    RetrieveComponents()
    RegisterItemUse()
    RunDegenThread()

    Middleware:Add("Characters:Spawning", function(source)
      local plyr = exports['core']:FetchSource(source)
      if plyr ~= nil then
        local char = plyr:GetData("Character")
        if char ~= nil then
          if char:GetData("Addiction") == nil then
            char:SetData("Addiction", _addictionTemplate)
          end
        end
      end
    end, 1)

    TriggerEvent("Drugs:Server:Startup")

    RemoveEventHandler(setupEvent)
  end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
  exports['core']:RegisterComponent("Drugs", _DRUGS)
end)
