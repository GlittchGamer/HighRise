AddEventHandler("Vehicles:Client:EnterVehicle", function(currentVehicle, currentSeat)
  GLOBAL_VEH = currentVehicle
  HUD.Vehicle:Show()
  --Hud.Minimap:Set()
end)

AddEventHandler("Vehicles:Client:ExitVehicle", function(currentVehicle, currentSeat)
  HUD.Vehicle:Hide()
  GLOBAL_VEH = nil
end)

AddEventHandler("Characters:Client:Spawn", function()
  HUD:Show()
  DisplayRadar(false)
end)

RegisterNetEvent("UI:Client:Reset", function(manual)
  SendNUIMessage({
    action = "UI_RESET",
    data = {},
  })
  HUD:Hide()
  exports['hud']:ActionHide()
  ListMenu:Close()
  Interaction:Hide()
  Notification:Clear()
  Confirm:Close()
  Input:Close()
  InfoOverlay:Close()
  Hud.Meth:Close()

  if manual then
    Citizen.Wait(2500)
    HUD:Show()
  end
end)

RegisterNetEvent("Characters:Client:Logout", function()
  TriggerEvent("UI:Client:Reset")
end)

AddEventHandler("Vehicles:Client:Seatbelt", function(state)
  SendNUIMessage({
    action = "UPDATE_SEATBELT",
    data = { seatbelt = state },
  })
end)

AddEventHandler("Vehicles:Client:Cruise", function(state)
  SendNUIMessage({
    action = "UPDATE_CRUISE",
    data = { cruise = state },
  })
end)

AddEventHandler("Vehicles:Client:Ignition", function(state)
  SendNUIMessage({
    action = "UPDATE_IGNITION",
    data = { ignition = state },
  })
end)

AddEventHandler("Vehicles:Client:Fuel", function(data, show)
  SendNUIMessage({
    action = "UPDATE_FUEL",
    data = {
      fuelData = data,
      fuelHide = show,
    },
  })
end)

RegisterNetEvent("Status:Client:Update", function(status, value)
  SendNUIMessage({
    action = "UPDATE_STATUS_VALUE",
    data = { name = status, value = value },
  })
end)

RegisterNetEvent("Progress:Client:Progress", function(action, cb)
  Progress:Progress(action, cb)
end)

RegisterNetEvent("Progress:Client:ProgressWithStartEvent", function(action, start, finish)
  Progress:ProgressWithStartEvent(action, start, finish)
end)

RegisterNetEvent("Progress:Client:ProgressWithTickEvent", function(action, tick, finish)
  Progress:ProgressWithTickEvent(action, tick, finish)
end)

RegisterNetEvent("Progress:Client:ProgressWithStartAndTick", function(action, start, tick, finish)
  Progress:ProgressWithStartAndTick(action, start, tick, finish)
end)

RegisterNetEvent("Progress:Client:Cancel", function()
  Progress:Cancel()
end)

RegisterNetEvent("Progress:Client:Fail", function()
  Progress:Fail()
end)

RegisterNUICallback("Progress:Finish", function(data, cb)
  Progress:Finish()
  cb("ok")
end)

AddEventHandler("Targeting:Client:UpdateState", function(isTargeting, hasTarget)
  SendNUIMessage({
    type = (isTargeting and "SHOW_EYE" or "HIDE_EYE"),
    data = {
      icon = (type(hasTarget) == "string" and hasTarget or false),
    },
  })
end)

AddEventHandler("Targeting:Client:OpenMenu", function(menuData)
  SetNuiFocus(true, true)
  SetCursorLocation(0.5, 0.5)
  SendNUIMessage({
    action = "OPEN_MENU",
    data = {
      menu = menuData,
    },
  })
end)

AddEventHandler("Targeting:Client:CloseMenu", function()
  SetNuiFocus(false, false)
  SendNUIMessage({
    action = "CLOSE_MENU",
    data = {},
  })
end)

RegisterNUICallback("targetingAction", function(data, cb)
  SetNuiFocus(false, false)
  SendNUIMessage({
    action = "CLOSE_MENU",
    data = {},
  })
  TriggerEvent("Targeting:Client:MenuSelect", data and data.event, data and data.data or {})
  cb("ok")
end)
