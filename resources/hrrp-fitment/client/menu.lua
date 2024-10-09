local wheelMenu = false
local wheelMenuOpen = false

function OpenWheelMenu()
  if wheelMenuOpen then return end

  if not costMultiplier then
    costMultiplier = 1.0
  end

  wheelMenuOpen = true

  EDITING_VEHICLE = GetVehiclePedIsIn(PlayerPedId(), false)

  local editedFrontTrack, editedRearTrack, editedWidth

  wheelMenu = exports['hrrp-menu']:Create('vehicle_wheels', 'Vehicle Wheels', function()
    wheelMenuOpen = true

    Citizen.CreateThread(function()
      while wheelMenuOpen do
        if editedFrontTrack then
          SetVehicleFrontTrackWidth(EDITING_VEHICLE, editedFrontTrack)
        end

        if editedRearTrack then
          SetVehicleRearTrackWidth(EDITING_VEHICLE, editedRearTrack)
        end
        Citizen.Wait(0)
      end
    end)
  end, function()
    Citizen.Wait(100)
    wheelMenu = false
    collectgarbage()
    wheelMenuOpen = false

    EDITING_VEHICLE = nil
    RunFitmentDataUpdate()
  end, true)

  local fitmentState = Entity(EDITING_VEHICLE)?.state?.WheelFitment

  local currentFrontTrackWidth
  if fitmentState and fitmentState?.frontTrack then
    currentFrontTrackWidth = fitmentState?.frontTrack
  else
    currentFrontTrackWidth = Utils:Round(GetVehicleWheelXOffset(EDITING_VEHICLE, 1) * 2, 2)
  end

  wheelMenu.Add:Slider('Front Track Width', {
    current = currentFrontTrackWidth,
    min = 0.4,
    max = 2.0,
    step = 0.02,
  }, function(data)
    editedFrontTrack = tonumber(data.data.value) + 0.0
  end)

  local currentRearTrackWidth
  if fitmentState and fitmentState?.rearTrack then
    currentRearTrackWidth = fitmentState?.rearTrack
  else
    currentRearTrackWidth = Utils:Round(GetVehicleWheelXOffset(EDITING_VEHICLE, 3) * 2, 2)
  end

  wheelMenu.Add:Slider('Rear Track Width', {
    current = currentRearTrackWidth,
    min = 0.4,
    max = 2.0,
    step = 0.02,
  }, function(data)
    editedRearTrack = tonumber(data.data.value) + 0.0
  end)

  local currentWheelWidth
  if fitmentState and fitmentState?.rearTrack then
    currentWheelWidth = fitmentState?.rearTrack
  else
    currentWheelWidth = Utils:Round(GetVehicleWheelWidth(EDITING_VEHICLE), 2)
  end

  wheelMenu.Add:Slider('Wheel Width', {
    current = currentWheelWidth,
    min = 0.2,
    max = 2.5,
    step = 0.05,
  }, function(data)
    editedWidth = tonumber(data.data.value) + 0.0
    SetVehicleWheelWidth(EDITING_VEHICLE, editedWidth)
  end)

  wheelMenu.Add:Button('Save', { success = true }, function()
    exports['hrrp-base']:LoggerTrace('Fitment', 'Attept Save')

    if editedFrontTrack or editedRearTrack or editedWidth then
      exports["hrrp-base"]:CallbacksServer('Vehicles:WheelFitment', {
        vNet = VehToNet(EDITING_VEHICLE),
        fitment = {
          rearTrack = editedRearTrack,
          frontTrack = editedFrontTrack,
          width = editedWidth
        },
      }, function(success, newNewData)
        if success then
          exports['hrrp-hud']:NotificationSuccess('Wheel Fitment Saved')
        else
          exports['hrrp-hud']:NotificationError('Wheel Fitment Saving Failed')
        end
      end)

      wheelMenu:Close()
    else
      exports['hrrp-hud']:NotificationError('There Was Nothing to Save')
    end
  end)

  wheelMenu.Add:Button('Discard', { error = true }, function()
    wheelMenu:Close()
  end)

  wheelMenu.Add:Button('Reset', { error = true }, function()
    exports['hrrp-base']:LoggerTrace('Fitment', 'Attept Reset')

    exports["hrrp-base"]:CallbacksServer('Vehicles:WheelFitment', {
      vNet = VehToNet(EDITING_VEHICLE),
      fitment = false,
    }, function(success, newNewData)
      if success then
        exports['hrrp-hud']:NotificationSuccess('Wheel Fitment Reset')
      else
        exports['hrrp-hud']:NotificationError('Wheel Fitment Reset Failed')
      end
    end)

    wheelMenu:Close()
  end)

  wheelMenu:Show()
end

function ForceCloseMenu()
  if wheelMenu then
    wheelMenu:Close()
  end
end

AddEventHandler('Vehicles:Client:ExitVehicle', function()
  ForceCloseMenu()
end)
