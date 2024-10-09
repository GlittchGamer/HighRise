_JOBS = {
  Permissions = {
    GetJobs = function(self)
      local char = LocalPlayer.state.Character
      if char then
        local jobs = char:GetData('Jobs') or {}
        return jobs
      end
      return false
    end,
    HasJob = function(self, jobId, workplaceId, gradeId, gradeLevel, checkDuty, permissionKey)
      local jobs = exports['hrrp-jobs']:JobsPermissionsGetJobs()
      if not jobs then return false end

      for k, v in ipairs(jobs) do
        if v.Id == jobId then
          if (not workplaceId or (v.Workplace and v.Workplace.Id == workplaceId)) then
            if (not gradeId or (v.Grade.Id == gradeId)) then
              if (not gradeLevel or (v.Grade.Level and v.Grade.Level >= gradeLevel)) then
                if not checkDuty or (checkDuty and exports['hrrp-jobs']:JobsDutyGet(jobId)) then
                  if not permissionKey or (permissionKey and exports['hrrp-jobs']:JobsPermissionsHasPermissionInJob(jobId, permissionKey)) then
                    return v
                  end
                end
              end
            end
          end
          break
        end
      end
      return false
    end,
    -- Gets the permissions the character has in a job they have
    GetPermissionsFromJob = function(self, jobId, workplaceId)
      local jobData = exports['hrrp-jobs']:JobsPermissionsHasJob(jobId, workplaceId)
      if jobData then
        local perms = GlobalState[string.format('JobPerms:%s:%s:%s', jobData.Id, (jobData.Workplace and jobData.Workplace.Id or false), jobData.Grade.Id)]
        if perms then
          return perms
        end
      end
      return false
    end,
    -- Checks if character has a permission in a specific job they have
    HasPermissionInJob = function(self, jobId, permissionKey)
      local permissionsInJob = exports['hrrp-jobs']:JobsPermissionsGetPermissionsFromJob(jobId)
      if permissionsInJob then
        if permissionsInJob[permissionKey] then
          return true
        end
      end
      return false
    end,
    -- Checks if character has a permission in any of their jobs
    HasPermission = function(self, permissionKey)
      local jobs = exports['hrrp-jobs']:JobsPermissionsGetJobs()
      if jobs then
        for k, v in ipairs(jobs) do
          if exports['hrrp-jobs']:JobsPermissionsHasPermissionInJob(v.Id, permissionKey) then
            return true
          end
        end
      end
      return false
    end,
  },
  Duty = {
    On = function(self, jobId, cb)
      if jobId then
        if exports['hrrp-jobs']:JobsDutyGet(jobId) then
          exports['hrrp-hud']:NotificationError('Already On Duty as that Job')
          if cb then cb(false) end
          return
        end
      end

      exports["hrrp-base"]:CallbacksServer('Jobs:OnDuty', jobId, function(success)
        if cb then cb(success) end
      end)
    end,
    Off = function(self, jobId, cb)
      exports["hrrp-base"]:CallbacksServer('Jobs:OffDuty', jobId, function(success)
        if cb then cb(success) end
      end)
    end,
    Get = function(self, jobId)
      if LocalPlayer.state.onDuty then
        if (not jobId) or (jobId == LocalPlayer.state.onDuty) then
          return LocalPlayer.state.onDuty
        end
      end
      return false
    end,
  }
}

AddEventHandler('Proxy:Shared:RegisterReady', function() --! Completed
  exports['hrrp-base']:RegisterComponent('Jobs', _JOBS)
end)

local function exportHandler(exportName, func)
  AddEventHandler(('__cfx_export_%s_%s'):format(GetCurrentResourceName(), exportName), function(setCB)
    setCB(function(...)
      return func(_JOBS, ...)
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

for k, v in pairs(_JOBS) do
  if type(v) == "function" then
    exportHandler("Jobs" .. k, v)
  elseif type(v) == "table" then
    createExportForObject(v, "Jobs" .. k)
  end
end

--[[
  exports['hrrp-jobs']:JobsPermissionsGetJobs()
]]
