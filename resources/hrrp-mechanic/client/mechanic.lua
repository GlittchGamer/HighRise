_repairingVehicle = false

AddEventHandler('Mechanic:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
  Logger = exports['hrrp-base']:FetchComponent('Logger')
  Fetch = exports['hrrp-base']:FetchComponent('Fetch')
  Callbacks = exports['hrrp-base']:FetchComponent('Callbacks')
  Game = exports['hrrp-base']:FetchComponent('Game')
  Mechanic = exports['hrrp-base']:FetchComponent('Mechanic')
  Utils = exports['hrrp-base']:FetchComponent('Utils')
  Notification = exports['hrrp-base']:FetchComponent('Notification')
  Polyzone = exports['hrrp-base']:FetchComponent('Polyzone')
  Jobs = exports['hrrp-base']:FetchComponent('Jobs')
  Progress = exports['hrrp-base']:FetchComponent('Progress')
  Vehicles = exports['hrrp-base']:FetchComponent('Vehicles')
  ListMenu = exports['hrrp-base']:FetchComponent('ListMenu')
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['hrrp-base']:RequestDependencies('Mechanic', {
    'Logger',
    'Fetch',
    'Callbacks',
    'Game',
    'Menu',
    'Mechanic',
    'Notification',
    'Utils',
    'Polyzone',
    'Jobs',
    'Progress',
    'Vehicles',
    'ListMenu',
  }, function(error)
    if #error > 0 then
      return;
    end
    RetrieveComponents()

    CreateMechanicZones()
    CreateMechanicDutyPoints()

    exports["hrrp-base"]:CallbacksRegisterClient('Mechanic:StartInstall', function(part, cb)
      if LocalPlayer.state.loggedIn and not _repairingVehicle then
        local duty = LocalPlayer.state.onDuty
        if duty and _mechanicJobs[duty] then
          local installingPartData = _mechanicItemsToParts[part]
          local target = exports['ox_target']:TargetingGetEntityPlayerIsLookingAt()
          if (
                installingPartData and target and target.entity and DoesEntityExist(target.entity)
                and IsEntityAVehicle(target.entity)
                and not GetIsVehicleEngineRunning(target.entity)
                and (
                  (#(GetEntityCoords(target.entity) - LocalPlayer.state.myPos) <= 5.0)
                  or Vehicles.Utils:IsCloseToRearOfVehicle(target.entity)
                  or Vehicles.Utils:IsCloseToFrontOfVehicle(target.entity)
                )
              ) then
            local vehEnt = Entity(target.entity)
            local vehClass = vehEnt.state.Class
            local vehDamage = vehEnt.state.DamagedParts

            if not vehDamage or vehDamage[installingPartData.part] >= 99 then
              exports['hrrp-hud']:NotificationError('Vehicle Part Doesn\'t Need Repairing')
              return cb(false)
            end

            local requiresHighGradeParts = false
            if vehClass then
              requiresHighGradeParts = _highPerformanceClasses[vehClass]
            end

            if (not requiresHighGradeParts and installingPartData.regular) or (requiresHighGradeParts and installingPartData.hperformance) then
              if GetIsVehicleEngineRunning(target.entity) then
                exports['hrrp-hud']:NotificationError('Turn Off the Engine')
                return cb(false)
              end

              if IsPedInAnyVehicle(LocalPlayer.state.ped, false) then
                exports['hrrp-hud']:NotificationError('Can\'t Repair Whilst in a Vehicle')
                return cb(false)
              end

              TaskTurnPedToFaceEntity(LocalPlayer.state.ped, target.entity, 1.0)
              Citizen.Wait(750)

              local repairLength = installingPartData.time or 15

              Progress:ProgressWithStartAndTick({
                name = "veh_mech_repair",
                duration = repairLength * 1000,
                label = "Repairing Vehicle",
                canCancel = true,
                tickrate = 1000,
                controlDisables = {
                  disableMovement = true,
                  disableCarMovement = true,
                  disableMouse = false,
                  disableCombat = true,
                },
                animation = {
                  anim = installingPartData.anim or 'mechanic',
                },
                disarm = true,
              }, function()
                _repairingVehicle = true
              end, function()
                if not DoesEntityExist(target.entity) or not (
                      Vehicles.Utils:IsCloseToRearOfVehicle(target.entity)
                      or Vehicles.Utils:IsCloseToFrontOfVehicle(target.entity)
                      or (#(GetEntityCoords(target.entity) - LocalPlayer.state.myPos) <= 5.0)
                    ) then
                  Progress:Cancel()
                end
              end, function(wasCancelled)
                _repairingVehicle = false
                if not wasCancelled then
                  if Vehicles.Repair:Part(target.entity, installingPartData.part, installingPartData.amount) then
                    cb(true)
                    exports['hrrp-hud']:NotificationSuccess('Part Repaired')
                  else
                    cb(false)
                    exports['hrrp-hud']:NotificationError('Failed to Repair Part')
                  end
                else
                  cb(false)
                end
              end)

              return
            else
              exports['hrrp-hud']:NotificationError('This Part Doesn\'t Fit! Stupid Mechanic!')
            end
          end
        end
      end
      cb(false)
    end)


    exports["hrrp-base"]:CallbacksRegisterClient('Mechanic:StartUpgradeInstall', function(part, cb)
      if LocalPlayer.state.loggedIn and not _repairingVehicle then
        local duty = LocalPlayer.state.onDuty
        if duty and _mechanicJobs[duty] then
          local target = exports['ox_target']:TargetingGetEntityPlayerIsLookingAt()
          if (
                target and target.entity and DoesEntityExist(target.entity)
                and IsEntityAVehicle(target.entity)
                and (
                  (#(GetEntityCoords(target.entity) - LocalPlayer.state.myPos) <= 5.0)
                  or Vehicles.Utils:IsCloseToRearOfVehicle(target.entity)
                  or Vehicles.Utils:IsCloseToFrontOfVehicle(target.entity)
                )
              ) then
            if GetIsVehicleEngineRunning(target.entity) then
              exports['hrrp-hud']:NotificationError('Turn Off the Engine')
              return cb(false)
            end

            SetVehicleModKit(target.entity, 0)

            if part.toggleMod and IsToggleModOn(target.entity, part.modType) then
              exports['hrrp-hud']:NotificationError('Vehicle Already Has Upgrade of That Level')
              return cb(false)
            end

            if not part.toggleMod then
              local maxUpgradable = GetNumVehicleMods(target.entity, part.modType) - 1
              local currentUpgrade = GetVehicleMod(target.entity, part.modType)
              if part.modIndex > maxUpgradable then
                exports['hrrp-hud']:NotificationError('Vehicle Does Not Support That Upgrade')
                return cb(false)
              end

              if currentUpgrade >= part.modIndex then
                exports['hrrp-hud']:NotificationError('Vehicle Already Has Upgrade of That Level')
                return cb(false)
              end
            end

            if IsPedInAnyVehicle(LocalPlayer.state.ped, false) then
              exports['hrrp-hud']:NotificationError('Can\'t Repair Whilst in a Vehicle')
              return cb(false)
            end

            TaskTurnPedToFaceEntity(LocalPlayer.state.ped, target.entity, 1.0)
            Citizen.Wait(750)

            local repairLength = part.time or 25

            Progress:ProgressWithStartAndTick({
              name = "veh_mech_install",
              duration = repairLength * 1000,
              label = "Installing " .. part.part .. " Upgrade",
              canCancel = true,
              tickrate = 1000,
              controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
              },
              animation = {
                anim = part.anim or 'mechanic',
              },
              disarm = true,
            }, function()
              _repairingVehicle = true
            end, function()
              if not DoesEntityExist(target.entity) or not (
                    Vehicles.Utils:IsCloseToRearOfVehicle(target.entity)
                    or Vehicles.Utils:IsCloseToFrontOfVehicle(target.entity)
                    or (#(GetEntityCoords(target.entity) - LocalPlayer.state.myPos) <= 5.0)
                  ) then
                Progress:Cancel()
              end
            end, function(wasCancelled)
              _repairingVehicle = false
              if not wasCancelled then
                if part.toggleMod then
                  ToggleVehicleMod(target.entity, part.modType, true)
                else
                  SetVehicleMod(target.entity, part.modType, part.modIndex, false)
                end

                cb(true, VehToNet(target.entity))
                exports['hrrp-hud']:NotificationSuccess('Part Installed')
              else
                cb(false)
              end
            end)
            return
          end
        end
      end
      cb(false)
    end)

    RemoveEventHandler(setupEvent)
  end)
end)

RegisterNetEvent('Mechanic:Client:ForcePerformanceProperty', function(vehicle, modType, modIndex)
  if NetworkDoesEntityExistWithNetworkId(vehicle) then
    local veh = NetToVeh(vehicle)
    if DoesEntityExist(veh) then
      SetVehicleModKit(veh, 0)

      if type(modIndex) == "boolean" then
        ToggleVehicleMod(veh, part.modType, modIndex)
      else
        SetVehicleMod(veh, modType, modIndex, false)
      end
    end
  end
end)

_MECHANIC = {
  CanAccessVehicleAsMechanic = function(self, vehicle)
    local vehCoords = GetEntityCoords(vehicle)
    local myDuty = LocalPlayer.state.onDuty
    if myDuty and _mechanicJobs[myDuty] then
      local inMechanicZone, mechanicZone = GetMechanicZoneAtCoords(vehCoords)
      if inMechanicZone and mechanicZone == myDuty then
        return true
      end
    end
    return false
  end,
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
  exports['hrrp-base']:RegisterComponent('Mechanic', _MECHANIC)
end)

local function exportHandler(exportName, func)
  AddEventHandler(('__cfx_export_%s_%s'):format(GetCurrentResourceName(), exportName), function(setCB)
    setCB(function(...)
      return func(_MECHANIC, ...)
    end)
  end)
end

for k, v in pairs(_MECHANIC) do
  if type(v) == "function" then
    exportHandler(k, v)
  end
end


-- Regular Engine/Body Repair

AddEventHandler('Mechanic:Client:StartRegularRepair', function(entityData)
  if entityData and entityData.entity and DoesEntityExist(entityData.entity) and not _repairingVehicle then
    if GetIsVehicleEngineRunning(entityData.entity) then
      return exports['hrrp-hud']:NotificationError('Turn Off the Engine')
    end

    if IsPedInAnyVehicle(LocalPlayer.state.ped, false) then
      return exports['hrrp-hud']:NotificationError('Can\'t Repair Whilst in a Vehicle')
    end

    TaskTurnPedToFaceEntity(LocalPlayer.state.ped, entityData.entity, 1.0)
    Citizen.Wait(750)

    local repairLength = 20
    exports["hrrp-animations"]:EmotesPlay('mechanic', false, repairLength * 1000, true)
    Progress:ProgressWithStartAndTick({
      name = "veh_mech_repair",
      duration = repairLength * 1000,
      label = "Repairing Vehicle",
      canCancel = true,
      tickrate = 1000,
      controlDisables = {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
      },
      disarm = true,
    }, function()
      _repairingVehicle = true
    end, function()
      if not DoesEntityExist(entityData.entity) or not (
            Vehicles.Utils:IsCloseToRearOfVehicle(entityData.entity)
            or Vehicles.Utils:IsCloseToFrontOfVehicle(entityData.entity)
          ) then
        Progress:Cancel()
      end
    end, function(wasCancelled)
      _repairingVehicle = false
      exports["hrrp-animations"]:EmotesForceCancel()
      if not wasCancelled then
        if Vehicles.Repair:Normal(entityData.entity) then
          exports['hrrp-hud']:NotificationSuccess('Regular Repair Complete')
        else
          exports['hrrp-hud']:NotificationError('Regular Repair Failed')
        end
      end
    end)
  end
end)

-- Citizen.CreateThread(function()
--     local fridge = `v_res_fridgemoda`

--     loadModel(fridge)
--     local lol = CreateObject(fridge, -578.07, -911.8, 22.89, false, false)
--     FreezeEntityPosition(lol, true)
--     SetEntityLodDist(lol, 50)
-- end)

function loadModel(model)
  if IsModelInCdimage(model) then
    while not HasModelLoaded(model) do
      RequestModel(model)
      Citizen.Wait(5)
    end
  end
end
