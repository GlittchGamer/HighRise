ORIGINAL_HANDLING = {}

local valTypes = {
  Float = true,
  Int = true,
  Vector = true,
}

local handlingFunctions = {
  Get = {
    Float = GetVehicleHandlingFloat,
    Int = GetVehicleHandlingInt,
    Vector = GetVehicleHandlingVector,
  },
  Set = {
    Float = SetVehicleHandlingFloat,
    Int = SetVehicleHandlingInt,
    Vector = SetVehicleHandlingVector,
  }
}

function SetVehicleHandlingOverride(veh, fieldName, valType, val)
  if DoesEntityExist(veh) and valType and valTypes[valType] and val ~= nil then
    if not ORIGINAL_HANDLING[veh] then
      ORIGINAL_HANDLING[veh] = {}
    end

    if not ORIGINAL_HANDLING[veh][fieldName] then
      ORIGINAL_HANDLING[veh][fieldName] = {
        type = valType,
        value = handlingFunctions.Get[valType](veh, 'CHandlingData', fieldName),
      }
    end

    handlingFunctions.Set[valType](veh, 'CHandlingData', fieldName, val)

    return true
  end
  return false
end

function SetVehicleHandlingOverrideMultiplier(veh, fieldName, valType, val)
  if DoesEntityExist(veh) and valType and valTypes[valType] and val ~= nil then
    if not ORIGINAL_HANDLING[veh] then
      ORIGINAL_HANDLING[veh] = {}
    end

    if not ORIGINAL_HANDLING[veh][fieldName] then
      ORIGINAL_HANDLING[veh][fieldName] = {
        type = valType,
        value = handlingFunctions.Get[valType](veh, 'CHandlingData', fieldName),
      }
    end

    handlingFunctions.Set[valType](veh, 'CHandlingData', fieldName, ORIGINAL_HANDLING[veh][fieldName].value * val)

    return true
  end
  return false
end

function ResetVehicleHandlingOverride(veh, fieldName, skipChecks)
  if (DoesEntityExist(veh) and ORIGINAL_HANDLING[veh] and fieldName) or skipChecks then
    local originalValue = ORIGINAL_HANDLING[veh][fieldName]
    if originalValue and originalValue.type and originalValue.value then
      handlingFunctions.Set[originalValue.type](veh, 'CHandlingData', fieldName, originalValue.value)
      return true
    end
  end
  return false
end

function ResetVehicleHandlingOverrides(veh)
  if DoesEntityExist(veh) and ORIGINAL_HANDLING[veh] then
    for k, v in pairs(ORIGINAL_HANDLING[veh]) do
      ResetVehicleHandlingOverride(veh, k, true)
    end
    return true
  end
  return false
end

function getPerformanceRating(pVehicle)
  -- local isMotorCycle = IsThisModelABike(GetEntityModel(pVehicle))
  local fInitialDriveMaxFlatVel = GetVehicleHandlingFloat(pVehicle, 'CHandlingData', "fInitialDriveMaxFlatVel")
  local fInitialDriveForce = GetVehicleHandlingFloat(pVehicle, 'CHandlingData', "fInitialDriveForce")
  -- local fDriveBiasFront = GetVehicleHandlingFloat(pVehicle, 'CHandlingData', "fDriveBiasFront")
  local fInitialDragCoeff = GetVehicleHandlingFloat(pVehicle, 'CHandlingData', "fInitialDragCoeff")
  local fTractionCurveMax = GetVehicleHandlingFloat(pVehicle, 'CHandlingData', "fTractionCurveMax")
  local fTractionCurveMin = GetVehicleHandlingFloat(pVehicle, 'CHandlingData', "fTractionCurveMin")
  local fSuspensionReboundDamp = GetVehicleHandlingFloat(pVehicle, 'CHandlingData', "fSuspensionReboundDamp")
  local fBrakeForce = GetVehicleHandlingFloat(pVehicle, 'CHandlingData', "fBrakeForce")
  local force = fInitialDriveForce
  if fInitialDriveForce > 0 and fInitialDriveForce < 1 then
    force = force * 1.1
  end
  local handling = (fTractionCurveMax + fSuspensionReboundDamp) * fTractionCurveMin
  local braking = ((fTractionCurveMin / fInitialDragCoeff) * fBrakeForce) * 7
  local accel = (fInitialDriveMaxFlatVel * force) / 10
  local speed = ((fInitialDriveMaxFlatVel / fInitialDragCoeff) * (fTractionCurveMax + fTractionCurveMin)) / 40
  local perfRating = ((accel * 5) + speed + handling + braking) * 15


  print('Handling Total: ' .. handling)
  print('Braking Total: ' .. braking)
  print('Accel Total: ' .. accel)
  print('Speed Total: ' .. speed)
  print('Perf Total: ' .. perfRating)

  return perfRating
end

AddEventHandler('Vehicles:Client:ExitVehicle', function(veh)
  if ResetVehicleHandlingOverrides(veh) then
    exports['hrrp-base']:LoggerInfo('Vehicles', 'Resetting Applied Handling Overrides For Vehicle')
  end
end)

AddEventHandler('Vehicles:Client:PerfRating', function(pEntityData)
  if pEntityData and pEntityData.entity and DoesEntityExist(pEntityData.entity) then
    local perfRating = getPerformanceRating(pEntityData.entity)
    if perfRating then
      print("Our perf rating: " .. perfRating)
      exports['hrrp-hud']:NotificationInfo(string:format("Vehicle Performance Rating: %d", perfRating), 2500)
    end
  end
end)
