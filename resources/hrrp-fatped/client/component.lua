_FatPed = {
  FatUsers = { 3 }, -- Add your user ids here
  isFat = function(self, UserID)
    if self.Fat then return self.Fat end
    for k, v in ipairs(self.FatUsers) do
      if UserID == v then
        self.Fat = true
        return self.Fat
      end
    end
    return false
  end,
}

AddEventHandler("FatPed:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Logger = exports["hrrp-base"]:FetchComponent("Logger")
  Keybinds = exports["hrrp-base"]:FetchComponent("Keybinds")
  Notification = exports["hrrp-base"]:FetchComponent("Notification")
  PedInteraction = exports["hrrp-base"]:FetchComponent("PedInteraction")
  FatPed = exports["hrrp-base"]:FetchComponent("FatPed")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports["hrrp-base"]:RequestDependencies("FatPed", {
    "Logger",
    "Keybinds",
    "Notification",
    "PedInteraction",
    "FatPed",
  }, function(error)
    if #error > 0 then
      print("Something went wrong loading an dependency")
      print(json.encode(error))
      return
    end
    RetrieveComponents()

    RemoveEventHandler(setupEvent)
  end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
  exports["hrrp-base"]:RegisterComponent("FatPed", _FatPed)
end)

AddEventHandler('Vehicles:Client:EnterVehicle', function(veh)
  if not FatPed:isFat(LocalPlayer.state.Character:GetData("SID")) then return end
  local getVehType = GetVehicleClass(veh)

  if getVehType == 8 then
    local vehNumWheels = GetVehicleNumberOfWheels(veh)
    for i = -1, vehNumWheels do
      local tireHealth = GetVehicleWheelHealth(veh, i)
      if math.random(1, 100) >= 50 and tireHealth >= 200.0 then
        SetVehicleTyreBurst(veh, i, true, 1000)
        exports['hrrp-hud']:NotificationError("Fatty bust a tire!", 2500)
      end
    end
  end
end)


CreateThread(function()
  Wait(500)
  -- exports["hrrp-animations"]:EmotesForceCancel()
end)
