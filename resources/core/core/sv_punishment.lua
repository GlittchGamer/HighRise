COMPONENTS.Punishment = {
  _required = { "CheckBan", "Kick", "Unban", "Ban" },
  _name = "base",
  CheckBan = function(self, key, value)
    local p = promise.new()
    local query = string.format("SELECT * FROM bans WHERE %s = @value AND active = 1", key)
    MySQL.Async.fetchAll(query, { ['@value'] = value }, function(results)
      if #results > 0 then
        for _, v in ipairs(results) do
          if v.expires < os.time() and v.expires ~= -1 then
            MySQL.Async.execute("UPDATE bans SET active = 0 WHERE _id = @id", { ['@id'] = v._id })
          else
            return p:resolve(v)
          end
        end
        p:resolve(nil)
      else
        p:resolve(nil)
      end
    end)
    return Citizen.Await(p)
  end,
  Kick = function(self, source, reason, issuer, afk)
    local tPlayer = COMPONENTS.exports['core']:FetchSource(source)
    if not tPlayer then
      return { success = false }
    end
    if issuer ~= "Pwnzor" then
      if source == issuer then
        return { success = false, message = "Cannot Ban Yourself!" }
      end
      local iPlayer = COMPONENTS.exports['core']:FetchSource(issuer)
      if not iPlayer then
        return { success = false }
      end
      if iPlayer.Permissions:GetLevel() <= tPlayer.Permissions:GetLevel() then
        return { success = false, message = "Insufficient Permissions" }
      end
      COMPONENTS.Logger:Info(
        "Punishment",
        string.format("%s [%s] Kicked By %s [%s] For %s", tPlayer:GetData("Name"), tPlayer:GetData("AccountID"),
          iPlayer:GetData("Name"), iPlayer:GetData("AccountID"), reason),
        { console = true, file = true, database = true, discord = { embed = true, type = "inform" } },
        {
          account = tPlayer:GetData("AccountID"),
          identifier = tPlayer:GetData("Identifier"),
          reason = reason,
          issuer =
              string.format("%s [%s]", iPlayer:GetData("Name"), iPlayer:GetData("AccountID"))
        }
      )
      COMPONENTS.Punishment.Actions:Kick(source, reason, iPlayer:GetData("Name"))
      return { success = true, Name = tPlayer:GetData("Name"), AccountID = tPlayer:GetData("AccountID"), reason = reason }
    else
      if not afk then
        COMPONENTS.Logger:Info(
          "Punishment",
          string.format("%s [%s] Kicked By %s For %s", tPlayer:GetData("Name"), tPlayer:GetData("AccountID"), issuer,
            reason),
          { console = true, file = true, database = true, discord = { embed = true, type = "inform", webhook = GetConvar("discord_pwnzor_webhook", "") } },
          {
            account = tPlayer:GetData("AccountID"),
            identifier = tPlayer:GetData("Identifier"),
            reason = reason,
            issuer =
                issuer
          }
        )
      end
      COMPONENTS.Punishment.Actions:Kick(source, reason, issuer)
      return { success = true, Name = tPlayer:GetData("Name"), AccountID = tPlayer:GetData("AccountID"), reason = reason }
    end
  end,
}

COMPONENTS.Punishment.Unban = {
  BanID = function(self, id, issuer)
    if COMPONENTS.Punishment:CheckBan("_id", id) then
      local iPlayer = COMPONENTS.exports['core']:FetchSource(issuer)
      MySQL.Async.fetchAll("SELECT * FROM bans WHERE _id = @id AND active = 1", { ['@id'] = id }, function(results)
        if COMPONENTS.Punishment.Actions:Unban(results, iPlayer) then
          COMPONENTS.Chat.Send.Server:Single(iPlayer:GetData("Source"), string.format("%s Has Been Revoked", id))
        end
      end)
    end
  end,
  AccountID = function(self, aId, issuer)
    if COMPONENTS.Punishment:CheckBan("account", aId) then
      local tPlayer = COMPONENTS.Fetch:PlayerData("AccountID", aId)
      local dbf = false
      if tPlayer == nil then
        tPlayer = COMPONENTS.Fetch:Website("account", aId)
        dbf = true
      end
      local iPlayer = COMPONENTS.exports['core']:FetchSource(issuer)
      MySQL.Async.fetchAll("SELECT * FROM bans WHERE account = @aId AND active = 1", { ['@aId'] = aId },
        function(results)
          if COMPONENTS.Punishment.Actions:Unban(results, iPlayer) then
            COMPONENTS.Chat.Send.Server:Single(iPlayer:GetData("Source"),
              string.format("%s (Account: %s) Has Been Unbanned", tPlayer:GetData("Name"), tPlayer:GetData("AccountID")))
          end
        end)
      if dbf then
        tPlayer:DeleteStore()
      end
    else
      COMPONENTS.Chat.Send.Server:Single(iPlayer:GetData("Source"),
        string.format("%s (Account: %s) Is Not Banned", tPlayer:GetData("Name"), tPlayer:GetData("AccountID")))
    end
  end,
  Identifier = function(self, identifier, issuer)
    if COMPONENTS.Punishment:CheckBan("identifier", identifier) then
      local tPlayer = COMPONENTS.Fetch:PlayerData("Identifier", identifier)
      local dbf = false
      if tPlayer == nil then
        tPlayer = COMPONENTS.Fetch:Website("identifier", identifier)
        dbf = true
      end
      local iPlayer = COMPONENTS.exports['core']:FetchSource(issuer)
      MySQL.Async.fetchAll("SELECT * FROM bans WHERE identifier = @identifier AND active = 1",
        { ['@identifier'] = identifier }, function(results)
          if COMPONENTS.Punishment.Actions:Unban(results, iPlayer) then
            COMPONENTS.Chat.Send.Server:Single(iPlayer:GetData("Source"),
              string.format("%s (Identifier: %s) Has Been Unbanned", tPlayer:GetData("Name"),
                tPlayer:GetData("Identifier")))
          end
        end)
      if dbf then
        tPlayer:DeleteStore()
      end
    else
      COMPONENTS.Chat.Send.Server:Single(iPlayer:GetData("Source"),
        string.format("%s (Identifier: %s) Is Not Banned", tPlayer:GetData("Name"), tPlayer:GetData("Identifier")))
    end
  end,
}

COMPONENTS.Punishment.Ban = {
  Source = function(self, source, expires, reason, issuer)
    local tPlayer = COMPONENTS.exports['core']:FetchSource(source)
    local iPlayer
    if not tPlayer then
      return { success = false }
    end
    if issuer ~= "Pwnzor" then
      if source == issuer then
        return { success = false, message = "Cannot Ban Yourself!" }
      end
      iPlayer = COMPONENTS.exports['core']:FetchSource(issuer)
      if not iPlayer then
        return { success = false }
      end
      if iPlayer.Permissions:GetLevel() < tPlayer.Permissions:GetLevel() then
        return { success = false, message = "Insufficient Permissions" }
      end
      issuer = string.format("%s [%s]", iPlayer:GetData("Name"), iPlayer:GetData("AccountID"))
    end
    local expStr = "Never"
    if expires ~= -1 then
      expires = (os.time() + ((60 * 60 * 24) * expires))
      expStr = os.date("%Y-%m-%d at %I:%M:%S %p", expires)
    end
    local banStr = string.format("%s Was Permanently Banned By %s for %s", tPlayer:GetData("Name"), issuer, reason)
    if expires ~= -1 then
      banStr = string.format("%s Was Banned By %s Until %s for %s", tPlayer:GetData("Name"), issuer, expStr, reason)
    end
    if iPlayer ~= nil then
      COMPONENTS.Punishment.Actions:Ban(
        tPlayer:GetData("Source"),
        tPlayer:GetData("AccountID"),
        tPlayer:GetData("Identifier"),
        tPlayer:GetData("Name"),
        tPlayer:GetData("Tokens"),
        reason,
        expires,
        expStr,
        issuer,
        iPlayer:GetData("AccountID"),
        false
      )
      return {
        success = true,
        Name = tPlayer:GetData("Name"),
        AccountID = tPlayer:GetData("AccountID"),
        expires =
            expires,
        reason = reason,
        banStr = banStr
      }
    else
      COMPONENTS.Punishment.Actions:Ban(
        tPlayer:GetData("Source"),
        tPlayer:GetData("AccountID"),
        tPlayer:GetData("Identifier"),
        tPlayer:GetData("Name"),
        tPlayer:GetData("Tokens"),
        reason,
        expires,
        expStr,
        issuer,
        -1,
        true
      )
      return {
        success = true,
        Name = tPlayer:GetData("Name"),
        AccountID = tPlayer:GetData("AccountID"),
        expires =
            expires,
        reason = reason,
        banStr = banStr
      }
    end
    COMPONENTS.Logger:Info(
      "Punishment",
      banStr,
      { console = true, file = true, database = true, discord = { embed = true, type = "info" } },
      {
        player = tPlayer:GetData("Name"),
        identifier = tPlayer:GetData("Identifier"),
        reason = reason,
        issuer = issuer,
        expires =
            expStr
      }
    )
  end,
  AccountID = function(self, aId, expires, reason, issuer)
    local iPlayer = COMPONENTS.exports['core']:FetchSource(issuer)
    if not iPlayer then
      return { success = false }
    end
    if iPlayer:GetData("AccountID") == tonumber(aid) then
      return { success = false, message = "Cannot Ban Yourself!" }
    end
    local tPlayer = COMPONENTS.Fetch:PlayerData("AccountID", tonumber(aId))
    issuer = string.format("%s [%s]", iPlayer:GetData("Name"), iPlayer:GetData("AccountID"))
    local dbf = false
    if tPlayer == nil then
      tPlayer = COMPONENTS.Fetch:Website("account", tonumber(aId))
      dbf = true
    end
    local bannedPlayer = tonumber(aId)
    local expStr = "Never"
    if expires ~= -1 then
      expires = (os.time() + ((60 * 60 * 24) * expires))
      expStr = os.date("%Y-%m-%d at %I:%M:%S %p", expires)
    end
    local banStr = string.format("%s (Account: %s) Was Permanently Banned By %s. Reason: %s",
      tPlayer and tPlayer:GetData("Name") or "Unknown", tPlayer and tPlayer:GetData("AccountID") or bannedPlayer, issuer,
      reason)
    if expires ~= -1 then
      banStr = string.format("%s (Account: %s) Was Banned By %s Until %s. Reason: %s",
        tPlayer and tPlayer:GetData("Name") or "Unknown", tPlayer and tPlayer:GetData("AccountID") or bannedPlayer,
        issuer, expStr, reason)
    end
    if tPlayer == nil then
      if COMPONENTS.Punishment.Actions:Ban(nil, tonumber(aId), nil, bannedPlayer, {}, reason, expires, expStr, issuer, iPlayer:GetData("AccountID"), false) then
        COMPONENTS.Logger:Info(
          "Punishment",
          banStr,
          { console = true, file = true, database = true, discord = { embed = true, type = "info" } },
          { player = bannedPlayer, account = tonumber(aId), reason = reason, issuer = issuer, expires = expStr }
        )
        return { success = true, AccountID = tonumber(aId), reason = reason, expires = expires, banStr = banStr }
      end
    else
      local tPerms = 0
      if tPlayer:GetData("Source") ~= nil then
        for _, v in ipairs(tPlayer:GetData("Groups")) do
          if COMPONENTS.Config.Groups[tostring(v)].Permission then
            if COMPONENTS.Config.Groups[tostring(v)].Permission.Level > tPerms then
              tPerms = COMPONENTS.Config.Groups[tostring(v)].Permission.Level
            end
          end
        end
      else
        tPerms = 99
      end
      if iPlayer.Permissions:GetLevel() <= tPerms then
        return { success = false, message = "Insufficient Permissions" }
      end
      if COMPONENTS.Punishment.Actions:Ban(tPlayer:GetData("Source"), tPlayer:GetData("AccountID"), tPlayer:GetData("Identifier"), tPlayer:GetData("Name"), tPlayer:GetData("Tokens"), reason, expires, expStr, issuer, iPlayer:GetData("AccountID"), false) then
        COMPONENTS.Logger:Info(
          "Punishment",
          banStr,
          { console = true, file = true, database = true, discord = { embed = true, type = "info" } },
          {
            player = bannedPlayer,
            account = tPlayer:GetData("AccountID"),
            identifier = tPlayer:GetData("Identifier"),
            reason =
                reason,
            issuer = issuer,
            expires = expStr
          }
        )
        local retData = {
          success = true,
          Name = tPlayer:GetData("Name"),
          AccountID = tPlayer:GetData("AccountID"),
          expires =
              expires,
          reason = reason,
          banStr = banStr
        }
        Citizen.CreateThread(function()
          if dbf and tPlayer then
            tPlayer:DeleteStore()
          end
        end)
        return retData
      end
    end
  end,
  Identifier = function(self, identifier, expires, reason, issuer)
    local iPlayer = COMPONENTS.exports['core']:FetchSource(issuer)
    if not iPlayer then
      return { success = false }
    end
    if iPlayer:GetData("Identifier") == identifier then
      return { success = false, message = "Cannot Ban Yourself!" }
    end
    local tPlayer = COMPONENTS.Fetch:PlayerData("Identifier", identifier)
    issuer = string.format("%s [%s]", iPlayer:GetData("Name"), iPlayer:GetData("AccountID"))
    local dbf = false
    if tPlayer == nil then
      tPlayer = COMPONENTS.Fetch:Website("identifier", identifier)
      dbf = true
    end
    local expStr = "Never"
    if expires ~= -1 then
      expires = (os.time() + ((60 * 60 * 24) * expires))
      expStr = os.date("%Y-%m-%d at %I:%M:%S %p", expires)
    end
    local banStr = string.format("%s (Identifier: %s) Was Permanently Banned By %s. Reason: %s",
      tPlayer and tPlayer:GetData("Name") or "Unknown", tPlayer and tPlayer:GetData("Identifier") or identifier, issuer,
      reason)
    if expires ~= -1 then
      banStr = string.format("%s (Identifier: %s) Was Banned By %s Until %s. Reason: %s",
        tPlayer and tPlayer:GetData("Name") or "Unknown", tPlayer and tPlayer:GetData("Identifier") or identifier, issuer,
        expStr, reason)
    end
    if tPlayer == nil then
      if COMPONENTS.Punishment.Actions:Ban(nil, nil, identifier, bannedPlayer, {}, reason, expires, expStr, issuer, iPlayer:GetData("AccountID"), false) then
        COMPONENTS.Logger:Info(
          "Punishment",
          banStr,
          { console = true, file = true, database = true, discord = { embed = true, type = "info" } },
          { player = identifier, identifier = identifier, reason = reason, issuer = issuer, expires = expStr }
        )
        if dbf and tPlayer then
          tPlayer:DeleteStore()
        end
        return { success = true, Identifier = identifier, reason = reason, expires = expires, banStr = banStr }
      end
    else
      local tPerms = 0
      if tPlayer:GetData("Source") ~= nil then
        for _, v in ipairs(tPlayer:GetData("Groups")) do
          if COMPONENTS.Config.Groups[tostring(v)].Permission then
            if COMPONENTS.Config.Groups[tostring(v)].Permission.Level > tPerms then
              tPerms = COMPONENTS.Config.Groups[tostring(v)].Permission.Level
            end
          end
        end
      else
        for _, v in ipairs(tPlayer:GetData("Groups")) do
          if COMPONENTS.Config.Groups[tostring(v)].Permission then
            if COMPONENTS.Config.Groups[tostring(v)].Permission.Level > tPerms then
              tPerms = COMPONENTS.Config.Groups[tostring(v)].Permission.Level
            end
          end
        end
      end
      if iPlayer.Permissions:GetLevel() <= tPerms then
        return { success = false, message = "Insufficient Permissions" }
      end
      if COMPONENTS.Punishment.Actions:Ban(tPlayer:GetData("Source"), tPlayer:GetData("AccountID"), tPlayer:GetData("Identifier"), tPlayer:GetData("Name"), tPlayer:GetData("Tokens"), reason, expires, expStr, issuer, false) then
        COMPONENTS.Logger:Info(
          "Punishment",
          banStr,
          { console = true, file = true, database = true, discord = { embed = true, type = "info" } },
          {
            player = tPlayer:GetData("Name"),
            account = tPlayer:GetData("AccountID"),
            identifier = tPlayer:GetData(
              "Identifier"),
            reason = reason,
            issuer = issuer,
            expires = expStr
          }
        )
        local retData = {
          success = true,
          Name = tPlayer:GetData("Name"),
          AccountID = tPlayer:GetData("AccountID"),
          Identifier =
              tPlayer:GetData("Identifier"),
          expires = expires,
          reason = reason,
          banStr = banStr
        }
        if dbf and tPlayer then
          tPlayer:DeleteStore()
        end
        return retData
      end
    end
    if dbf then
      tPlayer:DeleteStore()
    end
  end,
}

COMPONENTS.Punishment.Actions = {
  Kick = function(self, tSource, reason, issuer)
    DropPlayer(tSource, string.format("Kicked From The Server By %s\nReason: %s", issuer, reason))
  end,
  Ban = function(self, tSource, tAccount, tIdentifier, tName, tTokens, reason, expires, expStr, issuer, issuerId, mask)
    local orStatement = {}
    if tIdentifier then
      table.insert(orStatement, {
        identifier = tIdentifier,
      })
    end


    local doesPlayerHavePreviousBan = MySQL.single.await('SELECT * FROM bans WHERE account = @account', {
      ['@account'] = tAccount,
    })

    local success = -1
    if not doesPlayerHavePreviousBan then
      success = MySQL.insert.await(
        'INSERT INTO bans (account, identifier, expires, reason, issuer, active, started, tokens) VALUES (@account, @identifier, @expires, @reason, @issuer, @active, @started, @tokens)',
        {
          ['@account'] = tAccount,
          ['@identifier'] = tIdentifier,
          ['@expires'] = expires,
          ['@reason'] = reason,
          ['@issuer'] = issuer,
          ['@active'] = true,
          ['@started'] = os.time(),
          ['@tokens'] = json.encode(tTokens),
        })
    else
      success = MySQL.update.await(
        'UPDATE bans SET account = @account, identifier = @identifier, expires = @expires, reason = @reason, issuer = @issuer, active = @active, started = @started, tokens = @tokens WHERE account = @account',
        {
          ['@account'] = tAccount,
          ['@identifier'] = tIdentifier,
          ['@expires'] = expires,
          ['@reason'] = reason,
          ['@issuer'] = issuer,
          ['@active'] = true,
          ['@started'] = os.time(),
          ['@tokens'] = json.encode(tTokens),
        })

      if success < 0 then
        return COMPONENTS.Logger:Error(

          "[^8Error^7] Error in adding ban",
          { console = true, file = true, database = true, discord = { embed = true, type = "error" } }
        )
      end

      if mask then
        reason = "💙 From Pwnzor 🙂"
      end

      if tSource ~= nil then
        if expires ~= -1 then
          DropPlayer(
            tSource,
            string.format(
              "You're Banned, Appeal in Discord\n\nReason: %s\nExpires: %s\nID: %s",
              reason,
              expStr,
              success
            )
          )
        else
          DropPlayer(
            tSource,
            string.format(
              "You're Permanently Banned, Appeal in Discord\n\nReason: %s\nID: %s",
              reason,
              success
            )
          )
        end
      end
    end
  end,
  Unban = function(self, ids, issuer)
    local _ids = {}
    -- for k, v in ipairs(ids) do
    --   COMPONENTS.Database.Auth:updateOne({
    --     collection = "bans",
    --     query = { _id = v._id, active = true },
    --     update = {
    --       ["$set"] = { active = false, unbanned = { issuer = issuer:GetData("Name"), date = os.time() } },
    --     },
    --   })

    --   table.insert(_ids, v._id)
    -- end

    -- COMPONENTS.Logger:Info(
    --   "Punishment",
    --   string.format("%s Bans Revoked By %s [%s]", #ids, issuer:GetData("Name"), issuer:GetData("AccountID")),
    --   { console = true, file = true, database = true, discord = { embed = true, type = "info" } },
    --   {
    --     issuer = string.format("%s [%s]", issuer:GetData("Name"), issuer:GetData("AccountID")),
    --   },
    --   _ids
    -- )

    return false;
  end,
}


local function exportHandler(exportName, func)
  AddEventHandler(('__cfx_export_%s_%s'):format(GetCurrentResourceName(), exportName), function(setCB)
    setCB(function(...)
      return func(COMPONENTS.Punishment, ...)
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

for k, v in pairs(COMPONENTS.Punishment) do
  if type(v) == "function" then
    exportHandler("Punishment" .. k, v)
  elseif type(v) == "table" then
    createExportForObject(v, "Punishment" .. k)
  end
end