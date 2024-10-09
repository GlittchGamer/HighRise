local _toggled = false
local _paused = false
local _vehToggled = false
local _statuses = {}
local _statusCount = 0

local _idsCd = false
local _zoomLevel = GetResourceKvpInt("zoomLevel") or 3

local _zoomLevels = {
  900,
  1000,
  1100,
  1200,
  1300,
  1400,
}

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(500)
    if not IsPedInAnyVehicle(PlayerPedId(), false) then
      if IsPedUsingActionMode(PlayerPedId()) then
        SetPedUsingActionMode(PlayerPedId(), -1, -1, 1)
      end
    end
  end
end) --Disables combat walk after shooting or punching

-- Citizen.CreateThread(function()
-- 	Citizen.Wait(4000)
-- 	if not GetResourceKvpInt("zoomLevel") then
-- 		SetResourceKvpInt("zoomLevel", 3)
-- 		_zoomLevel = 3
-- 		SetRadarZoom(_zoomLevels[3])
-- 	end

-- 	SetRadarZoom(_zoomLevels[_zoomLevel])
-- end)

AddEventHandler("Hud:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Hud = exports["hrrp-base"]:FetchComponent("Hud")
  Callbacks = exports["hrrp-base"]:FetchComponent("Callbacks")
  Progress = exports["hrrp-base"]:FetchComponent("Progress")
  Action = exports["hrrp-base"]:FetchComponent("Action")
  Keybinds = exports["hrrp-base"]:FetchComponent("Keybinds")
  ListMenu = exports["hrrp-base"]:FetchComponent("ListMenu")
  Notification = exports["hrrp-base"]:FetchComponent("Notification")
  Minigame = exports["hrrp-base"]:FetchComponent("Minigame")
  Interaction = exports["hrrp-base"]:FetchComponent("Interaction")
  Utils = exports["hrrp-base"]:FetchComponent("Utils")
  Phone = exports["hrrp-base"]:FetchComponent("Phone")
  Inventory = exports["hrrp-base"]:FetchComponent("Inventory")
  Weapons = exports["hrrp-base"]:FetchComponent("Weapons")
  Jail = exports["hrrp-base"]:FetchComponent("Jail")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports["hrrp-base"]:RequestDependencies("Hud", {
    "Hud",
    "Callbacks",
    "Action",
    "Progress",
    "Keybinds",
    "ListMenu",
    "Notification",
    "Minigame",
    "Interaction",
    "Utils",
    "Phone",
    "Inventory",
    "Weapons",
    "Jail",
  }, function(error)
    if #error > 0 then
      return
    end
    RetrieveComponents()
    -- Hud.Minimap:Set()

    exports['hrrp-keybinds']:Add("show_interaction", "F1", "keyboard", "Hud - Show Interaction Menu", function()
      INTERACTION:Show()
    end)

    -- exports['hrrp-keybinds']:Add("map_zoom_in", "PageUp", "keyboard", "Minimap - Zoom In", function()
    -- 	Hud.Minimap:In()
    -- end)

    -- exports['hrrp-keybinds']:Add("map_zoom_out", "PageDown", "keyboard", "Minimap - Zoom Out", function()
    -- 	Hud.Minimap:Out()
    -- end)

    exports['hrrp-keybinds']:Add("ui_toggle", "F11", "keyboard", "Hud - Toggle HUD", function()
      HUD:Toggle()
    end)

    exports['hrrp-keybinds']:Add("ids_toggle", "I", "keyboard", "Hud - Toggle IDs", function()
      if not _idsCd then
        HUD.ID:Toggle()
      end
    end)

    exports["hrrp-base"]:CallbacksRegisterClient("HUD:GetTargetInfront", function(data, cb)
      local originCoords = GetOffsetFromEntityInWorldCoords(LocalPlayer.state.ped, 0, 0.5, -0.5)
      local destinationCoords = GetOffsetFromEntityInWorldCoords(LocalPlayer.state.ped, 0, 1.0, -0.5)
      local castedRay = StartShapeTestSweptSphere(originCoords, destinationCoords, 1.0, 8, LocalPlayer.state.ped, 4)
      local _, hitting, endCoords, surfaceNormal, entity = GetShapeTestResult(castedRay)

      if hitting == 1 then
        local playerId = NetworkGetPlayerIndexFromPed(entity)
        if playerId ~= 0 then
          cb(GetPlayerServerId(playerId))
        else
          cb(nil)
        end
      else
        cb(nil)
      end
    end)

    exports["hrrp-base"]:CallbacksRegisterClient("HUD:PutOnBlindfold", function(data, cb)
      Progress:Progress({
        name = "blindfold_action",
        duration = 6000,
        label = data,
        useWhileDead = false,
        canCancel = true,
        disarm = false,
        controlDisables = {
          disableMovement = true,
          disableCarMovement = true,
          disableMouse = false,
          disableCombat = true,
        },
        animation = {
          animDict = "random@mugging4",
          anim = "struggle_loop_b_thief",
          flags = 49,
        },
      }, function(cancelled)
        cb(not cancelled)
      end)
    end)

    RemoveEventHandler(setupEvent)
  end)
end)

function deepcopy(orig)
  local orig_type = type(orig)
  local copy
  if orig_type == "table" then
    copy = {}
    for orig_key, orig_value in next, orig, nil do
      copy[deepcopy(orig_key)] = deepcopy(orig_value)
    end
    setmetatable(copy, deepcopy(getmetatable(orig)))
  else -- number, string, boolean, etc
    copy = orig
  end
  return copy
end

HUD = {
  _required = { "IsDisabled", "IsDisabledAllowDead", "Show", "Hide", "Toggle", "Vehicle", "RegisterStatus" },
  IsDisabled = function(self)
    return (
      LocalPlayer.state.isDead
      or LocalPlayer.state.isCuffed
      or LocalPlayer.state.doingAction
      or LocalPlayer.state.inventoryOpen
      or LocalPlayer.state.phoneOpen
      or LocalPlayer.state.crafting
      or LocalPlayer.state.isHospitalized
      or LocalPlayer.state.myEscorter ~= nil
    )
  end,
  IsDisabledAllowDead = function(self)
    return (
      LocalPlayer.state.isCuffed
      or LocalPlayer.state.inventoryOpen
      or LocalPlayer.state.phoneOpen
      or LocalPlayer.state.crafting
      or LocalPlayer.state.isHospitalized
    )
  end,
  Show = function(self)
    if _toggled then
      return
    end

    local fuel = nil
    if GLOBAL_VEH ~= nil and DoesEntityExist(GLOBAL_VEH) then
      local vehState = Entity(GLOBAL_VEH).state
      fuel = vehState.Fuel
    end

    SendNUIMessage({
      action = "SHOW_HUD",
      data = {
        hp = (GetEntityHealth(PlayerPedId()) - 100),
        armor = GetPedArmour(PlayerPedId()),
        fuel = fuel,
      },
    })
    _toggled = true
    StartThreads()

    if GLOBAL_VEH ~= nil then
      Hud.Vehicle:Show()
    end
  end,
  Hide = function(self)
    if not _toggled then
      return
    end

    SendNUIMessage({
      action = "HIDE_HUD",
    })
    _toggled = false

    if Phone ~= nil and not Phone:IsOpen() then
      DisplayRadar(false)
    end
    Hud.Vehicle:Hide()
  end,
  XHair = function(self, state)
    SendNUIMessage({
      action = "ARMED",
      data = {
        state = state,
      },
    })
  end,
  Scope = function(self, state)
    if state then
      SendNUIMessage({
        action = "SHOW_SCOPE",
      })
    else
      SendNUIMessage({
        action = "HIDE_SCOPE",
      })
    end
  end,
  Toggle = function(self)
    SendNUIMessage({
      action = "TOGGLE_HUD",
    })
    _toggled = not _toggled
    if _toggled then
      StartThreads()

      if GLOBAL_VEH ~= nil then
        Hud.Vehicle:Show()
      else
        Hud.Vehicle:Hide()
      end
    else
      if Phone ~= nil and not Phone:IsOpen() then
        DisplayRadar(false)
      end
      Hud.Vehicle:Hide()
    end
  end,
  ShiftLocation = function(self, status)
    SendNUIMessage({
      action = "SHIFT_LOCATION",
      data = { shift = status },
    })
  end,
  Vehicle = {
    Show = function(self)
      if _vehToggled then
        return
      end

      SendNUIMessage({
        action = "SHOW_VEHICLE",
        data = {
          electric = false, --TODO: Make it dynamic
        }
      })
      _vehToggled = true
      StartVehicleThreads()
    end,
    Hide = function(self)
      if not _vehToggled then
        return
      end

      SendNUIMessage({
        action = "HIDE_VEHICLE",
      })
      _vehToggled = false
    end,
    Toggle = function(self)
      SendNUIMessage({
        action = "TOGGLE_VEHICLE",
      })
      _vehToggled = not _vehToggled
      if _vehToggled then
        StartVehicleThreads()
      end
    end,
  },
  RegisterStatus = function(self, name, current, max, icon, color, flash, update, options)
    local data = {
      name = name,
      max = max,
      value = current,
      icon = icon,
      color = color,
      flash = flash,
      options = options,
    }

    if update then
      SendNUIMessage({
        action = "UPDATE_STATUS",
        data = { status = data },
      })
    else
      SendNUIMessage({
        action = "REGISTER_STATUS",
        data = { status = data },
      })
      _statusCount = _statusCount + 1
    end

    _statuses[name] = data
  end,
  VOIP = function(self, talking, range, onRadio)
    SendNUIMessage({
      action = "UPDATE_VOIP_STATUS",
      data = {
        talking = talking,
        audioRange = range,
        talkingOnRadio = onRadio
      },
    })
  end,
  ResetStatus = function(self)
    SendNUIMessage({
      action = "RESET_STATUSES",
    })
  end,
  ID = {
    Toggle = function(self)
      if not _showingIds then
        if not _idsCd then
          ShowIds()
          _idsCd = true
          Citizen.SetTimeout(6000, function()
            HUD.ID:Toggle()
          end)
        end
      else
        _showingIds = false
        Citizen.SetTimeout(10000, function()
          _idsCd = false
        end)
      end
    end,
  },
  -- Minimap = {
  -- 	Set = function(self)
  -- 		SetRadarZoom(_zoomLevels[_zoomLevel])
  -- 	end,
  -- 	In = function(self)
  -- 		if _zoomLevel == 1 then
  -- 			_zoomLevel = #_zoomLevels
  -- 		else
  -- 			_zoomLevel = _zoomLevel - 1
  -- 		end
  -- 		SetResourceKvpInt("zoomLevel", _zoomLevel)
  -- 		SetRadarZoom(_zoomLevels[_zoomLevel])
  -- 	end,
  -- 	Out = function(self)
  -- 		if _zoomLevel == #_zoomLevels then
  -- 			_zoomLevel = 1
  -- 		else
  -- 			_zoomLevel = _zoomLevel + 1
  -- 		end
  -- 		SetResourceKvpInt("zoomLevel", _zoomLevel)
  -- 		SetRadarZoom(_zoomLevels[_zoomLevel])
  -- 	end,
  -- },
  Dead = function(self, state)
    SendNUIMessage({
      action = "SET_DEAD",
      data = {
        state = state,
      },
    })
  end,
  GemTable = {
    Open = function(self, quality)
      SendNUIMessage({
        action = "SHOW_GEM_TABLE",
        data = {
          info = quality
        }
      })
    end,
    Close = function(self)
      SendNUIMessage({
        action = "CLOSE_GEM_TABLE",
        data = {},
      })
    end
  },
  Meth = {
    Open = function(self, config)
      SetNuiFocus(true, true)
      SetNuiFocusKeepInput(false)
      SendNUIMessage({
        action = "OPEN_METH",
        data = {
          config = config,
        }
      })
    end,
    Close = function(self)
      SetNuiFocus(false, false)
      SetNuiFocusKeepInput(false)
      SendNUIMessage({
        action = "CLOSE_METH",
        data = {},
      })
    end,
  },
  DeathTexts = {
    Show = function(self, type, deathTime, timer, keyOverride)
      SendNUIMessage({
        action = "DO_DEATH_TEXT",
        data = {
          key = exports['hrrp-keybinds']:GetKey(keyOverride or "secondary_action") or 'Unknown',
          f1Key = exports['hrrp-keybinds']:GetKey(keyOverride or "show_interaction") or 'Unknown',
          type = type,
          deathTime = deathTime,
          timer = timer,
          medicalPrice = (not GlobalState["Duty:ems"] or GlobalState["Duty:ems"] == 0) and 150 or 5000
        },
      })
    end,
    Release = function(self)
      SendNUIMessage({
        action = "DO_DEATH_RELEASING",
        data = {},
      })
    end,
    Hide = function(self)
      SendNUIMessage({
        action = "HIDE_DEATH_TEXT",
        data = {},
      })
    end,
  },
  Flashbang = {
    Do = function(self, duration, strength)
      SendNUIMessage({
        action = "SET_FLASHBANGED",
        data = {
          duration = duration,
          strength = strength,
        }
      })
    end,
    End = function(self)
      SendNUIMessage({
        action = "CLEAR_FLASHBANGED",
      })
    end,
  }
}


local function exportHandler(exportName, func)
  AddEventHandler(('__cfx_export_%s_%s'):format(GetCurrentResourceName(), exportName), function(setCB)
    setCB(function(...)
      return func(HUD, ...)
    end)
  end)
end

local function createExportForObject(object, name)
  name = name or ""
  for k, v in pairs(object) do
    if type(v) == "function" then
      exportHandler(name .. k, v)
    elseif type(v) == "table" then
      createExportForObject(v, name .. k)
    end
  end
end

for k, v in pairs(HUD) do
  if type(v) == "function" then
    exportHandler(k, v)
  elseif type(v) == "table" then
    createExportForObject(v, k)
  end
end

AddEventHandler("Proxy:Shared:RegisterReady", function()
  exports["hrrp-base"]:RegisterComponent("Hud", HUD)
end)

function GetLocation()
  local pos = GetEntityCoords(LocalPlayer.state.ped)

  if LocalPlayer.state?.tpLocation then
    pos = vector3(
      LocalPlayer.state?.tpLocation.x,
      LocalPlayer.state?.tpLocation.y,
      LocalPlayer.state?.tpLocation.z
    )
  end

  local direction = GetDirection(GetEntityHeading(LocalPlayer.state.ped))
  local var1, var2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
  local area = GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z))

  return {
    main = GetStreetNameFromHashKey(var1),
    cross = GetStreetNameFromHashKey(var2),
    area = area,
    direction = direction,
  }
end

function GetDirection(heading)
  if (heading >= 0 and heading < 45) or (heading >= 315 and heading < 360) then
    return "N"
  elseif heading >= 45 and heading < 135 then
    return "W"
  elseif heading >= 135 and heading < 225 then
    return "S"
  elseif heading >= 225 and heading < 315 then
    return "E"
  end
end

function DrawText3D(position, text, r, g, b)
  local onScreen, _x, _y = World3dToScreen2d(position.x, position.y, position.z + 1)
  local dist = #(GetGameplayCamCoords() - position)

  local scale = (1 / dist) * 2
  local fov = (1 / GetGameplayCamFov()) * 100
  local scale = scale * fov

  if onScreen then
    if not useCustomScale then
      SetTextScale(0.0 * scale, 0.55 * scale)
    else
      SetTextScale(0.0 * scale, customScale)
    end
    SetTextFont(0)
    SetTextProportional(1)
    SetTextColour(r, g, b, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
  end
end

_showingIds = false
function ShowIds()
  _showingIds = true
  local nearPlayers = {}

  local showInvisible = LocalPlayer.state.isDev

  Citizen.CreateThread(function()
    while _showingIds do
      for _, data in ipairs(nearPlayers) do
        local targetPed = GetPlayerPed(data.id)
        if data.SID ~= nil and (IsEntityVisible(targetPed) or showInvisible) then
          DrawText3D(GetPedBoneCoords(targetPed, 0), data.SID, 255, 255, 255)
        end
      end
      Citizen.Wait(0)
    end
  end)

  Citizen.CreateThread(function()
    while _showingIds do
      nearPlayers = {}
      local playerCoords = GetEntityCoords(LocalPlayer.state.ped)

      if exports['hrrp-admin']:NoClipIsActive() then
        playerCoords = exports['hrrp-admin']:NoClipGetPos()
      end

      for _, id in ipairs(GetActivePlayers()) do
        local targetPed = GetPlayerPed(id)
        if DoesEntityExist(targetPed) then
          local source = GetPlayerServerId(id)
          local distance = #(
            vector3(playerCoords.x, playerCoords.y, playerCoords.z)
            - GetEntityCoords(targetPed)
          )
          if distance <= 25 and GlobalState[string.format("SID:%s", source)] ~= nil then
            table.insert(nearPlayers, {
              id = id,
              SID = GlobalState[string.format("SID:%s", source)],
              source = source,
              distance = distance,
            })
          end
        end
      end
      Wait(2000)
    end
  end)
end

function StartThreads()
  Citizen.CreateThread(function()
    while _toggled do
      if IsPauseMenuActive() and not _paused then
        _paused = true

        SendNUIMessage({
          action = "TOGGLE_HUD",
        })

        if _vehToggled then
          SendNUIMessage({
            action = "TOGGLE_VEHICLE",
          })
        end
      end

      if not _paused then
        Citizen.Wait(200)
        SendNUIMessage({
          action = "UPDATE_HP",
          data = {
            hp = (GetEntityHealth(LocalPlayer.state.ped) - 100),
            armor = GetPedArmour(LocalPlayer.state.ped),
          },
        })
        Citizen.Wait(200)
      else
        if not IsPauseMenuActive() then
          SendNUIMessage({
            action = "TOGGLE_HUD",
          })

          if _vehToggled then
            SendNUIMessage({
              action = "TOGGLE_VEHICLE",
            })
          end
          _paused = false
        end
        Citizen.Wait(400)
      end
    end
  end)
end

function StartVehicleThreads()
  if not _toggled then
    return
  end

  local class = GetVehicleClass(GLOBAL_VEH)

  if class == 8 or class == 13 or class == 14 or class == 15 or class == 16 then
    SendNUIMessage({
      action = "HIDE_SEATBELT",
    })
  else
    SendNUIMessage({
      action = "SHOW_SEATBELT",
    })
  end

  Citizen.CreateThread(function()
    DisplayRadar(true)
    while _vehToggled do
      local speed = math.ceil(GetEntitySpeed(GLOBAL_VEH) * 2.237)
      SendNUIMessage({
        action = "UPDATE_SPEED",
        data = { speed = speed },
      })

      local currRPM = GetVehicleCurrentRpm(GLOBAL_VEH)
      SendNUIMessage({
        action = "UPDATE_RPM",
        data = { rpm = currRPM },
      })

      SendNUIMessage({
        action = "UPDATE_GEAR",
        data = { gear = GetVehicleCurrentGear(GLOBAL_VEH) },
      })

      SendNUIMessage({
        action = "UPDATE_LOCATION",
        data = { location = GetLocation() },
      })
      Citizen.Wait(100)
    end

    DisplayRadar(false)
  end)

  if GetPedInVehicleSeat(GLOBAL_VEH, -1) ~= LocalPlayer.state.ped then
    Citizen.CreateThread(function()
      local lastIgnition = Entity(GLOBAL_VEH).state?.VEH_IGNITION
      while _vehToggled do
        Citizen.Wait(1000)

        if GLOBAL_VEH then
          local ignitionState = Entity(GLOBAL_VEH).state?.VEH_IGNITION
          if lastIgnition ~= ignitionState then
            lastIgnition = ignitionState

            SendNUIMessage({
              action = "UPDATE_IGNITION",
              data = { ignition = ignitionState },
            })
          end
        end
      end
    end)
  end

  if class ~= 13 then
    Citizen.CreateThread(function()
      while _vehToggled do
        local checkEngine = false

        if GLOBAL_VEH then
          local ent = Entity(GLOBAL_VEH)

          if class ~= 14 and class ~= 15 and class ~= 16 then
            local damageStuff = ent.state.DamagedParts or {}

            for k, v in pairs(damageStuff) do
              if type(v) == "number" and v < 25.0 then
                checkEngine = true
              end
            end
          end

          if GetVehicleEngineHealth(GLOBAL_VEH) <= 400.0 then
            checkEngine = true
          end
        end

        SendNUIMessage({
          action = "UPDATE_ENGINELIGHT",
          data = { checkEngine = checkEngine },
        })

        Citizen.Wait(10000)
      end
    end)
  else
    SendNUIMessage({
      action = "UPDATE_ENGINELIGHT",
      data = { checkEngine = false },
    })
  end
end

-- Citizen.CreateThread(function()
-- 	SetMapZoomDataLevel(0, 0.96, 0.9, 0.08, 0.0, 0.0) -- Level 0
-- 	SetMapZoomDataLevel(1, 1.6, 0.9, 0.08, 0.0, 0.0) -- Level 1
-- 	SetMapZoomDataLevel(2, 8.6, 0.9, 0.08, 0.0, 0.0) -- Level 2
-- 	SetMapZoomDataLevel(3, 12.3, 0.9, 0.08, 0.0, 0.0) -- Level 3
-- 	SetMapZoomDataLevel(4, 22.3, 0.9, 0.08, 0.0, 0.0) -- Level 4
-- end)

Citizen.CreateThread(function()
  SetRadarZoom(1200)
  ReplaceHudColourWithRgba(150, 255, 255, 255, 255)
  ReplaceHudColourWithRgba(151, 255, 255, 255, 255)
  ReplaceHudColourWithRgba(142, 255, 0, 0, 255)
  SetBlipAlpha(GetNorthRadarBlip(), 0)

  local minimap = RequestScaleformMovie("minimap")
  if not HasScaleformMovieLoaded(minimap) then
    RequestScaleformMovie(minimap)
    while not HasScaleformMovieLoaded(minimap) do
      Wait(1)
    end
  end

  RequestStreamedTextureDict("squaremap", false)
  if not HasStreamedTextureDictLoaded("squaremap") then
    Wait(150)
  end

  -- local defaultAspectRatio = 1920/1080 -- Don't change this.
  local defaultAspectRatio = GetAspectRatio(0)
  local resolutionX, resolutionY = GetActiveScreenResolution()

  print(defaultAspectRatio, resolutionX, resolutionY)

  local aspectRatio = resolutionX / resolutionY
  local minimapOffset = 0
  if aspectRatio > defaultAspectRatio then
    minimapOffset = ((defaultAspectRatio - aspectRatio) / 3.6) - 0.008
  end

  SetMinimapClipType(0)
  AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "squaremap", "radarmasksm")
  AddReplaceTexture("platform:/textures/graphics", "radarmask1g", "squaremap", "radarmasksm")
  -- 0.0 = nav symbol and icons left
  -- 0.1638 = nav symbol and icons stretched
  -- 0.216 = nav symbol and icons raised up
  SetMinimapComponentPosition("minimap", "L", "B", 0.0 + minimapOffset, -0.047, 0.1638, 0.233)

  -- icons within map
  SetMinimapComponentPosition("minimap_mask", "L", "B", 0.0 + minimapOffset, 0.0, 0.128, 0.20)

  -- -0.01 = map pulled left
  -- 0.025 = map raised up
  -- 0.262 = map stretched
  -- 0.315 = map shorten
  SetMinimapComponentPosition('minimap_blur', 'L', 'B', -0.01 + minimapOffset, 0.025, 0.262, 0.350)
  SetBlipAlpha(GetNorthRadarBlip(), 0)
  SetRadarBigmapEnabled(true, false)
  SetMinimapClipType(0)
  Wait(50)
  SetRadarBigmapEnabled(false, false)

  -- DisplayRadar(true)
end)

-- Minimap update
CreateThread(function()
  while true do
    SetRadarBigmapEnabled(false, false)
    SetRadarZoom(1000)
    Wait(500)
  end
end)


-- function DoRadarFix()
-- 	Citizen.CreateThread(function()
-- 		Citizen.Wait(300)
-- 		SetRadarZoom(_zoomLevels[6])
-- 		Citizen.Wait(300)
-- 		SetRadarZoom(_zoomLevels[4])
-- 		Citizen.Wait(300)
-- 		SetRadarZoom(_zoomLevels[1])
-- 		Citizen.Wait(300)
-- 		SetRadarZoom(_zoomLevels[_zoomLevel])
-- 	end)
-- end


--[[
    MINIMAP ANCHOR BY GLITCHDETECTOR (Feb 16 2018 version)
    Modify and redistribute as you please, just keep the original credits in.
    You're free to distribute this in any project where it's used.
]]

--[[
    Returns a Minimap object with the following details:
    x, y: Top left origin of minimap
    width, height: Size of minimap (not pixels!)
    left_x, right_x: Left and right side of minimap on x axis
    top_y, bottom_y: Top and bottom side of minimap on y axis
]]
-- function GetMinimapAnchor()
--   -- Safezone goes from 1.0 (no gap) to 0.9 (5% gap (1/20))
--   -- 0.05 * ((safezone - 0.9) * 10)
--   local safezone = GetSafeZoneSize()
--   local safezone_x = 1.0 / 20.0
--   local safezone_y = 1.0 / 20.0
--   local aspect_ratio = GetAspectRatio(0)
--   local res_x, res_y = GetActiveScreenResolution()
--   local xscale = 1.0 / res_x
--   local yscale = 1.0 / res_y
--   local Minimap = {}
--   Minimap.width = xscale * (res_x / (3.95 * aspect_ratio))
--   -- Minimap.height = yscale * (res_y / 5.674)
--   Minimap.height = yscale * (res_y / 6.15)
--   Minimap.left_x = xscale * (res_x * (safezone_x * ((math.abs(safezone - 1.0)) * 10)))
--   Minimap.bottom_y = 1.0 - yscale * (res_y * (safezone_y * ((math.abs(safezone - 1.0)) * 20)))
--   Minimap.right_x = Minimap.left_x + Minimap.width
--   Minimap.top_y = Minimap.bottom_y - Minimap.height
--   Minimap.x = Minimap.left_x
--   Minimap.y = Minimap.top_y
--   Minimap.xunit = xscale
--   Minimap.yunit = yscale
--   return Minimap
-- end

-- function drawRct(x, y, width, height, r, g, b, a)
--   DrawRect(x + width / 2, y + height / 2, width, height, r, g, b, a)
-- end

-- Citizen.CreateThread(function()
--   Wait(500)
--   local ui = GetMinimapAnchor()

--   print(ui.width)

--   SetScriptGfxAlign(string.byte('L'), string.byte('B'))
--   local minimapTopX, minimapTopY = GetScriptGfxPosition(-0.0045, 0.002 + (-0.188888))
--   ResetScriptGfxAlign()
--   local w, h = GetActiveScreenResolution()
--   -- return { w * minimapTopX, h * minimapTopY }
--   print(w * minimapTopX, h * minimapTopY)


--   while true do
--     Wait(0)
--     local thickness = 4 -- Defines how many pixels wide the border is
--     drawRct(ui.x, ui.y, ui.width, thickness * ui.yunit, 0, 0, 0, 255)
--     drawRct(ui.x, ui.y + ui.height, ui.width, -thickness * ui.yunit, 0, 0, 0, 255)
--     drawRct(ui.x, ui.y, thickness * ui.xunit, ui.height, 0, 0, 0, 255)
--     drawRct(ui.x + ui.width, ui.y, -thickness * ui.xunit, ui.height, 0, 0, 0, 255)
--   end
-- end)
