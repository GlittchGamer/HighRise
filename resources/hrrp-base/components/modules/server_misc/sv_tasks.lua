local _tasks = {}
local started = false

AddEventHandler("Proxy:Shared:RegisterReady", function()
  if not started then
    started = true
    TaskTick()
  end
end)

function TaskTick()
  for k, v in pairs(_tasks) do
    if v.pause or v.skip then
      if v.skip then
        v.skip = false
      end
    else
      if v.tick >= (v.timer - 1) then
        v.callback(v.data)
        v.tick = 0
      else
        v.tick = v.tick + 1
      end
    end
  end

  Citizen.SetTimeout(60000, TaskTick)
end

COMPONENTS.Tasks = {
  Register = function(self, id, timer, cb, data, firstTick)
    if _tasks[id] ~= nil then
      COMPONENTS.Logger:Warn("Tasks", "Overriding Already Existing Task: " .. id)
    else
      COMPONENTS.Logger:Trace(
        "Tasks",
        "Registering New Task: ^2" .. id .. "^7 To Execute Every ^3" .. timer .. " Minutes^7"
      )
    end

    _tasks[id] = {
      id = id,
      timer = timer,
      tick = firstTick or 0,
      pause = false,
      skip = false,
      callback = cb,
      data = data,
    }
  end,
  Delete = function(self, id)
    if _tasks[id] ~= nil then
      _tasks[id] = nil
    else
      COMPONENTS.Logger:Warn("Tasks", "Attempt To Delete Non-Existing Task: " .. id)
    end
  end,
  Pause = function(self, id)
    if _tasks[id] ~= nil then
      _tasks[id].pause = true
    else
      COMPONENTS.Logger:Warn("Tasks", "Attempt To Pause Non-Existing Task: " .. id)
    end
  end,
  Resume = function(self, id)
    if _tasks[id] ~= nil then
      _tasks[id].pause = false
    else
      COMPONENTS.Logger:Warn("Tasks", "Attempt To Resume Non-Existing Task: " .. id)
    end
  end,
  Skip = function(self, id)
    if _tasks[id] ~= nil then
      _tasks[id].skip = false
      _tasks[id].pause = false
    else
      COMPONENTS.Logger:Warn("Tasks", "Attempt To Skip Non-Existing Task: " .. id)
    end
  end,
}

local function exportHandler(exportName, func)
  AddEventHandler(('__cfx_export_%s_%s'):format(GetCurrentResourceName(), exportName), function(setCB)
    setCB(function(...)
      return func(COMPONENTS.Tasks, ...)
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

for k, v in pairs(COMPONENTS.Tasks) do
  if type(v) == "function" then
    exportHandler("Tasks" .. k, v)
  elseif type(v) == "table" then
    createExportForObject(v, "Tasks" .. k)
  end
end
