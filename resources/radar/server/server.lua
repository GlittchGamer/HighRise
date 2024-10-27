FLAGGED_PLATES = {}

AddEventHandler('Radar:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
  Callbacks = exports['core']:FetchComponent('Callbacks')
  Logger = exports['core']:FetchComponent('Logger')
  Utils = exports['core']:FetchComponent('Utils')
  Chat = exports['core']:FetchComponent('Chat')
  Jobs = exports['core']:FetchComponent('Jobs')
  Fetch = exports['core']:FetchComponent('Fetch')
  Radar = exports['core']:FetchComponent('Radar')
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies('Radar', {

    'Callbacks',
    'Logger',
    'Utils',
    'Chat',
    'Jobs',
    'Fetch',
    'Radar',
  }, function(error)
    if #error > 0 then return end -- Do something to handle if not all dependencies loaded
    RetrieveComponents()
    RegisterChatCommands()

    RemoveEventHandler(setupEvent)
  end)
end)

Citizen.CreateThread(function()
  GlobalState.RadarFlaggedPlates = {}
end)

function RegisterChatCommands()
  Chat:RegisterCommand('flagplate', function(src, args, raw)
    local plate = args[1]
    local reason = args[2]

    if plate then
      exports['radar']:AddFlaggedPlate(plate:upper(), reason)
    end
  end, {
    help = 'Flag a Plate',
    params = {
      { name = 'Plate',  help = 'The Plate to Flag' },
      { name = 'Reason', help = 'Reason Why the Plate is Flagged' },
    },
  }, 2, {
    { Id = 'police', Level = 1 }
  })

  Chat:RegisterCommand('unflagplate', function(src, args, raw)
    local plate = args[1]
    local reason = args[2]

    if plate and reason then
      exports['radar']:RemoveFlaggedPlate(plate)
    end
  end, {
    help = 'Unflag a Plate',
    params = {
      { name = 'Plate', help = 'The Plate to Unflag' },
    },
  }, 1, {
    { Id = 'police', Level = 1 }
  })

  Chat:RegisterCommand('radar', function(src)
    TriggerClientEvent('Radar:Client:ToggleRadarDisabled', src)
  end, {
    help = 'Toggle Radar'
  }, 0, {
    { Id = 'police', Level = 1 }
  })
end

RADAR = {
  AddFlaggedPlate = function(self, plate, reason)
    if not reason then reason = 'No Reason Specified' end

    exports['core']:LoggerTrace('Radar', string.format('New Flagged Plate: %s, Reason: %s', plate, reason))
    FLAGGED_PLATES[plate] = reason

    GlobalState.RadarFlaggedPlates = FLAGGED_PLATES
  end,
  RemoveFlaggedPlate = function(self, plate)
    exports['core']:LoggerTrace('Radar', string.format('Plate Unflagged: %s', plate))
    FLAGGED_PLATES[plate] = nil

    GlobalState.RadarFlaggedPlates = FLAGGED_PLATES
  end,
  ClearFlaggedPlates = function(self)
    exports['core']:LoggerTrace('Radar', 'All Plates Unflagged')
    FLAGGED_PLATES = {}

    GlobalState.RadarFlaggedPlates = FLAGGED_PLATES
  end,
  GetFlaggedPlates = function(self)
    return FLAGGED_PLATES
  end,
  CheckPlate = function(self, plate)
    return FLAGGED_PLATES[plate]
  end,
}

AddEventHandler('Proxy:Shared:RegisterReady', function() --!Completed
  exports['core']:RegisterComponent('Radar', RADAR)
end)

local function exportHandler(exportName, func)
  AddEventHandler(('__cfx_export_%s_%s'):format(GetCurrentResourceName(), exportName), function(setCB)
    setCB(function(...)
      return func(RADAR, ...)
    end)
  end)
end

for k, v in pairs(RADAR) do
  if type(v) == "function" then
    exportHandler(k, v)
  end
end

RegisterNetEvent('Radar:Server:StolenVehicle', function(plate)
  if type(plate) == "string" then
    exports['radar']:AddFlaggedPlate(plate, 'Vehicle Reported Stolen')
  end
end)
