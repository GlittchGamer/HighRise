COMPONENTS.Convar = {
  DISCORD_APP = { value = GetConvar('discord_app', '') },
  MAX_CLIENTS = { value = tonumber(GetConvar('sv_maxclients', '32')) },
  LOGGING = { value = tonumber(GetConvar('log_level', 0)) },
  MFW_VERSION = { value = GetConvar('mfw_version', "UNKNOWN") },
}

local function exportHandler(exportName, func)
  AddEventHandler(('__cfx_export_%s_%s'):format(GetCurrentResourceName(), exportName), function(setCB)
    setCB(function(...)
      return func(COMPONENTS.Convar, ...)
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

for k, v in pairs(COMPONENTS.Convar) do
  if type(v) == "function" then
    exportHandler("Convar" .. k, v)
  elseif type(v) == "table" then
    createExportForObject(v, "Convar" .. k)
  end
end
