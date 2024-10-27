Callbacks = nil
Status = nil

local _statuses = {}

AddEventHandler("Status:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Callbacks = exports['core']:FetchComponent("Callbacks")
  Fetch = exports['core']:FetchComponent("Fetch")
  Utils = exports['core']:FetchComponent("Utils")
  Chat = exports['core']:FetchComponent("Chat")
  Status = exports['core']:FetchComponent("Status")
  Inventory = exports['core']:FetchComponent("Inventory")
  Wallet = exports['core']:FetchComponent("Wallet")
  Execute = exports['core']:FetchComponent("Execute")
  RegisterChatCommands()
  registerUsables()
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies("Status", {
    "Callbacks",
    "Fetch",
    "Utils",
    "Chat",
    "Status",
    "Inventory",
    "Wallet",
    "Execute",
  }, function(error)
    if #error > 0 then
      return
    end -- Do something to handle if not all dependencies loaded
    RetrieveComponents()
    RegisterCallbacks()

    RemoveEventHandler(setupEvent)
  end)
end)

STATUS = {
  Register = function(self, name, max, icon, tick, modify)
    table.insert(_statuses, {
      name = name,
      max = max,
      icon = icon,
      tick = tick,
      modify = modify,
    })
  end,
  Get = {
    All = function(self)
      return _statuses
    end,
    Single = function(self, name)
      for k, v in ipairs(_statuses) do
        if v.name == name then
          return v
        end
      end
    end,
  },
  Modify = {
    Add = function(self, source, name, value, addCd, isForced)
      exports['core']:CallbacksClient(source, "Status:Modify", {
        name = name,
        value = math.abs(value),
        addCd = addCd,
        isForced = isForced,
      })
    end,
    Remove = function(self, source, name, value, addCd, isForced)
      exports['core']:CallbacksClient(source, "Status:Modify", {
        name = name,
        value = -(math.abs(value)),
        addCd = addCd,
        isForced = isForced,
      })
    end,
  },
  Set = function(self, source, name, value)
    local player = exports['core']:FetchSource(source)
    local char = player:GetData("Character")
    if char ~= nil then
      local status = char:GetData("Status")
      if status == nil then
        status = {}
      end
      status[name] = value
      char:SetData("Status", status)
      TriggerClientEvent("Status:Client:Update", source, name, value)
    end
  end,
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
  exports['core']:RegisterComponent("Status", STATUS)
end)

RegisterServerEvent("Status:Server:Update", function(data)
  local player = exports['core']:FetchSource(source)
  local char = player:GetData("Character")
  if char ~= nil then
    local status = char:GetData("Status")
    if status == nil then
      status = {}
    end
    status[data.status] = data.value
    char:SetData("Status", status)
  end
end)
