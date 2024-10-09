AddEventHandler('Jobs:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
  Callbacks = exports['hrrp-base']:FetchComponent('Callbacks')
  Logger = exports['hrrp-base']:FetchComponent('Logger')
  Utils = exports['hrrp-base']:FetchComponent('Utils')
  Notification = exports['hrrp-base']:FetchComponent('Notification')
  Jobs = exports['hrrp-base']:FetchComponent('Jobs')
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['hrrp-base']:RequestDependencies('Jobs', {
    'Callbacks',
    'Logger',
    'Utils',
    'Notification',
    'Jobs',
  }, function(error)
    if #error > 0 then return; end
    RetrieveComponents()
    RemoveEventHandler(setupEvent)
  end)
end)
