COMPONENTS.Execute = {
  _name = "base",
  Client = function(self, source, component, method, ...)
    TriggerClientEvent("Execute:Client:Component", source, component, method, ...)
  end,
}

RegisterNetEvent("Execute:Server:Log", function(component, method, ...)
  local src = source
end)


--For nested
local function exportHandler(exportName, func)
  AddEventHandler(('__cfx_export_%s_%s'):format(GetCurrentResourceName(), exportName), function(setCB)
    setCB(function(...)
      return func(COMPONENTS.Execute, ...)
    end)
  end)
end

for k, v in pairs(COMPONENTS.Execute) do
  if type(v) == "function" then
    exportHandler('Execute' .. k, v)
  end
end
