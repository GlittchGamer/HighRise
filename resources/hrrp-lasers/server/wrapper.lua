AddEventHandler('Lasers:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
  Callbacks = exports['hrrp-base']:FetchComponent('Callbacks')
  Chat = exports['hrrp-base']:FetchComponent('Chat')
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['hrrp-base']:RequestDependencies('Lasers', {
    'Callbacks',
    'Chat',
  }, function(error)
    if #error > 0 then return; end
    RetrieveComponents()

    Chat:RegisterAdminCommand("lasers", function(source, args, rawCommand)
      if args[1] == "start" then
        exports["hrrp-base"]:CallbacksClient(source, "Lasers:Create:Start")
      elseif args[1] == "end" then
        exports["hrrp-base"]:CallbacksClient(source, "Lasers:Create:End")
      elseif args[1] == "save" then
        exports["hrrp-base"]:CallbacksClient(source, "Lasers:Create:Save")
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
