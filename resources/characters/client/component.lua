Characters = nil

AddEventHandler("Characters:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Callbacks = exports['core']:FetchComponent("Callbacks")
  Characters = exports['core']:FetchComponent("Characters")
  Action = exports['core']:FetchComponent("Action")
  Ped = exports['core']:FetchComponent("Ped")
  Utils = exports['core']:FetchComponent('Utils')
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies("Characters", {
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
    LocalPlayer.state.Character = exports['core']:DataStoreCreate(1, 'Character', data)
  end

  exports['core']:FetchComponent("Player").LocalPlayer:SetData("Character", LocalPlayer.state.Character)
  TriggerEvent("Characters:Client:Updated", key)

  if cb then
    cb()
  end
end)

CHARACTERS = {
  Updating = true,
  Logout = function(self)
    exports['core']:CallbacksServer("Characters:Logout", {}, function()
      LocalPlayer.state.Char = nil
      LocalPlayer.state.Character = nil
      LocalPlayer.state.loggedIn = false
      exports['hud']:ActionHide()
      exports['core']:FetchComponent("Spawn"):InitCamera()
      SendNUIMessage({
        type = "APP_RESET",
      })
      Citizen.Wait(500)
      exports['core']:FetchComponent("Spawn"):Init()
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
  exports['core']:RegisterComponent("Characters", CHARACTERS)
end)
