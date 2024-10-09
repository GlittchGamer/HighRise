blips = {}

AddEventHandler('Blips:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
  Logger = exports['hrrp-base']:FetchComponent('Logger')
  Blips = exports['hrrp-base']:FetchComponent('Blips')
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['hrrp-base']:RequestDependencies('Blips', {
    'Logger',
    'Blips',
  }, function(error)
    if #error > 0 then
      return;
    end
    RetrieveComponents()

    RemoveEventHandler(setupEvent)
  end)
end)

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler("Characters:Client:Logout", function()
  exports['hrrp-blips']:RemoveAll()
end)

BLIPS = {
  Add = function(self, id, name, coords, sprite, colour, scale, display, category, flashes)
    if coords == nil then
      exports['hrrp-base']:LoggerError('Blips', "Coords needed for Blip")
      return
    end

    if type(coords) == 'table' and coords.x ~= nil then
      coords = vector3(coords.x, coords.y, coords.z)
    else
      coords = vector3(coords[1], coords[2], coords[3])
    end

    if blips[id] ~= nil then
      exports['hrrp-blips']:Remove(id)
    end

    local _blip = AddBlipForCoord(coords)
    SetBlipSprite(_blip, sprite or 1)
    SetBlipAsShortRange(_blip, true)
    SetBlipDisplay(_blip, display and display or 2)
    SetBlipScale(_blip, scale or 0.55)
    SetBlipColour(_blip, colour or 1)
    SetBlipFlashes(_blip, flashes)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name or 'Name Missing')
    EndTextCommandSetBlipName(_blip)
    if category then
      SetBlipCategory(_blip, category)
    end

    blips[id] = {
      blip = _blip,
      coords = coords
    }

    return _blip
  end,
  Remove = function(self, id)
    if blips[id] == nil then return end
    RemoveBlip(blips[id].blip)
    blips[id] = nil
  end,
  RemoveAll = function(self)
    for k, v in pairs(blips) do
      RemoveBlip(blips[k].blip)
      blips[k] = nil
    end
  end,
  SetMarker = function(self, id)
    local blip = blips[id]
    SetNewWaypoint(blip.coords.x, blip.coords.y)
  end
}

AddEventHandler('Proxy:Shared:RegisterReady', function() --! Completed
  exports['hrrp-base']:RegisterComponent('Blips', BLIPS)
end)

local function exportHandler(exportName, func)
  AddEventHandler(('__cfx_export_%s_%s'):format(GetCurrentResourceName(), exportName), function(setCB)
    setCB(function(...)
      return func(BLIPS, ...)
    end)
  end)
end

for k, v in pairs(BLIPS) do
  if type(v) == "function" then
    exportHandler(k, v)
  end
end


Citizen.CreateThread(function()
  AddTextEntry("BLIP_PROPCAT", "Garage")
  AddTextEntry("BLIP_APARTCAT", "Business")
  AddTextEntry("BLIP_OTHPLYR", "Units")
end)
