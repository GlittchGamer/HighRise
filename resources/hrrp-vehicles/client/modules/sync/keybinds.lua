AddEventHandler('Vehicles:Client:StartUp', function()
  exports['hrrp-keybinds']:Add('emergency_lights', 'Q', 'keyboard', 'Vehicle - Toggle Emergency Lighting', function()
    Vehicles.Sync.EmergencyLights:Toggle()
  end)

  exports['hrrp-keybinds']:Add('emergency_sirens', 'LMENU', 'keyboard', 'Vehicle - Toggle Emergency Sirens', function()
    Vehicles.Sync.EmergencySiren:Toggle()
  end)

  exports['hrrp-keybinds']:Add('emergency_sirens_tone', 'R', 'keyboard', 'Vehicle - Cycle Emergency Siren Tone', function()
    Vehicles.Sync.EmergencySiren:Cycle()
  end)

  exports['hrrp-keybinds']:Add('emergency_airhorn', 'E', 'keyboard', 'Vehicle - Emergency Airhorn', function()
    Vehicles.Sync.EmergencyAirhorn:Set(true)
  end, function()
    Vehicles.Sync.EmergencyAirhorn:Set(false)
  end)

  exports['hrrp-keybinds']:Add('veh_indicators_hazards', '', 'keyboard', 'Vehicle - Indicator - Hazards', function()
    Vehicles.Sync.Indicators:Set(0)
  end)

  exports['hrrp-keybinds']:Add('veh_indicators_right', '', 'keyboard', 'Vehicle - Indicator - Right', function()
    Vehicles.Sync.Indicators:Set(1)
  end)

  exports['hrrp-keybinds']:Add('veh_indicators_left', '', 'keyboard', 'Vehicle - Indicator - Left', function()
    Vehicles.Sync.Indicators:Set(2)
  end)

  exports['hrrp-keybinds']:Add('veh_neons_toggle', '', 'keyboard', 'Vehicle - Toggle Neons/Underglow', function()
    Vehicles.Sync.Neons:Toggle()
  end)

  exports['hrrp-keybinds']:Add('veh_bike_drop', 'G', 'keyboard', 'Vehicle - Put Down Bicycle', function()
    Vehicles.Sync.Bike:Drop()
  end)
end)
