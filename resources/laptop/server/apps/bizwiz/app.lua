local bizWizJobs = {}

function CheckBusinessPermissions(source, permission)
  local onDuty = exports['jobs']:JobsDutyGet(source)
  if onDuty and onDuty.Id and bizWizJobs[onDuty.Id] then
    if (not permission) or exports['jobs']:JobsPermissionsHasPermissionInJob(source, onDuty.Id, permission) then
      return onDuty.Id
    end
  end
  return false
end

AddEventHandler('Job:Server:DutyAdd', function(dutyData, source)
  local job = exports['jobs']:JobsPermissionsHasJob(source, dutyData.Id)
  if job then
    local hasConfig = _bizWizConfig[job.Id]
    local bizWiz = Jobs.Data:Get(job.Id, "bizWiz")

    if hasConfig then
      bizWiz = hasConfig.type
    end

    if job and bizWiz and _bizWizTypes[bizWiz] then
      local bizWizLogo = Jobs.Data:Get(job.Id, "bizWizLogo")

      if not bizWizLogo and hasConfig then
        bizWizLogo = hasConfig.logo
      end

      bizWizJobs[job.Id] = true

      Laptop:UpdateJobData(source)
      TriggerClientEvent("Laptop:Client:BizWiz:Login", source, bizWizLogo or "https://i.imgur.com/ORHSuSM.png",
        _bizWizTypes[bizWiz], GetBusinessNotices(job.Id))
    end
  end
end)

AddEventHandler('Job:Server:DutyRemove', function(dutyData, source, SID)
  if bizWizJobs[dutyData.Id] then
    TriggerClientEvent("Laptop:Client:BizWiz:Logout", source)
  end
end)

function GetBusinessNotices(job)
  local notices = {}
  for k, v in ipairs(_businessNotices) do
    if v.job == job then
      table.insert(notices, v)
    end
  end

  return notices
end

AddEventHandler("Laptop:Server:RegisterCallbacks", function()
  exports['core']:CallbacksRegisterServer("Laptop:BizWiz:EmployeeSearch", function(source, data, cb)
    local job = CheckBusinessPermissions(source)
    if job then
      local query = [[
        SELECT
          SID, First, Last
        FROM characters
        WHERE
          (
            CONCAT(First, ' ', Last) LIKE ?
            OR CAST(SID AS CHAR) LIKE ?
          )
          AND JSON_CONTAINS(Jobs, JSON_OBJECT('Id', ?), '$')
        LIMIT 4
      ]]

      local term = '%' .. (data.term or '') .. '%'
      local params = { term, term, job }

      MySQL.Async.fetchAll(query, params, function(results)
        if not results then
          cb({})
          return
        end

        cb(results)
      end)
    else
      cb(false)
    end
  end)

  exports['core']:CallbacksRegisterServer("Laptop:BizWiz:GetTwitterProfile", function(source, data, cb)
    local job = CheckBusinessPermissions(source, "JOB_MANAGEMENT")
    if job then
      cb({
        success = true,
        pfp = Jobs.Data:Get(job, "TwitterAvatar")
      })
    else
      cb(false)
    end
  end)

  exports['core']:CallbacksRegisterServer("Laptop:BizWiz:SetTwitterProfile", function(source, data, cb)
    local job = CheckBusinessPermissions(source, "JOB_MANAGEMENT")
    if job then
      local success = Jobs.Data:Set(job, "TwitterAvatar", data.profile)
      if success then
        cb(data.profile)
      else
        cb(false)
      end
    else
      cb(false)
    end
  end)

  exports['core']:CallbacksRegisterServer("Laptop:BizWiz:SendTweet", function(source, data, cb)
    local job = CheckBusinessPermissions(source, "TABLET_TWEET")
    if job then
      local jobData = Jobs:Get(job)
      local avatar = Jobs.Data:Get(job, "TwitterAvatar")

      Phone.Twitter:Post(
        -1,
        -1,
        {
          name = jobData.Name,
          picture = avatar,
        },
        data.content,
        data.image,
        false,
        "business"
      )

      cb(true)
    else
      cb(false)
    end
  end)

  Chat:RegisterAdminCommand("bizwizset", function(source, args, rawCommand)
    local setting = args[2]
    if setting == "false" then
      setting = false
    end

    local res = Jobs.Data:Set(args[1], "bizWiz", setting)

    if res?.success then
      Chat.Send.System:Single(source, "Success")
    else
      Chat.Send.System:Single(source, "Failed")
    end
  end, {
    help = "[Admin] Grant a Business Access to BizWiz App",
    params = {
      {
        name = "Job ID",
        help = "Job ID",
      },
      {
        name = "BizWiz Type",
        help = "e.g. default, mechanic (false to remove)",
      },
    }
  }, 2)

  Chat:RegisterAdminCommand("bizwizlogo", function(source, args, rawCommand)
    local setting = args[2]
    if setting == "false" then
      setting = false
    end

    local res = Jobs.Data:Set(args[1], "bizWizLogo", setting)

    if res?.success then
      Chat.Send.System:Single(source, "Success")
    else
      Chat.Send.System:Single(source, "Failed")
    end
  end, {
    help = "[Admin] Set BizWiz Logo",
    params = {
      {
        name = "Job ID",
        help = "Job ID",
      },
      {
        name = "BizWiz Logo Link (imgur)",
        help = "(false to remove)",
      },
    }
  }, 2)

  exports['core']:CallbacksRegisterServer("Laptop:BizWiz:ViewVehicleFleet", function(source, data, cb)
    local job = CheckBusinessPermissions(source, "FLEET_MANAGEMENT")
    if job then
      Vehicles.Owned:GetAll(nil, 1, job, function(vehicles)
        for k, v in ipairs(vehicles) do
          if v.Storage then
            if v.Storage.Type == 0 then
              v.Storage.Name = Vehicles.Garages:Impound().name
            elseif v.Storage.Type == 1 then
              v.Storage.Name = Vehicles.Garages:Get(v.Storage.Id).name
            elseif v.Storage.Type == 2 then
              local prop = Properties:Get(v.Storage.Id)
              v.Storage.Name = prop?.label
            end
          end
        end

        cb(vehicles)
      end)
    else
      cb(false)
    end
  end)

  exports['core']:CallbacksRegisterServer("Laptop:BizWiz:TrackFleetVehicle", function(source, data, cb)
    local job = CheckBusinessPermissions(source, "FLEET_MANAGEMENT")
    if job then
      cb(Vehicles.Owned:Track(data.vehicle))
    else
      cb(false)
    end
  end)
end)