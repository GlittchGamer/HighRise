AddEventHandler("Robbery:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Logger = exports['core']:FetchComponent("Logger")
  Callbacks = exports['core']:FetchComponent("Callbacks")
  PedInteraction = exports['core']:FetchComponent("PedInteraction")
  Progress = exports['core']:FetchComponent("Progress")
  Phone = exports['core']:FetchComponent("Phone")
  Notification = exports['core']:FetchComponent("Notification")
  Polyzone = exports['core']:FetchComponent("Polyzone")
  Progress = exports['core']:FetchComponent("Progress")
  Minigame = exports['core']:FetchComponent("Minigame")
  Keybinds = exports['core']:FetchComponent("Keybinds")
  Properties = exports['core']:FetchComponent("Properties")
  Sounds = exports['core']:FetchComponent("Sounds")
  Interaction = exports['core']:FetchComponent("Interaction")
  Inventory = exports['core']:FetchComponent("Inventory")
  Action = exports['core']:FetchComponent("Action")
  Blips = exports['core']:FetchComponent("Blips")
  EmergencyAlerts = exports['core']:FetchComponent("EmergencyAlerts")
  Doors = exports['core']:FetchComponent("Doors")
  ListMenu = exports['core']:FetchComponent("ListMenu")
  Input = exports['core']:FetchComponent("Input")
  Game = exports['core']:FetchComponent("Game")
  NetSync = exports['core']:FetchComponent("NetSync")
  Damage = exports['core']:FetchComponent("Damage")
  Lasers = exports['core']:FetchComponent("Lasers")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies("Robbery", {
    "Logger",
    "Callbacks",
    "PedInteraction",
    "Progress",
    "Phone",
    "Notification",
    "Polyzone",
    "Progress",
    "Minigame",
    "Keybinds",
    "Properties",
    "Sounds",
    "Interaction",
    "Inventory",
    "Action",
    "Blips",
    "EmergencyAlerts",
    "Doors",
    "ListMenu",
    "Input",
    "Game",
    "NetSync",
    "Damage",
    "Lasers",
  }, function(error)
    if #error > 0 then
      return
    end
    RetrieveComponents()
    RegisterGamesCallbacks()
    TriggerEvent("Robbery:Client:Setup")

    exports['pedinteraction']:Add(
      "RobToolsPickup",
      GetHashKey("csb_anton"),
      vector3(393.724, -831.028, 28.292),
      228.358,
      25.0,
      {
        {
          icon = "hand",
          text = "Pickup Items",
          event = "Robbery:Client:PickupItems",
        },
      },
      "box-dollar"
    )

    RemoveEventHandler(setupEvent)
  end)
end)

AddEventHandler("Robbery:Client:PickupItems", function()
  exports['core']:CallbacksServer("Robbery:Pickup", {})
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
  exports['core']:RegisterComponent("Robbery", _ROBBERY)
end)

RegisterNetEvent("Robbery:Client:State:Init", function(states)
  _bankStates = states

  for k, v in pairs(states) do
    TriggerEvent(string.format("Robbery:Client:Update:%s", k))
  end
end)

RegisterNetEvent("Robbery:Client:State:Set", function(bank, state)
  _bankStates[bank] = state
  TriggerEvent(string.format("Robbery:Client:Update:%s", bank))
end)

RegisterNetEvent("Robbery:Client:State:Update", function(bank, key, value, tableId)
  if tableId then
    _bankStates[bank][tableId] = _bankStates[bank][tableId] or {}
    _bankStates[bank][tableId][key] = value
  else
    _bankStates[bank][key] = value
  end
  TriggerEvent(string.format("Robbery:Client:Update:%s", bank))
end)

AddEventHandler("Robbery:Client:Holdup:Do", function(entity, data)
  Progress:ProgressWithTickEvent({
    name = "holdup",
    duration = 5000,
    label = "Robbing",
    useWhileDead = false,
    canCancel = true,
    ignoreModifier = true,
    controlDisables = {
      disableMovement = true,
      disableCarMovement = true,
      disableMouse = false,
      disableCombat = true,
    },
    animation = {
      animDict = "random@shop_robbery",
      anim = "robbery_action_b",
      flags = 49,
    },
  }, function()
    if
        #(
          GetEntityCoords(LocalPlayer.state.ped)
          - GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(entity.serverId)))
        ) <= 3.0
    then
      return
    end
    Progress:Cancel()
  end, function(cancelled)
    if not cancelled then
      exports['core']:CallbacksServer("Robbery:Holdup:Do", entity.serverId, function(s)
        Inventory.Dumbfuck:Open(s)

        while not LocalPlayer.state.inventoryOpen do
          Citizen.Wait(1)
        end

        Citizen.CreateThread(function()
          while LocalPlayer.state.inventoryOpen do
            if
                #(
                  GetEntityCoords(LocalPlayer.state.ped)
                  - GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(entity.serverId)))
                ) > 3.0
            then
              Inventory.Close:All()
            end
            Citizen.Wait(2)
          end
        end)
      end)
    end
  end)
end)

_ROBBERY = {}
