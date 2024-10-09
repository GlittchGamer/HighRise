local characterLoaded = false
local addedZones = {}
local wCombozone

local polyDebug = false

AddEventHandler("Polyzone:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Logger = exports["hrrp-base"]:FetchComponent("Logger")
  Callbacks = exports["hrrp-base"]:FetchComponent("Callbacks")
  Game = exports["hrrp-base"]:FetchComponent("Game")
  Utils = exports["hrrp-base"]:FetchComponent("Utils")
  Polyzone = exports["hrrp-base"]:FetchComponent("Polyzone")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports["hrrp-base"]:RequestDependencies("Polyzone", {
    "Logger",
    "Callbacks",
    "Game",
    "Utils",
    "Polyzone",
  }, function(error)
    if #error > 0 then
      return
    end -- Do something to handle if not all dependencies loaded
    RetrieveComponents()

    exports["hrrp-base"]:CallbacksRegisterClient("exports['hrrp-polyzone']:PolyZoneGetZoneAtCoords", function(data, cb)
      cb(exports['hrrp-polyzone']:PolyZoneGetZoneAtCoords(data))
    end)

    exports["hrrp-base"]:CallbacksRegisterClient("exports['hrrp-polyzone']:PolyZoneGetZonePlayerIn", function(data, cb)
      local c = GetEntityCoords(LocalPlayer.state.ped)
      cb(exports['hrrp-polyzone']:PolyZoneGetZoneAtCoords(vector3(c.x, c.y, c.z)))
    end)

    exports["hrrp-base"]:CallbacksRegisterClient("exports['hrrp-polyzone']:PolyZoneGetAllZonesAtCoords", function(data, cb)
      cb(exports['hrrp-polyzone']:PolyZoneGetAllZonesAtCoords(data))
    end)

    exports["hrrp-base"]:CallbacksRegisterClient("exports['hrrp-polyzone']:PolyZoneGetAllZonesPlayerIn", function(data, cb)
      local c = GetEntityCoords(LocalPlayer.state.ped)
      cb(exports['hrrp-polyzone']:PolyZoneGetAllZonesAtCoords(vector3(c.x, c.y, c.z)))
    end)

    exports["hrrp-base"]:CallbacksRegisterClient("exports['hrrp-polyzone']:PolyZoneIsCoordsInZone", function(data, cb)
      cb(exports['hrrp-polyzone']:PolyZoneIsCoordsInZone(data.coords, data.id, data.key, data.val))
    end)

    RemoveEventHandler(setupEvent)
  end)
end)

RegisterNetEvent('Characters:Client:Spawn')
AddEventHandler('Characters:Client:Spawn', function()
  characterLoaded = true
  InitWrapperZones()
end)

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
  characterLoaded = false
  for k, v in pairs(addedZones) do
    TriggerEvent('Polyzone:Exit', k, false, false, v.data or {})
  end
  polyDebug = false
  TriggerEvent('Targeting:Client:PolyzoneDebug', false)
  if wCombozone then
    wCombozone:destroy()
    wCombozone = nil
    exports['hrrp-base']:LoggerTrace('Polyzone', 'Destroyed All Polyzones (Character Logout)')
  end
end)

function CreateZoneForCombo(id, data)
  local options = data.options
  options.name = id
  options.data = (type(data.data) == 'table' and data.data or {})
  options.data.id = id

  if data.type == 'circle' then
    return CircleZone:Create(data.center, data.radius, data.options)
  elseif data.type == 'poly' then
    return PolyZone:Create(data.points, data.options)
  elseif data.type == 'box' then
    return BoxZone:Create(data.center, data.length, data.width, data.options)
  end
end

function InitWrapperZones()
  if wCombozone then return end

  local createdZones = {}

  for k, v in pairs(addedZones) do
    local zone = CreateZoneForCombo(k, v)
    table.insert(createdZones, zone)
  end

  exports['hrrp-base']:LoggerTrace('Polyzone', string.format('Initialized %s Simple Polyzones', #createdZones))

  wCombozone = ComboZone:Create(createdZones, {
    name = 'wrapper_combo',
  })

  wCombozone:onPlayerInOutExhaustive(function(isPointInside, testedPoint, insideZones, enteredZones, leftZones)
    if not characterLoaded then return end

    if enteredZones then
      for id, zone in ipairs(enteredZones) do
        if zone.data and zone.data.id then
          TriggerEvent('Polyzone:Enter', zone.data.id, testedPoint, insideZones, zone.data)
        end
      end
    end

    if leftZones then
      for id, zone in ipairs(leftZones) do
        if zone.data and zone.data.id then
          TriggerEvent('Polyzone:Exit', zone.data.id, testedPoint, insideZones, zone.data)
        end
      end
    end
  end)
end

function AddZoneAfterCreation(id, zoneData)
  if not wCombozone then return; end
  local zone = CreateZoneForCombo(id, zoneData)
  wCombozone:AddZone(zone)
end

_POLYZONE = {
  Create = {
    Box = function(self, id, center, length, width, options, data)
      local existingZone = addedZones[id]

      if existingZone and wCombozone then
        exports['hrrp-polyzone']:PolyZoneRemove(id)
        Citizen.Wait(100)
      end

      addedZones[id] = {
        id = id,
        type = 'box',
        center = center,
        width = width,
        length = length,
        options = options,
        data = data,
      }

      AddZoneAfterCreation(id, addedZones[id])
    end,
    Poly = function(self, id, points, options, data)
      local existingZone = addedZones[id]

      if existingZone and wCombozone then
        exports['hrrp-polyzone']:PolyZoneRemove(id)
        Citizen.Wait(100)
      end

      addedZones[id] = {
        id = id,
        type = 'poly',
        points = points,
        options = options,
        data = data,
      }

      AddZoneAfterCreation(id, addedZones[id])
    end,
    Circle = function(self, id, center, radius, options, data)
      local existingZone = addedZones[id]

      if existingZone and wCombozone then
        exports['hrrp-polyzone']:PolyZoneRemove(id)
        Citizen.Wait(100)
      end

      addedZones[id] = {
        id = id,
        type = 'circle',
        center = center,
        radius = radius,
        options = options,
        data = data,
      }

      AddZoneAfterCreation(id, addedZones[id])
    end,
  },
  Remove = function(self, id)
    if addedZones[id] then
      if wCombozone then
        wCombozone:RemoveZone(id)
        TriggerEvent('Polyzone:Exit', id, false, false, addedZones[id].data or {})
      end
      addedZones[id] = nil
    end
    return false
  end,
  Get = function(self, id)
    return addedZones[id]
  end,
  -- !! WARNING WON'T WORK FOR OVERLAPPING ZONES SO BETTER OFF NOT USING IT !!
  GetZoneAtCoords = function(self, coords)
    if not wCombozone then return false end
    local isInside, insideZone = wCombozone:isPointInside(coords)
    if isInside and insideZone and insideZone.data then
      return insideZone.data
    end
    return false
  end,
  GetAllZonesAtCoords = function(self, coords)
    local withinZonesData = {}
    local isInside, insideZones = wCombozone:isPointInsideExhaustive(coords)
    if isInside and insideZones and #insideZones > 0 then
      for k, v in ipairs(insideZones) do
        table.insert(withinZonesData, v.data)
      end
    end
    return withinZonesData
  end,
  IsCoordsInZone = function(self, coords, id, key, val)
    local isInside, insideZones = wCombozone:isPointInsideExhaustive(coords)
    if isInside and insideZones and #insideZones > 0 then
      for k, v in ipairs(insideZones) do
        if (not id or v.data.id == id) and (not key or ((val == nil and v.data[key]) or (val ~= nil and v.data[key] == val))) then
          return v.data
        end
      end
    end
    return false
  end,
}

AddEventHandler('Proxy:Shared:RegisterReady', function() --!Completed
  exports['hrrp-base']:RegisterComponent('Polyzone', _POLYZONE)
end)

local function exportHandler(exportName, func)
  AddEventHandler(('__cfx_export_%s_%s'):format(GetCurrentResourceName(), exportName), function(setCB)
    setCB(function(...)
      return func(_POLYZONE, ...)
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

for k, v in pairs(_POLYZONE) do
  if type(v) == "function" then
    exportHandler("PolyZone" .. k, v)
  elseif type(v) == "table" then
    createExportForObject(v, "PolyZone" .. k)
  end
end


RegisterNetEvent('Polyzone:Client:ToggleDebug', function()
  polyDebug = not polyDebug

  TriggerEvent('Targeting:Client:PolyzoneDebug', polyDebug)
  -- if polyDebug and LocalPlayer.state.isAdmin then
  if polyDebug then
    exports['hrrp-base']:LoggerWarn('Polyzone', 'Polyzone Debug Enabled')
    Citizen.CreateThread(function()
      while polyDebug do
        if wCombozone then
          wCombozone:draw()
        else
          Citizen.Wait(500)
        end
        Citizen.Wait(0)
      end
    end)
  end
end)

-- ## Exports for PolyZone because some scripts can't run them base
