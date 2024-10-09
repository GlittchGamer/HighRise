GLOBAL_PED = false

targetableObjectModels = {}
targetableEntities = {}
interactionZones = {}

AddEventHandler('Targeting:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
  Logger = exports['hrrp-base']:FetchComponent('Logger')
  Utils = exports['hrrp-base']:FetchComponent('Utils')
  Keybinds = exports['hrrp-base']:FetchComponent('Keybinds')
  UISounds = exports['hrrp-base']:FetchComponent('UISounds')
  Jobs = exports['hrrp-base']:FetchComponent('Jobs')
  Vehicles = exports['hrrp-base']:FetchComponent('Vehicles')
  Fetch = exports['hrrp-base']:FetchComponent('Fetch')
  EMS = exports['hrrp-base']:FetchComponent('EMS')
  Inventory = exports['hrrp-base']:FetchComponent('Inventory')
  Reputation = exports['hrrp-base']:FetchComponent('Reputation')
  Mechanic = exports['hrrp-base']:FetchComponent('Mechanic')
  Polyzone = exports['hrrp-base']:FetchComponent('Polyzone')
  Tow = exports['hrrp-base']:FetchComponent('Tow')
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['hrrp-base']:RequestDependencies('Targeting', {
    'Logger',
    'Utils',
    'Keybinds',
    'UISounds',
    'Jobs',
    'Vehicles',
    'Fetch',
    'EMS',
    'Inventory',
    'Reputation',
    'Mechanic',
    'Polyzone',
    'Tow',
  }, function(error)
    if #error > 0 then
      return
    end
    RetrieveComponents()

    exports['hrrp-keybinds']:Add('targeting_starts', 'LMENU', 'keyboard', 'Targeting (Third Eye) (Hold)', function()
      StartTargeting()
    end, function()
      if not inTargetingMenu then
        StopTargeting()
      end
    end)

    if LocalPlayer.state.loggedIn then
      DeInitPolyzoneTargets()
      Citizen.Wait(100)
      InitPolyzoneTargets()
    end

    RemoveEventHandler(setupEvent)
  end)
end)

RegisterNetEvent('Characters:Client:Spawn')
AddEventHandler('Characters:Client:Spawn', function()
  Citizen.CreateThread(function()
    while LocalPlayer.state.loggedIn do
      GLOBAL_PED = PlayerPedId()
      Citizen.Wait(5000)
    end
  end)

  local lastEntity = nil
  Citizen.CreateThread(function()
    while LocalPlayer.state.loggedIn do
      Citizen.Wait(500)
      local hitting, endCoords, entity = GetEntityPlayerIsLookingAt(25.0, GLOBAL_PED, 286)
      if hitting and GetEntityType(entity) > 0 and entity ~= lastEntity then
        lastEntity = entity
        TriggerEvent('Targeting:Client:TargetChanged', entity, endCoords)
      elseif not hitting and lastEntity then
        lastEntity = nil
        TriggerEvent('Targeting:Client:TargetChanged', false)
      end
    end
  end)

  Citizen.Wait(2000)

  InitPolyzoneTargets()
end)

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
  DeInitPolyzoneTargets()
end)

TARGETING = {
  GetEntityPlayerIsLookingAt = function(self)
    local hitting, endCoords, entity = GetEntityPlayerIsLookingAt(25.0, GLOBAL_PED, 286)
    if hitting then
      return {
        entity = entity,
        endCoords = endCoords,
      }
    end
    return false
  end,
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
  -- ? Clear targets since they should be being reregistered on component update anyways
  targetableObjectModels = {}
  targetableEntities = {}
  interactablePeds = {}
  interactableModels = {}
  interactionZones = {}
  exports['hrrp-base']:RegisterComponent('Targeting', TARGETING)
end)
