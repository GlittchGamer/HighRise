BED_LIMIT = #Config.Beds
_inBed = {}
_inBedChar = {}

AddEventHandler("Damage:Shared:DependencyUpdate", HospitalComponents)
function HospitalComponents()
  Callbacks = exports['core']:FetchComponent("Callbacks")
  Middleware = exports['core']:FetchComponent("Middleware")
  Fetch = exports['core']:FetchComponent("Fetch")
  Damage = exports['core']:FetchComponent("Damage")
  Hospital = exports['core']:FetchComponent("Hospital")
  Crypto = exports['core']:FetchComponent("Crypto")
  Phone = exports['core']:FetchComponent("Phone")
  Execute = exports['core']:FetchComponent("Execute")
  Chat = exports['core']:FetchComponent("Chat")
  Billing = exports['core']:FetchComponent("Billing")
  Inventory = exports['core']:FetchComponent("Inventory")
  Labor = exports['core']:FetchComponent("Labor")
  Jobs = exports['core']:FetchComponent("Jobs")
  Handcuffs = exports['core']:FetchComponent("Handcuffs")
  Ped = exports['core']:FetchComponent("Ped")
  Routing = exports['core']:FetchComponent("Routing")
  Pwnzor = exports['core']:FetchComponent("Pwnzor")
  Banking = exports['core']:FetchComponent("Banking")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies("Hospital", {
    "Callbacks",
    "Middleware",
    "Fetch",
    "Damage",
    "Hospital",
    "Crypto",
    "Phone",
    "Execute",
    "Chat",
    "Billing",
    "Inventory",
    "Labor",
    "Jobs",
    "Handcuffs",
    "Ped",
    "Routing",
    "Pwnzor",
    "Banking",
  }, function(error)
    if #error > 0 then
      return
    end -- Do something to handle if not all dependencies loaded
    HospitalComponents()
    HospitalCallbacks()
    HospitalMiddleware()

    GlobalState["HiddenHospital"] = {
      coords = vector3(1730.343, 3029.604, 62.170),
      heading = 74.207,
    }

    Chat:RegisterAdminCommand("clearbeds", function(source, args, rawCommand)
      _inBed = {}
    end, {
      help = "Force Clear All Hospital Beds",
      params = {},
    }, -1)

    RemoveEventHandler(setupEvent)
  end)
end)

HOSPITAL = {
  RequestBed = function(self, source)
    --return math.random(#Config.Beds)
    for k, v in ipairs(Config.Beds) do
      if _inBed[k] == nil then
        return k
      end
    end
    return nil
  end,
  FindBed = function(self, source, location)
    for k, v in ipairs(Config.Beds) do
      if (#(vector3(v.x, v.y, v.z) - vector3(location.x, location.y, location.z)) <= 2.0) and not _inBed[k] then
        return k
      end
    end
    return nil
  end,
  OccupyBed = function(self, source, bedId)
    local char = exports['core']:FetchSource(source):GetData("Character")
    if char and Config.Beds[bedId] ~= nil then
      if _inBed[bedId] == nil then
        _inBedChar[char:GetData("ID")] = bedId
        _inBed[bedId] = char:GetData("ID")
        return true
      else
        return false
      end
    else
      return false
    end
  end,
  LeaveBed = function(self, source)
    local char = exports['core']:FetchSource(source):GetData("Character")
    if char ~= nil then
      local inBedId = _inBedChar[char:GetData("ID")]
      if inBedId ~= nil then
        _inBed[inBedId] = nil
        _inBedChar[char:GetData("ID")] = nil
        return true
      end
    end
    return false
  end,
  ICU = {
    Send = function(self, target)
      local plyr = exports['core']:FetchSource(target)
      if plyr ~= nil then
        local char = plyr:GetData("Character")
        if char ~= nil then
          if char:GetData("ICU") ~= nil and char:GetData("ICU").Released ~= nil and not char:GetData("ICU").Released then
            return false
          end

          Labor.Jail:Sentenced(target)

          Player(target).state.ICU = true
          char:SetData("ICU", {
            Released = false,
          })

          Citizen.CreateThread(function()
            exports['jobs']:JobsDutyOff(target, Player(target).state.onDuty)
            Handcuffs:UncuffTarget(-1, target)
            Ped.Mask:UnequipNoItem(target)
            Inventory.Holding:Put(target)
          end)

          exports['pwnzor']:PwnzorPlayersTempPosIgnore(target)
          TriggerClientEvent("Hospital:Client:ICU:Sent", target)
          TriggerClientEvent("Hospital:Client:ICU:Enter", target)
          exports['core']:ExecuteClient(target, "Notification", "Info", "You Were Admitted To ICU")
        else
          return false
        end
      else
        return false
      end
    end,
    Release = function(self, target)
      local plyr = exports['core']:FetchSource(target)
      if plyr ~= nil then
        local char = plyr:GetData("Character")
        if char ~= nil then
          Player(target).state.ICU = false
          char:SetData("ICU", {
            Released = true,
            Items = false,
          })
          exports['core']:ExecuteClient(target, "Notification", "Info", "You Were Released From ICU")
        else
          return false
        end
      else
        return false
      end
    end,
    GetItems = function(self, target)
      local plyr = exports['core']:FetchSource(target)
      if plyr ~= nil then
        local char = plyr:GetData("Character")
        if char ~= nil then
          Player(target).state.ICU = false
          char:SetData("ICU", {
            Released = true,
            Items = true,
          })
          Inventory.Holding:Take(target)
        else
          return false
        end
      else
        return false
      end
    end,
  },
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
  exports['core']:RegisterComponent("Hospital", HOSPITAL)
end)