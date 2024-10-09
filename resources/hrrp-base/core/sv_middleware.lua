local _middlewares = {}

AddEventHandler('onResourceStop', function(resource)
  if COMPONENTS.Proxy.ExportsReady then
    if resource ~= GetCurrentResourceName() then
      -- _middlewares = {}
      for index, events in pairs(_middlewares) do
        for eventIndex, eventData in pairs(events) do
          if eventData.resource == resource then
            table.remove(_middlewares[index], eventIndex)
          end
        end
      end
    end
  end
end)

COMPONENTS.Middleware = {
  TriggerEvent = function(self, event, source, ...)
    if _middlewares[event] then
      table.sort(_middlewares[event], function(a, b) return a.prio < b.prio end)

      -- print(json.encode(_middlewares[event], { indent = true }))

      for k, v in pairs(_middlewares[event]) do
        v.cb(source, ...)
      end
    end
  end,
  TriggerEventWithData = function(self, event, source, ...)
    if _middlewares[event] then
      -- Making bold assumption this is only going to be done with data you want inserted into a table
      local data = {}
      table.sort(_middlewares[event], function(a, b) return a.prio < b.prio end)
      for k, v in pairs(_middlewares[event]) do
        for k2, v2 in ipairs(v.cb(source, ...)) do
          v2.ID = #data + 1
          table.insert(data, v2)
        end
      end
      table.sort(data, function(a, b) return a.ID < b.ID end)
      return data
    end
  end,
  Add = function(self, event, cb, prio)
    if prio == nil then
      prio = 1
    end

    if _middlewares[event] == nil then
      _middlewares[event] = {}
    end

    table.insert(_middlewares[event], { cb = cb, prio = prio, resource = GetInvokingResource() })
  end
}

local function exportHandler(exportName, func)
  AddEventHandler(('__cfx_export_%s_%s'):format(GetCurrentResourceName(), exportName), function(setCB)
    setCB(function(...)
      return func(COMPONENTS.Middleware, ...)
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

for k, v in pairs(COMPONENTS.Middleware) do
  if type(v) == "function" then
    exportHandler("Middleware" .. k, v)
  elseif type(v) == "table" then
    createExportForObject(v, "Middleware" .. k)
  end
end
