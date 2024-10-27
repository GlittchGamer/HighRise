AddEventHandler('Jobs:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
  Callbacks = exports['core']:FetchComponent('Callbacks')
  Logger = exports['core']:FetchComponent('Logger')
  Utils = exports['core']:FetchComponent('Utils')
  Notification = exports['core']:FetchComponent('Notification')
  Jobs = exports['core']:FetchComponent('Jobs')
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies('Jobs', {
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
