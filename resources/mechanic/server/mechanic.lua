AddEventHandler("Apartments:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Callbacks = exports['core']:FetchComponent("Callbacks")
  Logger = exports['core']:FetchComponent("Logger")
  Utils = exports['core']:FetchComponent("Utils")
  Fetch = exports['core']:FetchComponent("Fetch")
  Mechanic = exports['core']:FetchComponent("Mechanic")
  Jobs = exports['core']:FetchComponent("Jobs")
  Inventory = exports['core']:FetchComponent("Inventory")
  Crafting = exports['core']:FetchComponent("Crafting")
  Vehicles = exports['core']:FetchComponent("Vehicles")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies("Mechanic", {

    "Callbacks",
    "Logger",
    "Utils",
    "Fetch",
    "Mechanic",
    "Jobs",
    "Inventory",
    "Crafting",
    "Vehicles",
  }, function(error)
    if #error > 0 then
      return
    end
    RetrieveComponents()
    RegisterCallbacks()

    RegisterMechanicItems()

    for k, v in ipairs(_mechanicShopStorageCrafting) do
      if v.partCrafting then
        for benchId, bench in ipairs(v.partCrafting) do
          Crafting:RegisterBench(string.format("mech-%s-%s", v.job, benchId), bench.label, bench.targeting, {
            x = bench.targeting.poly.coords.x,
            y = bench.targeting.poly.coords.y,
            z = bench.targeting.poly.coords.z,
            h = bench.targeting.poly.options.heading,
          }, {
            job = {
              id = v.job,
              onDuty = true,
            },
          }, bench.recipes, bench.canUseSchematics)
        end
      end

      if v.partStorage then
        for storageId, storage in ipairs(v.partStorage) do
          Inventory.Poly:Create(storage)
        end
      end
    end

    RemoveEventHandler(setupEvent)
  end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
  exports['core']:RegisterComponent("Mechanic", MECHANIC)
end)

MECHANIC = {}
