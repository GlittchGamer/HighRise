_openCd = false -- Prevents spamm open/close
_settings = {}
_loggedIn = false

local _ignoreEvents = {
  "Health",
  "HP",
  "Armor",
  "Status",
  "Damage",
  "Wardrobe",
  "Animations",
  "Ped",
}

AddEventHandler("Laptop:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Callbacks = exports["hrrp-base"]:FetchComponent("Callbacks")
  Logger = exports["hrrp-base"]:FetchComponent("Logger")
  Notification = exports["hrrp-base"]:FetchComponent("Notification")
  UISounds = exports["hrrp-base"]:FetchComponent("UISounds")
  Sounds = exports["hrrp-base"]:FetchComponent("Sounds")
  Hud = exports["hrrp-base"]:FetchComponent("Hud")
  Keybinds = exports["hrrp-base"]:FetchComponent("Keybinds")
  Interaction = exports["hrrp-base"]:FetchComponent("Interaction")
  Inventory = exports["hrrp-base"]:FetchComponent("Inventory")
  Hud = exports["hrrp-base"]:FetchComponent("Hud")
  ListMenu = exports["hrrp-base"]:FetchComponent("ListMenu")
  Labor = exports["hrrp-base"]:FetchComponent("Labor")
  Jail = exports["hrrp-base"]:FetchComponent("Jail")
  Blips = exports["hrrp-base"]:FetchComponent("Blips")
  Reputation = exports["hrrp-base"]:FetchComponent("Reputation")
  Polyzone = exports["hrrp-base"]:FetchComponent("Polyzone")
  NetSync = exports["hrrp-base"]:FetchComponent("NetSync")
  Vehicles = exports["hrrp-base"]:FetchComponent("Vehicles")
  Progress = exports["hrrp-base"]:FetchComponent("Progress")
  Jobs = exports["hrrp-base"]:FetchComponent("Jobs")
  Utils = exports["hrrp-base"]:FetchComponent("Utils")
  Minigame = exports["hrrp-base"]:FetchComponent("Minigame")
  PedInteraction = exports["hrrp-base"]:FetchComponent("PedInteraction")
  Laptop = exports["hrrp-base"]:FetchComponent("Laptop")
  Properties = exports["hrrp-base"]:FetchComponent("Properties")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports["hrrp-base"]:RequestDependencies("Laptop", {
    "Callbacks",
    "Logger",
    "Notification",
    "UISounds",
    "Sounds",
    "Hud",
    "Keybinds",
    "Interaction",
    "Inventory",
    "Hud",
    "ListMenu",
    "Labor",
    "Jail",
    "Blips",
    "Reputation",
    "Polyzone",
    "NetSync",
    "Vehicles",
    "Progress",
    "Jobs",
    "Utils",
    "Minigame",
    "PedInteraction",
    "Properties",
    "Laptop",
  }, function(error)
    if #error > 0 then
      return
    end -- Do something to handle if not all dependencies loaded
    RetrieveComponents()

    exports['hrrp-keybinds']:Add("laptop_open", "", "keyboard", "Laptop - Open", function()
      OpenLaptop()
    end)

    RegisterBoostingCallbacks()

    RemoveEventHandler(setupEvent)
  end)
end)

function OpenLaptop()
  print(_loggedIn, exports['hrrp-hud']:IsDisabled(), Jail:IsJailed(), hasValue(LocalPlayer.state.Character:GetData("States"), "LAPTOP"),
    not LocalPlayer.state.laptopOpen)
  _loggedIn = true --TODO: Temporary fix for laptop not opening
  if
      _loggedIn
      and not exports['hrrp-hud']:IsDisabled()
      and not Jail:IsJailed()
      and hasValue(LocalPlayer.state.Character:GetData("States"), "LAPTOP")
      and not LocalPlayer.state.laptopOpen
  then
    Laptop:Open()
  end
end

RegisterNetEvent("Laptop:Client:Open", OpenLaptop)

AddEventHandler("Inventory:Client:ItemsLoaded", function()
  while Laptop == nil do
    Citizen.Wait(10)
  end
  Laptop.Data:Set("items", Inventory.Items:GetData())
end)

AddEventHandler("Characters:Client:Updated", function(key)
  if hasValue(_ignoreEvents, key) then
    return
  end
  _settings = LocalPlayer.state.Character:GetData("LaptopSettings")
  Laptop.Data:Set("player", LocalPlayer.state.Character:GetData())

  if
      key == "States"
      and LocalPlayer.state.laptopOpen
      and (not hasValue(LocalPlayer.state.Character:GetData("States"), "LAPTOP"))
  then
    Laptop:Close(true)
  end
end)

AddEventHandler("Ped:Client:Died", function()
  Laptop:Close(true)
end)

RegisterNetEvent("Job:Client:DutyChanged", function(state)
  Laptop.Data:Set("onDuty", state)
end)

RegisterNetEvent("UI:Client:Reset", function(manual)
  SetNuiFocus(false, false)
  SendNUIMessage({
    type = "UI_RESET",
    data = {},
  })

  if manual then
    TriggerServerEvent("Laptop:Server:UIReset")
    if LocalPlayer.state.tabletOpen then
      Laptop:Close()
    end
  end
end)

AddEventHandler("UI:Client:Close", function(context)
  if context ~= "laptop" then
    Laptop:Close()
  end
end)

AddEventHandler("Ped:Client:Died", function()
  if LocalPlayer.state.laptopOpen then
    Laptop:Close()
  end
end)

RegisterNetEvent("Laptop:Client:SetApps", function(apps)
  LAPTOP_APPS = apps
  SendNUIMessage({
    type = "SET_APPS",
    data = apps,
  })
end)

AddEventHandler("Characters:Client:Spawn", function()
  _loggedIn = true

  Citizen.CreateThread(function()
    while _loggedIn do
      SendNUIMessage({
        type = "SET_TIME",
        data = GlobalState["Sync:Time"],
      })
      Citizen.Wait(15000)
    end
  end)
end)

RegisterNetEvent("Characters:Client:Logout", function()
  _loggedIn = false
end)

function hasValue(tbl, value)
  for k, v in ipairs(tbl or {}) do
    if v == value or (type(v) == "table" and hasValue(v, value)) then
      return true
    end
  end
  return false
end

RegisterNUICallback("AcceptPopup", function(data, cb)
  cb("OK")
  if data.data ~= nil and data.data.server then
    TriggerServerEvent(data.event, data.data)
  else
    TriggerEvent(data.event, data.data)
  end
end)

RegisterNUICallback("CancelPopup", function(data, cb)
  cb("OK")
  if data.data ~= nil and data.data.server then
    TriggerServerEvent(data.event, data.data)
  else
    TriggerEvent(data.event, data.data)
  end
end)

RegisterNUICallback("CDExpired", function(data, cb)
  cb("OK")
  _openCd = false
end)