COMPONENTS.Notifications = {
  _name = 'base',
  Hint = {
    ShowThisFrame = function(message)
      BeginTextCommandDisplayHelp('STRING')
      AddTextComponentSubstringPlayerName(message)
      EndTextCommandDisplayHelp(0, false, true, -1)
    end
  }
}

local function exportHandler(exportName, func)
  AddEventHandler(('__cfx_export_%s_%s'):format(GetCurrentResourceName(), exportName), function(setCB)
    setCB(function(...)
      return func(COMPONENTS.Notifications, ...)
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

for k, v in pairs(COMPONENTS.Notifications) do
  if type(v) == "function" then
    exportHandler("Notifications" .. k, v)
  elseif type(v) == "table" then
    createExportForObject(v, "Notifications" .. k)
  end
end
