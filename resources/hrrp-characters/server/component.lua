AddEventHandler('Characters:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
  Middleware = exports['hrrp-base']:FetchComponent('Middleware')

  Callbacks = exports['hrrp-base']:FetchComponent('Callbacks')
  DataStore = exports['hrrp-base']:FetchComponent('DataStore')
  Logger = exports['hrrp-base']:FetchComponent('Logger')

  Fetch = exports['hrrp-base']:FetchComponent('Fetch')
  Logger = exports['hrrp-base']:FetchComponent('Logger')
  Chat = exports['hrrp-base']:FetchComponent('Chat')
  GlobalConfig = exports['hrrp-base']:FetchComponent('Config')
  Routing = exports['hrrp-base']:FetchComponent('Routing')
  Sequence = exports['hrrp-base']:FetchComponent('Sequence')
  Reputation = exports['hrrp-base']:FetchComponent('Reputation')
  Apartment = exports['hrrp-base']:FetchComponent('Apartment')
  Utils = exports['hrrp-base']:FetchComponent('Utils')
  RegisterCommands()
  _spawnFuncs = {}
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['hrrp-base']:RequestDependencies('Characters', {
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
