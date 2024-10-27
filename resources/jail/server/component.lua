AddEventHandler("Jail:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Middleware = exports['core']:FetchComponent("Middleware")
  Callbacks = exports['core']:FetchComponent("Callbacks")
  Logger = exports['core']:FetchComponent("Logger")
  Fetch = exports['core']:FetchComponent("Fetch")
  Execute = exports['core']:FetchComponent("Execute")
  Routing = exports['core']:FetchComponent("Routing")
  Chat = exports['core']:FetchComponent("Chat")
  Jobs = exports['core']:FetchComponent("Jobs")
  Handcuffs = exports['core']:FetchComponent("Handcuffs")
  Ped = exports['core']:FetchComponent("Ped")
  Inventory = exports['core']:FetchComponent("Inventory")
  Sounds = exports['core']:FetchComponent("Sounds")
  Labor = exports['core']:FetchComponent("Labor")
  Loans = exports['core']:FetchComponent("Loans")
  Jail = exports['core']:FetchComponent("Jail")
  Pwnzor = exports['core']:FetchComponent("Pwnzor")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies("Jail", {
    "Middleware",
    "Callbacks",
    "Logger",
    "Fetch",
    "Execute",
    "Routing",
    "Chat",
    "Jobs",
    "Handcuffs",
    "Ped",
    "Inventory",
    "Sounds",
    "Labor",
    "Loans",
    "Jail",
    "Pwnzor",
  }, function(error)
    if #error > 0 then
      return
    end
    RetrieveComponents()
    RegisterCommands()
    RegisterCallbacks()
    RegisterMiddleware()
    RemoveEventHandler(setupEvent)
  end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
  exports['core']:RegisterComponent("Jail", _JAIL)
end)

function RegisterCommands()
  Chat:RegisterCommand(
    "jail",
    function(source, args, rawCommand)
      if tonumber(args[1]) and tonumber(args[2]) then
        local plyr = exports['core']:FetchSID(tonumber(args[1]))
        if plyr ~= nil then
          local char = plyr:GetData("Character")
          if char ~= nil then
            Jail:Sentence(source, plyr:GetData("Source"), tonumber(args[2]))
            Chat.Send.System:Single(
              source,
              string.format("%s Has Been Jailed For %s Months", args[1], args[2])
            )
          else
            Chat.Send.System:Single(source, "State ID Not Logged In")
          end
        else
          Chat.Send.System:Single(source, "State ID Not Logged In")
        end
      else
        Chat.Send.System:Single(source, "Invalid Arguments")
      end
    end,
    {
      help = "Jail Player",
      params = {
        {
          name = "Target",
          help = "State ID of target",
        },
        {
          name = "Length",
          help = "How long, in months (minutes), to jail player",
        },
      },
    },
    2,
    {
      {
        Id = "police",
      },
    }
  )

  Chat:RegisterCommand(
    "unjail",
    function(source, args, rawCommand)
      if tonumber(args[1]) then
        local plyr = exports['core']:FetchSID(tonumber(args[1]))
        if plyr ~= nil then
          local char = plyr:GetData("Character")
          if char ~= nil then
            Jail:Release(plyr:GetData("Source"), true)
            Chat.Send.System:Single(
              source,
              string.format("%s Has Been Released from Jail", args[1], args[2])
            )
          else
            Chat.Send.System:Single(source, "State ID Not Logged In")
          end
        else
          Chat.Send.System:Single(source, "State ID Not Logged In")
        end
      else
        Chat.Send.System:Single(source, "Invalid Arguments")
      end
    end,
    {
      help = "UnJail Player",
      params = {
        {
          name = "Target",
          help = "State ID of target",
        }
      },
    },
    1,
    {
      {
        Id = "police",
      },
    }
  )
end

_JAIL = {
  IsJailed = function(self, source)
    local player = exports['core']:FetchSource(source)
    if player ~= nil then
      local char = player:GetData("Character")
      if char ~= nil then
        local jailed = char:GetData("Jailed")
        if jailed and not jailed.Released then
          return true
        else
          return false
        end
      else
        return false
      end
    else
      return false
    end
  end,
  IsReleaseEligible = function(self, source, override)
    local player = exports['core']:FetchSource(source)
    if player ~= nil then
      local char = player:GetData("Character")
      if char ~= nil then
        local jailed = char:GetData("Jailed")

        if override then
          return true
        end

        if not jailed or jailed and jailed.Duration < 9999 and os.time() >= (jailed.Release or 0) then
          return true
        else
          return false
        end
      else
        return false
      end
    else
      return false
    end
  end,
  Sentence = function(self, source, target, duration)
    local jailer = exports['core']:FetchSource(source):GetData("Character")
    local jState = Player(source).state
    local jailerName = "LOS SANTOS POLICE DEPARTMENT"
    for k, v in ipairs(jailer:GetData("Jobs")) do
      if v.Id == jState.onDuty then
        if v.Workplace ~= nil then
          jailerName = v.Workplace.Name
        else
          jailerName = v.Name
        end
        break
      end
    end

    local char = exports['core']:FetchSource(target):GetData("Character")
    if char ~= nil then
      if char:GetData("ICU") ~= nil and char:GetData("ICU").Released ~= nil and not char:GetData("ICU").Released then
        return false
      end

      Labor.Jail:Sentenced(target)

      char:SetData("Jailed", {
        Time = os.time(),
        Release = (os.time() + (60 * duration)),
        Duration = duration,
        Released = false,
      })

      Citizen.CreateThread(function()
        exports['jobs']:JobsDutyOff(target, Player(target).state.onDuty)
        Handcuffs:UncuffTarget(-1, target)
        Ped.Mask:UnequipNoItem(target)
        Inventory.Holding:Put(target)
      end)

      TriggerClientEvent("Jail:Client:Jailed", target)
      exports['pwnzor']:PwnzorPlayersTempPosIgnore(target)
      exports['core']:CallbacksClient(target, "Jail:DoMugshot", {
        jailer = jailerName,
        duration = duration,
        date = os.date("%c"),
      }, function()
        TriggerClientEvent("Jail:Client:EnterJail", target)
      end)

      if duration >= 75 then
        local creditDecrease = 20

        local creditMult = math.floor(duration / 100)
        if creditMult >= 1 then
          creditDecrease += creditMult * 15
        end

        Loans.Credit:Decrease(char:GetData('SID'), creditDecrease)
      end
    else
      return false
    end
  end,
  Release = function(self, source, override)
    if Jail:IsReleaseEligible(source) then
      local char = exports['core']:FetchSource(source):GetData("Character")
      if char ~= nil then
        Labor.Jail:Released(source, override)
        char:SetData("Jailed", {
          Time = nil,
          Release = nil,
          Duration = nil,
          Released = true,
        })
        return true
      else
        return false
      end
    else
      exports['core']:ExecuteClient(source, "Notification", "Error", "Not Eligible For Release")
      return false
    end
  end,
}
