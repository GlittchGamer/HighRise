--[[
	This code is probably a steaming pile of shit, I beg someone
	that still has a few functioning brain cells to rewrite this
	so it isn't as much of a steaming pile of shit.

	Send Help.
]]
local _creator = false
local _size = 20.0
local _pendingTrack = {}

local _activeRace = nil
local _activeTrack = {}
local _inRace = false

local _doingPDRaces = false

local raceBlips = {}
local raceObjs = {}
local checkpointMarkers = {}

local MAX_SIZE = 75.0
local MIN_SIZE = 2.0

local tempCheckpointObj = {
  l = false,
  r = false,
}


local function showNonLoopParticle(dict, particleName, coords, scale, time)
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


local leftFlare = nil
local rightFlare = nil

local leftFlareOld = nil
local rightFlareOld = nil

local function handleFlare(checkpoint)
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

RegisterNetEvent("Phone:Client:SpawnBlueLine", function(data)
  SendNUIMessage({
    type = "PD_EVENT_SPAWN",
    data = data,
  })
end)

RegisterNetEvent("Characters:Client:Logout", function()
  -- TODO: CleanupPD if logged out while joined in race
end)

RegisterNetEvent("Phone:Client:Blueline:CreateRace", function(race)
  print("Adding pending race")
  SendNUIMessage({
    type = "PD_ADD_PENDING_RACE",
    data = race,
  })
end)

RegisterNetEvent("Phone:Client:Blueline:CancelRace", function(id)
  SendNUIMessage({
    type = "PD_CANCEL_RACE",
    data = {
      race = id,
      myRace = id == _activeRace._id,
    },
  })
  if id == _activeRace._id then
    CleanupPD()
  end
end)

RegisterNetEvent("Phone:Client:Blueline:FinishRace", function(id, race)
  SendNUIMessage({
    type = "PD_FINISH_RACE",
    data = {
      index = id,
      race = race,
    },
  })
end)

RegisterNetEvent("Phone:Client:Blueline:StartRace", function(id)
  SendNUIMessage({
    type = "PD_STATE_UPDATE",
    data = {
      race = id,
      state = 1,
    },
  })

  -- if _activeRace ~= nil and id == _activeRace._id then
  --   CleanupPD()
  --   StartRacePD()
  -- end
end)

RegisterNetEvent("Phone:Client:Blueline:JoinRace", function(id, racer, newRaceData)
  if _activeRace == nil or id ~= _activeRace._id then return end

  SendNUIMessage({
    type = "PD_JOIN_RACE",
    data = {
      race = id,
      racer = racer,
    },
  })

  _activeRace = newRaceData
end)

RegisterNetEvent("Phone:Client:Blueline:LeaveRace", function(id, racer)
  SendNUIMessage({
    type = "PD_LEAVE_RACE",
    data = {
      race = id,
      racer = racer,
    },
  })
end)

RegisterNetEvent("Phone:Blueline:NotifyDNFStart", function(id, time)
  SendNUIMessage({
    type = "DNF_START",
    data = {
      time = time,
    },
  })
end)

RegisterNetEvent("Phone:Blueline:NotifyDNF", function(id)
  _activeRace.dnf = true
  CleanupPD()
  UISounds.Play:FrontEnd(-1, "CHECKPOINT_MISSED", "HUD_MINI_GAME_SOUNDSET")
  SendNUIMessage({
    type = "RACE_DNF",
  })
end)

RegisterNUICallback("CreateRacePD", function(data, cb)
  exports["hrrp-base"]:CallbacksServer("Racing:Server:CreateRace", data, function(res)
    if res == nil or res.failed then
      _activeRace = nil
      cb(res or false)
    else
      _activeRace = res
      -- AddRaceBlipPD(_activeRace.trackData.Checkpoints[1])
      -- SetNewWaypoint(
      --   _activeRace.trackData.Checkpoints[1].coords.x + 0.0,
      --   _activeRace.trackData.Checkpoints[1].coords.y + 0.0
      -- )
      cb(true)
    end
  end)
end)

RegisterNUICallback("CancelRacePD", function(data, cb)
  exports["hrrp-base"]:CallbacksServer("Phone:Blueline:CancelRace", data, function(res)
    cb(res)
  end)
end)

RegisterNUICallback("PracticeTrackPD", function(data, cb)
  exports["hrrp-base"]:CallbacksServer("Phone:Blueline:GetTrack", data, function(res)
    cb(res ~= nil)
    if res ~= nil then
      SetupTrackPD(res)
      _activeRace = res
    end
  end)
end)

RegisterNUICallback("JoinRacePD", function(data, cb)
  exports["hrrp-base"]:CallbacksServer("Phone:Blueline:JoinRace", data, function(res)
    if res then
      _activeRace = res
      AddRaceBlipPD(_activeRace.trackData.Checkpoints[1])
      SetNewWaypoint(
        _activeRace.trackData.Checkpoints[1].coords.x + 0.0,
        _activeRace.trackData.Checkpoints[1].coords.y + 0.0
      )
    end
    cb(res ~= nil)
  end)
end)

RegisterNUICallback("LeaveRacePD", function(data, cb)
  exports["hrrp-base"]:CallbacksServer("Phone:Blueline:LeaveRace", data, function(res)
    if _activeRace ~= nil then
      _activeRace.dnf = true
      CleanupPD()
      UISounds.Play:FrontEnd(-1, "CHECKPOINT_MISSED", "HUD_MINI_GAME_SOUNDSET")
      SendNUIMessage({
        type = "RACE_DNF",
      })
    end
    cb(res)
  end)
end)

RegisterNUICallback("CreateTrackPD", function(data, cb)
  if exports['hrrp-jobs']:JobsPermissionsHasPermissionInJob("police", "PD_MANAGE_TRIALS") then
    local isCreating = exports['hrrp-racing']:CreatorStart('blueline')
    cb(true)
  else
    cb(false)
  end
end)

RegisterNUICallback("FinishCreatorPD", function(data, cb)
  if exports['hrrp-jobs']:JobsPermissionsHasPermissionInJob("police", "PD_MANAGE_TRIALS") then
    local createTrack = exports['hrrp-racing']:CreatorStop(true)
    if #createTrack.cachedTrack.Checkpoints <= 2 then
      exports['hrrp-hud']:NotificationError("Not Enough Checkpoints")
      return cb(false)
    end


    createTrack.cachedTrack.Name = data.name
    createTrack.cachedTrack.Type = data.type
    createTrack.cachedTrack.Distance = 0

    for i = 1, #createTrack.cachedTrack.Checkpoints do
      if i == #createTrack.cachedTrack.Checkpoints and data.type ~= "p2p" then
        createTrack.cachedTrack.Distance = createTrack.cachedTrack.Distance
            + #(vector3(
              createTrack.cachedTrack.Checkpoints[i].coords.x,
              createTrack.cachedTrack.Checkpoints[i].coords.y,
              createTrack.cachedTrack.Checkpoints[i].coords.z
            ) - vector3(
              createTrack.cachedTrack.Checkpoints[1].coords.x,
              createTrack.cachedTrack.Checkpoints[1].coords.y,
              createTrack.cachedTrack.Checkpoints[1].coords.z
            ))
      elseif i < #createTrack.cachedTrack.Checkpoints then
        createTrack.cachedTrack.Distance = createTrack.cachedTrack.Distance
            + #(vector3(
              createTrack.cachedTrack.Checkpoints[i].coords.x,
              createTrack.cachedTrack.Checkpoints[i].coords.y,
              createTrack.cachedTrack.Checkpoints[i].coords.z
            ) - vector3(
              createTrack.cachedTrack.Checkpoints[i + 1].coords.x,
              createTrack.cachedTrack.Checkpoints[i + 1].coords.y,
              createTrack.cachedTrack.Checkpoints[i + 1].coords.z
            ))
      end
    end

    createTrack.cachedTrack.Distance = quickMaths((createTrack.cachedTrack.Distance / 1609.34)) .. " Miles"
    exports["hrrp-base"]:CallbacksServer("Racing:Server:SaveRace", { track = createTrack.cachedTrack, raceType = data.type, raceVariant = 'blueline' },
      function(res2)
        cb(res2)
      end)
  else
    cb(false)
  end
end)

RegisterNUICallback("DeleteTrackPD", function(data, cb)
  if exports['hrrp-jobs']:JobsPermissionsHasPermissionInJob("police", "PD_MANAGE_TRIALS") then
    exports["hrrp-base"]:CallbacksServer("Phone:Blueline:DeleteTrack", data, function(res2)
      cb(res2)
    end)
  else
    cb(false)
  end
end)

RegisterNUICallback("ResetTrackHistoryPD", function(data, cb)
  if exports['hrrp-jobs']:JobsPermissionsHasPermissionInJob("police", "PD_MANAGE_TRIALS") then
    exports["hrrp-base"]:CallbacksServer("Phone:Blueline:ResetTrackHistory", data, function(res2)
      cb(res2)
    end)
  else
    cb(false)
  end
end)

RegisterNUICallback("StopCreatorPD", function(data, cb)
  cb("OK")
  exports['hrrp-racing']:CreatorStop()
end)

RegisterNUICallback("StartRacePD", function(data, cb)
  exports["hrrp-base"]:CallbacksServer("Racing:Server:StartRace", data, cb)
end)

RegisterNUICallback("EndRacePD", function(data, cb)
  exports["hrrp-base"]:CallbacksServer("Phone:Blueline:EndRace", data, cb)
end)

function IsInRacePD()
  return _doingPDRaces
end

function LapDetailsPD(data)
  exports["hrrp-base"]:CallbacksServer("Phone:Blueline:SaveLaptimes", data)
  if not _activeRace.dnf then
    local veh = GetVehiclePedIsIn(PlayerPedId())

    local vehName = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
    local vehEnt = Entity(veh)
    if vehEnt and vehEnt.state and vehEnt.state.Make and vehEnt.state.Model then
      vehName = vehEnt.state.Make .. " " .. vehEnt.state.Model
    end

    TriggerServerEvent(
      "Phone:Blueline:FinishRace",
      NetworkGetNetworkIdFromEntity(veh),
      _activeRace._id,
      data,
      GetVehicleNumberPlateText(veh),
      vehName
    )
  else
    SendNUIMessage({
      type = "PD_I_RACE",
      data = {
        state = false,
      },
    })
    _inRace = false
  end
  _activeRace = nil
  _doingPDRaces = false
end

function SetupTrackPD(skipBlip)
  CleanupPD()
  for k, v in ipairs(_activeRace.trackData.Checkpoints) do
    if not skipBlip then
      AddRaceBlipPD(v)
    end
  end
end

-- This is a fucking mess that somehow functions? Someone that is sane pls rewrite
local currentCheckpoint = 1
local safeCheckpoint = -1 --!This is the main checkpoint, nothing else touches or manipulates this other than setting the actual checkpoint
local currentLap = 1
local myPed = PlayerPedId()
local completedCheckpoints = {}
function StartRacePD()
  myPed = PlayerPedId()

  _inRace = true
  _doingPDRaces = true
  SetupTrackPD()

  local countdownMax = tonumber(_activeRace.countdown) or 20
  local countdown = 0
  while countdown < countdownMax do
    countdown = countdown + 1
    Citizen.Wait(1000)
  end

  Citizen.CreateThread(function()
    exports['hrrp-hud']:NotificationInfo("Race Started")
    UISounds.Play:FrontEnd(-1, "GO", "HUD_MINI_GAME_SOUNDSET")
    SendNUIMessage({
      type = "RACE_START",
      data = {
        totalCheckpoints = #_activeRace.trackData.Checkpoints,
        totalLaps = _activeRace.laps,
        track = _activeRace.trackData,
      },
    })

    --Start position management
    positionThread()

    while _activeRace ~= nil and _loggedIn do
      local myPos = GetEntityCoords(myPed)
      local cp = _activeRace.trackData.Checkpoints[currentCheckpoint]
      if cp == nil then
        cp = _activeRace.trackData.Checkpoints[1]
      end

      local dist = #(vector3(cp.coords.x, cp.coords.y, cp.coords.z) - myPos)

      if dist <= cp.size or safeCheckpoint == -1 then
        local blip = raceBlips[currentCheckpoint]
        if currentCheckpoint == 1 and #completedCheckpoints == #_activeRace.trackData.Checkpoints and _activeRace.trackData.Type ~= "p2p" then
          currentLap = currentLap + 1
          completedCheckpoints = {}
          if currentLap <= tonumber(_activeRace.laps) then
            exports['hrrp-hud']:NotificationInfo(string.format("Lap %s", currentLap))
            UISounds.Play:FrontEnd(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET")
            SendNUIMessage({
              type = "RACE_LAP",
            })

            TriggerServerEvent('Phone:SV:Racing:LapCompleted', _activeRace._id, currentCheckpoint)
          end
        end

        if safeCheckpoint ~= -1 then
          SetBlipColour(blip, 0)
          SetBlipScale(blip, 0.75)
          table.insert(completedCheckpoints, currentCheckpoint)
          UISounds.Play:FrontEnd(-1, "CHECKPOINT_NORMAL", "HUD_MINI_GAME_SOUNDSET")
          if currentCheckpoint < #_activeRace.trackData.Checkpoints then
            currentCheckpoint = currentCheckpoint + 1
            SendNUIMessage({
              type = "RACE_CP",
              data = {
                cp = #completedCheckpoints,
              },
            })
            TriggerServerEvent('Phone:SV:Racing:PassedCheckpoin', _activeRace._id, currentCheckpoint)
          elseif _activeRace.trackData.Type ~= "p2p" then
            currentCheckpoint = 1
            SendNUIMessage({
              type = "RACE_CP",
              data = {
                cp = #_activeRace.trackData.Checkpoints,
              },
            })
          end
        end

        if _activeRace.trackData.Type == "p2p" and #completedCheckpoints == #_activeRace.trackData.Checkpoints or currentLap > tonumber(_activeRace.laps) then
          exports['hrrp-hud']:NotificationInfo("Race Finished")
          CleanupPD()
          UISounds.Play:FrontEnd(-1, "FIRST_PLACE", "HUD_MINI_GAME_SOUNDSET")
          SendNUIMessage({
            type = "RACE_END",
          })
          SendNUIMessage({
            type = "PD_I_RACE",
            data = {
              state = false,
            },
          })
          _inRace = false
          return
        end

        cp = _activeRace.trackData.Checkpoints[currentCheckpoint]
        blip = raceBlips[currentCheckpoint]
        SetBlipColour(blip, 6)
        SetBlipScale(blip, 1.3)
        SetBlipColour(raceBlips[currentCheckpoint + 1], 6)
        SetBlipScale(raceBlips[currentCheckpoint + 1], 1.15)

        -- Like what the fuck is this code?
        local ftr = nil
        if currentCheckpoint + 1 > #_activeRace.trackData.Checkpoints then
          ftr = _activeRace.trackData.Checkpoints[1]
        else
          ftr = _activeRace.trackData.Checkpoints[currentCheckpoint + 1]
        end

        if currentLap > tonumber(_activeRace.laps) or (_activeRace.trackData.Type == "p2p" and currentCheckpoint == #_activeRace.trackData.Checkpoints)
        then
          ftr = cp
        end

        if currentCheckpoint + 1 > #_activeRace.trackData.Checkpoints then
          handleFlare(_activeRace.trackData.Checkpoints[1])
        else
          handleFlare(_activeRace.trackData.Checkpoints[currentCheckpoint + 1])
        end

        local v = GetVehiclePedIsIn(LocalPlayer.state.ped)
        if v ~= 0 and GetPedInVehicleSeat(v) then
          SetNewWaypoint(ftr.coords.x, ftr.coords.y)
        end
        safeCheckpoint = currentCheckpoint
      end

      if not IsWaypointActive() then
        local ftr = nil
        if currentCheckpoint + 1 > #_activeRace.trackData.Checkpoints then
          ftr = _activeRace.trackData.Checkpoints[1]
        else
          ftr = _activeRace.trackData.Checkpoints[currentCheckpoint + 1]
        end
        local v = GetVehiclePedIsIn(LocalPlayer.state.ped)
        if v ~= 0 and GetPedInVehicleSeat(v) then
          SetNewWaypoint(ftr.coords.x, ftr.coords.y)
        end
      end

      markWithDrawTextWaypoint()

      Citizen.Wait(1)
    end
  end)
end

function CleanupPD()
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

  for k, v in pairs(tempCheckpointObj) do
    if v then
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

function AddRaceBlipPD(data)
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
      GetHashKey("prop_beachflag_le"),
      data.left.x,
      data.left.y,
      data.left.z,
      false,
      true,
      false
    )
    local r = CreateObject(
      GetHashKey("prop_beachflag_le"),
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
      GetHashKey("prop_offroad_tyres02"),
      data.left.x,
      data.left.y,
      data.left.z,
      false,
      true,
      false
    )
    local r = CreateObject(
      GetHashKey("prop_offroad_tyres02"),
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

function CreateCheckpointPD()
  local pPed = PlayerPedId()
  local fX, fY, fZ = table.unpack(GetEntityForwardVector(pPed))
  facingVector = {
    x = fX,
    y = fY,
    z = fZ,
  }
  local pX, pY, pZ = table.unpack(GetEntityCoords(pPed))

  local lcp = _pendingTrack.Checkpoints[#_pendingTrack.Checkpoints]
  local dist = -1

  if lcp ~= nil then
    dist = #(vector3(pX, pY, pZ) - vector3(lcp.coords.x, lcp.coords.y, lcp.coords.z))
  end

  if lcp == nil or dist > 5 then
    local fuckme = rotateVector(facingVector, 90)
    local left = enlargeVector(
      { x = pX, y = pY, z = pZ },
      { x = pX + fuckme.x, y = pY + fuckme.y, z = pZ + fuckme.z },
      _size / 2
    )
    local fuckme2 = rotateVector(facingVector, -90)
    local right = enlargeVector(
      { x = pX, y = pY, z = pZ },
      { x = pX + fuckme2.x, y = pY + fuckme2.y, z = pZ + fuckme2.z },
      _size / 2
    )
    table.insert(_pendingTrack.Checkpoints, {
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
      isStart = #_pendingTrack.Checkpoints == 0,
      size = _size / 2,
    })

    AddRaceBlipPD(_pendingTrack.Checkpoints[#_pendingTrack.Checkpoints])
  else
    exports['hrrp-hud']:NotificationError("Point Too Close To Last Point")
  end
end

function RemoveCheckpointPD()
  if #_pendingTrack.Checkpoints > 0 then
    local cp = _pendingTrack.Checkpoints[#_pendingTrack.Checkpoints]

    RemoveBlip(raceBlips[#_pendingTrack.Checkpoints])
    table.remove(raceBlips, #_pendingTrack.Checkpoints)

    for k, v in ipairs(raceObjs[#_pendingTrack.Checkpoints]) do
      DeleteObject(v)
      table.remove(raceObjs, #_pendingTrack.Checkpoints)
    end

    table.remove(_pendingTrack.Checkpoints, #_pendingTrack.Checkpoints)
  end
end

function DisplayTempCheckpointPD()
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
    _size / 2
  )
  local fuckme2 = rotateVector(facingVector, -90)
  local right = enlargeVector(
    { x = pX, y = pY, z = pZ },
    { x = pX + fuckme2.x, y = pY + fuckme2.y, z = pZ + fuckme2.z },
    _size / 2
  )

  if not tempCheckpointObj.l then
    tempCheckpointObj.l = CreateObject(
      GetHashKey("prop_offroad_tyres02"),
      left.x,
      left.y,
      left.z,
      false,
      true,
      false
    )

    tempCheckpointObj.r = CreateObject(
      GetHashKey("prop_offroad_tyres02"),
      right.x,
      right.y,
      right.z,
      false,
      true,
      false
    )
  end

  SetEntityCoords(tempCheckpointObj.l, left.x, left.y, left.z)
  SetEntityCoords(tempCheckpointObj.r, right.x, right.y, right.z)
  for k, v in pairs(tempCheckpointObj) do
    PlaceObjectOnGroundProperly(v)
    SetEntityCollision(v, false, true)
    FreezeEntityPosition(v, true)
  end
end

function CreatorThreadPD()
  _size = 20.0
  _pendingTrack = {
    Checkpoints = {},
    History = {},
  }

  tempCheckpointObj = {
    l = false,
    r = false,
  }

  Citizen.CreateThread(function()
    while _creator do
      DisplayTempCheckpointPD()

      if IsControlPressed(0, 10) then
        _size = _size + 0.5
        if _size > MAX_SIZE then
          _size = MAX_SIZE
        end
      end

      if IsControlPressed(0, 11) then
        _size = _size - 0.5
        if _size < MIN_SIZE then
          _size = MIN_SIZE
        end
      end

      if IsControlJustReleased(0, 38) then
        if IsControlPressed(0, 21) then
          RemoveCheckpointPD()
        else
          CreateCheckpointPD()
        end
        Wait(1000)
      end

      Citizen.Wait(1)
    end
    CleanupPD()
    SendNUIMessage({
      type = "PD_RACE_STATE_CHANGE",
      data = {
        state = null,
      },
    })
  end)
end

--#region Marker and Test Display

local Config = {}
Config.DrawTextSetup = {
  markerType = 1,                                         -- Vertical cylinder
  markerColor = { r = 255, g = 255, b = 255, a = 200 },   --Color on the pillar
  distanceColor = { r = 255, g = 255, b = 255, a = 255 }, -- Color on distance text
  primaryColor = { r = 227, g = 106, b = 0, a = 255 },    -- Color on indicator text
  minHeight = 0.5,                                        -- Height when closest
  maxHeight = 30.0,                                       -- Height furthest away
  topSize = 0.5,                                          -- Pillar size top
  baseSize = 0.1,                                         -- Pillar size bottom
}


local markerType = Config.DrawTextSetup.markerType or 1 -- Vertical cylinder
local minHeight = Config.DrawTextSetup.minHeight or 1.0
local maxHeight = Config.DrawTextSetup.maxHeight or 100.0
local baseSize = Config.DrawTextSetup.baseSize or 0.1                                          -- Thin pillar
local markerColor = Config.DrawTextSetup.markerColor or { r = 255, g = 255, b = 255, a = 200 } -- White, semi-transparent
local distanceColor = Config.DrawTextSetup.distanceColor or { r = 0, g = 255, b = 0, a = 255 } -- Cyan
local primaryColor = Config.DrawTextSetup.primaryColor or { r = 255, g = 0, b = 250, a = 255 } -- White

function draw3DText(coords, text, scale, color)
  local onScreen, x, y = World3dToScreen2d(coords.x, coords.y, coords.z)

  if onScreen then
    SetTextScale(scale, scale)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(color.r, color.g, color.b, color.a)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(x, y)
  end
end

local function getCheckpointCoord(index, totalCheckpoints)
  if _activeRace == nil then return nil end

  if currentLap > 0 and currentLap == _activeRace.laps then
    if index - 1 == totalCheckpoints then
      return vector3(
        _activeRace.trackData.Checkpoints[1].coords.x,
        _activeRace.trackData.Checkpoints[1].coords.y,
        _activeRace.trackData.Checkpoints[1].coords.z
      )
    elseif index > totalCheckpoints and currentLap + 1 > _activeRace.laps then
      return nil
    end
  end
  index = (index - 1) % totalCheckpoints + 1
  return vector3(
    _activeRace.trackData.Checkpoints[index].coords.x,
    _activeRace.trackData.Checkpoints[index].coords.y,
    _activeRace.trackData.Checkpoints[index].coords.z
  )
end

local function getFinishLabel(totalCheckpoints, index)
  if _activeRace.laps == 0 and totalCheckpoints == index then -- if sprint
    return 'Finish Line'
  elseif index - 1 == totalCheckpoints then                   -- if laps
    if _activeRace.laps == currentLap then
      return 'Finish'
    else
      return 'Next Lap'
    end
  end
  return nil
end

local function getUpcomingCheckpoints()
  local coord1, coord2, coord3
  local coord1Label, coord2Label, coord3Label

  if _activeRace == nil then return {} end

  local totalCheckpoints = #_activeRace.trackData.Checkpoints
  local currentIndex = safeCheckpoint
  local checkpoints = {}

  if currentLap < 2 and safeCheckpoint == 1 then
    checkpoints[1] = {
      coords = vector3(
        _activeRace.trackData.Checkpoints[1].coords.x,
        _activeRace.trackData.Checkpoints[1].coords.y,
        _activeRace.trackData.Checkpoints[1].coords.z
      ),
      label = 'Starting Line'
    }
  end

  coord1 = getCheckpointCoord(currentIndex, totalCheckpoints)
  coord2 = getCheckpointCoord(currentIndex + 1, totalCheckpoints)
  coord3 = getCheckpointCoord(currentIndex + 2, totalCheckpoints)

  coord1Label = getFinishLabel(totalCheckpoints, currentIndex) or 'Next Checkpoint'
  coord2Label = getFinishLabel(totalCheckpoints, currentIndex + 1) or '2nd Checkpoint'
  coord3Label = getFinishLabel(totalCheckpoints, currentIndex + 2) or '3rd Checkpoint'


  if coord1 then checkpoints[#checkpoints + 1] = { coords = coord1, label = coord1Label } end
  if coord2 then checkpoints[#checkpoints + 1] = { coords = coord2, label = coord2Label } end
  if coord3 then checkpoints[#checkpoints + 1] = { coords = coord3, label = coord3Label } end
  return checkpoints
end

function markWithDrawTextWaypoint()
  local playerPed = PlayerPedId()
  local playerCoords = GetEntityCoords(playerPed)

  local upcomingCheckpoints = getUpcomingCheckpoints()

  for _, checkpoint in ipairs(upcomingCheckpoints) do
    local checkpointCoords = vector3(checkpoint.coords.x, checkpoint.coords.y, checkpoint.coords.z)
    local distance = #(playerCoords - checkpointCoords)
    local height = math.min(maxHeight, math.max(minHeight, distance / 2.5))

    DrawMarker(
      markerType,
      checkpoint.coords.x, checkpoint.coords.y, checkpoint.coords.z,
      0.0, 0.0, 0.0,              -- Direction
      0.0, 0.0, 0.0,              -- Rotation
      baseSize, baseSize, height, -- Scale
      markerColor.r, markerColor.g, markerColor.b, markerColor.a,
      false --[[ Bob ]],
      true --[[ Face camera ]],
      2 --[[ integer ]],
      true --[[ boolean ]],
      nil, nil, nil
    )


    -- Calculate text positions
    local baseTextHeight = checkpoint.coords.z + height
    local labelHeight = baseTextHeight + 0.7 + height * 0.05
    local distanceHeight = baseTextHeight + 0.5

    local color = distanceColor
    if i == 1 or i == 2 and #_activeRace.trackData.Checkpoints > 3 then color = primaryColor end

    -- Draw checkpoint label
    local labelCoords = vector3(checkpoint.coords.x, checkpoint.coords.y, labelHeight)
    draw3DText(labelCoords, checkpoint.label, 0.25, color)

    -- Draw distance
    local distanceCoords = vector3(checkpoint.coords.x, checkpoint.coords.y, distanceHeight)
    draw3DText(distanceCoords, string.format("%.0fm", distance), 0.5, distanceColor)
  end
end

--#endregion

--#region Position Functions
local function copyWihoutId(original)
  local copy = {}
  for key, value in pairs(original) do
    local insertId = #copy + 1
    copy[insertId] = value
    copy[insertId].alias = key
  end
  return copy
end

local function bothOpponentsHaveDefinedPositions(aSrc, bSrc)
  local currentPlayer = GetPlayerPed(-1)
  local currentPlayerCoords = GetEntityCoords(currentPlayer, 0)

  local aPly = GetPlayerFromServerId(aSrc)
  local aTarget = GetPlayerPed(aPly)
  local aCoords = GetEntityCoords(aTarget, 0)

  local bPly = GetPlayerFromServerId(bSrc)
  local bTarget = GetPlayerPed(bPly)
  local bCoords = GetEntityCoords(bTarget, 0)

  if currentPlayer == aTarget then
    return #(currentPlayerCoords - bCoords) > 0 -- not defined if 0
  elseif currentPlayer == bTarget then
    return #(currentPlayerCoords - aCoords) > 0 -- not defined if 0
  else
    if #(currentPlayerCoords - aCoords) == 0 then
      return false
    elseif #(currentPlayerCoords - bCoords) == 0 then
      return false
    else
      return #(bCoords - aCoords) > 0
    end
  end
end

local function distanceToCheckpoint(src, pCheckpoint)
  local ped = GetPlayerFromServerId(src)
  local target = GetPlayerPed(ped)
  local pos = GetEntityCoords(target, 0)
  local next
  if pCheckpoint + 1 > #CurrentRaceData.Checkpoints then
    next = CurrentRaceData.Checkpoints[1]
  else
    next = CurrentRaceData.Checkpoints[pCheckpoint + 1]
  end

  local distanceToNext = #(pos - vector3(next.coords.x, next.coords.y, next.coords.z))
  return distanceToNext
end

local function placements(pRacers)
  local tempPositions = copyWihoutId(pRacers)
  if #tempPositions > 1 then
    table.sort(tempPositions, function(a, b)
      if a.Lap > b.Lap then
        return true
      elseif a.Lap < b.Lap then
        return false
      elseif a.Lap == b.Lap then
        if a.Checkpoint > b.Checkpoint then
          return true
        elseif a.Checkpoint < b.Checkpoint then
          return false
        elseif a.Checkpoint == b.Checkpoint then
          if bothOpponentsHaveDefinedPositions(a.source, b.source) then
            return distanceToCheckpoint(a.source, a.Checkpoint) < distanceToCheckpoint(b.source, b.Checkpoint)
          else
            if a.RaceTime ~= nil and b.RaceTime ~= nil and a.RaceTime < b.RaceTime then
              return true
            else
              return false
            end
          end
        end
      end
      return false
    end)
  end
  return tempPositions
end

local function getIndex(Positions)
  local myAlias = tostring(LocalPlayer.state.Character:GetData('Callsign'))
  for k, v in pairs(Positions) do
    if myAlias == v.alias then return k end
  end

  return 0
end


function positionThread()
  CreateThread(function()
    while _activeRace ~= nil do
      if _activeRace.trackData.Checkpoints ~= nil and next(_activeRace.trackData.Checkpoints) ~= nil then
        local positions  = placements(_activeRace.racers)
        local MyPosition = getIndex(positions)
        SendNUIMessage({
          type = "UPDATE_LEADERBOARD",
          data = {
            currentPosition = MyPosition,
            amountOfRacers = #positions
          }
        })
      else
        break
      end
      Wait(1000)
    end
  end)
end

RegisterNetEvent('Phone:CL:Racing:PassedCheckpoint', function(raceId, alias, pCheckpoint)
  if _activeRace and _activeRace._id == raceId then
    if not _activeRace["racers"][alias] then return end --!Racer no longer exists but somehow passed a checkpoint?
    _activeRace["racers"][alias].Checkpoint = pCheckpoint
  end
end)

RegisterNetEvent('Phone:CL:Racing:LapCompleted', function(raceId, alias, pNewLap)
  if _activeRace and _activeRace._id == raceId then
    if not _activeRace["racers"][alias] then return end --!Racer no longer exists but somehow passed a Lap?
    _activeRace["racers"][alias].Laps = pNewLap
  end
end)

--#endregion
