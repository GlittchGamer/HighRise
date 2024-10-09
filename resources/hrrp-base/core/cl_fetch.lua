COMPONENTS.Fetch = {
  _required = { 'Player' },
  _name = 'base',
  Player = function(self)
    return COMPONENTS.Player.LocalPlayer
  end,
  Character = function(self)
    return COMPONENTS.Player.LocalPlayer:GetData('Character')
  end,
}

local function exportHandler(exportName, func)
  AddEventHandler(('__cfx_export_%s_%s'):format(GetCurrentResourceName(), exportName), function(setCB)
    setCB(function(...)
      return func(COMPONENTS.Fetch, ...)
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

for k, v in pairs(COMPONENTS.Fetch) do
  if type(v) == "function" then
    exportHandler("Fetch" .. k, v)
  elseif type(v) == "table" then
    createExportForObject(v, "Fetch" .. k)
  end
end
