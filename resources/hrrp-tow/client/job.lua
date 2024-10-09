AddEventHandler('Tow:Client:RequestJob', function()
  exports["hrrp-base"]:CallbacksServer('Tow:RequestJob', {}, function(success)
    if success then
      exports['hrrp-hud']:NotificationSuccess('You are Now Employed at Tow Yard', 5000, 'truck-tow')
    else
      exports['hrrp-hud']:NotificationError('Employement Request Failed', 5000, 'truck-tow')
    end
  end)
end)

AddEventHandler('Tow:Client:QuitJob', function()
  exports["hrrp-base"]:CallbacksServer('Tow:QuitJob', {}, function(success)
    if not success then
      exports['hrrp-hud']:NotificationError('Request to Quit Failed', 5000, 'truck-tow')
    end
  end)
end)

AddEventHandler('Tow:Client:OnDuty', function()
  exports["hrrp-base"]:CallbacksServer('Tow:OnDuty', {})
end)

AddEventHandler('Tow:Client:OffDuty', function()
  exports["hrrp-base"]:CallbacksServer('Tow:OffDuty', {})
end)

AddEventHandler('Tow:Client:RequestTruck', function()
  local availableSpace = GetClosestAvailableParkingSpace(LocalPlayer.state.myPos, _towSpaces)
  if availableSpace then
    exports["hrrp-base"]:CallbacksServer('Tow:RequestTruck', availableSpace, function(vehNet)
      if vehNet ~= nil then
        SetEntityAsMissionEntity(NetToVeh(vehNet))
      end
    end)
  else
    exports['hrrp-hud']:NotificationError('Parking Space Occupied, Move Out the Way!', 7500, 'truck-tow')
  end
end)

AddEventHandler('Tow:Client:ReturnTruck', function()
  exports["hrrp-base"]:CallbacksServer('Tow:ReturnTruck', {})
end)

AddEventHandler('Tow:Client:RequestImpound', function(entityData)
  local myTowTruck = GlobalState[string.format('TowTrucks:%s', LocalPlayer.state.Character:GetData('SID'))]
  if myTowTruck then
    myTowTruck = NetToVeh(myTowTruck)
  end

  if entityData and entityData.entity and DoesEntityExist(entityData.entity) and (not myTowTruck or myTowTruck ~= entityData.entity) and #(GetEntityCoords(entityData.entity) - GetEntityCoords(LocalPlayer.state.ped)) <= 10.0 and IsVehicleEmpty(entityData.entity) and exports['hrrp-polyzone']:PolyZoneIsCoordsInZone(GetEntityCoords(entityData.entity), 'tow_impound_zone') then
    Progress:ProgressWithTickEvent({
      name = 'veh_impound',
      duration = 10 * 1000,
      label = 'Impounding Vehicle',
      useWhileDead = false,
      canCancel = true,
      vehicle = false,
      disarm = false,
      ignoreModifier = true,
      controlDisables = {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
      },
      animation = {
        anim = 'clipboard',
      },
    }, function()
      if not DoesEntityExist(entityData.entity) or (#(GetEntityCoords(entityData.entity) - GetEntityCoords(LocalPlayer.state.ped)) > 10.0) or not IsVehicleEmpty(entityData.entity) then
        Progress:Cancel()
      end
    end, function(cancelled)
      if not cancelled and DoesEntityExist(entityData.entity) and (#(GetEntityCoords(entityData.entity) - GetEntityCoords(LocalPlayer.state.ped)) <= 10.0) and IsVehicleEmpty(entityData.entity) then
        exports["hrrp-base"]:CallbacksServer('Vehicles:Impound', {
          vNet = VehToNet(entityData.entity),
          type = 'impound',
        }, function(success)
          if success then
            exports['hrrp-hud']:NotificationSuccess('Vehicle Impounded Successfully')
          else
            exports['hrrp-hud']:NotificationError('Impound Failed Miserably')
          end
        end)
      else
        exports['hrrp-hud']:NotificationError('Impound Failed')
      end
    end)
  else
    exports['hrrp-hud']:NotificationError('Cannot Impound That Vehicle')
  end
end)
