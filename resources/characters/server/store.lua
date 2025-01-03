local _noUpdate = { "Source", "User", "_id", "ID", "First", "Last", "Phone", "DOB", "Gender", "TempJob", "Ped",
  "MDTHistory", "Parole", "Preview", "Team" }

local _saving = {}

function StoreData(source)
  if _saving[source] then
    return
  end
  _saving[source] = true
  local plyr = exports['core']:FetchSource(source)
  local char = plyr:GetData("Character")
  local data = char:GetData()
  local cId = data.ID
  for k, v in ipairs(_noUpdate) do
    data[v] = nil
  end

  local ped = GetPlayerPed(source)
  if ped > 0 then
    data.HP = GetEntityHealth(ped)
    data.Armor = GetPedArmour(ped)
  end

  if data.States then
    local s = {}
    for k, v in ipairs(data.States) do
      if string.sub(v, 1, string.len("SCRIPT")) ~= "SCRIPT" then
        table.insert(s, v)
      end
    end
    data.States = s
  end

  -- data.LastPlayed = os.date("%c")
  data.LastPlayed = os.time() * 1000

  exports['core']:LoggerTrace("Characters", string.format("Saving Character %s", cId), { console = true })

  local dbData = Utils:CloneDeep(data)

  for k, v in pairs(dbData) do
    if type(v) == "table" then
      dbData[k] = json.encode(v)
    end
  end

  -- Construct the SQL query
  local updateFields = {}
  for k, v in pairs(dbData) do
    if not table.contains(_noUpdate, k) then
      table.insert(updateFields, string.format("`%s` = @%s", k, k))
    end
  end

  local query = string.format([[
        UPDATE `characters` SET %s WHERE `User` = @User AND `_id` = @ID
    ]], table.concat(updateFields, ", "))

  dbData['@User'] = plyr:GetData("AccountID")
  dbData['@ID'] = cId

  local saveCharacter = MySQL.update.await(query, dbData)
  _saving[source] = false

  exports['core']:LoggerTrace("Characters", string.format("Character %s has been saved to the Database successfully", cId),
    { console = true })
end

-- Helper function to check if a table contains a value
function table.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

local _prevSaved = 0
Citizen.CreateThread(function()
  while Fetch == nil or Database == nil do
    Citizen.Wait(1000)
  end

  Citizen.Wait(120000)

  while true do
    local v = exports['core']:FetchNext(_prevSaved)
    exports['core']:LoggerTrace(
      "Characters",
      string.format("BEFORE SAVE, _prevSaved: %s, v ~= nil: %s", _prevSaved, tostring(v ~= nil)),
      { console = true }
    )
    if v ~= nil then
      local s = v:GetData("Source")
      if v:GetData("Character") ~= nil then
        StoreData(s)
      end
      _prevSaved = s
    else
      _prevSaved = 0
    end

    local c = exports['core']:FetchCountCharacters() or 1
    exports['core']:LoggerTrace(
      "Characters",
      string.format("AFTER SAVE, _prevSaved: %s, characters: %s", _prevSaved, c),
      { console = true }
    )

    Citizen.Wait(600000 / math.max(1, c))
  end
end)
