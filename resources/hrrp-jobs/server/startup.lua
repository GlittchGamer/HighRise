local _ranStartup = false
JOB_CACHE = {}
JOB_COUNT = 0

_loaded = false

AddEventHandler('Jobs:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
  Middleware = exports['hrrp-base']:FetchComponent('Middleware')
  Callbacks = exports['hrrp-base']:FetchComponent('Callbacks')
  Logger = exports['hrrp-base']:FetchComponent('Logger')
  Utils = exports['hrrp-base']:FetchComponent('Utils')
  Fetch = exports['hrrp-base']:FetchComponent('Fetch')
  Chat = exports['hrrp-base']:FetchComponent('Chat')
  Execute = exports['hrrp-base']:FetchComponent('Execute')
  Sequence = exports['hrrp-base']:FetchComponent('Sequence')
  Generator = exports['hrrp-base']:FetchComponent('Generator')
  Phone = exports['hrrp-base']:FetchComponent('Phone')
  Jobs = exports['hrrp-base']:FetchComponent('Jobs')
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['hrrp-base']:RequestDependencies('Jobs', {
    'Middleware',
    'Callbacks',
    'Logger',
    'Utils',
    'Fetch',
    'Execute',
    'Sequence',
    'Generator',
    'Chat',
    'Jobs',
    'Phone'
  }, function(error)
    if #error > 0 then return; end
    RetrieveComponents()
    RegisterJobMiddleware()
    RegisterJobCallbacks()
    RegisterJobChatCommands()

    _loaded = true

    RunStartup()

    TriggerEvent('Jobs:Server:Startup')

    RemoveEventHandler(setupEvent)
  end)
end)

function FindAllJobs()
  local results = MySQL.query.await('SELECT * FROM jobs', {})

  if results and #results > 0 then
    return results
  else
    return {}
  end
end

function RefreshAllJobData(job)
  local jobsFetch = FindAllJobs()
  JOB_COUNT = #jobsFetch
  for k, v in ipairs(jobsFetch) do
    JOB_CACHE[v.Id] = v
    if v.Workplaces ~= nil then
      JOB_CACHE[v.Id].Workplaces = json.decode(v.Workplaces or {})
    end

    if v.Grades ~= nil then
      JOB_CACHE[v.Id].Grades = json.decode(v.Grades or {})
    end
  end

  TriggerEvent("Jobs:Server:UpdatedCache", job or -1)

  local govResults = MySQL.query.await([[
        SELECT Id, Name, Grades, Salary, SalaryTier, LastUpdated, Workplaces
        FROM jobs
        WHERE Type = "Government"
    ]], {})

  if govResults and #govResults > 0 then
    for _, v in ipairs(govResults) do
      local Workplaces = json.decode(v.Workplaces)
      for _, Workplace in ipairs(Workplaces) do
        for _, Grade in ipairs(Workplace.Grades) do
          local key = string.format("JobPerms:%s:%s:%s", v.Id, Workplace.Id, Grade.Id)
          GlobalState[key] = Grade.Permissions
        end
      end
    end
  end

  local companyResults = MySQL.query.await([[
        SELECT Id, Name, Grades, Salary, SalaryTier, LastUpdated, Workplaces
        FROM jobs
        WHERE Type = "Company"
    ]], {})

  if companyResults and #companyResults > 0 then
    for _, v in ipairs(companyResults) do
      local Grades = json.decode(v.Grades)
      for _, Grade in ipairs(Grades) do
        local key = string.format("JobPerms:%s:false:%s", v.Id, Grade.Id)
        GlobalState[key] = Grade.Permissions
      end
    end
  end

  return true
end

function RunStartup()
  if _ranStartup then
    return
  end
  _ranStartup = true

  local function replaceExistingDefaultJob(_id, document)
    local deleteResult = MySQL.query.await('DELETE FROM jobs WHERE Id = @Id', { ['@Id'] = _id })

    if deleteResult > 0 then
      local insertResult = MySQL.insert.await(
        'INSERT INTO jobs (Id, Name, Type, Workplaces, Grades, Salary, SalaryTier, LastUpdated) VALUES (@Id, @Name, @Type, @Workplaces, @Grades, @Salary, @SalaryTier, @LastUpdated)',
        {
          ['@Id'] = _id,
          ['@Name'] = document.Name,
          ['@Type'] = document.Type,
          ['@Workplaces'] = json.encode(document.Workplaces),
          ['@Grades'] = json.encode(document.Grades),
          ['@Salary'] = document.Salary,
          ['@SalaryTier'] = document.SalaryTier,
          ['@LastUpdated'] = document.LastUpdated
        })

      if insertResult > 0 then
        Citizen.Wait(10000)
        return true
      else
        exports['hrrp-base']:LoggerError("Jobs", "Error Inserting Job on Default Job Update")
        return false
      end
    else
      exports['hrrp-base']:LoggerError("Jobs", "Error Deleting Job on Default Job Update")
      return false
    end
  end

  local function insertDefaultJob(document)
    local insertResult = MySQL.insert.await(
      'INSERT INTO jobs (Id, Name, Type, Workplaces, Grades, LastUpdated, Salary, SalaryTier) VALUES (@Id, @Name, @Type, @Workplaces, @Grades, @LastUpdated, @Salary, @SalaryTier)',
      {
        ['@Id'] = document.Id,
        ['@Name'] = document.Name,
        ['@Type'] = document.Type,
        ['@Workplaces'] = json.encode(document.Workplaces),
        ['@Grades'] = json.encode(document.Grades),
        ['@LastUpdated'] = document.LastUpdated,
        ['@Salary'] = document.Salary,
        ['@SalaryTier'] = document.SalaryTier
      })

    if insertResult > 0 then
      return true
    else
      exports['hrrp-base']:LoggerError('Jobs', 'Error Inserting Job on Default Job Update')
      return false
    end
  end

  local jobsFetch = FindAllJobs()
  local currentData = {}
  for k, v in ipairs(jobsFetch) do
    currentData[v.Id] = v
  end

  for k, v in ipairs(_defaultJobData) do
    local currentDataForJob = currentData[v.Id]
    if currentDataForJob and v.LastUpdated < v.LastUpdated then
      replaceExistingDefaultJob(currentDataForJob._id, v)
    elseif not currentDataForJob then
      insertDefaultJob(v)
    end
  end

  RefreshAllJobData()
  exports['hrrp-base']:LoggerTrace("Jobs", string.format("Loaded ^2%s^7 Jobs", JOB_COUNT))
  TriggerEvent("Jobs:Server:CompleteStartup")
end
