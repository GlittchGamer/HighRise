AddEventHandler("Targeting:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Jobs = exports['core']:FetchComponent('Jobs')
  Vehicles = exports['core']:FetchComponent('Vehicles')
  Inventory = exports['core']:FetchComponent('Inventory')
  Reputation = exports['core']:FetchComponent('Reputation')
  Mechanic = exports['core']:FetchComponent('Mechanic')
  Polyzone = exports['core']:FetchComponent('Polyzone')
  Tow = exports['core']:FetchComponent('Tow')
  Input = exports['core']:FetchComponent('Input')
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies("Targeting", {
    'Jobs',
    'Vehicles',
    'Inventory',
    'Reputation',
    'Mechanic',
    'Polyzone',
    'Tow',
    'Input'
  }, function(error)
    if #error > 0 then
      return
    end
    RetrieveComponents()
    RemoveEventHandler(setupEvent)
  end)
end)

local playerData = {}
Citizen.SetTimeout(0, function()
  local utils = require 'client.utils'

  ---@diagnostic disable-next-line: duplicate-set-field
  function utils.getItems()
    return exports["inventory"]:InventoryItemsGetCounts() -- need to figure this out at some point
  end

  function utils.doesPlayerHasTempJob(tempJob)
    local job = LocalPlayer.state.Character:GetData("TempJob")
    if job == nil then
      return false
    end
    return job == tempJob
  end

  ---@diagnostic disable-next-line: duplicate-set-field
  function utils.hasPlayerGotGroup(jobPermissions)
    if type(jobPermissions) ~= "table" then
      return true
    end

    for k, v in ipairs(jobPermissions) do
      if v.job then
        if not v.reqOffDuty or (v.reqOffDuty and (not Jobs.Duty:Get(v.job))) then
          if Jobs.Permissions:HasJob(v.job, v.workplace, v.grade, v.gradeLevel, v.reqDuty, v.permissionKey) then
            return true
          end
        end
      elseif v.permissionKey then
        if Jobs.Permissions:HasPermission(v.permissionKey) then
          return true
        end
      end
    end
    return false
  end

  function utils.hasPlayerGotState(state)
    local states = LocalPlayer.state.Character:GetData("States") or {}
    for k, v in ipairs(states) do
      if v == state then
        return true
      end
    end
    return false
  end

  function utils.hasPlayerGotRep(rep)
    return rep.level <= Reputation:GetLevel(rep.id)
  end
end)
