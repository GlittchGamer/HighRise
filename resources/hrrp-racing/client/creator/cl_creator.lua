function DisplayTempCheckpoints()
  local pPed = PlayerPedId()
  local fX, fY, fZ = table.unpack(GetEntityForwardVector(pPed))
  facingVector = {
    x = fX,
    y = fY,
    z = fZ,
  }
  local pX, pY, pZ = table.unpack(GetEntityCoords(pPed))

  local fuckme = rotateVector(facingVector, 90)
  local left = enlargeVector(
    { x = pX, y = pY, z = pZ },
    { x = pX + fuckme.x, y = pY + fuckme.y, z = pZ + fuckme.z },
    Creator.CURR_SIZE / 2
  )
  local fuckme2 = rotateVector(facingVector, -90)
  local right = enlargeVector(
    { x = pX, y = pY, z = pZ },
    { x = pX + fuckme2.x, y = pY + fuckme2.y, z = pZ + fuckme2.z },
    Creator.CURR_SIZE / 2
  )

  if not Creator.tempCheckpointObj.l then
    Creator.tempCheckpointObj.l = CreateObject(
      GetHashKey("prop_offroad_tyres02"),
      left.x,
      left.y,
      left.z,
      false,
      true,
      false
    )

    Creator.tempCheckpointObj.r = CreateObject(
      GetHashKey("prop_offroad_tyres02"),
      right.x,
      right.y,
      right.z,
      false,
      true,
      false
    )
  end

  SetEntityCoords(Creator.tempCheckpointObj.l, left.x, left.y, left.z)
  SetEntityCoords(Creator.tempCheckpointObj.r, right.x, right.y, right.z)
  for k, v in pairs(Creator.tempCheckpointObj) do
    PlaceObjectOnGroundProperly(v)
    SetEntityCollision(v, false, true)
    FreezeEntityPosition(v, true)
  end
end

function CreateCheckpoint()
  local pPed = PlayerPedId()
  local fX, fY, fZ = table.unpack(GetEntityForwardVector(pPed))
  facingVector = {
    x = fX,
    y = fY,
    z = fZ,
  }
  local pX, pY, pZ = table.unpack(GetEntityCoords(pPed))



  local lastCheckpoint = Creator.PENDING_TRACK.Checkpoints[#Creator.PENDING_TRACK.Checkpoints]
  local dist = -1

  if lastCheckpoint ~= nil then
    dist = #(vector3(pX, pY, pZ) - vector3(lastCheckpoint.coords.x, lastCheckpoint.coords.y, lastCheckpoint.coords.z))
  end


  if lastCheckpoint == nil or dist > 5 then
    local fuckme = rotateVector(facingVector, 90)
    local left = enlargeVector(
      { x = pX, y = pY, z = pZ },
      { x = pX + fuckme.x, y = pY + fuckme.y, z = pZ + fuckme.z },
      Creator.CURR_SIZE / 2
    )
    local fuckme2 = rotateVector(facingVector, -90)
    local right = enlargeVector(
      { x = pX, y = pY, z = pZ },
      { x = pX + fuckme2.x, y = pY + fuckme2.y, z = pZ + fuckme2.z },
      Creator.CURR_SIZE / 2
    )
    table.insert(Creator.PENDING_TRACK.Checkpoints, {
      coords = {
        x = quickMaths(pX),
        y = quickMaths(pY),
        z = quickMaths(pZ),
      },
      facingVector = facingVector,
      left = left,
      leftrv = rotateVector(facingVector, 90),
      right = right,
      rightrv = rotateVector(facingVector, -90),
      isStart = #Creator.PENDING_TRACK.Checkpoints == 0,
      size = Creator.CURR_SIZE / 2,
    })

    AddRaceBlip(Creator.PENDING_TRACK.Checkpoints[#Creator.PENDING_TRACK.Checkpoints])
  else
    exports['hrrp-hud']:NotificationError("Point Too Close To Last Point")
  end
end

function RemoveCheckpoint()
  if #Creator.PENDING_TRACK.Checkpoints == 0 then
    print("No checkpoints?")
    return
  end

  local lastCheckpointIndex = #Creator.PENDING_TRACK.Checkpoints
  local lastCheckpoint = Creator.PENDING_TRACK.Checkpoints[lastCheckpointIndex]
  if lastCheckpoint == nil then
    print("Apparently no last checkpoint")
    return
  end

  table.remove(Creator.PENDING_TRACK.Checkpoints, lastCheckpointIndex)
  RemoveRaceBlip(lastCheckpointIndex)
end

function AdjustCheckpointSize(increase)
  if increase then
    if Creator.CURR_SIZE < Creator.MAX_SIZE then
      Creator.CURR_SIZE = Creator.CURR_SIZE + 0.5
    end
  else
    if Creator.CURR_SIZE > Creator.MIN_SIZE then
      Creator.CURR_SIZE = Creator.CURR_SIZE - 0.5
    end
  end
end

function RunCreatorThread()
  CreateThread(function()
    while Creator.creating do
      Wait(1)
      -- Your code for creating checkpoints goes here
      DisplayTempCheckpoints()
    end
    Cleanup(true)
  end)
end
