AddEventHandler('Proxy:Shared:RegisterReady', function() --!Completed
  exports['core']:RegisterComponent('EntityTypes', ENTITYTYPES)
end)

ENTITYTYPES = {
  Get = function(self, cb)
    MySQL.query('SELECT * FROM entitytypes', {}, function(results)
      if not results then return end
      cb(results)
    end)
  end,
  GetID = function(self, id, cb)
    cb(LoadedEntitys[id])
  end
}

local function exportHandler(exportName, func)
  AddEventHandler(('__cfx_export_%s_%s'):format(GetCurrentResourceName(), exportName), function(setCB)
    setCB(function(...)
      return func(ENTITYTYPES, ...)
    end)
  end)
end

for k, v in pairs(ENTITYTYPES) do
  if type(v) == "function" then
    exportHandler('EntityTypes' .. k, v)
  end
end
