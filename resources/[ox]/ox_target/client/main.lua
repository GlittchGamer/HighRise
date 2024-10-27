if not lib.checkDependency('ox_lib', '3.0.0', true) then return end

lib.locale()

local utils = require 'client.utils'
local state = require 'client.state'
local getEntityOptions = require 'client.api'.getEntityOptions
local icons = {
    ped = "person-walking",
    free_ped = "person-walking",
    player = "person",
    entity = "bullseye-pointer",
    vehicle = {
		[0] = "car",
		[1] = "car",
		[2] = "car",
		[3] = "car",
		[4] = "car",
		[5] = "car",
		[6] = "car",
		[7] = "car",
		[8] = "motorcycle",
		[9] = "truck-monster",
		[10] = "truck-pickup",
		[11] = "car",
		[12] = "car",
		[13] = "bicycle",
		[14] = "ship",
		[15] = "helicopter",
		[16] = "plane",
		[17] = "taxi-bus",
		[18] = "car",
		[19] = "car",
		[20] = "truck",
		[21] = "train",
    }
}

require 'client.debug'
require 'client.defaults'
require 'client.compat.qtarget'
require 'client.compat.qb-target'
require 'client.compat.targeting'

local objRefresh = 300
local raycastFromCamera, getNearbyZones, drawZoneSprites, refreshObjectSprites in utils
local SendNuiMessage = SendNuiMessage
local GetEntityCoords = GetEntityCoords
local GetEntityType = GetEntityType
local HasEntityClearLosToEntity = HasEntityClearLosToEntity
local GetEntityBoneIndexByName = GetEntityBoneIndexByName
local GetEntityBonePosition_2 = GetEntityBonePosition_2
local next = next
local GetEntityModel = GetEntityModel
local IsDisabledControlJustPressed = IsDisabledControlJustPressed
local DisableControlAction = DisableControlAction
local DisablePlayerFiring = DisablePlayerFiring
local GetModelDimensions = GetModelDimensions
local GetOffsetFromEntityInWorldCoords = GetOffsetFromEntityInWorldCoords
local options = {}
currentTarget = {}
local currentMenu
local menuHistory = {}
local nearbyZones

-- Toggle ox_target, instead of holding the hotkey
local toggleHotkey = GetConvarInt('ox_target:toggleHotkey', 0) == 1
local mouseButton = GetConvarInt('ox_target:leftClick', 1) == 1 and 24 or 25
local debug = GetConvarInt('ox_target:debug', 0) == 1

---@param option table
---@param distance number
---@param endCoords vector3
---@param entityHit? number
---@param entityType? number
---@param entityModel? number | false
local function shouldHide(option, distance, endCoords, entityHit, entityType, entityModel)
    if option.menuName ~= currentMenu then
        return true
    end

    if option.distance and distance > option.distance then
        return true
    end

    if option.groups and not utils.hasPlayerGotGroup(option.groups) then
        return true
    end

    if option.jobPerms and not utils.hasPlayerGotGroup(option.jobPerms) then
        return true
    end

    if option.items and not utils.hasPlayerGotItems(option.items, option.anyItem) then
        return true
    end

    if option.item and not utils.hasPlayerGotItems(option.item, option.anyItem) then
        return true
    end

    if option.anyItems and not utils.hasPlayerGotItems(option.anyItems, true) then
        return true
    end

    if option.state and not utils.hasPlayerGotState(option.state) then
        return true
    end

    if option.rep and not utils.hasPlayerGotRep(option.rep) then
        return true
    end

    if option.tempJob and not utils.doesPlayerHasTempJob(option.tempJob) then
        return true
    end

    if option.model and entityModel and entityModel ~= option.model then
        return true
    end

    local bone = entityModel and option.bones or nil

    if bone then
        ---@cast entityHit number
        ---@cast entityType number
        ---@cast entityModel number

        local _type = type(bone)

        if _type == 'string' then
            local boneId = GetEntityBoneIndexByName(entityHit, bone)

            if boneId ~= -1 and #(endCoords - GetEntityBonePosition_2(entityHit, boneId)) <= 2 then
                bone = boneId
                option.targetBone = boneId
            else
                return true
            end
        elseif _type == 'table' then
            local closestBone, boneDistance

            for j = 1, #bone do
                local boneId = GetEntityBoneIndexByName(entityHit, bone[j])

                if boneId ~= -1 then
                    local dist = #(endCoords - GetEntityBonePosition_2(entityHit, boneId))

                    if dist <= (boneDistance or 1) then
                        closestBone = boneId
                        boneDistance = dist
                    end
                end
            end

            if closestBone then
                bone = closestBone
                option.targetBone = closestBone
            else
                return true
            end
        end
    end

    local offset = entityModel and option.offset or nil

    if offset then
        ---@cast entityHit number
        ---@cast entityType number
        ---@cast entityModel number

        if not option.absoluteOffset then
            local min, max = GetModelDimensions(entityModel)
            offset = (max - min) * offset + min
        end

        offset = GetOffsetFromEntityInWorldCoords(entityHit, offset.x, offset.y, offset.z)

        if #(endCoords - offset) > (option.offsetSize or 1) then
            return true
        end
    end

    if option.canInteract then
        if option.target then
            local entData = { entity = entityHit, distance = distance, endCoords = endCoords, text = option.name, boneIndex = bone }
            if entityHit ~= 0 and entityType == 1 and IsPedAPlayer(entityHit) then
                entData.serverId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entityHit))
            end
            local success, resp = pcall(option.canInteract, option.data, entData )
            return not success or not resp
        end
        local success, resp = pcall(option.canInteract, entityHit, distance, endCoords, option.name, bone)
        return not success or not resp
    end
end

local hasTarget = false

AddEventHandler("Keybinds:Client:KeyUp:primary_action", function()
    if hasTarget then
        state.setNuiFocus(true, true)
    end
end)

Citizen.CreateThread(function()
    local hit, entityHit, lastEntity
    while true do
        hit, entityHit = raycastFromCamera(511)
        if entityHit ~= lastEntity then
            local success, result = pcall(GetEntityType, entityHit)
            if success then
                lastEntity = entityHit
                TriggerEvent("Targeting:Client:TargetChanged", entityHit ~= 0 and entityHit or false)
            else
                lastEntity = entityHit
                TriggerEvent("Targeting:Client:TargetChanged", false)
            end
        end
        Citizen.Wait(500)
    end
end)

local function startTargeting()
    if state.isDisabled() or state.isActive() or IsNuiFocused() or IsPauseMenuActive() or IsPedInAnyVehicle(cache.ped, false) then return end

    state.setActive(true)

    local flag = 511
    local hit, entityHit, endCoords, distance, lastEntity, entityType, entityModel, hasTick, zonesChanged, entityOptions
    local zones = {}

    local timer = GetGameTimer() - 500
    while state.isActive() do
        if not state.isNuiFocused() and lib.progressActive() then
            state.setActive(false)
            break
        end

        local playerCoords = GetEntityCoords(cache.ped)
        hit, entityHit, endCoords = raycastFromCamera(flag)
        distance = #(playerCoords - endCoords)

        if entityHit ~= 0 and entityHit ~= lastEntity then
            local success, result = pcall(GetEntityType, entityHit)
            entityType = success and result or 0
        end

        if entityType == 0 then
            local _flag = flag == 511 and 26 or 511
            local _hit, _entityHit, _endCoords = raycastFromCamera(_flag)
            local _distance = #(playerCoords - _endCoords)

            if _distance < distance then
                flag, hit, entityHit, endCoords, distance = _flag, _hit, _entityHit, _endCoords, _distance

                if entityHit ~= 0 then
                    local success, result = pcall(GetEntityType, entityHit)
                    entityType = success and result or 0
                end
            end
        end

        if hit and distance < 7 then
            local newOptions
            nearbyZones, zonesChanged = getNearbyZones(endCoords)

            if GetGameTimer() - timer > objRefresh then
                refreshObjectSprites()
                timer = GetGameTimer()
            end

            if entityHit ~= lastEntity then
                currentMenu = nil

                if next(options) then
                    table.wipe(options)
                    SendNUIMessage({
                      event = "leftTarget",
                    })
                end

                if flag ~= 511 then
                    entityHit = HasEntityClearLosToEntity(entityHit, cache.ped, 7) and entityHit or 0
                end

                if lastEntity ~= entityHit and debug then
                    if lastEntity then
                        SetEntityDrawOutline(lastEntity, false)
                    end

                    if entityType ~= 1 then
                        SetEntityDrawOutline(entityHit, true)
                    end
                end

                if entityHit ~= 0 then
                    local success, result = pcall(GetEntityModel, entityHit)
                    entityModel = success and result

                    if entityModel then
                        newOptions = getEntityOptions(entityHit, entityType, entityModel)
                    end
                end
            end

            ---@type table<string, OxTargetOption[]>
            entityOptions = newOptions
            options = newOptions or options or {}
            newOptions = (newOptions or zonesChanged or entityHit ~= lastEntity) and true
            lastEntity = entityHit
            currentTarget.entity = entityHit
            currentTarget.coords = endCoords
            currentTarget.distance = distance
            local hidden = 0
            local totalOptions = 0

            for _, v in pairs(options) do
                local optionCount = #v
                totalOptions += optionCount

                for i = 1, optionCount do
                    local option = v[i]
                    local hide = shouldHide(option, distance, endCoords, entityHit, entityType, entityModel)

                    if option.hide ~= hide then
                        option.hide = hide
                        newOptions = true
                    end

                    if hide then hidden += 1 end
                end
            end
    

            if zonesChanged then table.wipe(zones) end

            for i = 1, #nearbyZones do
                local zoneOptions = nearbyZones[i].options
                local optionCount = #zoneOptions
                totalOptions += optionCount
                zones[i] = zoneOptions

                for j = 1, optionCount do
                    local option = zoneOptions[j]
                    local hide = shouldHide(option, distance, endCoords, entityHit)

                    if option.hide ~= hide then
                        option.hide = hide
                        newOptions = true
                    end

                    if hide then hidden += 1 end
                end
            end

            if newOptions then
                if hidden == totalOptions then
                    hasTarget = false
                    SendNUIMessage({
                      event = "leftTarget",
                    })
                else
                    hasTarget = true

                    if currentMenu then
                        totalOptions += 1
                        options.__builtin = {
                            {
                                icon = 'fa-solid fa-circle-chevron-left',
                                label = locale('go_back'),
                                name = 'builtin:goback',
                                menuName = currentMenu,
                                openMenu = 'home'
                            },
                        }
                    end

                    local jsonOptions = {
                        __builtin = options.__builtin,
                    }
                    local mainIcon, backupIcon
                    for intType, opArray in pairs(options) do
                        if not jsonOptions[intType] then
                            jsonOptions[intType] = {}
                        end
                        local icon, typeIcon = CheckOptions(opArray, jsonOptions[intType], entityHit, distance, endCoords, bone)
                        if icon and not mainIcon then
                            mainIcon = icon
                        end
                        if typeIcon and not backupIcon then
                            backupIcon = typeIcon
                        end
                    end
                    local zoneCpy = {}
                    local icon, zoneIcon = CheckOptions(zones, zoneCpy, entityHit, distance, endCoords, bone, true)
                    if icon and not mainIcon then
                        mainIcon = icon
                    end
                    if zoneIcon and not backupIcon then
                        backupIcon = zoneIcon
                    end

                    if not mainIcon then
                        mainIcon = GetIconFromEntity(entityHit, entityType, entityOptions)
                    end

                    if not mainIcon then
                        mainIcon = backupIcon
                    end

                    SendNUIMessage({
                      event = "setTarget",
                      data = {
                        options = jsonOptions,
                        zones = zoneCpy,
                        icon = mainIcon,
                      }
                    })
                end
            end
        else
            if hasTarget then
                hasTarget = false

                SendNUIMessage({
                  event = "leftTarget",
                })
            end

            if lastEntity then
                if debug then SetEntityDrawOutline(lastEntity, false) end
                if options then table.wipe(options) end

                lastEntity = nil
            else
                Wait(50)
            end
        end

        if toggleHotkey and IsPauseMenuActive() then
            state.setActive(false)
        end

        if not hasTick then
            hasTick = true
            local dict, texture = utils.getTexture()

            CreateThread(function()
                while state.isActive() do
                    if debug then
                        ---@diagnostic disable-next-line: param-type-mismatch
                        DrawMarker(28, endCoords.x, endCoords.y, endCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 0.2, 255, 42, 24, 100, false, false, 0, true, false, false, false)
                    end

                    drawZoneSprites(dict, texture)
                    DisablePlayerFiring(cache.playerId, true)
                    DisableControlAction(0, 24, true)
                    DisableControlAction(0, 25, true)
                    DisableControlAction(0, 140, true)
                    DisableControlAction(0, 141, true)
                    DisableControlAction(0, 142, true)

                    if state.isNuiFocused() then
                        DisableControlAction(0, 1, true)
                        DisableControlAction(0, 2, true)

                        -- if not hasTarget or (options and IsDisabledControlJustPressed(0, 25)) then
                        --     state.setNuiFocus(false, false)
                        -- end
                    elseif hasTarget and (IsDisabledControlJustPressed(0, 24) or IsDisabledControlJustPressed(0, 25)) then
                        state.setNuiFocus(true, true)
                    end

                    Wait(0)
                end
                if state.isNuiFocused() then
                    -- ensure disabling nui focus
                    state.setNuiFocus(false, false)
                end
                SetStreamedTextureDictAsNoLongerNeeded(dict)
            end)
        end

        if not hasTarget then
            flag = flag == 511 and 26 or 511
        end

        Wait(60)
    end


    SendNUIMessage({
      event = "leftTarget",
    })

    if lastEntity and debug then
        SetEntityDrawOutline(lastEntity, false)
    end

    hasTarget = false
    state.setNuiFocus(false)
    SendNUIMessage({
      event = "visible",
      data = {
        visible = false,
      }
    })
    table.wipe(currentTarget)
    table.wipe(options)

    if nearbyZones then table.wipe(nearbyZones) end
end

do
    ---@type KeybindProps
    local keybind = {
        name = 'ox_target',
        defaultKey = GetConvar('ox_target:defaultHotkey', 'LMENU'),
        defaultMapper = 'keyboard',
        description = locale('toggle_targeting'),
    }

    if toggleHotkey then
        function keybind:onPressed()
            if state.isActive() then
                return state.setActive(false)
            end

            return startTargeting()
        end
    else
        keybind.onPressed = startTargeting

        function keybind:onReleased()
            state.setActive(false)
        end
    end

    lib.addKeybind(keybind)
end

---@generic T
---@param option T
---@param server? boolean
---@return T
local function getResponse(option, server)
    local response = table.clone(option)
    response.entity = currentTarget.entity
    response.zone = currentTarget.zone
    response.coords = currentTarget.coords
    response.distance = currentTarget.distance
    if response.entity ~= 0 then
        local success, result = pcall(GetEntityType, currentTarget.entity)
        response.entityType = success and result or nil
        success, result = pcall(GetEntityModel, currentTarget.entity)
        response.model = success and result or nil
    end

    if server then
        response.entity = response.entity ~= 0 and NetworkGetEntityIsNetworked(response.entity) and NetworkGetNetworkIdFromEntity(response.entity) or 0
    end

    response.icon = nil
    response.groups = nil
    response.items = nil
    response.canInteract = nil
    response.onSelect = nil
    response.export = nil
    response.event = nil
    response.serverEvent = nil
    response.command = nil

    return response
end

RegisterNUICallback('select', function(data, cb)
    cb(1)

    local zone = data[3] and nearbyZones[data[3]]

    ---@type OxTargetOption?
    local option = zone and zone.options[data[2]] or options[data[1]][data[2]]

    if option then
        if option.openMenu then
            local menuDepth = #menuHistory

            if option.name == 'builtin:goback' then
                option.menuName = option.openMenu
                option.openMenu = menuHistory[menuDepth]

                if menuDepth > 0 then
                    menuHistory[menuDepth] = nil
                end
            else
                menuHistory[menuDepth + 1] = currentMenu
            end

            currentMenu = option.openMenu ~= 'home' and option.openMenu or nil
        else
            state.setNuiFocus(false)
            state.setActive(false)
        end

        if option.target then
            local response = getResponse(option, option.serverEvent ~= nil)
            response.menu = {
                option
            }
            if response.entity ~= 0 and GetEntityType(response.entity) == 1 and IsPedAPlayer(response.entity) then
                response.serverId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(response.entity))
            end
            if option.onSelect then
                option.onSelect(response, option.data)
            elseif option.export then
                exports[option.resource][option.export](nil, response, option.data)
            elseif option.event then
                TriggerEvent(option.event, response, option.data)
            elseif option.serverEvent then
                TriggerServerEvent(option.serverEvent, option.data, response)
            elseif option.command then
                ExecuteCommand(option.command)
            end
        else
            if option.onSelect then
                option.onSelect(option.qtarget and currentTarget.entity or getResponse(option))
            elseif option.export then
                exports[option.resource][option.export](nil, getResponse(option))
            elseif option.event then
                TriggerEvent(option.event, getResponse(option))
            elseif option.serverEvent then
                TriggerServerEvent(option.serverEvent, getResponse(option, true))
            elseif option.command then
                ExecuteCommand(option.command)
            end
        end

        if option.menuName == 'home' then return end
    end

    if not option?.openMenu and IsNuiFocused() then
        state.setActive(false)
    end
end)

function CheckOptions(opArray, jsonOptions, entityHit, distance, endCoords, bone, isZone)
    local mainIcon, icon
    for k, v in pairs(opArray) do
        local _option = {}
        if not mainIcon and v.mainIcon and not v.hide then
            mainIcon = v.mainIcon
        end
        if not icon and v.icon and not v.hide then
            icon = v.icon
        end
        for index, value in pairs(v) do
            if index == "textCb" then
                local success, error = pcall(function()
                    _option.label = value(v.data, { entity = entityHit, distance = distance, endCoords = endCoords, text = v.label, boneIndex = bone }, v.data)
                end)
                if not success then
                    _option.label = "ERROR"
                end
            elseif type(value) ~= "function" then
                _option[index] = value
                if isZone and type(value) == "table" then
                    -- zones are array in array for some reason
                    if type(value) == "table" and not mainIcon and value.mainIcon and not value.hide then
                        mainIcon = value.mainIcon
                    end
                    if type(value) == "table" and not icon and value.icon and not value.hide then
                        icon = value.icon
                    end
                    if value.textCb then
                        local success = pcall(function()
                            value.label = value.textCb(value.data, { entity = entityHit, distance = distance, endCoords = endCoords, text = v.label, boneIndex = bone }, v.data)
                        end)
                        if not success then
                            value.label = "ERROR"
                        end
                    end
                end
            end
        end
        jsonOptions[k] = _option
    end
    return mainIcon, icon
end

function GetIconFromEntity(entity, entityType, entityOptions)
    if entity == 0 or not DoesEntityExist(entity) then return nil end
    if entityType == 1 then
        if IsPedAPlayer(entity) then
            return icons.player
        else
            if entityOptions and (entityOptions.model or entityOptions.entity or entityOptions.localEntity) then
                return icons.ped
            else
                TaskTurnPedToFaceEntity(entity, cache.ped, 4000)
                return icons.free_ped
            end
        end
    elseif entityType == 2 then
        return icons.vehicle[GetVehicleClass(entity)]
    elseif entityType == 3 then
        return icons.entity
    end
end


RegisterCommand('target', function (source, args)
  startTargeting()
end, false)