AddEventHandler("Arcade:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Fetch = exports['core']:FetchComponent("Fetch")

  Callbacks = exports['core']:FetchComponent("Callbacks")
  Logger = exports['core']:FetchComponent("Logger")
  Chat = exports['core']:FetchComponent("Chat")
  Middleware = exports['core']:FetchComponent("Middleware")
  Execute = exports['core']:FetchComponent("Execute")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies("Arcade", {
    "Fetch",

    "Callbacks",
    "Logger",
    "Chat",
    "Middleware",
    "Execute",
  }, function(error)
    if #error > 0 then
      return
    end -- Do something to handle if not all dependencies loaded
    RetrieveComponents()

    exports['core']:CallbacksRegisterServer("Arcade:Open", function(source, data, cb)
      local plyr = exports['core']:FetchSource(source)
      if plyr ~= nil then
        local char = plyr:GetData("Character")
        if char ~= nil then
          if Player(source).state.onDuty == "avast_arcade" then
            GlobalState["Arcade:Open"] = true
          end
        end
      end
    end)

    exports['core']:CallbacksRegisterServer("Arcade:Close", function(source, data, cb)
      local plyr = exports['core']:FetchSource(source)
      if plyr ~= nil then
        local char = plyr:GetData("Character")
        if char ~= nil then
          if Player(source).state.onDuty == "avast_arcade" then
            GlobalState["Arcade:Open"] = false
          end
        end
      end
    end)

    RemoveEventHandler(setupEvent)
  end)
end)
