EDITING_VEHICLE = nil

AddEventHandler('Fitment:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
  Logger = exports['core']:FetchComponent('Logger')
  Fetch = exports['core']:FetchComponent('Fetch')
  Callbacks = exports['core']:FetchComponent('Callbacks')
  Game = exports['core']:FetchComponent('Game')
  Utils = exports['core']:FetchComponent('Utils')
  Notification = exports['core']:FetchComponent('Notification')
  Polyzone = exports['core']:FetchComponent('Polyzone')
  Jobs = exports['core']:FetchComponent('Jobs')
  Weapons = exports['core']:FetchComponent('Weapons')
  Progress = exports['core']:FetchComponent('Progress')
  Vehicles = exports['core']:FetchComponent('Vehicles')
  ListMenu = exports['core']:FetchComponent('ListMenu')
  Action = exports['core']:FetchComponent('Action')
  Sounds = exports['core']:FetchComponent('Sounds')
  Menu = exports['core']:FetchComponent('Menu')
  Interaction = exports['core']:FetchComponent('Interaction')
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies('Fitment', {
    'Logger',
    'Fetch',
    'Callbacks',
    'Game',
    'Menu',
    'Notification',
    'Utils',
    'Polyzone',
    'Jobs',
    'Weapons',
    'Progress',
    'Vehicles',
    'ListMenu',
    'Action',
    'Sounds',
    'Menu',
    'Interaction',
  }, function(error)
    if #error > 0 then return; end
    RetrieveComponents()

    Interaction:RegisterMenu("veh_wheels", false, "tire", function()
      OpenWheelMenu()
      Interaction:Hide()
    end, function()
      local pedCoords = GetEntityCoords(LocalPlayer.state.ped)

      local insideZone = exports['polyzonehandler']:PolyZoneIsCoordsInZone(pedCoords, false, 'veh_customs_wheels')
      if insideZone?.veh_customs_wheels and LocalPlayer.state.onDuty and insideZone.veh_customs_wheels == LocalPlayer.state.onDuty then
        return true
      end
      return false
    end)

    RemoveEventHandler(setupEvent)
  end)
end)

local fitmentVehicles = {}

RegisterNetEvent('Characters:Client:Spawn')
AddEventHandler('Characters:Client:Spawn', function()
  StartFitmentThread()
end)

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
  RunVehicleCleanup()
end)

RegisterNetEvent('Fitment:Client:Update', function(netId, data)
  if LocalPlayer.state.loggedIn then
    if fitmentVehicles[netId] and fitmentVehicles[netId].veh then
      if data then
        fitmentVehicles[netId] = {
          veh = fitmentVehicles[netId].veh,
          data = data,
        }

        if v ~= EDITING_VEHICLE then
          SetVehicleWheelWidth(v, data.width + 0.0)
        end
      else
        fitmentVehicles[netId] = nil
      end
    end
  end
end)

function RunVehicleCleanup()
  for k, v in pairs(fitmentVehicles) do
    if not v?.veh or not DoesEntityExist(v?.veh) then
      fitmentVehicles[k] = nil
    end
  end
end

function RunFitmentDataUpdate()
  local vPool = GetGamePool('CVehicle')
  for k, v in ipairs(vPool) do
    if NetworkGetEntityIsNetworked(v) then
      local fitmentData = Entity(v)?.state?.WheelFitment
      if fitmentData then
        fitmentVehicles[VehToNet(v)] = {
          veh = v,
          data = fitmentData,
        }

        if fitmentData.width and v ~= EDITING_VEHICLE then
          SetVehicleWheelWidth(v, fitmentData.width + 0.0)
        end
      end
    end
  end
end

function StartFitmentThread()
  Citizen.CreateThread(function()
    local tick = 0
    while LocalPlayer.state.loggedIn do
      RunFitmentDataUpdate()
      Citizen.Wait(5000)

      if tick >= 5 then
        tick = 0
        RunVehicleCleanup()
      else
        tick = tick + 1
      end
    end
  end)

  Citizen.CreateThread(function()
    while LocalPlayer.state.loggedIn do
      Citizen.Wait(1)
      for k, v in pairs(fitmentVehicles) do
        if v?.veh and v.veh ~= EDITING_VEHICLE and DoesEntityExist(v.veh) then
          SetVehicleFrontTrackWidth(v.veh, v?.data?.frontTrack)
          SetVehicleRearTrackWidth(v.veh, v?.data?.rearTrack)
        end
      end
    end
  end)
end
