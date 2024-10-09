COMPONENTS.Stream = {
  _protected = true,
  _name = 'base',
}

COMPONENTS.Stream = {
  RequestModel = function(modelName)
    local modelHash = (type(modelName) == 'number' and modelName or GetHashKey(modelName))
    if not HasModelLoaded(modelHash) and IsModelInCdimage(modelHash) then
      RequestModel(modelHash)
      local timeout = 0
      while not HasModelLoaded(modelHash) do
        if timeout > 20000 then
          COMPONENTS.Logger:Error("Stream", string.format('failed to load model, please report this: %s', modelName))
        end
        Citizen.Wait(1)
        timeout += 1
      end
    end
  end,
  RequestAnimDict = function(dictName)
    RequestAnimDict(dictName)
    while not HasAnimDictLoaded(dictName) do
      Citizen.Wait(100)
    end
  end,
  RequestAnimSet = function(setName)
    RequestAnimSet(setName)
    while not HasAnimSetLoaded(setName) do
      Citizen.Wait(100)
    end
  end
}

local function exportHandler(exportName, func)
  AddEventHandler(('__cfx_export_%s_%s'):format(GetCurrentResourceName(), exportName), function(setCB)
    setCB(function(...)
      return func(COMPONENTS.Stream, ...)
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

for k, v in pairs(COMPONENTS.Stream) do
  if type(v) == "function" then
    exportHandler("Stream" .. k, v)
  elseif type(v) == "table" then
    createExportForObject(v, "Stream" .. k)
  end
end
