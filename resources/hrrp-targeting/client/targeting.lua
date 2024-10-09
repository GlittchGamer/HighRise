local holdingTargeting = false
local lastSentIcon = false
local hittingTarget = false
local hittingTargetData = {}
inTargetingMenu = false

_unusableTargets = {}

enableWorldPrompts = true


local blockInteractHint = {}

local function FindNearestZones()
  NearZones = {}

  for _, zone in pairs(nearbyZones) do
    if zone.data and zone.data.blockInteractHint then
      blockInteractHint[zone.id] = true
    end
    local fetchZone = GetPZoneAtCoords(zone.center, 10.0)
    if fetchZone then
      NearZones[#NearZones + 1] = {
        id = fetchZone.name,
        center = zone.center,
        active = true,
        dist = #(zone.center - GetEntityCoords(GLOBAL_PED)),
        opacity = 255
      }
    end
  end
end

function StartTargeting()
  if
      not holdingTargeting
      and not inTargetingMenu
      and not LocalPlayer.state.doingAction
      and not LocalPlayer.state.inTrunk
      and not LocalPlayer.state.inDumpster
  then
    holdingTargeting = true
    hittingTargetData = false
    TriggerEvent("Targeting:Client:UpdateState", true, false)


    NearZones = {}
    nearbyZones = GetZones(GetEntityCoords(GLOBAL_PED)) or {}

    Citizen.CreateThread(function()
      while holdingTargeting do
        if
            IsPauseMenuActive()
            --or IsPedInAnyVehicle(GLOBAL_PED)
            or IsPedFatallyInjured(GLOBAL_PED)
            or not LocalPlayer.state.loggedIn
        then
          return StopTargeting()
        end

        local hitting, endCoords, entity = GetEntityPlayerIsLookingAt(25.0, GLOBAL_PED)
        local nowHitting = false

        if hitting then
          local entityType = GetEntityType(entity)
          local entityCoords = GetEntityCoords(entity)
          local pedCoords = GetEntityCoords(GLOBAL_PED)

          if entityType == 1 then
            -- is a ped, no point checking for polyzones
            if
                IsPedAPlayer(entity)
                and (#(pedCoords - entityCoords) <= 3.0)
                and not IsPedInAnyVehicle(GLOBAL_PED)
            then
              local playerId = NetworkGetPlayerIndexFromPed(entity)
              if NetworkIsPlayerActive(playerId) then
                nowHitting = {
                  type = "player",
                  entity = entity,
                  endCoords = endCoords,
                  serverId = GetPlayerServerId(playerId),
                  uid = string.format("player-%s", entity),
                }
              end
            else
              local interactablePed = IsPedInteractable(entity)
              if interactablePed and (#(pedCoords - entityCoords) <= interactablePed.proximity) then
                nowHitting = interactablePed
                nowHitting.entity = entity
                nowHitting.endCoords = endCoords
                nowHitting.uid = string.format("ped-%s", entity)
              end
            end
          elseif
              entityType == 2
              and NetworkGetEntityIsNetworked(entity)
              and not IsPedInAnyVehicle(GLOBAL_PED)
          then
            -- is a vehicle, no point checking for polyzones
            nowHitting = {
              type = "vehicle",
              entity = entity,
              endCoords = endCoords,
              uid = string.format("vehicle-%s", entity),
            }
          else
            if entityType == 3 then
              local interactableEntity = IsEntityInteractable(entity)
              if interactableEntity and (#(entityCoords - pedCoords) <= interactableEntity.proximity) then
                nowHitting = interactableEntity
                nowHitting.entity = entity
                nowHitting.endCoords = endCoords
                nowHitting.uid = string.format("entity-%s", entity)
              end
            end

            local withinZone = GetPZoneAtCoords(endCoords)

            if withinZone then
              nowHitting = withinZone
              nowHitting.id = withinZone.name
              nowHitting.endCoords = endCoords
              nowHitting.uid = string.format("pz-%s", withinZone.name)
            end
          end
        end

        if nowHitting and CanOpenTargetingMenu(nowHitting.uid, nowHitting) then
          hittingTarget = true
          hittingTargetData = nowHitting

          if hittingTargetData.icon then
            UpdateTargetingIcon(hittingTargetData.icon)
          elseif hittingTargetData.type == "vehicle" then
            UpdateTargetingIcon(Config.VehicleIcons[GetVehicleClass(hittingTargetData.entity)])
          elseif hittingTargetData.type and Config.DefaultIcons[hittingTargetData.type] then
            UpdateTargetingIcon(Config.DefaultIcons[hittingTargetData.type])
          else
            UpdateTargetingIcon(Config.DefaultIcons.object)
          end
        elseif hittingTarget then
          hittingTarget = false
          UpdateTargetingIcon(false)
          if inTargetingMenu then
            inTargetingMenu = false
            TriggerEvent("Targeting:Client:CloseMenu")
          end
        end

        if enableWorldPrompts then
          FindNearestZones()
        end

        Citizen.Wait(250)
      end
    end)

    Citizen.CreateThread(function()
      local rgbAccent, rgbWhite = { 255, 0, 57 }, { 255, 255, 255 }

      local previousZones = {}
      local drawingZones = {}
      local lastUpdate = GetGameTimer()

      RequestStreamedTextureDict("shared")
      while holdingTargeting do
        if enableWorldPrompts then
          local activeZones, nearZoneLookup = {}, {}

          -- Insert all `NearZones` that aren't already being drawn into `drawingZones`
          for _, zone in ipairs(NearZones) do
            nearZoneLookup[zone.id] = true
            if zone.active then activeZones[zone.id] = true end
            if not drawingZones[zone.id] then
              drawingZones[zone.id] = { zone = zone, type = "in", fade = 0 }
            end
          end

          -- Insert all `previousZones` that aren't in `NearZones` and aren't already being drawn (or whose fade type == 'in') into `drawingZones`
          for _, zone in ipairs(previousZones) do
            local inNear = nearZoneLookup[zone.id]
            if not inNear and (not drawingZones[zone.id] or drawingZones[zone.id].type == "in") then
              drawingZones[zone.id] = { zone = zone, type = "out", fade = 100 }
            end
          end

          -- Draw prompts for all zones in `drawingZones`
          local currentTime = GetGameTimer()
          for id, fz in pairs(drawingZones) do
            if not blockInteractHint[fz.zone.id] then
              local isActive = activeZones[fz.zone.id] ~= nil
              local opacity = map_range(fz.fade, 0, 100, 0, isActive and 255 or 200)
              if fz.type == "in" then
                fz.fade = math.min(fz.fade + 0.15 * (currentTime - lastUpdate), 100)
              elseif fz.type == "out" then
                fz.fade = math.max(fz.fade - 0.15 * (currentTime - lastUpdate), 0)
                if fz.fade == 0 then drawingZones[id] = nil end
              end

              SetDrawOrigin(fz.zone.center, 0)
              local rgb = isActive and rgbAccent or rgbWhite
              DrawSprite("shared", "emptydot_32", 0, 0, 0.02, 0.035, 0, rgb[1], rgb[2], rgb[3], math.floor(opacity + 0.5))
              ClearDrawOrigin()
            end
          end

          lastUpdate = currentTime
          previousZones = { table.unpack(NearZones) }
        end
        DisablePlayerFiring(GLOBAL_PED, true)
        DisableControlAction(0, 25, true)
        Citizen.Wait(0)
      end
    end)

    _unusableTargets = {}
  end
end

function StopTargeting()
  if holdingTargeting then
    hittingTarget = false
    hittingTargetData = false
    holdingTargeting = false
    lastSentIcon = false
    if not inTargetingMenu then
      TriggerEvent("Targeting:Client:UpdateState", false, false)
    end
  end
end

function UpdateTargetingIcon(icon)
  if lastSentIcon ~= icon then
    lastSentIcon = icon
    TriggerEvent("Targeting:Client:UpdateState", holdingTargeting, lastSentIcon)
  end
end

AddEventHandler("Keybinds:Client:KeyUp:primary_action", function()
  if not inTargetingMenu and hittingTarget and hittingTargetData and holdingTargeting then
    if hittingTargetData.type == "vehicle" then
      OpenTargetingMenu(hittingTargetData, Config.VehicleMenu)
    elseif hittingTargetData.type == "player" then
      OpenTargetingMenu(hittingTargetData, Config.PlayerMenu)
    elseif hittingTargetData.menu then
      -- model, entity, zone, ped
      OpenTargetingMenu(hittingTargetData, hittingTargetData.menu)
    end
  end
end)

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

function OpenTargetingMenu(entityData, menu)
  local distance = #(entityData.endCoords - GetEntityCoords(GLOBAL_PED))
  local currentMenu = {}
  for k, v in ipairs(menu) do
    if
        (v.isEnabled == nil or (v.isEnabled ~= nil and v.isEnabled(v.data, entityData)))
        and (not v.minDist or (v.minDist and distance <= v.minDist))
        and (v.tempjob == nil or (v.tempjob ~= nil and DoesCharacterhaveTemp(v.tempjob)))
        and (v.jobPerms == nil or (v.jobPerms ~= nil and DoesCharacterPassJobPermissions(v.jobPerms)))
        and (v.state == nil or (v.state ~= nil and DoesCharacterhaveState(v.state)))
        and (entityData.type ~= "vehicle" or (entityData.type == "vehicle" and v.model == nil) or (entityData.type == "vehicle" and GetEntityModel(
          entityData.entity
        ) == v.model))
        and (v.item == nil or v.item ~= nil and Inventory.Check.Player:HasItem(
          v.item,
          v.itemCountFunc and v.itemCountFunc(v.data, entityData) or v.itemCount or 1
        ))
        and (v.items == nil or v.items ~= nil and Inventory.Check.Player:HasItems(v.items))
        and (v.anyItems == nil or v.anyItems ~= nil and Inventory.Check.Player:HasAnyItems(v.anyItems))
        and (v.rep == nil or v.rep.level <= Reputation:GetLevel(v.rep.id))
        and (not IsPedInAnyVehicle(GLOBAL_PED) or v.allowFromVehicle)
    then
      local menuItem = table.copy(v)
      if v.textFunc then
        menuItem.text = v.textFunc(v.data, entityData)
        menuItem.textFunc = nil
      end
      table.insert(currentMenu, menuItem)
    end
  end

  if #currentMenu <= 0 then
    return
  end

  inTargetingMenu = true
  TriggerEvent("Targeting:Client:OpenMenu", currentMenu)
end

function CanOpenTargetingMenu(id, entityData)
  if _unusableTargets[id] then
    return false
  end

  local menu = entityData.menu
  if entityData.type == "vehicle" then
    menu = Config.VehicleMenu
  elseif entityData.type == "player" then
    menu = Config.PlayerMenu
  end

  if not menu then return false; end

  local distance = #(entityData.endCoords - GetEntityCoords(GLOBAL_PED))
  local availableItems = 0

  for k, v in ipairs(menu) do
    if
        (v.isEnabled == nil or (v.isEnabled ~= nil and v.isEnabled(v.data, entityData)))
        and (not v.minDist or (v.minDist and distance <= v.minDist))
        and (v.tempjob == nil or (v.tempjob ~= nil and DoesCharacterhaveTemp(v.tempjob)))
        and (v.jobPerms == nil or (v.jobPerms ~= nil and DoesCharacterPassJobPermissions(v.jobPerms)))
        and (v.state == nil or (v.state ~= nil and DoesCharacterhaveState(v.state)))
        and (entityData.type ~= "vehicle" or (entityData.type == "vehicle" and v.model == nil) or (entityData.type == "vehicle" and GetEntityModel(
          entityData.entity
        ) == v.model))
        and (v.item == nil or v.item ~= nil and Inventory.Check.Player:HasItem(
          v.item,
          v.itemCountFunc and v.itemCountFunc(v.data, entityData) or v.itemCount or 1
        ))
        and (v.items == nil or v.items ~= nil and Inventory.Check.Player:HasItems(v.items))
        and (v.anyItems == nil or v.anyItems ~= nil and Inventory.Check.Player:HasAnyItems(v.anyItems))
        and (v.rep == nil or v.rep.level <= Reputation:GetLevel(v.rep.id))
        and (not IsPedInAnyVehicle(GLOBAL_PED) or v.allowFromVehicle)
    then
      availableItems += 1
    end
  end

  if availableItems > 0 then
    return true
  end

  _unusableTargets[id] = true
  return false
end

AddEventHandler("Targeting:Client:MenuSelect", function(event, data)
  if not LocalPlayer.state.loggedIn then
    return
  end
  if event then
    TriggerEvent(event, hittingTargetData, data)
    UISounds.Play:FrontEnd(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET")
  end
  StopTargeting()
  hittingTargetData = false
  inTargetingMenu = false
  TriggerEvent("Targeting:Client:UpdateState", false, false)
end)


function map_range(s, a1, a2, b1, b2)
  return b1 + (s - a1) * (b2 - b1) / (a2 - a1)
end
