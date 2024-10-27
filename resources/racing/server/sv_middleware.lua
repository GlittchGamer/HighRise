function RegisterMiddleware()
  exports['core']:MiddlewareAdd('Characters:Spawning', function(source)
    print("Setting phone data for source: " .. source .. " with racing tracks, amount: #" .. #Races.Tracks)
    TriggerClientEvent("Phone:Client:SetData", source, "racing_tracks", Races.Tracks)
  end)

  exports['core']:MiddlewareAdd("Characters:Logout", function(source)
    -- LeaveAnyRacePD(source)
  end, 2)

  exports['core']:MiddlewareAdd("playerDropped", function(source)
    -- LeaveAnyRacePD(source)
  end, 2)

  exports['core']:MiddlewareAdd("Phone:UIReset", function(source)
    TriggerClientEvent("Phone:Client:SetData", source, "racing_tracks", Races.Tracks)
  end, 2)
end

AddEventHandler('Core:Server:RegisterMiddleware', function(resourceName)
  if resourceName ~= GetCurrentResourceName() then return end
  RegisterMiddleware()
end)
