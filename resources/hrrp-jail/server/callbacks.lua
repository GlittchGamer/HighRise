function RegisterCallbacks()
  exports['hrrp-base']:CallbacksRegisterServer("Jail:SpawnJailed", function(source, data, cb)
    Routing:RoutePlayerToGlobalRoute(source)
    local char = exports['hrrp-base']:FetchSource(source):GetData("Character")
    TriggerClientEvent("Jail:Client:EnterJail", source)
    cb(true)
  end)

  exports['hrrp-base']:CallbacksRegisterServer("Jail:Validate", function(source, data, cb)
    if not Jail:IsJailed(source) then
      cb(false)
    else
      if data.type == "logout" then
        cb(true)
      else
        cb(false)
      end
    end
  end)

  exports['hrrp-base']:CallbacksRegisterServer("Jail:RetreiveItems", function(source, data, cb)
    Inventory.Holding:Take(source)
  end)

  exports['hrrp-base']:CallbacksRegisterServer("Jail:Release", function(source, data, cb)
    cb(Jail:Release(source))
  end)

  exports['hrrp-base']:CallbacksRegisterServer("Jail:StartWork", function(source, data, cb)
    Labor.Duty:On("Prison", source, false)
  end)

  exports['hrrp-base']:CallbacksRegisterServer("Jail:QuitWork", function(source, data, cb)
    Labor.Duty:Off("Prison", source, false, false)
  end)

  exports['hrrp-base']:CallbacksRegisterServer("Jail:MakeItem", function(source, data, cb)
    local char = exports['hrrp-base']:FetchSource(source):GetData("Character")
    if data == "food" or data == "drink" then
      Inventory:AddItem(char:GetData("SID"), string.format("prison_%s", data), 1, {}, 1)
    end
  end)
end