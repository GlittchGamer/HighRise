COMPONENTS.Config = {
  Discord = {
    Server = "940921960060293120",
  },
  Groups = {},
  Server = {
    ID = os.time(),
    Name = "Server Name",
    Access = GetConvar('sv_access_role', 0),
  }
}


local function exportHandler(exportName, func)
  AddEventHandler(('__cfx_export_%s_%s'):format(GetCurrentResourceName(), exportName), function(setCB)
    setCB(function(...)
      return func(COMPONENTS.Config, ...)
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

for k, v in pairs(COMPONENTS.Config) do
  if type(v) == "function" then
    exportHandler("Config" .. k, v)
  elseif type(v) == "table" then
    createExportForObject(v, "Config" .. k)
  end
end
