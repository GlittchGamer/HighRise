AddEventHandler("Labor:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Logger = exports["hrrp-base"]:FetchComponent("Logger")
  Callbacks = exports["hrrp-base"]:FetchComponent("Callbacks")
  Game = exports["hrrp-base"]:FetchComponent("Game")
  Phone = exports["hrrp-base"]:FetchComponent("Phone")
  PedInteraction = exports["hrrp-base"]:FetchComponent("PedInteraction")
  Interaction = exports["hrrp-base"]:FetchComponent("Interaction")
  Progress = exports["hrrp-base"]:FetchComponent("Progress")
  Minigame = exports["hrrp-base"]:FetchComponent("Minigame")
  Notification = exports["hrrp-base"]:FetchComponent("Notification")
  ListMenu = exports["hrrp-base"]:FetchComponent("ListMenu")
  Blips = exports["hrrp-base"]:FetchComponent("Blips")
  Polyzone = exports["hrrp-base"]:FetchComponent("Polyzone")
  Hud = exports["hrrp-base"]:FetchComponent("Hud")
  Inventory = exports["hrrp-base"]:FetchComponent("Inventory")
  EmergencyAlerts = exports["hrrp-base"]:FetchComponent("EmergencyAlerts")
  Status = exports["hrrp-base"]:FetchComponent("Status")
  Labor = exports["hrrp-base"]:FetchComponent("Labor")
  Sounds = exports["hrrp-base"]:FetchComponent("Sounds")
  Properties = exports["hrrp-base"]:FetchComponent("Properties")
  Action = exports["hrrp-base"]:FetchComponent("Action")
  Sync = exports["hrrp-base"]:FetchComponent("Sync")
  Confirm = exports["hrrp-base"]:FetchComponent("Confirm")
  Utils = exports["hrrp-base"]:FetchComponent("Utils")
  Keybinds = exports["hrrp-base"]:FetchComponent("Keybinds")
  Reputation = exports["hrrp-base"]:FetchComponent("Reputation")
  NetSync = exports["hrrp-base"]:FetchComponent("NetSync")
  Vehicles = exports["hrrp-base"]:FetchComponent("Vehicles")
  NPCDialog = exports["hrrp-base"]:FetchComponent("NPCDialog")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports["hrrp-base"]:RequestDependencies("Labor", {
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
  exports["hrrp-base"]:RegisterComponent("Labor", LABOR)
end)

AddEventHandler("Labor:Client:AcceptRequest", function(data)
  exports["hrrp-base"]:CallbacksServer("Labor:AcceptRequest", data)
end)

AddEventHandler("Labor:Client:DeclineRequest", function(data)
  exports["hrrp-base"]:CallbacksServer("Labor:DeclineRequest", data)
end)

LABOR = {
  Get = {
    Jobs = function(self)
      local p = promise.new()
      exports["hrrp-base"]:CallbacksServer("Labor:GetJobs", {}, function(jobs)
        p:resolve(jobs)
      end)
      return Citizen.Await(p)
    end,
    Groups = function(self)
      local p = promise.new()
      exports["hrrp-base"]:CallbacksServer("Labor:GetGroups", {}, function(groups)
        p:resolve(groups)
      end)
      return Citizen.Await(p)
    end,
    Reputations = function(self)
      local p = promise.new()
      exports["hrrp-base"]:CallbacksServer("Labor:GetReputations", {}, function(jobs)
        p:resolve(jobs)
      end)
      return Citizen.Await(p)
    end,
  },
}
