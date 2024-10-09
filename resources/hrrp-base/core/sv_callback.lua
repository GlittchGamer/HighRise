local _sCallbacks = {}
local _cCallbacks = {}

COMPONENTS.Callbacks = {
  _required = { 'RegisterServerCallback', 'DoServerCallback', 'ClientCallback' },
  _name = 'base',
  RegisterServerCallback = function(self, event, cb)
    _sCallbacks[event] = cb
  end,
  DoServerCallback = function(self, source, event, data, extraId)
    if _sCallbacks[event] ~= nil then
      Citizen.CreateThread(function()
        _sCallbacks[event](source, data, function(...)
          TriggerClientEvent('Callbacks:Client:ReceiveCallback', source, event, extraId, ...)
        end)
      end)
    end
  end,
  ClientCallback = function(self, source, event, data, cb, extraId)
    if data == nil then data = {} end

    id = string.format("%s", event)
    if extraId ~= nil then
      id = string.format("%s-%s", event, extraId)
    else
      extraId = ''
    end

    _cCallbacks[source] = _cCallbacks[source] or {}
    _cCallbacks[source][id] = cb
    TriggerClientEvent('Callbacks:Client:TriggerEvent', source, event, data, extraId)
  end,
  Client = function(self, source, event, data, cb, extraId)
    self:ClientCallback(source, event, data, cb, extraId)
  end,
  RegisterServer = function(self, event, cb)
    self:RegisterServerCallback(event, cb)
  end,
}

RegisterServerEvent('Callbacks:Server:TriggerEvent', function(event, data, extraId)
  data = data or {}
  COMPONENTS.Callbacks:DoServerCallback(source, event, data, extraId)
end)

RegisterServerEvent('Callbacks:Server:ReceiveCallback', function(event, extraId, ...)
  local src = source
  local id = event

  if extraId ~= nil and extraId ~= "" then
    id = string.format("%s-%s", event, extraId)
  end

  _cCallbacks[src] = _cCallbacks[src] or {}
  if _cCallbacks[src][id] ~= nil then
    _cCallbacks[src][id](...)
    _cCallbacks[src][id] = nil
  end
end)

local function exportHandler(exportName, func)
  AddEventHandler(('__cfx_export_%s_%s'):format(GetCurrentResourceName(), exportName), function(setCB)
    setCB(function(...)
      return func(COMPONENTS.Callbacks, ...)
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

for k, v in pairs(COMPONENTS.Callbacks) do
  if type(v) == "function" then
    exportHandler("Callbacks" .. k, v)
  elseif type(v) == "table" then
    createExportForObject(v, "Callbacks" .. k)
  end
end
