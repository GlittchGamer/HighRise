AddEventHandler("Restaurant:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Callbacks = exports['core']:FetchComponent("Callbacks")
  Middleware = exports['core']:FetchComponent("Middleware")
  Logger = exports['core']:FetchComponent("Logger")
  Fetch = exports['core']:FetchComponent("Fetch")
  Inventory = exports['core']:FetchComponent("Inventory")
  Crafting = exports['core']:FetchComponent("Crafting")
  Jobs = exports['core']:FetchComponent("Jobs")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies("Restaurant", {

    "Callbacks",
    "Middleware",
    "Logger",
    "Fetch",
    "Inventory",
    "Crafting",
    "Jobs",
  }, function(error)
    if error then
    end

    RetrieveComponents()
    Startup()

    exports['core']:MiddlewareAdd("Characters:Spawning", function(source)
      RunRestaurantJobUpdate(source, true)
    end, 2)

    RemoveEventHandler(setupEvent)
  end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
  exports['core']:RegisterComponent("Restaurant", _RESTAURANT)
end)

_RESTAURANT = {}

function RunRestaurantJobUpdate(source, onSpawn)
  local charJobs = exports['jobs']:JobsPermissionsGetJobs(source)
  local warmersList = {}
  for k, v in ipairs(charJobs) do
    local jobWarmers = _warmers[v.Id]
    if jobWarmers then
      table.insert(warmersList, jobWarmers)
    end
  end
  TriggerClientEvent(
    "Restaurant:Client:CreatePoly",
    source,
    _pickups,
    warmersList,
    onSpawn
  )
end

AddEventHandler('Jobs:Server:JobUpdate', function(source)
  RunRestaurantJobUpdate(source)
end)
