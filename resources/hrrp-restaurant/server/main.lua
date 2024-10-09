AddEventHandler("Restaurant:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Callbacks = exports["hrrp-base"]:FetchComponent("Callbacks")
  Middleware = exports["hrrp-base"]:FetchComponent("Middleware")
  Logger = exports["hrrp-base"]:FetchComponent("Logger")
  Fetch = exports["hrrp-base"]:FetchComponent("Fetch")
  Inventory = exports["hrrp-base"]:FetchComponent("Inventory")
  Crafting = exports["hrrp-base"]:FetchComponent("Crafting")
  Jobs = exports["hrrp-base"]:FetchComponent("Jobs")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports["hrrp-base"]:RequestDependencies("Restaurant", {

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

    exports['hrrp-base']:MiddlewareAdd("Characters:Spawning", function(source)
      RunRestaurantJobUpdate(source, true)
    end, 2)

    RemoveEventHandler(setupEvent)
  end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
  exports["hrrp-base"]:RegisterComponent("Restaurant", _RESTAURANT)
end)

_RESTAURANT = {}

function RunRestaurantJobUpdate(source, onSpawn)
  local charJobs = exports['hrrp-jobs']:JobsPermissionsGetJobs(source)
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
