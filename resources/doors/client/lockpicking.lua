local lockpickAttempts = {}

function ResetLockpickAttempts()
  lockpickAttempts = {}
end

function IsAbleToLockpick(doorId)
  if lockpickAttempts[doorId] and lockpickAttempts[doorId] >= Config.Lockpick.maxAttempts then
    return false
  end
  return true
end

function AddLockpickFailedAttempt(doorId)
  local hasAttempt = lockpickAttempts[doorId]
  if hasAttempt then
    if hasAttempt < Config.Lockpick.maxAttempts then
      lockpickAttempts[doorId] = hasAttempt + 1
    end
  else
    lockpickAttempts[doorId] = 1
  end

  if lockpickAttempts[doorId] >= Config.Lockpick.maxAttempts then -- Reached Max, Give Cooldown to try again
    local startID = _character.ID
    Citizen.SetTimeout(60000 * 15, function()
      if lockpickAttempts[doorId] and characterLoaded and startID == _character.ID then
        lockpickAttempts[doorId] = nil
      end
    end)
  end
end

-- RegisterNetEvent('Doors:Client:AttemptLockpick', function(item)
--     if showingDoorInfo then
--         local doorData = DOORS_STATE[showingDoorInfo]
--         if doorData and doorData.lock then
--             if not doorData.lockpickable then
--                 return exports['hud']:NotificationError('You can\'t lockpick this door, it\'s too strong')
--             elseif Doors:IsAuthorized(doorData) then
--                 return exports['hud']:NotificationError('You can\'t lockpick a door that you have the keys for...')
--             elseif not IsAbleToLockpick(showingDoorInfo) then
--                 return exports['hud']:NotificationError('You have already tried lockpicking this door multiple times, it doesn\'t work...')
--             end

--             local doorDist = #(GetEntityCoords(GLOBAL_PED) - doorData.interactionCoords)

--             if doorDist <= 1.5 then
--                 local chance = math.random(100)
--                 if chance >= Config.Lockpick.chance then
--                     Citizen.SetTimeout(math.random(Config.Lockpick.animDuration) * 1000, function()
--                         Progress:Fail()
--                         AddLockpickFailedAttempt(showingDoorInfo)
--                         if math.random(100) <= 40 then -- 40% chance of lockpick breaking or it is just incompetence
--                             exports['core']:CallbacksServer('Inventory:Server:RemoveItem', { item = item }, function(done)
--                                 exports['hud']:NotificationError('Your lockpick broke trying to pick that lock')
--                             end)
--                         else
--                             exports['hud']:NotificationError('You were unable to pick that lock')
--                         end
--                     end)
--                 end

--                 Progress:Progress({
--                     name = 'lockpick',
--                     duration = Config.Lockpick.animDuration * 1000,
--                     label = 'Picking the lock',
--                     canCancel = true,
--                     controlDisables = {
--                         disableMovement = true,
--                         disableCarMovement = true,
--                         disableMouse = false,
--                         disableCombat = true,
--                     },
--                     animation = {
--                         animDict = 'mp_arresting',
--                         anim = 'a_uncuff',
--                         flags = 49,
--                     }
--                 }, function(status)
--                     if not status then
--                         exports['core']:CallbacksServer('Doors:ToggleLock', { doorId = showingDoorInfo, state = false, bylockpick = true }, function(success, newState)
--                             if success and not newState then
--                                 exports['hud']:NotificationSuccess('You lockpicked the door, it is now open')
--                             end
--                         end)
--                     end
--                 end)
--             end
--         end
--     end
-- end)
