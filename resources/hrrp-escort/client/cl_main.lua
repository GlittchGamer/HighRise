AddEventHandler("Escort:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Callbacks = exports["hrrp-base"]:FetchComponent("Callbacks")
  Utils = exports["hrrp-base"]:FetchComponent("Utils")
  Logger = exports["hrrp-base"]:FetchComponent("Logger")
  Game = exports["hrrp-base"]:FetchComponent("Game")
  Stream = exports["hrrp-base"]:FetchComponent("Stream")
  Keybinds = exports["hrrp-base"]:FetchComponent("Keybinds")
  Notification = exports["hrrp-base"]:FetchComponent("Notification")
  Progress = exports["hrrp-base"]:FetchComponent("Progress")
  Hud = exports["hrrp-base"]:FetchComponent("Hud")
  Escort = exports["hrrp-base"]:FetchComponent("Escort")
  Vehicles = exports["hrrp-base"]:FetchComponent("Vehicles")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports["hrrp-base"]:RequestDependencies("Escort", {
    "Callbacks",
    "Utils",
    "Logger",
    "Game",
    "Stream",
    "Keybinds",
    "Notification",
    "Progress",
    "Hud",
    "Escort",
    "Vehicles",
  }, function(error)
    if #error > 0 then
      return
    end
    RetrieveComponents()

    exports['hrrp-keybinds']:Add("escort", "k", "keyboard", "Escort", function()
      DoEscort()
    end)

    exports["hrrp-base"]:CallbacksRegisterClient("Escort:StopEscort", function(data, cb)
      DetachEntity(LocalPlayer.state.ped, true, true)
      cb(true)
    end)

    RemoveEventHandler(setupEvent)
  end)
end)

ESCORT = {
  DoEscort = function(self, target, tPlayer)
    if target ~= nil then
      exports["hrrp-base"]:CallbacksServer("Escort:DoEscort", {
        target = target,
        inVeh = IsPedInAnyVehicle(GetPlayerPed(tPlayer))
      }, function(state)
        if state then
          StartEscortThread(tPlayer)
        end
      end)
    end
  end,
  StopEscort = function(self)
    exports["hrrp-base"]:CallbacksServer("Escort:StopEscort", function()

    end)
  end,
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
  exports["hrrp-base"]:RegisterComponent("Escort", ESCORT)
end)

AddEventHandler('Interiors:Exit', function()
  if LocalPlayer.state.isEscorting ~= nil then
    Escort:StopEscort()
  end
end)

--[[ TODO
Add Dragging When Dead
Place In vehicle while Dead Slump Animation
Police Drag Maybe Cuff Also
Get In Trunk or Place in trunk???
]]
