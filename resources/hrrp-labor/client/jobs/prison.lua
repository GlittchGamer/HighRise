local _joiner = nil
local _working = false
local _state = nil
local _nodes = nil
local eventHandlers = {}

AddEventHandler("Labor:Client:Setup", function() end)

RegisterNetEvent("Prison:Client:OnDuty", function(joiner, time)
  _working = true
  _joiner = joiner
  _state = 0

  eventHandlers["receive"] = RegisterNetEvent(string.format("Prison:Client:%s:Receive", joiner), function(data)
    _nodes = data
    _state = 1

    for k, v in ipairs(_nodes.locations) do
      local id = string.format("PrisonNode%s", v.data.id)

      exports['hrrp-blips']:Add(id, data.blip.name, v.coords, data.blip.sprite or 188, data.blip.color or 56, 0.8)
      if v.type == "box" then
        exports['ox_target']:TargetingZonesAddBox(id, "box-open-full", v.coords, v.length, v.width, v.options, {
          {
            icon = "hand-middle-finger",
            text = data.action,
            event = string.format("Labor:Client:%s:Action", joiner),
            data = v.data,
            tempjob = "Prison",
            isEnabled = function(data)
              return _working and _state == 1
            end,
          },
        }, 3.0, true)
      elseif v.type == "circle" then
        exports['ox_target']:TargetingZonesAddCircle(id, "box-open-full", v.coords, v.radius, v.options, {
          {
            icon = "hand-middle-finger",
            text = data.action,
            event = string.format("Labor:Client:%s:Action", joiner),
            data = v.data,
            tempjob = "Prison",
            isEnabled = function(data)
              return _working and _state == 1
            end,
          },
        }, 3.0, true)
      elseif v.type == "poly" then
        exports['ox_target']:TargetingZonesAddPoly(id, "box-open-full", v.points, v.options, {
          {
            icon = "hand-middle-finger",
            text = data.action,
            event = string.format("Labor:Client:%s:Action", joiner),
            data = v.data,
            tempjob = "Prison",
            isEnabled = function(data)
              return _working and _state == 1
            end,
          },
        }, 3.0, true)
      end
    end
  end)

  eventHandlers["action"] = AddEventHandler(string.format("Labor:Client:%s:Action", joiner), function(ent, data)
    Progress:Progress({
      name = "prison_action",
      duration = data.duration,
      label = data.label,
      useWhileDead = false,
      canCancel = true,
      controlDisables = {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
      },
      animation = data.animation,
    }, function(status)
      if not status then
        exports["hrrp-base"]:CallbacksServer("Prison:Action", data.id, function(s)
          local id = string.format("PrisonNode%s", data.id)
          exports['ox_target']:TargetingZonesRemoveZone(id)
          exports['hrrp-blips']:Remove(id)
        end)
      end
    end)
  end)

  eventHandlers["cleanup"] = AddEventHandler(string.format("Labor:Client:%s:Cleanup", joiner), function()
    if _nodes ~= nil then
      for k, v in ipairs(_nodes.locations) do
        local id = string.format("PrisonNode%s", v.id)
        exports['ox_target']:TargetingZonesRemoveZone(id)
        exports['hrrp-blips']:Remove(id)
      end
    end

    _nodes = nil
    _state = 0
  end)
end)

AddEventHandler("Prison:Client:StartJob", function()
  exports["hrrp-base"]:CallbacksServer("Prison:StartJob", _joiner, function(state)
    if not state then
      exports['hrrp-hud']:NotificationError("Unable To Start Job")
    end
  end)
end)

RegisterNetEvent("Prison:Client:OffDuty", function(time)
  for k, v in pairs(eventHandlers) do
    RemoveEventHandler(v)
  end

  if _nodes ~= nil then
    for k, v in ipairs(_nodes.locations) do
      local id = string.format("PrisonNode%s", v.id)
      exports['ox_target']:TargetingZonesRemoveZone(id)
      exports['hrrp-blips']:Remove(id)
    end
  end

  _joiner = nil
  _working = false
  _nodes = nil
  _state = nil
  eventHandlers = {}
end)
