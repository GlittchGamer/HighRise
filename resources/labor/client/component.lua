AddEventHandler("Labor:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Logger = exports['core']:FetchComponent("Logger")
  Callbacks = exports['core']:FetchComponent("Callbacks")
  Game = exports['core']:FetchComponent("Game")
  Phone = exports['core']:FetchComponent("Phone")
  PedInteraction = exports['core']:FetchComponent("PedInteraction")
  Interaction = exports['core']:FetchComponent("Interaction")
  Progress = exports['core']:FetchComponent("Progress")
  Minigame = exports['core']:FetchComponent("Minigame")
  Notification = exports['core']:FetchComponent("Notification")
  ListMenu = exports['core']:FetchComponent("ListMenu")
  Blips = exports['core']:FetchComponent("Blips")
  Polyzone = exports['core']:FetchComponent("Polyzone")
  Hud = exports['core']:FetchComponent("Hud")
  Inventory = exports['core']:FetchComponent("Inventory")
  EmergencyAlerts = exports['core']:FetchComponent("EmergencyAlerts")
  Status = exports['core']:FetchComponent("Status")
  Labor = exports['core']:FetchComponent("Labor")
  Sounds = exports['core']:FetchComponent("Sounds")
  Properties = exports['core']:FetchComponent("Properties")
  Action = exports['core']:FetchComponent("Action")
  Sync = exports['core']:FetchComponent("Sync")
  Confirm = exports['core']:FetchComponent("Confirm")
  Utils = exports['core']:FetchComponent("Utils")
  Keybinds = exports['core']:FetchComponent("Keybinds")
  Reputation = exports['core']:FetchComponent("Reputation")
  NetSync = exports['core']:FetchComponent("NetSync")
  Vehicles = exports['core']:FetchComponent("Vehicles")
  NPCDialog = exports['core']:FetchComponent("NPCDialog")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies("Labor", {
    "Logger",
    "Callbacks",
    "Game",
    "Phone",
    "PedInteraction",
    "Interaction",
    "Progress",
    "Minigame",
    "Notification",
    "ListMenu",
    "Blips",
    "Polyzone",
    "Hud",
    "Inventory",
    "EmergencyAlerts",
    "Status",
    "Labor",
    "Sounds",
    "Properties",
    "Action",
    "Sync",
    "Confirm",
    "Utils",
    "Keybinds",
    "Reputation",
    "NetSync",
    "Vehicles",
    "NPCDialog",
  }, function(error)
    if #error > 0 then
      return
    end
    RetrieveComponents()
    TriggerEvent("Labor:Client:Setup")

    RemoveEventHandler(setupEvent)
  end)
end)

function Draw3DText(x, y, z, text)
  local onScreen, _x, _y = World3dToScreen2d(x, y, z)
  local px, py, pz = table.unpack(GetGameplayCamCoords())

  SetTextScale(0.25, 0.25)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 245)
  SetTextOutline(true)
  SetTextEntry("STRING")
  SetTextCentre(1)
  AddTextComponentString(text)
  DrawText(_x, _y)
end

function PedFaceCoord(pPed, pCoords)
  TaskTurnPedToFaceCoord(pPed, pCoords.x, pCoords.y, pCoords.z)

  Citizen.Wait(100)

  while GetScriptTaskStatus(pPed, 0x574bb8f5) == 1 do
    Citizen.Wait(0)
  end
end

AddEventHandler("Proxy:Shared:RegisterReady", function()
  exports['core']:RegisterComponent("Labor", LABOR)
end)

AddEventHandler("Labor:Client:AcceptRequest", function(data)
  exports['core']:CallbacksServer("Labor:AcceptRequest", data)
end)

AddEventHandler("Labor:Client:DeclineRequest", function(data)
  exports['core']:CallbacksServer("Labor:DeclineRequest", data)
end)

LABOR = {
  Get = {
    Jobs = function(self)
      local p = promise.new()
      exports['core']:CallbacksServer("Labor:GetJobs", {}, function(jobs)
        p:resolve(jobs)
      end)
      return Citizen.Await(p)
    end,
    Groups = function(self)
      local p = promise.new()
      exports['core']:CallbacksServer("Labor:GetGroups", {}, function(groups)
        p:resolve(groups)
      end)
      return Citizen.Await(p)
    end,
    Reputations = function(self)
      local p = promise.new()
      exports['core']:CallbacksServer("Labor:GetReputations", {}, function(jobs)
        p:resolve(jobs)
      end)
      return Citizen.Await(p)
    end,
  },
}
