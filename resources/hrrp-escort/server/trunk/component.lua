AddEventHandler("Trunk:Shared:DependencyUpdate", TrunkComponents)
function TrunkComponents()
  Middleware = exports["hrrp-base"]:FetchComponent("Middleware")
  Callbacks = exports["hrrp-base"]:FetchComponent("Callbacks")
  Trunk = exports["hrrp-base"]:FetchComponent("Trunk")
  Escort = exports["hrrp-base"]:FetchComponent("Escort")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports["hrrp-base"]:RequestDependencies("Trunk", {
    "Middleware",
    "Callbacks",
    "Trunk",
    "Escort",
  }, function(error)
    if #error > 0 then
      return
    end -- Do something to handle if not all dependencies loaded
    TrunkComponents()

    Middleware:Add("Characters:Logout", function(source)
      if Player(source).state.inTrunk then
        Trunk:Exit(source, GlobalState[string.format("PlayerTrunk:%s", source)])
      end
    end, 5)

    Middleware:Add("playerDropped", function(source)
      if Player(source).state.inTrunk then
        Trunk:Exit(source, GlobalState[string.format("PlayerTrunk:%s", source)])
      end
    end, 5)

    exports['hrrp-base']:CallbacksRegisterServer("Trunk:PutIn", function(source, data, cb)
      local t = Player(source).state.isEscorting

      if t ~= nil then
        Escort:Stop(source)
        exports["hrrp-base"]:CallbacksClient(t, "Trunk:GetPutIn", data)
      end
    end)

    exports['hrrp-base']:CallbacksRegisterServer("Trunk:PullOut", function(source, data, cb)
      if GlobalState[string.format("Trunk:%s", data)] == nil then
        GlobalState[string.format("Trunk:%s", data)] = {}
      end

      if #GlobalState[string.format("Trunk:%s", data)] > 0 then
        local t = GlobalState[string.format("Trunk:%s", data)][1]

        if t ~= nil then
          exports["hrrp-base"]:CallbacksClient(t, "Trunk:GetPulledOut", {}, function()
            Citizen.Wait(500)
            Escort:Do(source, {
              target = t,
              inVeh = false
            })
          end)
        end
      end
    end)

    RemoveEventHandler(setupEvent)
  end)
end)

_TRUNK = {
  Enter = function(self, source, netId)
    GlobalState[string.format("PlayerTrunk:%s", source)] = netId
    local t = GlobalState[string.format("Trunk:%s", netId)] or {}
    table.insert(t, source)
    GlobalState[string.format("Trunk:%s", netId)] = t
  end,
  Exit = function(self, source, netId)
    if GlobalState[string.format("Trunk:%s", netId)] ~= nil then
      local newTable = {}
      for k, v in ipairs(GlobalState[string.format("Trunk:%s", netId)]) do
        if source == v then
          GlobalState[string.format("PlayerTrunk:%s", source)] = nil
          TriggerClientEvent("Trunk:Client:Exit", source)
        else
          table.insert(newTable, v)
        end
      end

      GlobalState[string.format("Trunk:%s", netId)] = newTable
    elseif GlobalState[string.format("PlayerTrunk:%s", source)] then -- Car Probably Deleted
      GlobalState[string.format("PlayerTrunk:%s", source)] = nil
      TriggerClientEvent("Trunk:Client:Exit", source)
    end
  end,
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
  exports["hrrp-base"]:RegisterComponent("Trunk", _TRUNK)
end)

RegisterNetEvent("Trunk:Server:Enter", function(netId)
  Trunk:Enter(source, netId)
end)

RegisterNetEvent("Trunk:Server:Exit", function(netId)
  Trunk:Exit(source, netId)
end)
