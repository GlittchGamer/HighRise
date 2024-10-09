_characterLoaded, GLOBAL_PED = false, nil

_interactionPeds = {}
_spawnedInteractionPeds = {}


local dependenciesLoaded = false
AddEventHandler('PedInteraction:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
  Callbacks = exports['hrrp-base']:FetchComponent('Callbacks')
  Notification = exports['hrrp-base']:FetchComponent('Notification')
  Game = exports['hrrp-base']:FetchComponent('Game')
  Utils = exports['hrrp-base']:FetchComponent('Utils')
  Logger = exports['hrrp-base']:FetchComponent('Logger')
  PedInteraction = exports['hrrp-base']:FetchComponent('PedInteraction')
  Jobs = exports['hrrp-base']:FetchComponent('Jobs')
  Polyzone = exports['hrrp-base']:FetchComponent('Polyzone')

  dependenciesLoaded = true
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['hrrp-base']:RequestDependencies('PedInteraction', {
    'Callbacks',
    'Notification',
    'Game',
    'Utils',
    'Logger',
    'PedInteraction',
    'Jobs',
    'Polyzone'
  }, function(error)
    if #error > 0 then return; end
    RetrieveComponents()

    RemoveEventHandler(setupEvent)

    -- exports['hrrp-pedinteraction']:Add('fuck', `a_m_y_soucent_04`, vector3(-810.171, -1311.092, 4.000), 332.419, 50.0, {
    --     { icon = 'boxes-stacked', text = 'F', event = 'F', data = {}, minDist = 2.0, jobs = false },
    -- })
  end)
end)

RegisterNetEvent("Characters:Client:Spawn")
AddEventHandler("Characters:Client:Spawn", function()
  _characterLoaded = true

  Citizen.CreateThread(function()
    while _characterLoaded do
      Citizen.Wait(1500)
      local pedCoords = GetEntityCoords(PlayerPedId())

      for k, v in pairs(_interactionPeds) do
        local canShowMenu = false

        if type(v.enabled) == 'boolean' then
          canShowMenu = v.enabled
        elseif type(v.enabled) == 'table' then
          canShowMenu = CheckEnabledPerms(v.enabled)
        end

        if canShowMenu then
          local inRange = #(v.coords - pedCoords) <= v.range
          if inRange and not _spawnedInteractionPeds[k] then
            _spawnedInteractionPeds[k] = CreateDumbAssPed(v.model, v.coords, v.heading, v.menu, v.icon, v.scenario, v.anim, v.component, canShowMenu)
          elseif not inRange and _spawnedInteractionPeds[k] then
            DeletePed(_spawnedInteractionPeds[k])
            exports['ox_target']:TargetingRemovePed(_spawnedInteractionPeds[k])
            _spawnedInteractionPeds[k] = nil
          end
        elseif _spawnedInteractionPeds[k] then
          DeletePed(_spawnedInteractionPeds[k])
          exports['ox_target']:TargetingRemovePed(_spawnedInteractionPeds[k])
          _spawnedInteractionPeds[k] = nil
        end
      end
    end
  end)
end)

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
  _characterLoaded = false
  for k, v in pairs(_spawnedInteractionPeds) do
    DeleteEntity(v)
  end

  _spawnedInteractionPeds = {}
end)

-- function CreatePolyZone(id, coords, range)
--   repeat --! This is to prevent errors since when a script restarts, it instantly wants to add all the fucking peds.
--     Wait(10)
--   until dependenciesLoaded
--   exports['hrrp-polyzone']:PolyZoneCreateCircle('PedInteraction_' .. id, coords, range, {}, { npc_id = id })
-- end

_pedShit = {
  Add = function(self, id, model, coords, heading, range, menu, icon, scenario, enabled, anim, component, customPedSkin)
    if id and model and type(coords) == 'vector3' and type(heading) == 'number' then
      if enabled == nil then
        enabled = true
      end

      if type(model) == 'string' then
        model = GetHashKey(model)
      end

      if not range then
        range = 50.0
      end

      if not IsModelValid(model) or not IsModelAPed(model) then
        exports['hrrp-base']:LoggerError('PedInteraction', 'Failed to Add Ped ID: ' .. id .. ' - It\'s Model is Invalid')
        return
      end

      _interactionPeds[id] = {
        id = id,
        enabled = enabled,
        range = range,
        model = model,
        coords = coords,
        heading = heading,
        menu = menu,
        scenario = scenario,
        anim = anim,
        component = component,
        customPedSkin = customPedSkin,
      }

      -- CreatePolyZone(id, coords, range)
    end
  end,
  Toggle = function(self, id, enabled)
    if _interactionPeds[id] then
      _interactionPeds[id].enabled = enabled
    end
  end,
  Remove = function(self, id)
    if _interactionPeds[id] then
      _interactionPeds[id] = nil
      if _spawnedInteractionPeds[id] then
        DeleteEntity(_spawnedInteractionPeds[id])
        exports['ox_target']:TargetingRemovePed(_spawnedInteractionPeds[id])
        _spawnedInteractionPeds[id] = nil
      end
    end
  end,
  GetPed = function(self, id)
    if _spawnedInteractionPeds[id] then
      return _spawnedInteractionPeds[id]
    end
    return false
  end
}

AddEventHandler('Proxy:Shared:RegisterReady', function() --!Completed
  exports['hrrp-base']:RegisterComponent('PedInteraction', _pedShit)
end)

local function exportHandler(exportName, func)
  AddEventHandler(('__cfx_export_%s_%s'):format(GetCurrentResourceName(), exportName), function(setCB)
    setCB(function(...)
      return func(_pedShit, ...)
    end)
  end)
end

for k, v in pairs(_pedShit) do
  if type(v) == "function" then
    exportHandler(k, v)
  end
end

function CreateDumbAssPed(model, coords, heading, menu, icon, scenario, anim, component, showInteract)
  RequestModel(model)
  while not HasModelLoaded(model) do
    Citizen.Wait(100)
  end

  local ped = CreatePed(5, model, coords.x, coords.y, coords.z, heading, false, false)
  SetEntityAsMissionEntity(ped, true, true)
  FreezeEntityPosition(ped, true)
  SetPedCanRagdoll(ped, false)
  TaskSetBlockingOfNonTemporaryEvents(ped, 1)
  SetBlockingOfNonTemporaryEvents(ped, 1)
  SetPedFleeAttributes(ped, 0, 0)
  SetPedCombatAttributes(ped, 17, 1)
  SetEntityInvincible(ped, true)
  SetPedSeeingRange(ped, 0)
  SetPedDefaultComponentVariation(ped)
  SetModelAsNoLongerNeeded(model)
  SetPedCanBeTargetted(ped, false)

  if component and type(component) == "table" then
    SetPedComponentVariation(ped, component.componentId or 0, component.drawableId or 0, component.texture or 0, component.textureId or 0,
      component.paletteId or 0)
  end

  if anim and type(anim) == "table" and anim.animDict and anim.anim then
    ClearPedTasks(ped)
    LoadAnim(anim.animDict)
    TaskPlayAnim(ped, anim.animDict, anim.anim, anim.blendIn or 8.0, anim.blendOut or 8.0, anim.duration or -1, anim.flag or 1, anim.playback or 0,
      anim.lockX or 0, anim.lockY or 0, anim.lockZ or 0)
  elseif scenario and type(scenario) == "string" then
    ClearPedTasks(ped)
    TaskStartScenarioInPlace(ped, scenario, 0, true)
  end

  exports['hrrp-flags']:PedsSetFlag(ped, 'isNPC', true)

  if menu and showInteract then
    exports['ox_target']:TargetingAddPed(ped, 'person-sign', menu, 2.0)
  end

  return ped
end

function LoadAnim(dict)
  while not HasAnimDictLoaded(dict) do
    RequestAnimDict(dict)
    Citizen.Wait(10)
  end
end

function CheckEnabledPerms(perms, entityData)
  if (perms.tempjob == nil or (perms.tempjob ~= nil and DoesCharacterhaveTemp(perms.tempjob)))
      and (perms.jobPerms == nil or (perms.jobPerms ~= nil and DoesCharacterPassJobPermissions(perms.jobPerms)))
      and (perms.state == nil or (perms.state ~= nil and DoesCharacterhaveState(perms.state)))
      and (perms.item == nil or perms.item ~= nil and Inventory.Check.Player:HasItem(
        perms.item,
        perms.itemCountFunc and perms.itemCountFunc(perms.data, entityData) or perms.itemCount or 1
      ))
      and (perms.items == nil or perms.items ~= nil and Inventory.Check.Player:HasItems(perms.items))
      and (perms.anyItems == nil or perms.anyItems ~= nil and Inventory.Check.Player:HasAnyItems(perms.anyItems))
      and (perms.rep == nil or perms.rep.level <= Reputation:GetLevel(perms.rep.id)) then
    return true
  end

  return false
end

function DoesCharacterhaveTemp(tempJob)
  local job = LocalPlayer.state.Character:GetData("TempJob")
  if job == nil then
    return false
  end
  return job == tempJob
end

function DoesCharacterPassJobPermissions(jobPermissions)
  if type(jobPermissions) ~= "table" then
    return true
  end

  for k, v in ipairs(jobPermissions) do
    if v.job then
      if not v.reqOffDuty or (v.reqOffDuty and (not exports['hrrp-jobs']:JobsDutyGet(v.job))) then
        if exports['hrrp-jobs']:JobsPermissionsHasJob(v.job, v.workplace, v.grade, v.gradeLevel, v.reqDuty, v.permissionKey) then
          return true
        end
      end
    elseif v.permissionKey then
      if exports['hrrp-jobs']:JobsPermissionsHasPermission(v.permissionKey) then
        return true
      end
    end
  end
  return false
end

function DoesCharacterhaveState(state)
  local states = LocalPlayer.state.Character:GetData("States") or {}
  for k, v in ipairs(states) do
    if v == state then
      return true
    end
  end
  return false
end

-- AddEventHandler('Polyzone:Enter', function(id, testedPoint, insideZones, data)
--   if data.npc_id == nil then return end
--   if _interactionPeds[data.npc_id] == nil then return end

--   local canShowMenu = false
--   if type(_interactionPeds[data.npc_id].enabled) == 'boolean' then
--     canShowMenu = _interactionPeds[data.npc_id].enabled
--   elseif type(_interactionPeds[data.npc_id].enabled) == 'table' then
--     canShowMenu = CheckEnabledPerms(_interactionPeds[data.npc_id].enabled, data)
--   end

--   local createdPed = CreateDumbAssPed(_interactionPeds[data.npc_id].model, _interactionPeds[data.npc_id].coords, _interactionPeds[data.npc_id].heading,
--     _interactionPeds[data.npc_id].menu,
--     _interactionPeds[data.npc_id].icon, _interactionPeds[data.npc_id].scenario, _interactionPeds[data.npc_id].anim, _interactionPeds[data.npc_id].component,
--     canShowMenu)
--   _spawnedInteractionPeds[data.npc_id] = createdPed
-- end)

-- AddEventHandler('Polyzone:Exit', function(id, testedPoint, insideZones, data)
--   if data.npc_id == nil then return end
--   if _interactionPeds[data.npc_id] == nil then return end

--   if _spawnedInteractionPeds[data.npc_id] then
--     DeleteEntity(_spawnedInteractionPeds[data.npc_id])
--     exports['ox_target']:TargetingRemovePed(_spawnedInteractionPeds[data.npc_id])
--     _spawnedInteractionPeds[data.npc_id] = nil
--   end
-- end)
