local ClonedPed = nil
local sitting = false
local oldCamView = nil
local currentAnimIndex = 1

AddEventHandler('SitAny:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
  Logger = exports['core']:FetchComponent('Logger')
  Action = exports['core']:FetchComponent('Action')
  Notification = exports['core']:FetchComponent('Notification')
  Interaction = exports['core']:FetchComponent('Interaction')
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies('SitAny', {
    'Action',
    'Logger',
    'Notification',
    'Interaction'
  }, function(error)
    if #error > 0 then
      return;
    end
    RetrieveComponents()

    Interaction:RegisterMenu("sitanywhere", 'Sit Down', "chair", function()
      Interaction:Hide()

      local animToUse = Config.Anims[currentAnimIndex]
      if not animToUse then
        exports['hud']:NotificationError("No animation found.")
        return
      end
      PlacingThread(animToUse)
    end)

    RemoveEventHandler(setupEvent)
  end)
end)

function LoadAnim(dict)
  while not HasAnimDictLoaded(dict) do
    RequestAnimDict(dict)
    Citizen.Wait(10)
  end
end

local txt = {
  '-- Sit --  \n',
  '[E] Sit  \n',
  '[X / Right Click] Cancel  \n',
  '[G] Next Animation  \n',
  '[H] Previous Animation  \n',
  '[Up/Down Arrows] Height \n',
  '[SCROLL] Rotate  \n',
}



local function CycleAnimations(direction)
  if direction == "next" then
    currentAnimIndex = currentAnimIndex + 1
    if currentAnimIndex > #Config.Anims then
      currentAnimIndex = 1
    end
  elseif direction == "previous" then
    currentAnimIndex = currentAnimIndex - 1
    if currentAnimIndex < 1 then
      currentAnimIndex = #Config.Anims
    end
  end
end

local function StartSittingThread()
  sitting = true
  exports['hud']:ActionShow("Press [Q] to cancel")
  CreateThread(function()
    while sitting do
      Wait(1)
      if IsControlJustPressed(0, 44) then
        sitting = false
        exports['hud']:ActionHide()
        ClearPedTasksImmediately(PlayerPedId())
        FreezeEntityPosition(PlayerPedId(), false)
        return
      end
    end
  end)
end

local function MakePedSitDown(coords, heading, animData)
  stopPlacing()
  exports['hud']:ActionHide()
  FreezeEntityPosition(PlayerPedId(), true)
  SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, false)
  TaskPlayAnimAdvanced(PlayerPedId(), animData.dict, animData.anim, coords.x, coords.y, coords.z, 0, 0, heading, 3.0, 3.0, -1, 2, 1.0, false, false)
  StartSittingThread()
end

function PlacingThread(animData)
  if ClonedPed == nil then
    local playerPed = PlayerPedId()
    ClonedPed = ClonePed(playerPed, false, false, false)
    FreezeEntityPosition(ClonedPed, true)
    SetEntityAlpha(ClonedPed, 0)

    local animToUse = Config.Anims[currentAnimIndex]

    if not animToUse then
      exports['hud']:NotificationError("No animation found.")
      return
    end

    LoadAnim(animData.dict)
    TaskPlayAnim(ClonedPed, animData.dict, animData.anim, 8.0, 8.0, -1, 1, 0, false, false, false)
    SetEntityCollision(ClonedPed, false, false)
    SetEntityAlpha(ClonedPed, 100)
    if Config.SetToFirstPerson then
      oldCamView = GetFollowPedCamViewMode()
      SetFollowPedCamViewMode(3)
      SetCamViewModeForContext(0, 4)
    end
    SetBlockingOfNonTemporaryEvents(ClonedPed, true)
    heading = GetEntityHeading(playerPed) + 90.0
    exports['hud']:ActionShow(table.concat(txt))
    CreateThread(function()
      local currentCoordsZ = 0
      while ClonedPed ~= nil do
        Wait(1)
        DisableControlAction(0, 22, true)
        startPlacing()
        if currentCoords then
          SetEntityCoords(ClonedPed, currentCoords.x, currentCoords.y, currentCoords.z + currentCoordsZ)
          SetEntityHeading(ClonedPed, heading)
        end
        if IsDisabledControlJustPressed(0, 14) then
          heading = heading + 5
          if heading > 360 then heading = 0.0 end
        end
        if IsDisabledControlPressed(0, 27) then
          currentCoordsZ = currentCoordsZ + 0.01
        end
        if IsDisabledControlPressed(0, 173) then
          currentCoordsZ = currentCoordsZ - 0.01
        end
        if IsDisabledControlJustPressed(0, 15) then
          heading = heading - 5
          if heading < 0 then heading = 360.0 end
        end
        if IsControlJustPressed(0, 38) then
          if #(GetEntityCoords(PlayerPedId()) - currentCoords) < 5.0 then
            MakePedSitDown(GetEntityCoords(ClonedPed), GetEntityHeading(ClonedPed), animToUse)
          else
            exports['hud']:NotificationError("You are too far")
          end
        end

        if IsControlJustPressed(0, 47) then -- G
          CycleAnimations("next")
          animToUse = Config.Anims[currentAnimIndex]

          if not animToUse then
            exports['hud']:NotificationError("No animation found.")
            return
          end

          LoadAnim(animToUse.dict)
          TaskPlayAnim(ClonedPed, animToUse.dict, animToUse.anim, 8.0, 8.0, -1, 1, 0, false, false, false)
        end

        if IsControlJustPressed(0, 74) then -- H
          CycleAnimations("previous")
          animToUse = Config.Anims[currentAnimIndex]

          if not animToUse then
            exports['hud']:NotificationError("No animation found.")
            return
          end

          LoadAnim(animToUse.dict)
          TaskPlayAnim(ClonedPed, animToUse.dict, animToUse.anim, 8.0, 8.0, -1, 1, 0, false, false, false)
        end

        if IsControlJustPressed(0, 177) then
          stopPlacing()
        end
      end
    end)
  else
    DeleteObject(ClonedPed)
    ClonedPed = nil
    stopPlacing()
    return
  end
end

function GetForwardVector(rotation)
  local rot = (math.pi / 180.0) * rotation
  return vector3(-math.sin(rot.z) * math.abs(math.cos(rot.x)), math.cos(rot.z) * math.abs(math.cos(rot.x)),
    math.sin(rot.x))
end

local function RotationToDirection(rotation)
  local adjustedRotation =
  {
    x = (math.pi / 180) * rotation.x,
    y = (math.pi / 180) * rotation.y,
    z = (math.pi / 180) * rotation.z
  }
  local direction =
  {
    x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
    y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
    z = math.sin(adjustedRotation.x)
  }
  return direction
end

function Camera(ped)
  local cameraRotation = GetGameplayCamRot()
  local cameraCoord = GetGameplayCamCoord()
  local direction = RotationToDirection(cameraRotation)
  local destination =
  {
    x = cameraCoord.x + direction.x * 10.0,
    y = cameraCoord.y + direction.y * 10.0,
    z = cameraCoord.z + direction.z * 10.0
  }

  local sphereCast = StartShapeTestSweptSphere(
    cameraCoord.x,
    cameraCoord.y,
    cameraCoord.z,
    destination.x,
    destination.y,
    destination.z,
    0.2,
    339,
    ped,
    4
  );
  return GetShapeTestResultIncludingMaterial(sphereCast);
end

function startPlacing()
  local _, hit, endCoords, _, _, _ = Camera(ClonedPed)
  if hit then
    currentCoords = endCoords
  end
end

function stopPlacing()
  if ClonedPed then
    DeleteEntity(ClonedPed)
  end
  ClonedPed = nil
  heading = 0.0
  currentCoords = nil
  exports['hud']:ActionHide()
  if Config.SetToFirstPerson then
    SetFollowPedCamViewMode(oldCamView)
    oldCamView = nil
  end
end
