AddEventHandler("Drugs:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Callbacks = exports["hrrp-base"]:FetchComponent("Callbacks")
  Inventory = exports["hrrp-base"]:FetchComponent("Inventory")
  Progress = exports["hrrp-base"]:FetchComponent("Progress")
  Hud = exports["hrrp-base"]:FetchComponent("Hud")
  Notification = exports["hrrp-base"]:FetchComponent("Notification")
  ObjectPlacer = exports["hrrp-base"]:FetchComponent("ObjectPlacer")
  Minigame = exports["hrrp-base"]:FetchComponent("Minigame")
  ListMenu = exports["hrrp-base"]:FetchComponent("ListMenu")
  PedInteraction = exports["hrrp-base"]:FetchComponent("PedInteraction")
  Polyzone = exports["hrrp-base"]:FetchComponent("Polyzone")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports["hrrp-base"]:RequestDependencies("Drugs", {
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
      exports["hrrp-base"]:FetchComponent("Logger"):Critical("Drugs", "Failed To Load All Dependencies")
      return
    end
    RetrieveComponents()

    TriggerEvent("Drugs:Client:Startup")

    RemoveEventHandler(setupEvent)
  end)
end)
