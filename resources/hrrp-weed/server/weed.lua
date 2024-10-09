_plants = {}

AddEventHandler("Weed:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Callbacks = exports["hrrp-base"]:FetchComponent("Callbacks")
  Logger = exports["hrrp-base"]:FetchComponent("Logger")
  Middleware = exports["hrrp-base"]:FetchComponent("Middleware")
  Logger = exports["hrrp-base"]:FetchComponent("Logger")
  Utils = exports["hrrp-base"]:FetchComponent("Utils")
  Locations = exports["hrrp-base"]:FetchComponent("Locations")
  Game = exports["hrrp-base"]:FetchComponent("Game")
  Weed = exports["hrrp-base"]:FetchComponent("Weed")
  Routing = exports["hrrp-base"]:FetchComponent("Routing")
  Fetch = exports["hrrp-base"]:FetchComponent("Fetch")
  Inventory = exports["hrrp-base"]:FetchComponent("Inventory")
  Execute = exports["hrrp-base"]:FetchComponent("Execute")
  Routing = exports["hrrp-base"]:FetchComponent("Routing")
  Tasks = exports["hrrp-base"]:FetchComponent("Tasks")
  Wallet = exports["hrrp-base"]:FetchComponent("Wallet")
  Reputation = exports["hrrp-base"]:FetchComponent("Reputation")
  WaitList = exports["hrrp-base"]:FetchComponent("WaitList")
  Chat = exports["hrrp-base"]:FetchComponent("Chat")
  Status = exports["hrrp-base"]:FetchComponent("Status")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports["hrrp-base"]:RequestDependencies("Weed", {

    "Callbacks",
    "Logger",
    "Middleware",
    "Logger",
    "Execute",
    "Utils",
    "Locations",
    "Game",
    "Routing",
    "Fetch",
    "Weed",
    "Inventory",
    "Routing",
    "Tasks",
    "Wallet",
    "Reputation",
    "WaitList",
    "Chat",
    "Status",
  }, function(error)
    if #error > 0 then
      return
    end -- Do something to handle if not all dependencies loaded
    RetrieveComponents()
    Startup()
    RegisterMiddleware()
    RegisterCallbacks()
    RegisterTasks()
    RegisterItems()

    RemoveEventHandler(setupEvent)
  end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
  exports["hrrp-base"]:RegisterComponent("Weed", WEED)
end)

function getStageByPct(pct)
  local stagePct = 100 / (#Plants - 1)
  return math.floor((pct / stagePct) + 1.5)
end

function checkNearPlant(source, id)
  local coords = GetEntityCoords(GetPlayerPed(source))
  if _plants[id] ~= nil then
    local plantLocation = _plants[id].plant.location
    return #(
      vector3(coords.x, coords.y, coords.z)
      - vector3(plantLocation.x, plantLocation.y, plantLocation.z)
    ) <= 5
  else
    return false
  end
end

WEED = {
  Planting = {
    Set = function(self, id, isUpdate)
      if _plants[id] ~= nil then
        local stage = getStageByPct(_plants[id].plant.growth)
        _plants[id].stage = stage

        TriggerClientEvent('Weed:Client:Objects:Update', -1, id, _plants[id], isUpdate)
      end
    end,
    Delete = function(self, id, skipRemove)
      if _plants[id] ~= nil then
        _plants[id] = nil
        TriggerClientEvent('Weed:Client:Objects:Delete', -1, id)
      end
    end,
    Create = function(self, isMale, location, material)
      local weed = {
        isMale = isMale,
        location = location,
        growth = 0,
        output = 1,
        material = material,
        planted = os.time(),
        water = 100.0,
      }

      local insertId = MySQL.Sync.insert(
        'INSERT INTO weed (isMale, location, growth, output, material, planted, water) VALUES (@isMale, @location, @growth, @output, @material, @planted, @water)',
        {
          ['@isMale'] = weed.isMale,
          ['@location'] = json.encode(weed.location),
          ['@growth'] = weed.growth,
          ['@output'] = weed.output,
          ['@material'] = weed.material,
          ['@planted'] = weed.planted,
          ['@water'] = weed.water,
        })

      print(insertId)

      if not insertId then
        return nil
      end

      weed._id = insertId
      return weed
    end

  },
}
