_placing = false
_placeData = nil
placementCoords = nil
isValid = false

AddEventHandler("exports['hrrp-objects']:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Notification = exports["hrrp-base"]:FetchComponent("Notification")
  ObjectPlacer = exports["hrrp-base"]:FetchComponent("ObjectPlacer")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports["hrrp-base"]:RequestDependencies("ObjectPlacer", {
    "Notification",
    "ObjectPlacer",
  }, function(error)
    if #error > 0 then
      exports["hrrp-base"]:FetchComponent("Logger"):Critical("ObjectPlacer", "Failed To Load All Dependencies")
      return
    end
    RetrieveComponents()

    RemoveEventHandler(setupEvent)
  end)
end)

RegisterNetEvent("Characters:Client:Logout", function()
  _placeData = nil
end)

_PLACER = {
  Start = function(self, model, finishEvent, data, allowedInterior, cancelEvent, isFurniture, stupidFlag)
    if _placing or IsPedInAnyVehicle(PlayerPedId()) then
      return
    end

    _placing = true
    _placeData = {
      finishEvent = finishEvent,
      cancelEvent = cancelEvent,
      data = data,
    }

    placementCoords = nil
    isValid = false

    RunPlacementThread(model, allowedInterior, isFurniture, stupidFlag)
  end,
  End = function(self)
    _placing = false
    if isValid then
      TriggerEvent(_placeData.finishEvent, _placeData.data, placementCoords)
    else
      if _placeData?.cancelEvent then
        TriggerEvent(_placeData.cancelEvent, _placeData.data, true)
      end
      exports['hrrp-hud']:NotificationError("Invalid Object Placement")
    end

    placementCoords = nil
    isValid = false
    _placeData = nil
  end,
  Cancel = function(self, skipNotification, skipEvent)
    _placing = false
    if not skipEvent and _placeData?.cancelEvent then
      TriggerEvent(_placeData.cancelEvent, _placeData.data)
    end

    if not skipNotification then
      exports['hrrp-hud']:NotificationError("Object Placement Cancelled")
    end

    placementCoords = nil
    isValid = false
    _placeData = nil
  end
}

AddEventHandler("Keybinds:Client:KeyDown:primary_action", function()
  if _placeData ~= nil then
    exports['hrrp-objects']:End()
  end
end)

AddEventHandler("Keybinds:Client:KeyDown:cancel_action", function()
  if _placeData ~= nil then
    exports['hrrp-objects']:Cancel()
  end
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
  exports["hrrp-base"]:RegisterComponent("ObjectPlacer", _PLACER)
end)

--* Export Handler
local function exportHandler(exportName, func)
  AddEventHandler(('__cfx_export_%s_%s'):format(GetCurrentResourceName(), exportName), function(setCB)
    setCB(function(...)
      return func(_PLACER, ...)
    end)
  end)
end

for k, v in pairs(_PLACER) do
  if type(v) == "function" then
    exportHandler(k, v)
  end
end
