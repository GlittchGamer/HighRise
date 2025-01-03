local _cachedSeq = {}
local _loading = {}

COMPONENTS.Sequence = {
  Get = function(self, key)
    if _loading[key] then
      repeat
        Wait(10)
      until not _loading[key]
    end

    if _cachedSeq[key] ~= nil then
      _cachedSeq[key] = {
        value = _cachedSeq[key].value + 1,
        dirty = true
      }
      return _cachedSeq[key].value
    else
      _loading[key] = true

      local SequenceData = {
        value = nil,
        dirty = false
      }
      local findSequenceKey = MySQL.single.await("SELECT * FROM `sequence` WHERE `key` = @key", {
        ['@key'] = key
      })
      COMPONENTS.Logger:Info("Base", 'We have selected from the sequence for key ' .. key .. '', {
        console = true,
      })
      if findSequenceKey == nil then
        local insertSequence = MySQL.insert.await("INSERT INTO `sequence` (`key`, `current`) VALUES (@key, @current)", {
          ['@key'] = key,
          ['@current'] = 1
        })
        COMPONENTS.Logger:Info("Base", 'We need the insert the key ' .. key .. '', {
          console = true,
        })
        SequenceData.value = 1
        SequenceData.dirty = true
      else
        COMPONENTS.Logger:Info("Base", 'We have updated the sequence and value for key ' .. key .. '', {
          console = true,
        })
        SequenceData.value = findSequenceKey.current + 1
        SequenceData.dirty = true
      end

      _cachedSeq[key] = SequenceData
      _loading[key] = false
      return SequenceData.value
    end
  end,
  Save = function(self)
    for k, v in pairs(_cachedSeq) do
      if v.dirty then
        local findSequenceKey = MySQL.single.await("SELECT * FROM `sequence` WHERE `key` = @key", {
          ['@key'] = k
        })
        if findSequenceKey == nil then
          MySQL.insert.await("INSERT INTO `sequence` (`key`, `current`) VALUES (@key, @current)", {
            ['@key'] = k,
            ['@current'] = v.value
          })
        else
          MySQL.update.await("UPDATE `sequence` SET `current` = @current WHERE `key` = @key", {
            ['@current'] = v.value,
            ['@key'] = k
          })
        end
        v.dirty = false
      end
    end
  end,
}

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  COMPONENTS.Tasks:Register("sequence_save", 1, function()
    COMPONENTS.Sequence:Save()
  end)

  RemoveEventHandler(setupEvent)
end)

AddEventHandler("Core:Server:ForceSave", function()
  COMPONENTS.Sequence:Save()
end)


local function exportHandler(exportName, func)
  AddEventHandler(('__cfx_export_%s_%s'):format(GetCurrentResourceName(), exportName), function(setCB)
    setCB(function(...)
      return func(COMPONENTS.Sequence, ...)
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

for k, v in pairs(COMPONENTS.Sequence) do
  if type(v) == "function" then
    exportHandler("Sequence" .. k, v)
  elseif type(v) == "table" then
    createExportForObject(v, "Sequence" .. k)
  end
end
