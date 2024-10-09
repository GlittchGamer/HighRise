AddEventHandler("Robbery:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Logger = exports["hrrp-base"]:FetchComponent("Logger")
  Callbacks = exports["hrrp-base"]:FetchComponent("Callbacks")
  PedInteraction = exports["hrrp-base"]:FetchComponent("PedInteraction")
  Progress = exports["hrrp-base"]:FetchComponent("Progress")
  Phone = exports["hrrp-base"]:FetchComponent("Phone")
  Notification = exports["hrrp-base"]:FetchComponent("Notification")
  Polyzone = exports["hrrp-base"]:FetchComponent("Polyzone")
  Progress = exports["hrrp-base"]:FetchComponent("Progress")
  Minigame = exports["hrrp-base"]:FetchComponent("Minigame")
  Keybinds = exports["hrrp-base"]:FetchComponent("Keybinds")
  Properties = exports["hrrp-base"]:FetchComponent("Properties")
  Sounds = exports["hrrp-base"]:FetchComponent("Sounds")
  Interaction = exports["hrrp-base"]:FetchComponent("Interaction")
  Inventory = exports["hrrp-base"]:FetchComponent("Inventory")
  Action = exports["hrrp-base"]:FetchComponent("Action")
  Blips = exports["hrrp-base"]:FetchComponent("Blips")
  EmergencyAlerts = exports["hrrp-base"]:FetchComponent("EmergencyAlerts")
  Doors = exports["hrrp-base"]:FetchComponent("Doors")
  ListMenu = exports["hrrp-base"]:FetchComponent("ListMenu")
  Input = exports["hrrp-base"]:FetchComponent("Input")
  Game = exports["hrrp-base"]:FetchComponent("Game")
  NetSync = exports["hrrp-base"]:FetchComponent("NetSync")
  Damage = exports["hrrp-base"]:FetchComponent("Damage")
  Lasers = exports["hrrp-base"]:FetchComponent("Lasers")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports["hrrp-base"]:RequestDependencies("Robbery", {
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

    exports['hrrp-pedinteraction']:Add(
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
  exports["hrrp-base"]:CallbacksServer("Robbery:Pickup", {})
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
  exports["hrrp-base"]:RegisterComponent("Robbery", _ROBBERY)
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
      exports["hrrp-base"]:CallbacksServer("Robbery:Holdup:Do", entity.serverId, function(s)
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
