Callbacks = nil
Game = nil

AddEventHandler("Commands:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Callbacks = exports['core']:FetchComponent("Callbacks")
  Game = exports['core']:FetchComponent("Game")
  Notification = exports['core']:FetchComponent("Notification")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies("Commands", {
    "Callbacks",
    "Game",
    "Notification",
  }, function(error)
    if #error > 0 then
      return
    end
    RetrieveComponents()

    Callbacks:RegisterClientCallback("Commands:SS", function(d, cb)
      exports["screenshot-basic"]:requestScreenshotUpload(string.format("https://discord.com/api/webhooks/%s", d), "files[]", function(data)
        local image = json.decode(data)
        cb(json.encode({ url = image.attachments[1].proxy_url }))
      end)
    end)

    RemoveEventHandler(setupEvent)
  end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
  exports['core']:RegisterComponent("Commands", CMDS)
end)

CMDS = {}

RegisterNetEvent("Commands:Client:TeleportToMarker", function()
  local WaypointHandle = GetFirstBlipInfoId(8)
  if DoesBlipExist(WaypointHandle) then
    local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)
    for height = 1, 1000 do
      SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

      local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

      if foundGround then
        SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
        break
      end

      Citizen.Wait(5)
    end
    exports['hud']:NotificationSuccess("Teleported")
  else
    exports['hud']:NotificationError("Please place your waypoint.")
  end
end)