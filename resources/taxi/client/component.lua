_state = false
_rate = GetResourceKvpInt("TAXI_RATE") or 10

AddEventHandler("Taxi:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Logger = exports['core']:FetchComponent("Logger")
  Blips = exports['core']:FetchComponent("Blips")
  Keybinds = exports['core']:FetchComponent("Keybinds")
  Notification = exports['core']:FetchComponent("Notification")
  PedInteraction = exports['core']:FetchComponent("PedInteraction")
  Taxi = exports['core']:FetchComponent("Taxi")
  Input = exports['core']:FetchComponent("Input")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies("Jail", {
    "Logger",
    "Blips",
    "Keybinds",
    "Notification",
    "PedInteraction",
    "Taxi",
  }, function(error)
    if #error > 0 then
      return
    end
    RetrieveComponents()

    exports['keybinds']:Add("taxi_increase_rate", "", "keyboard", "Taxi - Set Rate", function()
      Taxi.Rate:Set()
    end)

    exports['keybinds']:Add("taxi_reset_trip", "", "keyboard", "Taxi - Reset Trip", function()
      Taxi.Trip:Reset()
    end)

    exports['keybinds']:Add("taxi_toggle_hud", "", "keyboard", "Taxi - Toggle HUD", function()
      Taxi.Hud:Toggle()
    end)

    RemoveEventHandler(setupEvent)
  end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
  exports['core']:RegisterComponent("Taxi", _TAXI)
end)

local _threading = false
function DoTaxiThread(veh)
  if _threading then
    return
  end
  _threading = true

  local prevLocation = GetEntityCoords(veh)
  CreateThread(function()
    while LocalPlayer.state.loggedIn and _inVeh == veh and _state do
      local currLocation = GetEntityCoords(veh)
      local dist = #(currLocation - prevLocation)
      SendNUIMessage({
        type = "UPDATE_TRIP",
        data = {
          trip = dist,
        },
      })
      prevLocation = currLocation
      Citizen.Wait(1000)
    end
    _threading = false
  end)
end

_TAXI = {
  Hud = {
    Show = function(self)
      local veh = GetVehiclePedIsIn(LocalPlayer.state.ped)
      if _models[GetEntityModel(veh)] and GetPedInVehicleSeat(veh, -1) == LocalPlayer.state.ped then
        _inVeh = veh

        _state = true
        DoTaxiThread(veh)
        SendNUIMessage({
          type = "APP_SHOW",
          data = {
            rate = _rate,
          },
        })
      end
    end,
    Hide = function(self)
      _state = false
      SendNUIMessage({
        type = "APP_HIDE",
      })
    end,
    Reset = function(self)
      _state = false
      SendNUIMessage({
        type = "APP_RESET",
      })
    end,
    Toggle = function(self)
      if _state then
        Taxi.Hud:Hide()
      else
        Taxi.Hud:Show()
      end
    end,
  },
  Rate = {
    Set = function(self)
      local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
      if DoesEntityExist(vehicle) and IsVehicleModel(vehicle, GetHashKey("taxi")) then
        exports['hud']:InputShow("Taxi", "Set Rate", {
          {
            id = "rate",
            type = "number",
            options = {},
          },
        }, "Taxi:SetRate", {})
      end
    end,
  },
  Trip = {
    Reset = function(self)
      SendNUIMessage({
        type = "RESET_TRIP",
      })
    end,
  },
}

AddEventHandler('Taxi:SetRate', function(values, data)
  if tonumber(values.rate) < 1000 then
    SetResourceKvpInt("TAXI_RATE", tonumber(values.rate))
    SendNUIMessage({
      type = "SET_RATE",
      data = {
        rate = tonumber(values.rate),
      },
    })
  else
    exports['hud']:NotificationError("Rate cannot be higher than 1000 or higher")
  end
end)
