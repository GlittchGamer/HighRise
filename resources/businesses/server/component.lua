_pickups = {}

AddEventHandler("Businesses:Shared:DependencyUpdate", RetrieveComponents)
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
  Jobs = exports['core']:FetchComponent("Jobs")
  Vehicles = exports['core']:FetchComponent("Vehicles")
  Inventory = exports['core']:FetchComponent("Inventory")
  Wallet = exports['core']:FetchComponent("Wallet")
  Crafting = exports['core']:FetchComponent("Crafting")
  Banking = exports['core']:FetchComponent("Banking")
  MDT = exports['core']:FetchComponent("MDT")
  StorageUnits = exports['core']:FetchComponent("StorageUnits")
  Laptop = exports['core']:FetchComponent("Laptop")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies("Businesses", {
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
      exports['core']:FetchComponent("Logger"):Critical("Businesses", "Failed To Load All Dependencies")
      return
    end
    RetrieveComponents()

    TriggerEvent("Businesses:Server:Startup")

    exports['core']:MiddlewareAdd("Characters:Spawning", function(source)
      TriggerClientEvent("Businesses:Client:CreatePoly", source, _pickups)
    end, 2)

    Startup()

    RemoveEventHandler(setupEvent)
  end)
end)

function Startup()
  for k, v in ipairs(Config.Businesses) do
    exports['core']:LoggerTrace("Businesses", string.format("Registering Business ^3%s^7", v.Name))
    if v.Benches then
      for benchId, bench in pairs(v.Benches) do
        exports['core']:LoggerTrace("Businesses", string.format("Registering Crafting Bench ^2%s^7 For ^3%s^7", bench.label, v.Name))

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
        exports['core']:LoggerTrace("Businesses", string.format("Registering Poly Inventory ^2%s^7 For ^3%s^7", storage.id, v.Name))
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
