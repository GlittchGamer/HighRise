ACTION = {
  Show = function(self, message, duration)
    local formattedMessage = string.gsub(message, "{keybind}([A-Za-z!\"#$%&'()*+,-./[\\%]^_`|~]+){/keybind}",
      function(key)
        local keyName = exports['hrrp-keybinds']:GetKey(key) or 'Unknown'
        return '{key}' .. keyName .. '{/key}'
      end)

    SendNUIMessage({
      action = 'SHOW_ACTION',
      data = {
        message = formattedMessage
      }
    })
  end,
  Hide = function(self)
    SendNUIMessage({
      action = 'HIDE_ACTION'
    })
  end
}

AddEventHandler('Proxy:Shared:RegisterReady', function() --!Completed
  exports['hrrp-base']:RegisterComponent('Action', ACTION)
end)

local function exportHandler(exportName, func)
  AddEventHandler(('__cfx_export_%s_%s'):format(GetCurrentResourceName(), exportName), function(setCB)
    setCB(function(...)
      return func(ACTION, ...)
    end)
  end)
end

for k, v in pairs(ACTION) do
  if type(v) == "function" then
    exportHandler('Action' .. k, v)
  end
end
