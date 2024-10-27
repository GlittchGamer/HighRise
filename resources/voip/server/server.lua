voiceData = {}
radioData = {}
callData = {}

function GetDefaultPlayerVOIPData(source)
  return {
    Radio = 0,
    Call = 0,
    LastRadio = 0,
    LastCall = 0
  }
end

-- temp fix before an actual fix is added
CreateThread(function()
  for i = 1, 1024 do
    MumbleCreateChannel(i)
  end
end)

AddEventHandler('VOIP:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
  Callbacks = exports['core']:FetchComponent('Callbacks')
  Fetch = exports['core']:FetchComponent('Fetch')
  Chat = exports['core']:FetchComponent('Chat')
  Middleware = exports['core']:FetchComponent('Middleware')
  Logger = exports['core']:FetchComponent("Logger")
  Inventory = exports['core']:FetchComponent('Inventory')
  VOIP = exports['core']:FetchComponent('VOIP')
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies('VOIP', {

    'Callbacks',
    'Fetch',
    'Chat',
    'Middleware',
    'Logger',
    'Inventory',
    'VOIP'
  }, function(error)
    if #error > 0 then return end -- Do something to handle if not all dependencies loaded
    RetrieveComponents()
    RegisterMiddleware()

    --RegisterChatCommands()
    Inventory.Items:RegisterUse('radio', 'VOIP', function(source, itemData)
      TriggerClientEvent('Radio:Client:OpenUI', source, 1)
    end)

    Inventory.Items:RegisterUse('radio_shitty', 'VOIP', function(source, itemData)
      TriggerClientEvent('Radio:Client:OpenUI', source, 2)
    end)

    Inventory.Items:RegisterUse('megaphone', 'VOIP', function(source, itemData)
      TriggerClientEvent('VOIP:Client:Megaphone:Use', source)
    end)

    RemoveEventHandler(setupEvent)
  end)
end)


_fuckingVOIP = {
  AddPlayer = function(self, source)
    if not voiceData[source] then
      voiceData[source] = GetDefaultPlayerVOIPData()
      --Player(source).state:set('routingBucket', 0, true)
    end
  end,
  RemovePlayer = function(self, source)
    if voiceData[source] then
      local plyData = voiceData[source]

      if plyData.Radio > 0 then
        VOIP.Radio:SetChannel(source, 0)
      end

      if plyData.Call > 0 then
        VOIP.Phone:SetChannel(source, 0)
      end

      voiceData[source] = nil
    end
  end,
}

function RegisterMiddleware()
  exports['core']:MiddlewareAdd('Characters:Spawning', function(source)
    _fuckingVOIP:AddPlayer(source)
  end, 3)

  exports['core']:MiddlewareAdd('Characters:Logout', function(source)
    _fuckingVOIP:RemovePlayer(source)
  end, 3)
end

AddEventHandler('Proxy:Shared:RegisterReady', function() --! Completed
  exports['core']:RegisterComponent('VOIP', _fuckingVOIP)
end)


local function exportHandler(exportName, func)
  AddEventHandler(('__cfx_export_%s_%s'):format(GetCurrentResourceName(), exportName), function(setCB)
    setCB(function(...)
      return func(_fuckingVOIP, ...)
    end)
  end)
end

for k, v in pairs(_fuckingVOIP) do
  if type(v) == "function" then
    exportHandler(k, v)
  end
end
