Characters = nil

AddEventHandler("Characters:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Callbacks = exports["hrrp-base"]:FetchComponent("Callbacks")
  Characters = exports["hrrp-base"]:FetchComponent("Characters")
  Action = exports["hrrp-base"]:FetchComponent("Action")
  Ped = exports["hrrp-base"]:FetchComponent("Ped")
  Utils = exports['hrrp-base']:FetchComponent('Utils')
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports["hrrp-base"]:RequestDependencies("Characters", {
    "Callbacks",
    "Characters",
    "Action",
    "Ped",
  }, function(error)
    if #error > 0 then
      return
    end
    RetrieveComponents()

    RemoveEventHandler(setupEvent)
  end)
end)

AddEventHandler("Characters:Client:Spawn", function()
  Characters:Update()
end)

RegisterNetEvent("Characters:Client:SetData", function(key, data, cb)
  if key ~= -1 then
    LocalPlayer.state.Character:SetData(key, data)
  else
    LocalPlayer.state.Character = exports['hrrp-base']:DataStoreCreate(1, 'Character', data)
  end

  exports["hrrp-base"]:FetchComponent("Player").LocalPlayer:SetData("Character", LocalPlayer.state.Character)
  TriggerEvent("Characters:Client:Updated", key)

  if cb then
    cb()
  end
end)

CHARACTERS = {
  Updating = true,
  Logout = function(self)
    exports["hrrp-base"]:CallbacksServer("Characters:Logout", {}, function()
      LocalPlayer.state.Char = nil
      LocalPlayer.state.Character = nil
      LocalPlayer.state.loggedIn = false
      exports['hrrp-hud']:ActionHide()
      exports["hrrp-base"]:FetchComponent("Spawn"):InitCamera()
      SendNUIMessage({
        type = "APP_RESET",
      })
      Citizen.Wait(500)
      exports["hrrp-base"]:FetchComponent("Spawn"):Init()
    end)
  end,
  Update = function(self)
    Citizen.CreateThread(function()
      while self.Updating do
        TriggerServerEvent("Characters:Server:StoreUpdate")
        Citizen.Wait(180000)
      end
    end)
  end,
}

RegisterNetEvent('Characters:Client:LogoutComponent', function()
  CHARACTERS:Logout()
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
  exports["hrrp-base"]:RegisterComponent("Characters", CHARACTERS)
end)
