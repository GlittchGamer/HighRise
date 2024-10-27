AddEventHandler("Finance:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Fetch = exports['core']:FetchComponent("Fetch")
  Utils = exports['core']:FetchComponent("Utils")
  Execute = exports['core']:FetchComponent("Execute")

  Middleware = exports['core']:FetchComponent("Middleware")
  Callbacks = exports['core']:FetchComponent("Callbacks")
  Chat = exports['core']:FetchComponent("Chat")
  Logger = exports['core']:FetchComponent("Logger")
  Generator = exports['core']:FetchComponent("Generator")
  Phone = exports['core']:FetchComponent("Phone")
  Crypto = exports['core']:FetchComponent("Crypto")
  Banking = exports['core']:FetchComponent("Banking")
  Billing = exports['core']:FetchComponent("Billing")
  Loans = exports['core']:FetchComponent("Loans")
  Wallet = exports['core']:FetchComponent("Wallet")
  Tasks = exports['core']:FetchComponent("Tasks")
  Jobs = exports['core']:FetchComponent("Jobs")
  Vehicles = exports['core']:FetchComponent("Vehicles")
  Inventory = exports['core']:FetchComponent("Inventory")
  Properties = exports['core']:FetchComponent("Properties")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies("Finance", {
    "Fetch",
    "Utils",
    "Execute",
    "Chat",

    "Middleware",
    "Callbacks",
    "Logger",
    "Generator",
    "Phone",
    "Wallet",
    "Banking",
    "Billing",
    "Loans",
    "Crypto",
    "Jobs",
    "Tasks",
    "Vehicles",
    "Inventory",
    "Properties",
  }, function(error)
    if #error > 0 then
      exports['core']:FetchComponent("Logger"):Critical("Finance", "Failed To Load All Dependencies")
      return
    end
    RetrieveComponents()

    TriggerEvent("Finance:Server:Startup")

    RemoveEventHandler(setupEvent)
  end)
end)
