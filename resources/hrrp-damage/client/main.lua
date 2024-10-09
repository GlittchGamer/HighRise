AddEventHandler("Damage:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Callbacks = exports["hrrp-base"]:FetchComponent("Callbacks")
  Damage = exports["hrrp-base"]:FetchComponent("Damage")
  Logger = exports["hrrp-base"]:FetchComponent("Logger")
  Notification = exports["hrrp-base"]:FetchComponent("Notification")
  Hud = exports["hrrp-base"]:FetchComponent("Hud")
  Status = exports["hrrp-base"]:FetchComponent("Status")
  --Hospital = exports["hrrp-base"]:FetchComponent("Hospital")
  Progress = exports["hrrp-base"]:FetchComponent("Progress")
  EmergencyAlerts = exports["hrrp-base"]:FetchComponent("EmergencyAlerts")
  PedInteraction = exports["hrrp-base"]:FetchComponent("PedInteraction")
  Keybinds = exports["hrrp-base"]:FetchComponent("Keybinds")
  Jail = exports["hrrp-base"]:FetchComponent("Jail")
  Sounds = exports["hrrp-base"]:FetchComponent("Sounds")
  Weapons = exports["hrrp-base"]:FetchComponent("Weapons")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports["hrrp-base"]:RequestDependencies("Damage", {
    "Callbacks",
    "Damage",
    "Logger",
    "Notification",
    "Hud",
    "Status",
    --"Hospital",
    "Progress",
    "EmergencyAlerts",
    "PedInteraction",
    "Keybinds",
    "Jail",
    "Sounds",
    "Weapons",
  }, function(error)
    if #error > 0 then
      return
    end
    RetrieveComponents()

    exports["hrrp-base"]:CallbacksRegisterClient("Damage:Heal", function(s)
      if s then
        LocalPlayer.state.deadData = {}
      end
      Damage:Revive()
    end)

    exports["hrrp-base"]:CallbacksRegisterClient("Damage:FieldStabalize", function(s)
      Damage:Revive(true)
    end)

    exports["hrrp-base"]:CallbacksRegisterClient("Damage:Kill", function()
      ApplyDamageToPed(LocalPlayer.state.ped, 10000)
    end)

    exports["hrrp-base"]:CallbacksRegisterClient("Damage:Admin:Godmode", function(s)
      TriggerEvent("Status:Client:Update", "godmode", s and 100 or 0)
    end)

    RemoveEventHandler(setupEvent)
  end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
  exports["hrrp-base"]:RegisterComponent("Damage", DAMAGE)
end)

RegisterNetEvent("Characters:Client:Spawned", function()
  StartThreads()
  exports['hrrp-hud']:RegisterStatus("godmode", 0, 100, "shield-quartered", "#FFBB04", false, false, {
    hideZero = true,
  })
end)

RegisterNetEvent("Characters:Client:Logout", function()
  Damage:Revive()
end)

RegisterNetEvent("Damage:Client:Heal", function()
  Damage:Revive()
end)

RegisterNetEvent('UI:Client:Reset', function(apps)
  if not LocalPlayer.state.isDead and not LocalPlayer.state.isHospitalized then
    exports['hrrp-hud']:DeathTextsHide()
    exports['hrrp-hud']:Dead(false)
  end
end)

DAMAGE = {
  Revive = function(self, fieldTreat)
    local player = PlayerPedId()

    if LocalPlayer.state.isDead then
      DoScreenFadeOut(1000)
      while not IsScreenFadedOut() do
        Citizen.Wait(10)
      end
    end

    local wasDead = LocalPlayer.state.isDead
    local wasMinor = LocalPlayer.state.deadData?.isMinor

    LocalPlayer.state:set("isDead", false, true)
    LocalPlayer.state:set("deadData", false, true)
    LocalPlayer.state:set("isDeadTime", false, true)
    LocalPlayer.state:set("releaseTime", false, true)

    if IsPedDeadOrDying(player) then
      local playerPos = GetEntityCoords(player, true)
      NetworkResurrectLocalPlayer(playerPos, true, true, false)
    end

    TriggerServerEvent("Damage:Server:Revived", wasMinor, fieldTreat)
    exports['hrrp-hud']:Dead(false)

    if not LocalPlayer.state.isHospitalized and wasDead then
      exports['hrrp-hud']:DeathTextsHide()
      ClearPedTasksImmediately(player)
      SetEntityInvincible(player, LocalPlayer.state.isAdmin and LocalPlayer.state.isGodmode or false)
    end

    if wasMinor or fieldTreat then
      SetEntityHealth(player, 125)
    else
      SetEntityHealth(player, GetEntityMaxHealth(player))
    end
    SetPlayerSprint(PlayerId(), true)
    ClearPedBloodDamage(player)
    Status:Reset()

    DoScreenFadeIn(1000)

    if not LocalPlayer.state.isHospitalized and wasDead then
      exports["hrrp-animations"]:EmotesPlay("reviveshit", false, 1750, true)
    end
  end,
  Died = function(self)

  end,
  Apply = {
    StandardDamage = function(self, value, armorFirst, forceKill)
      if forceKill and not _hasKO then
        _hasKO = true
      end

      ApplyDamageToPed(LocalPlayer.state.ped, value, armorFirst)
    end,
  }
}
