COMPONENTS.Fetch = {
  _required = { "Source", "PlayerData", "All" },
  _name = "base",
  Source = function(self, source)
    return COMPONENTS.Players[source]
  end,
  PlayerData = function(self, key, value)
    for k, v in pairs(COMPONENTS.Players) do
      if v:GetData(key) == value then
        return v
      end
    end

    return nil
  end,
  Website = function(self, type, id)
    if type == "account" then
      local data = COMPONENTS.WebAPI.GetMember:AccountID(id)
      if data ~= nil then
        return COMPONENTS.DataStore:CreateStore('Fetch', data.id, {
          ID = data.id,
          AccountID = data.id,
          Identifier = data.identifier,
          Name = data.name,
          Roles = data.roles,
        })
      end
    elseif type == "identifier" then
      local data = COMPONENTS.WebAPI.GetMember:Identifier(id)
      if data ~= nil then
        return COMPONENTS.DataStore:CreateStore('Fetch', data.id, {
          ID = data.id,
          AccountID = data.id,
          Identifier = data.identifier,
          Name = data.name,
          Roles = data.roles,
        })
      end
    end
    return nil
  end,
  All = function(self)
    return COMPONENTS.Players
  end,
  Count = function(self)
    local c = 0
    for k, v in pairs(COMPONENTS.Players) do
      if v ~= nil then
        c = c + 1
      end
    end
    return c
  end,
  --! Because characters no need to handle fetch anymore
  CharacterData = function(self, key, value)
    for _, v in ipairs(GetPlayers()) do
      local plyr = self:Source(tonumber(v))
      if plyr ~= nil then
        local char = plyr:GetData("Character")
        if char ~= nil then
          local data = char:GetData(key)
          if data ~= nil and data == value then
            return plyr
          end
        end
      end
    end
    return nil
  end,
  Next = function(self, prev)
    local retNext = false
    for k, v in pairs(COMPONENTS.Players) do
      if prev == 0 or retNext then
        return v
      elseif prev == v:GetData("Source") then
        retNext = true
      end
    end

    return nil
  end,
  CountCharacters = function(self)
    local c = 0
    for k, v in pairs(COMPONENTS.Players) do
      if v:GetData("Character") ~= nil then
        c = c + 1
      end
    end
    return c
  end,
  ID = function(self, value)
    return self:CharacterData("ID", value)
  end,
  SID = function(self, value)
    return self:CharacterData("SID", value)
  end,
  GetOfflineData = function(self, stateId, key)
    local offlineChar = MySQL.single.await("SELECT * FROM characters WHERE SID = @SID", {
      ["@SID"] = stateId,
    })
    if offlineChar == nil then
      return nil
    end

    return _tablesToDecode[key] and json.decode(offlineChar[key]) or offlineChar[key]
  end,
}

local function exportHandler(exportName, func)
  AddEventHandler(('__cfx_export_%s_%s'):format(GetCurrentResourceName(), exportName), function(setCB)
    setCB(function(...)
      return func(COMPONENTS.Fetch, ...)
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

for k, v in pairs(COMPONENTS.Fetch) do
  if type(v) == "function" then
    exportHandler("Fetch" .. k, v)
  elseif type(v) == "table" then
    createExportForObject(v, "Fetch" .. k)
  end
end
