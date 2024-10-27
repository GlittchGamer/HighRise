AddEventHandler('Characters:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
  Middleware = exports['core']:FetchComponent('Middleware')

  Callbacks = exports['core']:FetchComponent('Callbacks')
  DataStore = exports['core']:FetchComponent('DataStore')
  Logger = exports['core']:FetchComponent('Logger')

  Fetch = exports['core']:FetchComponent('Fetch')
  Logger = exports['core']:FetchComponent('Logger')
  Chat = exports['core']:FetchComponent('Chat')
  GlobalConfig = exports['core']:FetchComponent('Config')
  Routing = exports['core']:FetchComponent('Routing')
  Sequence = exports['core']:FetchComponent('Sequence')
  Reputation = exports['core']:FetchComponent('Reputation')
  Apartment = exports['core']:FetchComponent('Apartment')
  Utils = exports['core']:FetchComponent('Utils')
  RegisterCommands()
  _spawnFuncs = {}
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies('Characters', {
    'Callbacks',

    'Middleware',
    'DataStore',
    'Logger',

    'Fetch',
    'Logger',
    'Chat',
    'Config',
    'Routing',
    'Sequence',
    'Reputation',
    'Apartment',
  }, function(error)
    if #error > 0 then return end -- Do something to handle if not all dependencies loaded
    RetrieveComponents()
    RegisterCallbacks()
    RegisterMiddleware()
    Startup()

    RemoveEventHandler(setupEvent)
  end)
end)

_tablesToDecode = {
  "Origin",
  "Apps",
  "Wardrobe",
  "Jobs",
  "Addiction",
  "PhoneSettings",
  "Crypto",
  "Licenses",
  "Alias",
  "PhonePermissions",
  "LaptopApps",
  "LaptopSettings",
  "LaptopPermissions",
  "Animations",
  "InventorySettings",
  "States",
  "MDTHistory",
  "MDTSuspension",
  "Qualifications",
  "LastClockOn",
  "Salary",
  "TimeClockedOn",
  "Reputations",
  "GangChain",
  "Jailed",
  "ICU",
  "Status",
  "Parole",
  "LSUNDGBan"
}
