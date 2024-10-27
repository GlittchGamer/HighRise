GLOBAL_PED = false

targetableObjectModels = {}
targetableEntities = {}
interactionZones = {}

AddEventHandler('Targeting:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
  Logger = exports['core']:FetchComponent('Logger')
  Utils = exports['core']:FetchComponent('Utils')
  Keybinds = exports['core']:FetchComponent('Keybinds')
  UISounds = exports['core']:FetchComponent('UISounds')
  Jobs = exports['core']:FetchComponent('Jobs')
  Vehicles = exports['core']:FetchComponent('Vehicles')
  Fetch = exports['core']:FetchComponent('Fetch')
  EMS = exports['core']:FetchComponent('EMS')
  Inventory = exports['core']:FetchComponent('Inventory')
  Reputation = exports['core']:FetchComponent('Reputation')
  Mechanic = exports['core']:FetchComponent('Mechanic')
  Polyzone = exports['core']:FetchComponent('Polyzone')
  Tow = exports['core']:FetchComponent('Tow')
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies('Targeting', {
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

    exports['keybinds']:Add('targeting_starts', 'LMENU', 'keyboard', 'Targeting (Third Eye) (Hold)', function()
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
  exports['core']:RegisterComponent('Targeting', TARGETING)
end)
