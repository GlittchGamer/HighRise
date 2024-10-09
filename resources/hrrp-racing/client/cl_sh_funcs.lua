-- ! Any shared client function will go here

--#region Maths
function quickMaths(num)
  return tonumber(string.format("%.2f", num))
end

function rotateVector(vector, degrees)
  local rads = math.rad(degrees)
  local x = math.cos(rads) * vector.x - math.sin(rads) * vector.y
  local y = math.sin(rads) * vector.x + math.cos(rads) * vector.y
  return { x = x, y = y, z = vector.z }
end

function enlargeVector(vectorOrigin, vectorAngle, distance)
  local distanceVector = vector3(
    (vectorAngle.x - vectorOrigin.x) * distance,
    (vectorAngle.y - vectorOrigin.y) * distance,
    (vectorAngle.z - vectorOrigin.z) * distance
  )
  return {
    x = quickMaths(vectorOrigin.x + distanceVector.x),
    y = quickMaths(vectorOrigin.y + distanceVector.y),
    z = quickMaths(vectorOrigin.z),
  }
end

--#endregion

--#region Blips & Objects
raceBlips = {}
raceObjs = {}
function AddRaceBlip(data)
  local newBlip = AddBlipForCoord(data.coords.x + 0.0, data.coords.y + 0.0, data.coords.z + 0.0)
  SetBlipAsFriendly(newBlip, true)
  local sprite = 1
  if data.isStart then
    sprite = 38
  end
  SetBlipScale(newBlip, 0.75)
  SetBlipSprite(newBlip, sprite)

  if not data.isStart then
    ShowNumberOnBlip(newBlip, #raceBlips)
  end

  BeginTextCommandSetBlipName("STRING")
  local str = string.format("Checkpoint %s", #raceBlips)
  if data.isStart then
    str = "Start Line"
  end
  SetBlipAsShortRange(newBlip, true)
  AddTextComponentString(str)
  EndTextCommandSetBlipName(newBlip)

  table.insert(raceBlips, newBlip)

  local objData = {}
  if data.isStart then
    local l = CreateObject(
      `prop_beachflag_le`,
      data.left.x,
      data.left.y,
      data.left.z,
      false,
      true,
      false
    )
    local r = CreateObject(
      `prop_beachflag_le`,
      data.right.x,
      data.right.y,
      data.right.z,
      false,
      true,
      false
    )
    PlaceObjectOnGroundProperly(l)
    PlaceObjectOnGroundProperly(r)
    table.insert(objData, l)
    table.insert(objData, r)
  else
    local l = CreateObject(
      `prop_offroad_tyres02`,
      data.left.x,
      data.left.y,
      data.left.z,
      false,
      true,
      false
    )
    local r = CreateObject(
      `prop_offroad_tyres02`,
      data.right.x,
      data.right.y,
      data.right.z,
      false,
      true,
      false
    )
    PlaceObjectOnGroundProperly(l)
    PlaceObjectOnGroundProperly(r)
    table.insert(objData, l)
    table.insert(objData, r)
  end

  table.insert(raceObjs, objData)
end

function RemoveRaceBlip(id)
  if raceBlips[id] then
    RemoveBlip(raceBlips[id])
    raceBlips[id] = nil
  end

  if raceObjs[id] then
    for raceObjsIndex, obj in pairs(raceObjs[id]) do
      DeleteObject(obj)
    end
    table.remove(raceObjs, id)
  end
end

--#endregion

--#region Flares
function showNonLoopParticle(dict, particleName, coords, scale, time)
  while not HasNamedPtfxAssetLoaded(dict) do
    RequestNamedPtfxAsset(dict)
    Wait(0)
  end

  UseParticleFxAssetNextCall(dict)

  local particleHandle = StartParticleFxLoopedAtCoord(
    particleName,
    coords.x,
    coords.y,
    coords.z + 1.0,
    0.0,
    0.0,
    0.0,
    scale,
    false,
    false,
    false
  )
  SetParticleFxLoopedColour(particleHandle, 0.0, 0.0, 1.0)
  return particleHandle
end

leftFlare = nil
rightFlare = nil

leftFlareOld = nil
rightFlareOld = nil

function handleFlare(checkpoint)
  if leftFlareOld then
    StopParticleFxLooped(leftFlareOld, false)
  end
  if rightFlareOld then
    StopParticleFxLooped(rightFlareOld, false)
  end

  leftFlareOld = leftFlare
  rightFlareOld = rightFlare

  if checkpoint then
    local Size = 1.0
    leftFlare = showNonLoopParticle("core", "exp_grd_flare", checkpoint.left, Size)
    rightFlare = showNonLoopParticle("core", "exp_grd_flare", checkpoint.right, Size)
  end
end

--#endregion

--#region Cleanup
function Cleanup(pCreator)
  DeleteWaypoint()
  ClearGpsMultiRoute()
  for k, v in ipairs(raceBlips) do
    RemoveBlip(v)
  end
  raceBlips = {}
  for k, v in pairs(raceObjs) do
    for k2, v2 in ipairs(v) do
      DeleteObject(v2)
    end
  end

  if pCreator then
    for k, v in pairs(Creator.tempCheckpointObj) do
      DeleteObject(v)
    end
  end

  if leftFlare then
    StopParticleFxLooped(leftFlare, false)
  end
  if leftFlareOld then
    StopParticleFxLooped(leftFlareOld, false)
  end
  if rightFlare then
    StopParticleFxLooped(rightFlare, false)
  end
  if rightFlareOld then
    StopParticleFxLooped(rightFlareOld, false)
  end
end

--#endregion

--#region Race
function SetupTrack()
  for k, v in pairs(Racing.ActiveRace.trackData.Checkpoints) do
    AddRaceBlip(v)
  end
end

--#endregion
