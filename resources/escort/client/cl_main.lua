AddEventHandler("Escort:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Callbacks = exports['core']:FetchComponent("Callbacks")
  Utils = exports['core']:FetchComponent("Utils")
  Logger = exports['core']:FetchComponent("Logger")
  Game = exports['core']:FetchComponent("Game")
  Stream = exports['core']:FetchComponent("Stream")
  Keybinds = exports['core']:FetchComponent("Keybinds")
  Notification = exports['core']:FetchComponent("Notification")
  Progress = exports['core']:FetchComponent("Progress")
  Hud = exports['core']:FetchComponent("Hud")
  Escort = exports['core']:FetchComponent("Escort")
  Vehicles = exports['core']:FetchComponent("Vehicles")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies("Escort", {
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

    exports['keybinds']:Add("escort", "k", "keyboard", "Escort", function()
      DoEscort()
    end)

    exports['core']:CallbacksRegisterClient("Escort:StopEscort", function(data, cb)
      DetachEntity(LocalPlayer.state.ped, true, true)
      cb(true)
    end)

    RemoveEventHandler(setupEvent)
  end)
end)

ESCORT = {
  DoEscort = function(self, target, tPlayer)
    if target ~= nil then
      exports['core']:CallbacksServer("Escort:DoEscort", {
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
    exports['core']:CallbacksServer("Escort:StopEscort", function()

    end)
  end,
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
  exports['core']:RegisterComponent("Escort", ESCORT)
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
