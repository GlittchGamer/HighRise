function RegisterMiddleware()
  exports['hrrp-base']:MiddlewareAdd('Characters:Spawning', function(source)
    print("Setting phone data for source: " .. source .. " with racing tracks, amount: #" .. #Races.Tracks)
    TriggerClientEvent("Phone:Client:SetData", source, "racing_tracks", Races.Tracks)
  end)

  exports['hrrp-base']:MiddlewareAdd("Characters:Logout", function(source)
    -- LeaveAnyRacePD(source)
  end, 2)

  exports['hrrp-base']:MiddlewareAdd("playerDropped", function(source)
    -- LeaveAnyRacePD(source)
  end, 2)

  exports['hrrp-base']:MiddlewareAdd("Phone:UIReset", function(source)
    TriggerClientEvent("Phone:Client:SetData", source, "racing_tracks", Races.Tracks)
  end, 2)
end

AddEventHandler('Core:Server:RegisterMiddleware', function(resourceName)
  if resourceName ~= GetCurrentResourceName() then return end
  RegisterMiddleware()
end)
