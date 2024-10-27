AddEventHandler('Animations:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
  Utils = exports['core']:FetchComponent('Utils')
  Callbacks = exports['core']:FetchComponent('Callbacks')
  Chat = exports['core']:FetchComponent('Chat')
  Middleware = exports['core']:FetchComponent('Middleware')
  Inventory = exports['core']:FetchComponent('Inventory')
  RegisterChatCommands()
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies('Animations', {
    'Utils',
    'Callbacks',
    'Chat',
    'Middleware',
    'Inventory',
  }, function(error)
    if #error > 0 then return end -- Do something to handle if not all dependencies loaded
    RetrieveComponents()
    RegisterCallbacks()
    RegisterMiddleware()

    RegisterItems()

    RemoveEventHandler(setupEvent)
  end)
end)

function RegisterMiddleware()
  exports['core']:MiddlewareAdd('Characters:Spawning', function(source)
    local player = exports['core']:FetchComponent('Fetch'):Source(source)
    local char = player:GetData('Character')
    ANIMATIONS:GetData(char, function(data)
      TriggerClientEvent('Animations:Client:RecieveStoredAnimSettings', source, data)
    end)
  end, 2)
end

function RegisterChatCommands()
  Chat:RegisterCommand('e', function(source, args, rawCommand)
    local emote = args[1]
    if emote == "c" or emote == "cancel" then
      TriggerClientEvent('Animations:Client:CharacterCancelEmote', source)
    else
      TriggerClientEvent('Animations:Client:CharacterDoAnEmote', source, emote)
    end
  end, {
    help = 'Do An Emote or Dance',
    params = { {
      name = 'Emote',
      help = 'Name of The Emote'
    } },
  })
  Chat:RegisterCommand('emotes', function(source, args, rawCommand)
    TriggerClientEvent('Animations:Client:OpenMainEmoteMenu', source)
  end, {
    help = 'Open Emote Menu',
  })
  Chat:RegisterCommand('emotebinds', function(source, args, rawCommand)
    TriggerClientEvent('Animations:Client:OpenEmoteBinds', source)
  end, {
    help = 'Edit Emote Binds',
  })
  Chat:RegisterCommand('walks', function(source, args, rawCommand)
    TriggerClientEvent('Animations:Client:OpenWalksMenu', source)
  end, {
    help = 'Change Walk Style',
  })
  Chat:RegisterCommand('face', function(source, args, rawCommand)
    TriggerClientEvent('Animations:Client:OpenExpressionsMenu', source)
  end, {
    help = 'Change Facial Expression',
  })
  Chat:RegisterCommand('selfie', function(source, args, rawCommand)
    TriggerClientEvent('Animations:Client:Selfie', source)
  end, {
    help = 'Open Selfie Mode',
  })
end

function RegisterCallbacks()
  exports['core']:CallbacksRegisterServer('Animations:UpdatePedFeatures', function(source, data, cb)
    local _src = source
    local player = exports['core']:FetchComponent('Fetch'):Source(_src)
    local char = player:GetData('Character')
    ANIMATIONS.PedFeatures:UpdateFeatureInfo(char, data.type, data.data, function(success)
      cb(success)
    end)
  end)

  exports['core']:CallbacksRegisterServer('Animations:UpdateEmoteBinds', function(source, data, cb)
    local _src = source
    local player = exports['core']:FetchComponent('Fetch'):Source(_src)
    local char = player:GetData('Character')
    ANIMATIONS.EmoteBinds:Update(char, data, function(success)
      cb(success, data)
    end)
  end)
end

ANIMATIONS = {
  PedFeatures = {
    UpdateFeatureInfo = function(self, char, type, data, cb)
      if type == "walk" then
        local currentData = char:GetData('Animations')
        char:SetData('Animations',
          { walk = data, expression = currentData.expression, emoteBinds = currentData.emoteBinds })
        cb(true)
      elseif type == "expression" then
        local currentData = char:GetData('Animations')
        char:SetData('Animations', { walk = currentData.walk, expression = data, emoteBinds = currentData.emoteBinds })
        cb(true)
      else
        cb(false)
      end
    end,
  },
  EmoteBinds = {
    Update = function(self, char, data, cb)
      local currentData = char:GetData('Animations')
      char:SetData('Animations', { walk = currentData.walk, expression = currentData.expression, emoteBinds = data })
      cb(true)
    end,
  },
  GetData = function(self, char, cb)
    if char:GetData('Animations') == nil then
      char:SetData('Animations', { walk = 'default', expression = 'default', emoteBinds = {} })
    end
    cb(char:GetData('Animations'))
  end,
}

local function exportHandler(exportName, func)
  AddEventHandler(('__cfx_export_%s_%s'):format(GetCurrentResourceName(), exportName), function(setCB)
    setCB(function(...)
      return func(ANIMATIONS, ...)
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

for k, v in pairs(ANIMATIONS) do
  if type(v) == "function" then
    exportHandler("Animations" .. k, v)
  elseif type(v) == "table" then
    createExportForObject(v, "Animations" .. k)
  end
end


RegisterServerEvent('Animations:Server:ClearAttached', function(propsToDelete)
  local src = source
  local ped = GetPlayerPed(src)

  if ped then
    for k, v in ipairs(GetAllObjects()) do
      if GetEntityAttachedTo(v) == ped and propsToDelete[GetEntityModel(v)] then
        DeleteEntity(v)
      end
    end
  end
end)
