AddEventHandler('Vehicles:Client:StartUp', function()
  exports["hrrp-base"]:CallbacksRegisterClient('Vehicles:GetFakePlateAddingVehicle', function(data, cb)
    local target = Targeting:GetEntityPlayerIsLookingAt()
    if target and target.entity and DoesEntityExist(target.entity) and IsEntityAVehicle(target.entity) and CanModelHaveFakePlate(GetEntityModel(target.entity)) then
      if Vehicles:HasAccess(target.entity, false, true) and (Vehicles.Utils:IsCloseToRearOfVehicle(target.entity) or Vehicles.Utils:IsCloseToFrontOfVehicle(target.entity)) then
        Progress:Progress({
          name = "vehicle_adding_plate",
          duration = 5000,
          label = "Installing Plate",
          useWhileDead = false,
          canCancel = true,
          ignoreModifier = true,
          controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = false,
          },
          animation = {
            animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
            anim = "machinic_loop_mechandplayer",
            --flags = 15,
          },
        }, function(cancelled)
          if not cancelled and Vehicles:HasAccess(target.entity, true, true) and (Vehicles.Utils:IsCloseToRearOfVehicle(target.entity) or Vehicles.Utils:IsCloseToFrontOfVehicle(target.entity)) then
            cb(VehToNet(target.entity))
          else
            cb(false)
          end
        end)
      else
        cb(false)
      end
    else
      cb(false)
    end
  end)
end)

AddEventHandler('Vehicles:Client:RemoveFakePlate', function(entityData)
  if entityData and DoesEntityExist(entityData.entity) and CanModelHaveFakePlate(GetEntityModel(entityData.entity)) then
    Progress:Progress({
      name = "vehicle_removing_plate",
      duration = 5000,
      label = "Removing Plate",
      useWhileDead = false,
      canCancel = true,
      ignoreModifier = true,
      controlDisables = {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = false,
      },
      animation = {
        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
        anim = "machinic_loop_mechandplayer",
        --flags = 15,
      },
    }, function(cancelled)
      if not cancelled and Vehicles:HasAccess(entityData.entity) and (Vehicles.Utils:IsCloseToRearOfVehicle(entityData.entity) or Vehicles.Utils:IsCloseToFrontOfVehicle(entityData.entity)) then
        exports["hrrp-base"]:CallbacksServer('Vehicles:RemoveFakePlate', VehToNet(entityData.entity), function(success)
          if success then
            exports['hrrp-hud']:NotificationSuccess('Removed Plate Successfully')
          else
            exports['hrrp-hud']:NotificationError('Could not Remove Plate')
          end
        end)
      else
        exports['hrrp-hud']:NotificationError('Could not Remove Plate')
      end
    end)
  end
end)

AddEventHandler('Vehicles:Client:RemoveHarness', function(entityData)
  if entityData and DoesEntityExist(entityData.entity) then
    Progress:Progress({
      name = "vehicle_removing_harness",
      duration = 5000,
      label = "Removing Harness",
      useWhileDead = false,
      canCancel = true,
      ignoreModifier = true,
      controlDisables = {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = false,
      },
      animation = {
        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
        anim = "machinic_loop_mechandplayer",
        --flags = 15,
      },
    }, function(cancelled)
      if not cancelled and Vehicles:HasAccess(entityData.entity, true) then
        exports["hrrp-base"]:CallbacksServer('Vehicles:RemoveHarness', VehToNet(entityData.entity), function(success)
          if success then
            exports['hrrp-hud']:NotificationSuccess('Removed Harness Successfully')
          else
            exports['hrrp-hud']:NotificationError('Could not Remove Harness')
          end
        end)
      else
        exports['hrrp-hud']:NotificationError('Could not Remove Harness')
      end
    end)
  end
end)
