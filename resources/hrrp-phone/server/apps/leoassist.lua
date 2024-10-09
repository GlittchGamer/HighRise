local _alerts = {}

AddEventHandler("Phone:Server:RegisterMiddleware", function()
  Middleware:Add("Characters:Spawning", function(source)
    -- local char = exports['hrrp-base']:FetchSource(source):GetData("Character")
    -- if char:GetData("Job").job == "police" then
    -- 	TriggerClientEvent("Phone:Client:SetData", source, "leoAlerts", _alerts)
    -- else
    -- 	TriggerClientEvent("Phone:Client:RemoveData", source, "leoAlerts")
    -- end

    TriggerClientEvent("Phone:Client:RemoveData", source, "leoAlerts")
  end, 2)
  Middleware:Add("Phone:UIReset", function(source)
    TriggerClientEvent("Phone:Client:RemoveData", source, "leoAlerts")
  end, 2)
end)

AddEventHandler("Phone:Server:RegisterCallbacks", function()
  exports['hrrp-base']:CallbacksRegisterServer("Phone:LEOAsist:SearchPeople", function(source, data, cb)
    cb(MDT.People.Search:People(data))
  end)

  exports['hrrp-base']:CallbacksRegisterServer("Phone:LEOAsist:SearchVehicles", function(source, data, cb)
    cb(MDT.Vehicles:Search(data))
  end)
end)
