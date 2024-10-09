_pickups = {}

AddEventHandler("Businesses:Shared:DependencyUpdate", RetrieveComponents)
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
  Jobs = exports["hrrp-base"]:FetchComponent("Jobs")
  Vehicles = exports["hrrp-base"]:FetchComponent("Vehicles")
  Inventory = exports["hrrp-base"]:FetchComponent("Inventory")
  Wallet = exports["hrrp-base"]:FetchComponent("Wallet")
  Crafting = exports["hrrp-base"]:FetchComponent("Crafting")
  Banking = exports["hrrp-base"]:FetchComponent("Banking")
  MDT = exports["hrrp-base"]:FetchComponent("MDT")
  StorageUnits = exports["hrrp-base"]:FetchComponent("StorageUnits")
  Laptop = exports["hrrp-base"]:FetchComponent("Laptop")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports["hrrp-base"]:RequestDependencies("Businesses", {
    "Fetch",
    "Utils",
    "Execute",
    "Chat",

    "Middleware",
    "Callbacks",
    "Logger",
    "Generator",
    "Phone",
    "Jobs",
    "Vehicles",
    "Inventory",
    "Wallet",
    "Crafting",
    "Banking",
    "MDT",
    "StorageUnits",
    "Laptop",
  }, function(error)
    if #error > 0 then
      exports["hrrp-base"]:FetchComponent("Logger"):Critical("Businesses", "Failed To Load All Dependencies")
      return
    end
    RetrieveComponents()

    TriggerEvent("Businesses:Server:Startup")

    exports['hrrp-base']:MiddlewareAdd("Characters:Spawning", function(source)
      TriggerClientEvent("Businesses:Client:CreatePoly", source, _pickups)
    end, 2)

    Startup()

    RemoveEventHandler(setupEvent)
  end)
end)

function Startup()
  for k, v in ipairs(Config.Businesses) do
    exports['hrrp-base']:LoggerTrace("Businesses", string.format("Registering Business ^3%s^7", v.Name))
    if v.Benches then
      for benchId, bench in pairs(v.Benches) do
        exports['hrrp-base']:LoggerTrace("Businesses", string.format("Registering Crafting Bench ^2%s^7 For ^3%s^7", bench.label, v.Name))

        if bench.targeting.manual then
          Crafting:RegisterBench(string.format("%s-%s", v.Job, benchId), bench.label, bench.targeting, {}, {
            job = {
              id = v.Job,
              onDuty = true,
            },
          }, bench.recipes)
        else
          Crafting:RegisterBench(string.format("%s-%s", k, benchId), bench.label, bench.targeting, {
            x = 0,
            y = 0,
            z = bench.targeting.poly.coords.z,
            h = bench.targeting.poly.options.heading,
          }, {
            job = {
              id = v.Job,
              onDuty = true,
            },
          }, bench.recipes)
        end
      end
    end

    if v.Storage then
      for _, storage in pairs(v.Storage) do
        exports['hrrp-base']:LoggerTrace("Businesses", string.format("Registering Poly Inventory ^2%s^7 For ^3%s^7", storage.id, v.Name))
        Inventory.Poly:Create(storage)
      end
    end

    if v.Pickups then
      for num, pickup in pairs(v.Pickups) do
        table.insert(_pickups, pickup.id)
        pickup.num = num
        pickup.job = v.Job
        pickup.jobName = v.Name
        GlobalState[string.format("Businesses:Pickup:%s", pickup.id)] = pickup
      end
    end
  end
end
