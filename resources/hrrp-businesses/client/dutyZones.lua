AddEventHandler('Businesses:Client:Startup', function()
  exports['hrrp-polyzone']:PolyZoneCreateBox('unicorn_offdutyzone', vector3(119.96, -1302.6, 29.12), 61.4, 67.4, {
    heading = 7,
    --debugPoly=true,
    minZ = 25.32,
    maxZ = 46.32
  }, {
    goOffDuty = 'unicorn'
  })

  exports['hrrp-polyzone']:PolyZoneCreateBox('lasttrain_offdutyzone', vector3(-374.12, 279.15, 84.99), 57.4, 42.0, {
    heading = 0,
    --debugPoly=true,
    minZ = 81.39,
    maxZ = 90.39
  }, {
    goOffDuty = 'lasttrain'
  })

  exports['hrrp-polyzone']:PolyZoneCreateBox('tequila_offdutyzone', vector3(-556.95, 286.15, 99.17), 42.2, 39.4, {
    heading = 0,
    --debugPoly=true,
    minZ = 75.57,
    maxZ = 97.17
  }, {
    goOffDuty = 'tequila'
  })

  exports['hrrp-polyzone']:PolyZoneCreateBox('ferrari_pawn_offdutyzone', vector3(170.78, -1316.72, 29.36), 28.6, 46.6, {
    heading = 330,
    --debugPoly=true,
    minZ = 28.36,
    maxZ = 38.16
  }, {
    goOffDuty = 'ferrari_pawn'
  })

  exports['hrrp-polyzone']:PolyZoneCreateBox('uwu_offdutyzone', vector3(-590.48, -1084.29, 22.33), 85.4, 69.6, {
    heading = 1,
    --debugPoly=true,
    minZ = 18.33,
    maxZ = 33.33
  }, {
    goOffDuty = 'uwu'
  })
end)

AddEventHandler("Polyzone:Exit", function(id, testedPoint, insideZones, data)
  if data.goOffDuty and LocalPlayer.state.onDuty == data.goOffDuty then
    exports['hrrp-jobs']:JobsDutyOff(data.goOffDuty)
  end
end)
