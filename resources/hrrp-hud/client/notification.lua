Notification = {
  Clear = function(self)
    SendNUIMessage({
      action = "CLEAR_ALERTS",
    })
  end,
  Success = function(self, message, duration, icon)
    if duration == nil then
      duration = 2500
    end

    SendNUIMessage({
      action = "ADD_ALERT",
      data = {
        notification = {
          type = "success",
          message = message,
          duration = duration,
          icon = icon,
        },
      },
    })
  end,
  Warn = function(self, message, duration, icon)
    if duration == nil then
      duration = 2500
    end

    SendNUIMessage({
      action = "ADD_ALERT",
      data = {
        notification = {
          type = "warning",
          message = message,
          duration = duration,
          icon = icon,
        },
      },
    })
  end,
  Error = function(self, message, duration, icon)
    if duration == nil then
      duration = 2500
    end

    SendNUIMessage({
      action = "ADD_ALERT",
      data = {
        notification = {
          type = "error",
          message = message,
          duration = duration,
          icon = icon,
        },
      },
    })
  end,
  Info = function(self, message, duration, icon)
    if duration == nil then
      duration = 2500
    end

    SendNUIMessage({
      action = "ADD_ALERT",
      data = {
        notification = {
          type = "info",
          message = message,
          duration = duration,
          icon = icon,
        },
      },
    })
  end,
  Standard = function(self, message, duration, icon)
    if duration == nil then
      duration = 2500
    end

    SendNUIMessage({
      action = "ADD_ALERT",
      data = {
        notification = {
          type = "standard",
          message = message,
          duration = duration,
          icon = icon,
        },
      },
    })
  end,
  Custom = function(self, message, duration, icon, style)
    if duration == nil then
      duration = 2500
    end

    SendNUIMessage({
      action = "ADD_ALERT",
      data = {
        notification = {
          type = "custom",
          message = message,
          duration = duration,
          icon = icon,
          style = style,
        },
      },
    })
  end,
  Persistent = {
    Success = function(self, id, message, icon)
      SendNUIMessage({
        action = "ADD_ALERT",
        data = {
          notification = {
            _id = id,
            type = "success",
            message = message,
            duration = -1,
            icon = icon,
          },
        },
      })
    end,
    Warn = function(self, id, message, icon)
      SendNUIMessage({
        action = "ADD_ALERT",
        data = {
          notification = {
            _id = id,
            type = "warning",
            message = message,
            duration = -1,
            icon = icon,
          },
        },
      })
    end,
    Error = function(self, id, message, icon)
      SendNUIMessage({
        action = "ADD_ALERT",
        data = {
          notification = {
            _id = id,
            type = "error",
            message = message,
            duration = -1,
            icon = icon,
          },
        },
      })
    end,
    Info = function(self, id, message, icon)
      SendNUIMessage({
        action = "ADD_ALERT",
        data = {
          notification = {
            _id = id,
            type = "info",
            message = message,
            duration = -1,
            icon = icon,
          },
        },
      })
    end,
    Standard = function(self, id, message, icon)
      SendNUIMessage({
        action = "ADD_ALERT",
        data = {
          notification = {
            _id = id,
            type = "standard",
            message = message,
            duration = -1,
            icon = icon,
          },
        },
      })
    end,
    Custom = function(self, id, message, icon, style)
      SendNUIMessage({
        action = "ADD_ALERT",
        data = {
          notification = {
            _id = id,
            type = "custom",
            message = message,
            duration = -1,
            icon = icon,
            style = style,
          },
        },
      })
    end,
    Remove = function(self, id)
      SendNUIMessage({
        action = "HIDE_ALERT",
        data = {
          id = id,
        },
      })
    end,
  },
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
  exports["hrrp-base"]:RegisterComponent("Notification", Notification)
end)


local function exportHandler(exportName, func)
  AddEventHandler(('__cfx_export_%s_%s'):format(GetCurrentResourceName(), exportName), function(setCB)
    setCB(function(...)
      return func(Notification, ...)
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

for k, v in pairs(Notification) do
  if type(v) == "function" then
    exportHandler("Notification" .. k, v)
  elseif type(v) == "table" then
    createExportForObject(v, "Notification" .. k)
  end
end
