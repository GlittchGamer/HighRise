local _blacklistedJobs = { "police", "ems", "government" }
local _tabletJobs = {
  "pdm",
  "realestate",
  "redline",
  "hayes",
  "ottos",
  "autoexotics",
  "autocare",
  "securoserv",
  "dreamworks",
  "casino",
  "burgershot",
  "demonetti_storage",
  "tuna",
  "ferrari_pawn",
}

local _jobPerms = {
  JOB_MANAGEMENT = {
    name = "Manage Company",
    restricted = false, -- Array of Jobs (or false)
  },
  JOB_MANAGE_EMPLOYEES = {
    name = "Manage/Promote Employees",
    restricted = false,
  },
  JOB_FIRE = {
    name = "Fire Employees",
    restricted = false,
  },
  JOB_HIRE = {
    name = "Hire Employees",
    restricted = false,
  },
  JOB_STORAGE = {
    name = "Access Company Storage",
    restricted = false,
  },
  JOB_ACCESS_SAFE = {
    name = "Access Safe",
    restricted = false,
  },
  JOB_CRAFTING = {
    name = "Access Crafting",
    restricted = false,
  },
  BANK_ACCOUNT_BILL = {
    name = "Bank Account - Send Bills",
    restricted = false,
  },
  BANK_ACCOUNT_MANAGE = {
    name = "Bank Account - Manage",
    restricted = false,
  },
  BANK_ACCOUNT_WITHDRAW = {
    name = "Bank Account - Withdraw",
    restricted = false,
  },
  BANK_ACCOUNT_DEPOSIT = {
    name = "Bank Account - Deposit",
    restricted = false,
  },
  BANK_ACCOUNT_TRANSACTIONS = {
    name = "Bank Account - View Transactions",
    restricted = false,
  },
  BANK_ACCOUNT_BALANCE = {
    name = "Bank Account - View Balance",
    restricted = false,
  },
  FLEET_VEHICLES_0 = {
    name = "Access Fleet Vehicles",
    restrict = false,
  },
  -- FLEET_VEHICLES_1 = {
  -- 	name = "Fleet Vehicles Level 2",
  -- 	restrict = false,
  -- },
  -- FLEET_VEHICLES_2 = {
  -- 	name = "Fleet Vehicles Level 3",
  -- 	restrict = false,
  -- },
  -- FLEET_VEHICLES_3 = {
  -- 	name = "Fleet Vehicles Level 4",
  -- 	restrict = false,
  -- },
  -- FLEET_VEHICLES_4 = {
  -- 	name = "Fleet Vehicles Level 5",
  -- 	restrict = false,
  -- },
  FLEET_MANAGEMENT = {
    name = "Manage Vehicle Fleet",
    restrict = false,
  },


  dealership_stock = {
    name = "Dealership - Stocks",
    restricted = { "pdm", "redline", "tuna" },
  },
  dealership_showroom = {
    name = "Dealership - Showroom",
    restricted = { "pdm", "redline", "tuna" },
  },
  dealership_sell = {
    name = "Dealership - Sales",
    restricted = { "pdm", "redline", "tuna" },
  },
  dealership_testdrive = {
    name = "Dealership - Test Drive",
    restricted = { "pdm", "redline", "tuna" },
  },
  dealership_manage = {
    name = "Dealership - Manage",
    restricted = { "pdm", "redline", "tuna" },
  },
  dealership_buyback = {
    name = "Dealership - Buy Back Vehicle",
    restricted = { "pdm", "redline", "tuna" },
  },
  JOB_USE_WHOLESALER = {
    name = "Access Food Wholesaler",
    restricted = {
      "uwu",
      "pizza_this",
      "burgershot",
      "bowling",
      "beanmachine",
      "lasttrain",
      "tequila",
      "unicorn",
      "dgang",
      "bakery",
      "noodle",
      "triad",
      "prego",
    },
  },
  JOB_DOORS = {
    name = "Access Doors",
    restricted = {
      "realestate",
      "unicorn",
    },
  },
  STRIP_POLE = {
    name = "Use Strip Pole",
    restricted = {
      "unicorn",
    },
  },
  JOB_SELL = {
    name = "Sell Property",
    restricted = {
      "realestate", "pdm"
    },
  },
  JOB_USE_GEM_TABLE = {
    name = "Use Gem Table",
    restricted = {
      "sagma"
    }
  },
  JOB_USE_JEWELRY_CRAFTING = {
    name = "Use Jewelry Crafting",
    restricted = {
      "sagma"
    }
  },
  JOB_SELL_GEMS = {
    name = "Use Gem Seller",
    restricted = {
      "sagma"
    }
  },

  TABLET_CREATE_NOTICE = {
    name = "Tablet - Create Notice",
    restricted = _tabletJobs,
  },
  TABLET_DELETE_NOTICE = {
    name = "Tablet - Delete Notice",
    restricted = _tabletJobs,
  },
  TABLET_CREATE_DOCUMENT = {
    name = "Tablet - Create Document",
    restricted = _tabletJobs,
  },
  TABLET_VIEW_DOCUMENT = {
    name = "Tablet - View Document",
    restricted = _tabletJobs,
  },
  TABLET_PIN_DOCUMENT = {
    name = "Tablet - Pin Document",
    restricted = _tabletJobs,
  },
  TABLET_DELETE_DOCUMENT = {
    name = "Tablet - Delete Document",
    restricted = _tabletJobs,
  },
  TABLET_CREATE_RECEIPT = {
    name = "Tablet - Create Receipt",
    restricted = _tabletJobs,
  },
  TABLET_MANAGE_RECEIPT = {
    name = "Tablet - Manage Receipts",
    restricted = _tabletJobs,
  },
  TABLET_CLEAR_RECEIPT = {
    name = "Tablet - Clear All Receipts",
    restricted = _tabletJobs,
  },
  CASINO_LOCK_DOORS = {
    name = "Casino - Lock Doors",
    restricted = { "casino" },
  },
  CASINO_LOCK_ELEVATOR = {
    name = "Casino - Lock Elevators",
    restricted = { "casino" },
  },
  PREGO_BASEMENT = {
    name = "Cafe Prego - Access Basement",
    restricted = { "prego" },
  },
  UNIT_SELL = {
    name = "Storage Units - Sell",
    restricted = { "dgang", "demonetti_storage" },
  },


  SECONDARY_BANK_ACCOUNT_BILL = {
    name = "2nd Bank Account - Send Bills",
    restricted = { "ferrari_pawn" },
  },
  SECONDARY_BANK_ACCOUNT_MANAGE = {
    name = "2nd Bank Account - Manage",
    restricted = { "ferrari_pawn" },
  },
  SECONDARY_BANK_ACCOUNT_WITHDRAW = {
    name = "2nd Bank Account - Withdraw",
    restricted = { "ferrari_pawn" },
  },
  SECONDARY_BANK_ACCOUNT_DEPOSIT = {
    name = "2nd Bank Account - Deposit",
    restricted = { "ferrari_pawn" },
  },
  SECONDARY_BANK_ACCOUNT_TRANSACTIONS = {
    name = "2nd Bank Account - View Transactions",
    restricted = { "ferrari_pawn" },
  },
  SECONDARY_BANK_ACCOUNT_BALANCE = {
    name = "2nd Bank Account - View Balance",
    restricted = { "ferrari_pawn" },
  },
}

local _upgrades = {
  {
    value = "COMPANY_FLEET",
    label = "Coming Soon!",
    price = 5000000,
  },
}

local _pendingHires = {}
local _pendingXfers = {}

PHONE.CoManager = {
  FetchAllAccessibleRosters = function(self, source)
    local playersJobs = exports['hrrp-jobs']:JobsPermissionsGetJobs(source)
    local fetchedRosterData = {}
    local fetchingJobs = {}
    for k, v in ipairs(playersJobs) do
      if not hasValue(_blacklistedJobs, v.Id) then
        fetchingJobs[v.Id] = true
        fetchedRosterData[v.Id] = {}
      end
    end

    local onlineCharacters = {}
    for k, v in pairs(Fetch:All()) do
      local char = v:GetData("Character")
      if char then
        table.insert(onlineCharacters, char:GetData("SID"))
        local jobs = char:GetData("Jobs")
        if jobs and #jobs > 0 then
          for k, v in ipairs(jobs) do
            if fetchingJobs[v.Id] then
              table.insert(fetchedRosterData[v.Id], {
                Source = char:GetData("Source"),
                SID = char:GetData("SID"),
                First = char:GetData("First"),
                Last = char:GetData("Last"),
                Phone = char:GetData("Phone"),
                JobData = v,
              })
            end
          end
        end
      end
    end

    local query = 'SELECT SID, First, Last, Phone, Jobs FROM characters WHERE SID NOT IN (@onlineCharacters)'

    local params = { ['@onlineCharacters'] = onlineCharacters }


    local results = MySQL.query.await(query, params)

    local fetchedRosterData = {}


    if results and #results > 0 then
      for _, c in ipairs(results) do
        local jobs = json.decode(c.Jobs)

        if jobs and #jobs > 0 then
          for _, job in ipairs(jobs) do
            if fetchingJobs[job.Id] and

                (not workplaceId or job.Workplace.Id == workplaceId) and

                (not gradeId or job.Grade.Id == gradeId) then
              if not fetchedRosterData[job.Id] then
                fetchedRosterData[job.Id] = {}
              end

              table.insert(fetchedRosterData[job.Id], {

                Source = false,
                SID = c.SID,
                First = c.First,
                Last = c.Last,
                Phone = c.Phone,
                JobData = job,

              })
            end
          end
        end
      end

      return fetchedRosterData
    else
      return false
    end
  end,
  FetchTimeWorked = function(self, source, jobId)
    if exports['hrrp-jobs']:JobsPermissionsHasJob(source, jobId, false, false, false, false, "JOB_MANAGEMENT") then
      local onlineCharacters = {}

      local onlineShit = {}

      for k, v in pairs(Fetch:All()) do
        local char = v:GetData("Character")
        if char then
          table.insert(onlineCharacters, char:GetData("SID"))
          local jobs = char:GetData("Jobs")
          if jobs and #jobs > 0 then
            for k2, v2 in ipairs(jobs) do
              if v2.Id == jobId then
                table.insert(onlineShit, {
                  Source = char:GetData("Source"),
                  SID = char:GetData("SID"),
                  First = char:GetData("First"),
                  Last = char:GetData("Last"),
                  Phone = char:GetData("Phone"),
                  LastClockOn = char:GetData("LastClockOn"),
                  TimeClockedOn = char:GetData("TimeClockedOn"),
                })
              end
            end
          end
        end
      end

      local query =
      'SELECT SID, First, Last, Phone, LastClockOn, TimeClockedOn, Jobs FROM characters WHERE SID NOT IN (@onlineCharacters)'
      local params = {
        ['@onlineCharacters'] = onlineCharacters
      }

      local results = MySQL.query.await(query, params)
      if results and #results > 0 then
        for _, c in ipairs(results) do
          local jobs = json.decode(c.Jobs)
          if jobs and #jobs > 0 then
            for _, job in ipairs(jobs) do
              if job.Id == jobId then
                table.insert(onlineShit, {
                  Source = false,
                  SID = c.SID,
                  First = c.First,
                  Last = c.Last,
                  Phone = c.Phone,
                  LastClockOn = c.LastClockOn,
                  TimeClockedOn = c.TimeClockedOn,
                })
              end
            end
          end
        end
        return onlineShit
      else
        return false
      end
    end
    return false
  end

}

function GetOfflineCharacter(stateId)
  local results = MySQL.query.await('SELECT * FROM characters WHERE SID = @stateId', {
    ['@stateId'] = stateId
  })

  if results[1] then
    return results[1]
  else
    return false
  end
end

AddEventHandler("Phone:Server:RegisterMiddleware", function()
  Middleware:Add("Characters:Spawning", function(source)
    local char = exports['hrrp-base']:FetchSource(source):GetData("Character")

    TriggerClientEvent("Phone:Client:SetData", source, "companyUpgrades", _upgrades)
    TriggerClientEvent("Phone:Client:SetData", source, "externalJobs", _blacklistedJobs)
    TriggerClientEvent("Phone:Client:SetData", source, "NamedJobPermissions", _jobPerms)
    if _pendingHires[char:GetData("SID")] ~= nil then
      local data = _pendingHires[char:GetData("SID")]
      TriggerClientEvent(
        "Phone:Client:CoManager:GetJobOffer",
        source,
        data.time,
        data.NewJob
      )
    end
  end, 2)
  Middleware:Add("Characters:Logout", function(source)
    local plyr = exports['hrrp-base']:FetchSource(source)
    if plyr ~= nil then
      local char = plyr:GetData("Character")
      if char ~= nil then
        local stateId = char:GetData("SID")
        local data = _pendingHires[stateId]
        if data then
          TriggerClientEvent("Phone:Client:CoManager:GetOfferResult", data.HiredBy, os.time(), false)
          _pendingHires[stateId] = nil
        end
      end
    end
  end, 2)
  Middleware:Add("playerDropped", function(source)
    local plyr = exports['hrrp-base']:FetchSource(source)
    if plyr ~= nil then
      local char = plyr:GetData("Character")
      if char ~= nil then
        local stateId = char:GetData("SID")
        local data = _pendingHires[stateId]
        if data then
          TriggerClientEvent("Phone:Client:CoManager:GetOfferResult", data.HiredBy, os.time(), false)
          _pendingHires[stateId] = nil
        end
      end
    end
  end, 2)
  Middleware:Add("Phone:UIReset", function(source)
    local char = exports['hrrp-base']:FetchSource(source):GetData("Character")

    TriggerClientEvent("Phone:Client:SetData", source, "companyUpgrades", _upgrades)
    TriggerClientEvent("Phone:Client:SetData", source, "externalJobs", _blacklistedJobs)
    TriggerClientEvent("Phone:Client:SetData", source, "NamedJobPermissions", _jobPerms)
    if _pendingHires[char:GetData("SID")] ~= nil then
      local data = _pendingHires[char:GetData("SID")]
      TriggerClientEvent(
        "Phone:Client:CoManager:GetJobOffer",
        source,
        data.time,
        data.NewJob
      )
    end
  end, 2)
end)

AddEventHandler("Phone:Server:RegisterCallbacks", function()
  exports['hrrp-base']:CallbacksRegisterServer("Phone:CoManager:QuitJob", function(source, data, cb)
    local jobId = data.JobId

    if jobId and not hasValue(_blacklistedJobs, jobId) then
      if exports['hrrp-jobs']:JobsPermissionsIsOwner(source, jobId) then
        return cb({ success = false, code = "IS_OWNER" })
      else
        local char = exports['hrrp-base']:FetchSource(source):GetData("Character")
        if char then
          local success = Jobs:RemoveJob(char:GetData("SID"), jobId)
          if success then
            return cb({ success = true, code = "ERROR" })
          end
        end
      end
    end
    return cb({ success = false, code = "ERROR" })
  end)

  exports['hrrp-base']:CallbacksRegisterServer("Phone:CoManager:FetchRoster", function(source, data, cb)
    if data.ReqUpdate then
      local updatedJobData = Phone:UpdateJobData(source, true)
      cb({
        jobData = updatedJobData.jobData,
        rosterData = Phone.CoManager:FetchAllAccessibleRosters(source),
      })
    else
      cb({
        rosterData = Phone.CoManager:FetchAllAccessibleRosters(source),
      })
    end
  end)

  exports['hrrp-base']:CallbacksRegisterServer("Phone:CoManager:FetchTimeWorked", function(source, data, cb)
    cb(Phone.CoManager:FetchTimeWorked(source, data))
  end)

  exports['hrrp-base']:CallbacksRegisterServer("Phone:CoManager:RenameCompany", function(source, data, cb)
    local jobId, newName = data.JobId, data.NewName

    if jobId and newName and not hasValue(_blacklistedJobs, jobId) then
      if exports['hrrp-jobs']:JobsPermissionsIsOwner(source, jobId) then
        local res = Jobs.Management:Edit(jobId, {
          Name = newName,
        })

        cb(res)
      else
        cb({ success = false, code = "INVALID_PERMISSIONS" })
      end
    else
      cb({ success = false, code = "ERROR" })
    end
  end)

  exports['hrrp-base']:CallbacksRegisterServer("Phone:CoManager:HireEmployee", function(source, data, cb)
    local stateId, jobId, workplace, grade = math.tointeger(data.SID), data.Job.Id, data.Job.Workplace, data.Job.Grade

    if (not workplace or (workplace and workplace.Id)) and grade and grade.Id and Jobs:DoesExist(jobId, (workplace and workplace.Id or false), grade.Id) then
      local playerJobData = exports['hrrp-jobs']:JobsPermissionsHasJob(source, jobId)
      local playerJobPerms = exports['hrrp-jobs']:JobsPermissionsGetPermissionsFromJob(source, jobId)
      local playerIsOwner = exports['hrrp-jobs']:JobsPermissionsIsOwner(source, jobId)
      if (playerJobPerms and (playerJobPerms.JOB_HIRE or playerJobPerms.JOB_MANAGEMENT)) or playerIsOwner then
        if (playerJobData.Grade.Level > grade.Level) or playerIsOwner then
          local targetChar = Fetch:CharacterData("SID", stateId)
          if targetChar then
            targetChar = targetChar:GetData("Character")
          end

          if targetChar then
            local time = os.time()
            local stateId = targetChar:GetData("SID")

            local targetCharJobs = targetChar:GetData("Jobs")

            if targetCharJobs and #targetCharJobs > 0 then
              for k, v in ipairs(targetCharJobs) do
                if v.Id == jobId then
                  return cb({ success = false, code = "ERROR" })
                end
              end
            end

            if not _pendingHires[stateId] or (os.time() - _pendingHires[stateId]?.time) >= 300 then
              local hireData = {
                time = time,
                HiredBy = source,
                NewJob = {
                  Id = playerJobData.Id,
                  Name = playerJobData.Name,
                  Workplace = workplace,
                  Grade = grade,
                },
              }

              _pendingHires[stateId] = hireData

              TriggerClientEvent(
                "Phone:Client:CoManager:GetJobOffer",
                targetChar:GetData("Source"),
                time,
                hireData.NewJob
              )
              cb({ success = true })
            else
              return cb({ success = false, code = "OUTSTANDING_OFFER" })
            end
          end
          return cb({ success = false, code = "INVALID_TARGET" })
        end
      end
      return cb({ success = false, code = "INVALID_PERMISSIONS" })
    end
    return cb({ success = false, code = "ERROR" })
  end)

  exports['hrrp-base']:CallbacksRegisterServer("Phone:CoManager:FireEmployee", function(source, data, cb)
    local stateId, jobId = math.tointeger(data.SID), data.Job.Id

    if stateId and jobId then
      local job = Jobs:Get(jobId)
      local playerJobData = exports['hrrp-jobs']:JobsPermissionsHasJob(source, jobId)
      local playerJobPerms = exports['hrrp-jobs']:JobsPermissionsGetPermissionsFromJob(source, jobId)
      local playerIsOwner = exports['hrrp-jobs']:JobsPermissionsIsOwner(source, jobId)
      if (playerJobPerms and (playerJobPerms.JOB_FIRE or playerJobPerms.JOB_MANAGEMENT)) or playerIsOwner then
        if job.Owner and job.Owner == stateId then
          return cb({ success = false, code = "INVALID_PERMISSIONS" })
        end

        local targetJobData = false

        local targetChar = Fetch:CharacterData("SID", stateId)
        if targetChar then
          targetChar = targetChar:GetData("Character")
        end

        if targetChar then
          targetJobData = targetChar:GetData("Jobs")
        else
          local offlineChar = GetOfflineCharacter(stateId)
          if offlineChar then
            targetJobData = offlineChar.Jobs
          end
        end

        if targetJobData then
          local canRemoveJob = false
          for k, v in ipairs(targetJobData) do
            if v.Id == playerJobData.Id then
              if v.Grade.Level < playerJobData.Grade.Level then
                canRemoveJob = true
              end
              break
            end
          end

          if canRemoveJob then
            local success = Jobs:RemoveJob(stateId, playerJobData.Id)
            return cb({ success = success, code = "ERROR" })
          else
            return cb({ success = false, code = "INVALID_PERMISSIONS" })
          end
        else
          return cb({ success = false, code = "INVALID_TARGET" })
        end
      end
      return cb({ success = false, code = "INVALID_PERMISSIONS" })
    end
    return cb({ success = false, code = "ERROR" })
  end)

  exports['hrrp-base']:CallbacksRegisterServer("Phone:CoManager:UpdateEmployee", function(source, data, cb)
    local stateId, jobId, workplace, grade = math.tointeger(data.SID), data.Job.Id, data.Job.Workplace, data.Job.Grade
    if (not workplace or (workplace and workplace.Id) and grade and grade.Id) and Jobs:DoesExist(jobId, (workplace and workplace.Id or false), grade.Id) then
      local job = Jobs:Get(jobId)
      local playerJobData = exports['hrrp-jobs']:JobsPermissionsHasJob(source, jobId)
      local playerJobPerms = exports['hrrp-jobs']:JobsPermissionsGetPermissionsFromJob(source, jobId)
      local playerIsOwner = exports['hrrp-jobs']:JobsPermissionsIsOwner(source, jobId)
      if (playerJobPerms and (playerJobPerms.JOB_MANAGE_EMPLOYEES or playerJobPerms.JOB_MANAGEMENT)) or playerIsOwner then
        if job.Owner and job.Owner == stateId then
          return cb({ success = false, code = "INVALID_PERMISSIONS" })
        end

        if (playerJobData.Grade.Level > grade.Level) or playerIsOwner then
          local targetChar = Fetch:CharacterData("SID", stateId)
          if targetChar then
            targetChar = targetChar:GetData("Character")
          end

          local targetJobData = false

          if targetChar then
            targetJobData = targetChar:GetData("Jobs")
          else
            local offlineChar = GetOfflineCharacter(stateId)
            if offlineChar then
              targetJobData = offlineChar.Jobs
            end
          end


          if targetJobData then
            local canChangeJob = false
            for k, v in ipairs(targetJobData) do
              if v.Id == playerJobData.Id then
                if (v.Grade.Level < playerJobData.Grade.Level) or playerIsOwner then
                  canChangeJob = true
                end
                break
              end
            end

            if canChangeJob then
              local success = Jobs:GiveJob(stateId, playerJobData.Id, (workplace and workplace.Id or false), grade.Id)
              return cb({ success = success, code = "ERROR" })
            else
              return cb({ success = false, code = "INVALID_PERMISSIONS" })
            end
          end

          return cb({ success = false, code = "INVALID_TARGET" })
        end
      end
      return cb({ success = false, code = "INVALID_PERMISSIONS" })
    end
    return cb({ success = false, code = "ERROR" })
  end)

  exports['hrrp-base']:CallbacksRegisterServer("Phone:CoManager:EditWorkplace", function(source, data, cb)
    local jobId, workplaceId, newName = data.JobId, data.WorkplaceId, data.NewName

    if jobId and newName and not hasValue(_blacklistedJobs, jobId) then
      if exports['hrrp-jobs']:JobsPermissionsIsOwner(source, jobId) then
        local res = Jobs.Management.Workplace:Edit(jobId, workplaceId, newName)
        cb(res)
      else
        cb({ success = false, code = "INVALID_PERMISSIONS" })
      end
    else
      cb({ success = false, code = "ERROR" })
    end
  end)

  exports['hrrp-base']:CallbacksRegisterServer("Phone:CoManager:CreateGrade", function(source, data, cb)
    local jobId, workplaceId, gradeName, gradeLevel, gradePermissions = data.JobId, data.WorkplaceId, data.Name,
        math.tointeger(data.Level), data.Permissions
    if jobId and gradeName and gradeLevel and gradePermissions and not hasValue(_blacklistedJobs, jobId) then
      local playerJobData = exports['hrrp-jobs']:JobsPermissionsHasJob(source, jobId)
      local playerJobPerms = exports['hrrp-jobs']:JobsPermissionsGetPermissionsFromJob(source, jobId)
      local playerIsOwner = exports['hrrp-jobs']:JobsPermissionsIsOwner(source, jobId)

      if ((playerJobPerms and (playerJobPerms.JOB_MANAGEMENT)) and gradeLevel < playerJobData.Grade.Level) or playerIsOwner then
        local res = Jobs.Management.Grades:Create(jobId, workplaceId, gradeName, gradeLevel, gradePermissions)
        return cb(res)
      else
        return cb({ success = false, code = "INVALID_PERMISSIONS" })
      end
    end
    cb({ success = false, code = "ERROR" })
  end)

  exports['hrrp-base']:CallbacksRegisterServer("Phone:CoManager:EditGrade", function(source, data, cb)
    local jobId, workplaceId, gradeId, gradeName, gradeLevel, gradePermissions = data.JobId, data.WorkplaceId, data.Id,
        data.Name, tonumber(data.Level), data.Permissions
    if jobId and gradeId and not hasValue(_blacklistedJobs, jobId) then
      local existingGrade = Jobs:DoesExist(jobId, workplaceId, gradeId)
      if existingGrade then
        local playerJobData = exports['hrrp-jobs']:JobsPermissionsHasJob(source, jobId)
        local playerJobPerms = exports['hrrp-jobs']:JobsPermissionsGetPermissionsFromJob(source, jobId)
        local playerIsOwner = exports['hrrp-jobs']:JobsPermissionsIsOwner(source, jobId)

        if ((playerJobPerms and (playerJobPerms.JOB_MANAGEMENT)) and existingGrade.Grade.Level < playerJobData.Grade.Level and gradeLevel < playerJobData.Grade.Level) or playerIsOwner then
          local res = Jobs.Management.Grades:Edit(jobId, workplaceId, gradeId, {
            Name = gradeName,
            Level = gradeLevel,
            Permissions = gradePermissions,
          })

          return cb(res)
        else
          return cb({ success = false, code = "INVALID_PERMISSIONS" })
        end
      end
    end
    cb({ success = false, code = "ERROR" })
  end)

  exports['hrrp-base']:CallbacksRegisterServer("Phone:CoManager:DeleteGrade", function(source, data, cb)
    local jobId, workplaceId, gradeId = data.JobId, data.WorkplaceId, data.Id
    if jobId and gradeId and not hasValue(_blacklistedJobs, jobId) then
      local existingGrade = Jobs:DoesExist(jobId, workplaceId, gradeId)
      if existingGrade then
        local playerJobData = exports['hrrp-jobs']:JobsPermissionsHasJob(source, jobId)
        local playerJobPerms = exports['hrrp-jobs']:JobsPermissionsGetPermissionsFromJob(source, jobId)
        local playerIsOwner = exports['hrrp-jobs']:JobsPermissionsIsOwner(source, jobId)
        if ((playerJobPerms and (playerJobPerms.JOB_MANAGEMENT)) and existingGrade.Grade.Level < playerJobData.Grade.Level) or playerIsOwner then
          local res = Jobs.Management.Grades:Delete(jobId, workplaceId, gradeId)
          return cb(res)
        else
          return cb({ success = false, code = "INVALID_PERMISSIONS" })
        end
      end
    end
    cb({ success = false, code = "ERROR" })
  end)

  exports['hrrp-base']:CallbacksRegisterServer("Phone:CoManager:PurchaseUpgrade", function(source, data, cb)
    -- TODO
    cb({ success = false, code = "ERROR" })
  end)

  exports['hrrp-base']:CallbacksRegisterServer("Phone:CoManager:AcceptHire", function(source, data, cb)
    local player = exports['hrrp-base']:FetchSource(source)
    if player then
      local char = player:GetData("Character")
      if char then
        local stateId = char:GetData("SID")
        local data = _pendingHires[stateId]
        if data then
          local success = Jobs:GiveJob(stateId, data.NewJob.Id,
            (data.NewJob.Workplace and data.NewJob.Workplace.Id or false), data.NewJob.Grade.Id)
          TriggerClientEvent("Phone:Client:CoManager:GetOfferResult", data.HiredBy, os.time(), success)
          _pendingHires[stateId] = nil
          return cb(os.time(), success)
        end
      end
    end
    return cb(os.time(), false)
  end)

  exports['hrrp-base']:CallbacksRegisterServer("Phone:CoManager:DeclineHire", function(source, data, cb)
    local player = exports['hrrp-base']:FetchSource(source)
    if player then
      local char = player:GetData("Character")
      if char then
        local stateId = char:GetData("SID")
        local data = _pendingHires[stateId]
        if data then
          TriggerClientEvent("Phone:Client:CoManager:GetOfferResult", data.HiredBy, os.time(), false)
          _pendingHires[stateId] = nil
        end
      end
    end
    cb(os.time())
  end)

  exports['hrrp-base']:CallbacksRegisterServer("Phone:CoManager:DisbandCompany", function(source, data, cb)
    -- ! Disabled
    cb({ success = false, code = "ERROR" })
  end)

  -- TODO
  -- exports['hrrp-base']:CallbacksRegisterServer("Phone:CoManager:BeginTransfer", function(source, data, cb)
  -- 	local plyr = exports['hrrp-base']:FetchSource(source)
  -- 	local char = plyr:GetData("Character")
  -- 	local jobdata = GlobalState[string.format("JobTypes:%s", char:GetData("Job").Id)]

  -- 	if char:GetData("ID") == jobdata.Owner then
  -- 		local target = exports['hrrp-base']:FetchSID(tonumber(data.target))
  -- 		if target ~= nil then
  -- 			local tc = target:GetData("Character")
  -- 			if tc ~= nil then
  -- 				if tc:GetData("Job").Id == Config.DefaultJob.Id or tc:GetData("Job").Id == jobdata.Id then
  -- 					if _pendingXfers[tc:GetData("ID")] == nil and _pendingXfers[jobdata.Id] then
  -- 						_pendingXfers[tc:GetData("ID")] = {
  -- 							job = job.Id,
  -- 							sender = char:GetData("ID"),
  -- 							target = tc:GetData("ID"),
  -- 						}
  -- 						_pendingXfers[job.Id] = true
  -- 						Phone.Notification:AddWithId(
  -- 							target:GetData("Source"),
  -- 							"CO_XFER",
  -- 							job.Name,
  -- 							string.format(
  -- 								"%s Wants To Transfer Ownership of %s",
  -- 								string.format("%s %s", char:GetData("First"), char:GetData("Last")),
  -- 								job.Name
  -- 							),
  -- 							os.time() * 1000,
  -- 							-1,
  -- 							"comanager",
  -- 							{
  -- 								accept = "Phone:Client:CoManager:AcceptXfer",
  -- 								cancel = "Phone:Client:CoManager:DeclineXfer",
  -- 							},
  -- 							nil
  -- 						)
  -- 						cb({ error = false })
  -- 					else
  -- 						cb({ error = true, code = 5 })
  -- 					end
  -- 				else
  -- 					cb({ error = true, code = 4 })
  -- 				end
  -- 			else
  -- 				cb({ error = true, code = 3 })
  -- 			end
  -- 		else
  -- 			cb({ error = true, code = 1 })
  -- 		end
  -- 	else
  -- 		cb({ error = true, code = 2 })
  -- 	end
  -- end)

  -- exports['hrrp-base']:CallbacksRegisterServer("Phone:CoManager:AcceptXfer", function(source, data, cb)
  -- 	local plyr = exports['hrrp-base']:FetchSource(source)
  -- 	local char = plyr:GetData("Character")
  -- 	local xfer = _pendingXfers[char:GetData("ID")]

  -- 	if char:GetData("ID") == xfer.target then
  -- 		if Business.Company:Transfer(char:GetData("Job").Id, char, tc) then
  -- 			Phone:UpdateJobData(source)
  -- 			Phone:UpdateJobData(target:GetData("Source"))

  -- 			Phone.Notifications:RemoveById(source, "CO_XFER")

  -- 			cb({ error = false })
  -- 		else
  -- 			cb({ error = true, code = 4 })
  -- 		end
  -- 	else
  -- 		cb({ error = true, code = 2 })
  -- 	end
  -- end)

  -- exports['hrrp-base']:CallbacksRegisterServer("Phone:CoManager:DeclineXfer", function(source, data, cb)
  -- 	local plyr = exports['hrrp-base']:FetchSource(source)
  -- 	local char = plyr:GetData("Character")
  -- 	local xfer = _pendingXfers[char:GetData("ID")]

  -- 	if char:GetData("ID") == xfer.target then
  -- 		local orig = Fetch:CharacterData("ID", xfer.sender)
  -- 		if orig ~= nil then
  -- 			TriggerClientEvent("Phone:Client:CoManager:GetXferResponse", orig:GetData("Source"), os.time(), false)
  -- 		end

  -- 		_pendingXfers[xfer.job] = nil
  -- 		_pendingXfers[char:GetData("ID")] = nil

  -- 		cb(true)
  -- 	else
  -- 		cb(false)
  -- 	end
  -- end)
end)