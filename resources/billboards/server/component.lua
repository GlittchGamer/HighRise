AddEventHandler("Billboards:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Fetch = exports['core']:FetchComponent("Fetch")
  Utils = exports['core']:FetchComponent("Utils")
  Execute = exports['core']:FetchComponent("Execute")

  Middleware = exports['core']:FetchComponent("Middleware")
  Callbacks = exports['core']:FetchComponent("Callbacks")
  Chat = exports['core']:FetchComponent("Chat")
  Logger = exports['core']:FetchComponent("Logger")
  Generator = exports['core']:FetchComponent("Generator")
  Phone = exports['core']:FetchComponent("Phone")
  Jobs = exports['core']:FetchComponent("Jobs")
  Vehicles = exports['core']:FetchComponent("Vehicles")
  Inventory = exports['core']:FetchComponent("Inventory")
  Billboards = exports['core']:FetchComponent("Billboards")
  Regex = exports['core']:FetchComponent("Regex")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies("Billboards", {
    "Fetch",
    "Utils",
    "Execute",
    "Chat",

    "Middleware",
    "Callbacks",
    "Logger",
    "Generator",
    "Phone",
    "Jobs",
    "Vehicles",
    "Inventory",
    "Billboards",
    "Regex",
  }, function(error)
    if #error > 0 then
      exports['core']:FetchComponent("Logger"):Critical("Billboards", "Failed To Load All Dependencies")
      return
    end
    RetrieveComponents()

    FetchBillboardsData()

    Chat:RegisterAdminCommand("setbillboard", function(source, args, rawCommand)
      local billboardId, billboardUrl = args[1], args[2]
      print(billboardId, billboardUrl)
      if #billboardUrl <= 10 then
        print("Return here?")
        billboardUrl = false
      end
      print("updating")
      local didUpdate = Billboards:Set(billboardId, billboardUrl)
      print(didUpdate)
    end, {
      help = "Set a Billboard URL",
      params = {
        {
          name = "ID",
          help = "Billboard ID",
        },
        {
          name = "URL",
          help = "Billboard URL",
        },
      },
    }, 2)

    exports['core']:CallbacksRegisterServer("Billboards:UpdateURL", function(source, data, cb)
      local billboardData = _billboardConfig[data?.id]
      if billboardData and billboardData.job and Player(source).state.onDuty == billboardData.job then
        local billboardUrl = data.link
        if #billboardUrl <= 5 then
          billboardUrl = false
        end

        if not billboardUrl or Regex:Test(_billboardRegex, billboardUrl, "gim") then
          cb(Billboards:Set(data.id, billboardUrl))
        else
          cb(false, true)
        end
      else
        cb(false)
      end
    end)

    RemoveEventHandler(setupEvent)
  end)
end)

_BILLBOARDS = {
  Set = function(self, id, url)
    if id and _billboardConfig[id] then
      local updated = SetBillboardURL(id, url)
      if updated then
        GlobalState[string.format("Billboards:%s", id)] = url

        TriggerClientEvent('Billboards:Client:UpdateBoardURL', -1, id, url)

        return true
      end
    end
    return false
  end,
  Get = function(self, id)
    return GlobalState[string.format("Billboards:%s", id)]
  end,
  GetCategory = function(self, cat)
    local cIds = {}

    for k, v in pairs(_billboardConfig) do
      if v.category == cat then
        table.insert(cIds, k)
      end
    end

    return cIds
  end,
}

AddEventHandler("Proxy:Shared:RegisterReady", function(component)
  exports['core']:RegisterComponent("Billboards", _BILLBOARDS)
end)

local started = false
function FetchBillboardsData()
  if started then return; end

  started = true

  local fetchedBillboards = {}
  local billboardIds = {}

  local billboards = MySQL.query.await("SELECT * FROM billboards")
  if billboards then
    for k, v in ipairs(billboards) do
      if v.billboardId and v.billboardUrl then
        fetchedBillboards[v.billboardId] = v.billboardUrl
      end
    end

    for k, v in pairs(_billboardConfig) do
      GlobalState[string.format("Billboards:%s", k)] = fetchedBillboards[k]

      table.insert(billboardIds, k)
    end
  end
end

function SetBillboardURL(billboardId, url)
  local doesBillBoardExist = MySQL.single.await("SELECT * FROM billboards WHERE billboardId = @billboardId", {
    ["@billboardId"] = billboardId,
  })
  if not doesBillBoardExist then
    MySQL.query.await("INSERT INTO billboards (billboardId, billboardUrl) VALUES (@billboardId, @billboardUrl)", {
      ["@billboardId"] = billboardId,
      ["@billboardUrl"] = url,
    })
  else
    MySQL.query.await("UPDATE billboards SET billboardUrl = @billboardUrl WHERE billboardId = @billboardId", {
      ["@billboardId"] = billboardId,
      ["@billboardUrl"] = url,
    })
  end
  return true
end
