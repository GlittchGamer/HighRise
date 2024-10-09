AddEventHandler("Finance:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Fetch = exports["hrrp-base"]:FetchComponent("Fetch")
  Utils = exports["hrrp-base"]:FetchComponent("Utils")
  Execute = exports["hrrp-base"]:FetchComponent("Execute")

  Middleware = exports["hrrp-base"]:FetchComponent("Middleware")
  Callbacks = exports["hrrp-base"]:FetchComponent("Callbacks")
  Chat = exports["hrrp-base"]:FetchComponent("Chat")
  Logger = exports["hrrp-base"]:FetchComponent("Logger")
  Generator = exports["hrrp-base"]:FetchComponent("Generator")
  Phone = exports["hrrp-base"]:FetchComponent("Phone")
  Crypto = exports["hrrp-base"]:FetchComponent("Crypto")
  Banking = exports["hrrp-base"]:FetchComponent("Banking")
  Billing = exports["hrrp-base"]:FetchComponent("Billing")
  Loans = exports["hrrp-base"]:FetchComponent("Loans")
  Wallet = exports["hrrp-base"]:FetchComponent("Wallet")
  Tasks = exports["hrrp-base"]:FetchComponent("Tasks")
  Jobs = exports["hrrp-base"]:FetchComponent("Jobs")
  Vehicles = exports["hrrp-base"]:FetchComponent("Vehicles")
  Inventory = exports["hrrp-base"]:FetchComponent("Inventory")
  Properties = exports["hrrp-base"]:FetchComponent("Properties")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports["hrrp-base"]:RequestDependencies("Finance", {
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
      exports["hrrp-base"]:FetchComponent("Logger"):Critical("Finance", "Failed To Load All Dependencies")
      return
    end
    RetrieveComponents()

    TriggerEvent("Finance:Server:Startup")

    RemoveEventHandler(setupEvent)
  end)
end)
