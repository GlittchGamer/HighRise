COMPONENTS.Game = {
  _protected = true,
  _name = 'base',
}

COMPONENTS.Game = {
  Objects = {
    Spawn = function(self, coords, modelName, heading)
      local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))
      local obj = CreateObject(model, coords.x, coords.y, coords.z, true, false, true)
      SetEntityHeading(obj, heading)
      return obj
    end,
    Delete = function(self, obj)
      DeleteObject(obj)
    end
  }
}

local function exportHandler(exportName, func)
  AddEventHandler(('__cfx_export_%s_%s'):format(GetCurrentResourceName(), exportName), function(setCB)
    setCB(function(...)
      return func(COMPONENTS.Game, ...)
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

for k, v in pairs(COMPONENTS.Game) do
  if type(v) == "function" then
    exportHandler("Game" .. k, v)
  elseif type(v) == "table" then
    createExportForObject(v, "Game" .. k)
  end
end
