AddEventHandler("Arcade:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Fetch = exports["hrrp-base"]:FetchComponent("Fetch")

  Callbacks = exports["hrrp-base"]:FetchComponent("Callbacks")
  Logger = exports["hrrp-base"]:FetchComponent("Logger")
  Chat = exports["hrrp-base"]:FetchComponent("Chat")
  Middleware = exports["hrrp-base"]:FetchComponent("Middleware")
  Execute = exports["hrrp-base"]:FetchComponent("Execute")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports["hrrp-base"]:RequestDependencies("Arcade", {
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

    exports['hrrp-base']:CallbacksRegisterServer("Arcade:Open", function(source, data, cb)
      local plyr = exports['hrrp-base']:FetchSource(source)
      if plyr ~= nil then
        local char = plyr:GetData("Character")
        if char ~= nil then
          if Player(source).state.onDuty == "avast_arcade" then
            GlobalState["Arcade:Open"] = true
          end
        end
      end
    end)

    exports['hrrp-base']:CallbacksRegisterServer("Arcade:Close", function(source, data, cb)
      local plyr = exports['hrrp-base']:FetchSource(source)
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
