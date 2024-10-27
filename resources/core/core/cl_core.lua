COMPONENTS.Core = {
  _required = { "Init" },
  _name = "base",
}

Citizen.CreateThread(function()
  LocalPlayer.state.PlayerID = PlayerId()
end)

_baseThreading = false
function COMPONENTS.Core.Init(self)
  if _baseThreading then
    return
  end
  _baseThreading = true

  ShutdownLoadingScreenNui()
  ShutdownLoadingScreen()

  LocalPlayer.state.ped = PlayerPedId()
  LocalPlayer.state.myPos = GetEntityCoords(LocalPlayer.state.ped)

  SetScenarioTypeEnabled("WORLD_VEHICLE_STREETRACE", false)
  SetScenarioTypeEnabled("WORLD_VEHICLE_SALTON_DIRT_BIKE", false)
  SetScenarioTypeEnabled("WORLD_VEHICLE_SALTON", false)
  SetScenarioTypeEnabled("WORLD_VEHICLE_POLICE_NEXT_TO_CAR", false)
  SetScenarioTypeEnabled("WORLD_VEHICLE_POLICE_CAR", false)
  SetScenarioTypeEnabled("WORLD_VEHICLE_POLICE_BIKE", false)
  SetScenarioTypeEnabled("WORLD_VEHICLE_MILITARY_PLANES_SMALL", false)
  SetScenarioTypeEnabled("WORLD_VEHICLE_MILITARY_PLANES_BIG", false)
  SetScenarioTypeEnabled("WORLD_VEHICLE_MECHANIC", false)
  SetScenarioTypeEnabled("WORLD_VEHICLE_EMPTY", false)
  SetScenarioTypeEnabled("WORLD_VEHICLE_BUSINESSMEN", false)
  SetScenarioTypeEnabled("WORLD_VEHICLE_BIKE_OFF_ROAD_RACE", false)

  Citizen.CreateThread(function()
    while _baseThreading do
      Citizen.Wait(1000)
      LocalPlayer.state.ped = PlayerPedId()
      SetPedDropsWeaponsWhenDead(LocalPlayer.state.ped, false)
      --SetPedSuffersCriticalHits(LocalPlayer.state.ped, false) -- Disable Headshots
      SetPedAmmoToDrop(LocalPlayer.state.ped, 0)

      -- Action Aim Remove
      if IsPedUsingActionMode(LocalPlayer.state.ped) then
        SetPedUsingActionMode(LocalPlayer.state.ped, false, -1, 'DEFAULT_ACTION')
        SetPedUsingActionMode(LocalPlayer.state.ped, -1, -1, 1)
      end
    end
  end)

  Citizen.CreateThread(function()
    while _baseThreading do
      Citizen.Wait(100)
      LocalPlayer.state.myPos = GetEntityCoords(LocalPlayer.state.ped)
    end
  end)

  Citizen.CreateThread(function()
    while _baseThreading do
      if NetworkIsPlayerActive(PlayerId()) then
        TriggerEvent("Core:Client:SessionStarted")
        TriggerServerEvent("Core:Server:SessionStarted")
        break
      end
      Citizen.Wait(100)
    end
  end)

  Citizen.CreateThread(function()
    SetWeaponsNoAutoswap(true)
    SetRadarBigmapEnabled(false, false)
    Wait(5)

    NetworkSetFriendlyFireOption(true)

    while _baseThreading do
      SetRadarBigmapEnabled(false, false)
      SetRadarBigmapEnabled(false, false)
      DisableControlAction(0, 37, true)
      DisableControlAction(0, 157, true)
      DisableControlAction(0, 158, true)
      DisableControlAction(0, 159, true)
      DisableControlAction(0, 160, true)
      DisableControlAction(0, 161, true)
      DisableControlAction(0, 162, true)
      DisableControlAction(0, 163, true)
      DisableControlAction(0, 164, true)
      DisableControlAction(0, 165, true)
      HideHudComponentThisFrame(1)
      HideHudComponentThisFrame(7)
      HideHudComponentThisFrame(9)
      HideHudComponentThisFrame(6)
      HideHudComponentThisFrame(8)
      HideHudComponentThisFrame(19)
      HideHudComponentThisFrame(20)

      SetVehicleDensityMultiplierThisFrame(0.3)
      SetPedDensityMultiplierThisFrame(0.8)
      SetRandomVehicleDensityMultiplierThisFrame(0.4)
      SetParkedVehicleDensityMultiplierThisFrame(0.5)
      SetScenarioPedDensityMultiplierThisFrame(0.8, 0.8)
      Citizen.Wait(1)
    end
  end)

  Citizen.CreateThread(function()
    while _baseThreading do
      InvalidateIdleCam()
      InvalidateVehicleIdleCam()
      Wait(25000)
    end
  end)

  Citizen.CreateThread(function()
    for i = 1, 25 do
      EnableDispatchService(i, false)
    end

    while _baseThreading do
      local ped = PlayerPedId()
      SetPedHelmet(ped, false)
      if IsPedInAnyVehicle(ped, false) then
        if GetPedInVehicleSeat(GetVehiclePedIsIn(ped, false), 0) == ped then
          SetPedConfigFlag(ped, 184, true)
          if GetIsTaskActive(ped, 165) then
            SetPedIntoVehicle(ped, GetVehiclePedIsIn(ped, false), 0)
          end
        end
      end

      -- Disable Weapon Attacks with Rifles/Shotguns etc.
      local weapon = GetSelectedPedWeapon(LocalPlayer.state.ped)
      if weapon ~= `WEAPON_UNARMED` then
        if IsPedArmed(LocalPlayer.state.ped, 6) then
          DisableControlAction(1, 140, true)
          DisableControlAction(1, 141, true)
          DisableControlAction(1, 142, true)
        end
      end

      SetMaxWantedLevel(0)
      SetCreateRandomCopsNotOnScenarios(false)
      SetCreateRandomCops(false)
      SetCreateRandomCopsOnScenarios(false)

      Citizen.Wait(2)
    end
  end)

  SetRelationshipBetweenGroups(3, `PRISONER`, `PLAYER`)
  SetRelationshipBetweenGroups(3, `PLAYER`, `PRISONER`)

  Citizen.CreateThread(function()
    local resetcounter = 0
    local jumpDisabled = false

    while _baseThreading do
      Citizen.Wait(100)
      if jumpDisabled and resetcounter > 0 and IsPedJumping(PlayerPedId()) then
        SetPedToRagdoll(PlayerPedId(), 1000, 1000, 3, 0, 0, 0)
        resetcounter = 0
      end

      if not jumpDisabled and IsPedJumping(PlayerPedId()) then
        jumpDisabled = true
        resetcounter = 10
        Citizen.Wait(1200)
      end

      if resetcounter > 0 then
        resetcounter = resetcounter - 1
      else
        if jumpDisabled then
          resetcounter = 0
          jumpDisabled = false
        end
      end
    end
  end)


  Citizen.CreateThread(function()
    while _baseThreading do
      DisableControlAction(1, 140, true)
      if not IsControlPressed(1, 25, true) then
        DisableControlAction(1, 141, true)
        DisableControlAction(1, 142, true)
      end
      Wait(0)
    end
  end)
end

Citizen.CreateThread(function()
  while not exports or exports[GetCurrentResourceName()] == nil do
    Citizen.Wait(1)
  end

  COMPONENTS.Core:Init()

  TriggerEvent("Proxy:Shared:RegisterReady")
  for k, v in pairs(COMPONENTS) do
    TriggerEvent("Proxy:Shared:ExtendReady", k)
  end

  Citizen.Wait(1000)

  COMPONENTS.Proxy.ExportsReady = true
  TriggerEvent("Core:Shared:Ready")
  return
end)

AddEventHandler("onResourceStopped", function(resourceName)
  TriggerServerEvent("Core:Server:ResourceStopped", resourceName)
end)


local function exportHandler(exportName, func)
  AddEventHandler(('__cfx_export_%s_%s'):format(GetCurrentResourceName(), exportName), function(setCB)
    setCB(function(...)
      return func(COMPONENTS.Core, ...)
    end)
  end)
end

local function createExportForObject(object, name)
  name = name or ""
  for k, v in pairs(object) do
    if type(v) == "function" then
      exportHandler(name .. k, v)
    elseif type(v) == "table" then
      createExportForObject(v, name .. k)
    end
  end
end

for k, v in pairs(COMPONENTS.Core) do
  if type(v) == "function" then
    exportHandler("Core" .. k, v)
  elseif type(v) == "table" then
    createExportForObject(v, "Core" .. k)
  end
end
