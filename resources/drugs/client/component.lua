AddEventHandler("Drugs:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Callbacks = exports['core']:FetchComponent("Callbacks")
  Inventory = exports['core']:FetchComponent("Inventory")
  Progress = exports['core']:FetchComponent("Progress")
  Hud = exports['core']:FetchComponent("Hud")
  Notification = exports['core']:FetchComponent("Notification")
  ObjectPlacer = exports['core']:FetchComponent("ObjectPlacer")
  Minigame = exports['core']:FetchComponent("Minigame")
  ListMenu = exports['core']:FetchComponent("ListMenu")
  PedInteraction = exports['core']:FetchComponent("PedInteraction")
  Polyzone = exports['core']:FetchComponent("Polyzone")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies("Drugs", {
    "Callbacks",
    "Inventory",
    "Progress",
    "Hud",
    "Notification",
    "ObjectPlacer",
    "Minigame",
    "ListMenu",
    "PedInteraction",
    "Polyzone",
  }, function(error)
    if #error > 0 then
      exports['core']:FetchComponent("Logger"):Critical("Drugs", "Failed To Load All Dependencies")
      return
    end
    RetrieveComponents()

    TriggerEvent("Drugs:Client:Startup")

    RemoveEventHandler(setupEvent)
  end)
end)
