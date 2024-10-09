AddEventHandler("Apartments:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Callbacks = exports["hrrp-base"]:FetchComponent("Callbacks")
  Logger = exports["hrrp-base"]:FetchComponent("Logger")
  Utils = exports["hrrp-base"]:FetchComponent("Utils")
  Fetch = exports["hrrp-base"]:FetchComponent("Fetch")
  Mechanic = exports["hrrp-base"]:FetchComponent("Mechanic")
  Jobs = exports["hrrp-base"]:FetchComponent("Jobs")
  Inventory = exports["hrrp-base"]:FetchComponent("Inventory")
  Crafting = exports["hrrp-base"]:FetchComponent("Crafting")
  Vehicles = exports["hrrp-base"]:FetchComponent("Vehicles")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports["hrrp-base"]:RequestDependencies("Mechanic", {

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
  exports["hrrp-base"]:RegisterComponent("Mechanic", MECHANIC)
end)

MECHANIC = {}
