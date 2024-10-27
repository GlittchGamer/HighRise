AddEventHandler('Lasers:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
  Callbacks = exports['core']:FetchComponent('Callbacks')
  Chat = exports['core']:FetchComponent('Chat')
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies('Lasers', {
    'Callbacks',
    'Chat',
  }, function(error)
    if #error > 0 then return; end
    RetrieveComponents()

    Chat:RegisterAdminCommand("lasers", function(source, args, rawCommand)
      if args[1] == "start" then
        exports['core']:CallbacksClient(source, "Lasers:Create:Start")
      elseif args[1] == "end" then
        exports['core']:CallbacksClient(source, "Lasers:Create:End")
      elseif args[1] == "save" then
        exports['core']:CallbacksClient(source, "Lasers:Create:Save")
      end
    end, {
      help = "Create Lasers",
      params = {
        {
          name = "Action",
          help = "Action to perform (start, end, save)",
        },
      },
    }, 1)

    RemoveEventHandler(setupEvent)
  end)
end)
