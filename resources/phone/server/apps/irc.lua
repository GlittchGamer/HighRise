local _channels = {}

AddEventHandler("Phone:Server:RegisterMiddleware", function()
  Middleware:Add("Characters:Spawning", function(source)
    local char = exports['core']:FetchSource(source):GetData("Character")
    exports.oxmysql:query("SELECT * FROM irc_channels WHERE `character` = ?", { char:GetData("ID") },
      function(channels)
        _channels[char:GetData("ID")] = channels
        TriggerClientEvent("Phone:Client:SetData", source, "ircChannels", channels)
      end
    )
  end, 2)

  Middleware:Add("Phone:UIReset", function(source)
    local char = exports['core']:FetchSource(source):GetData("Character")
    exports.oxmysql:query("SELECT * FROM irc_channels WHERE `character` = ?", { char:GetData("ID") },
      function(channels)
        _channels[char:GetData("ID")] = channels
        TriggerClientEvent("Phone:Client:SetData", source, "ircChannels", channels)
      end
    )
  end, 2)

  Middleware:Add("Phone:CharacterCreated", function(source, cData)
    return {
      {
        app = "irc",
        alias = string.format("anon%s", (math.random(math.random(1000)))),
      },
    }
  end)

  Middleware:Add("Characters:Logout", function(source)
    local char = exports['core']:FetchSource(source):GetData("Character")
    if char ~= nil then
      _channels[char:GetData("ID")] = nil
    end
  end)
end)

local _cachedMessages = {}
AddEventHandler("Phone:Server:RegisterCallbacks", function()
  exports['core']:CallbacksRegisterServer("Phone:IRC:GetMessages", function(source, data, cb)
    local src = source
    local char = exports['core']:FetchSource(src):GetData("Character")

    if _cachedMessages[data] == nil then
      exports.oxmysql:query("SELECT * FROM irc_messages WHERE channel = ?", { data },
        function(messages)
          _cachedMessages[data] = messages or {}
          cb(_cachedMessages[data])
        end
      )
    else
      cb(_cachedMessages[data])
    end
  end)

  exports['core']:CallbacksRegisterServer("Phone:IRC:SendMessage", function(source, data, cb)
    local src = source
    local char = exports['core']:FetchSource(src):GetData("Character")
    local alias = char:GetData("Alias").irc
    _cachedMessages[data.channel] = _cachedMessages[data.channel] or {}

    local data2 = {
      from = alias,
      channel = data.channel,
      message = data.message,
      time = data.time,
    }

    exports.oxmysql:insert("INSERT INTO irc_messages (`from`, channel, message, time) VALUES (?, ?, ?, ?)",
      { data2.from, data2.channel, data2.message, data2.time },
      function(insertId)
        if insertId then
          data2._id = insertId
          data2.time = data2.time * 1.0 -- Dear Lue, Die In A Fire
          table.insert(_cachedMessages[data.channel], data2)

          for k, v in pairs(_channels) do
            if k ~= char:GetData("ID") then
              for k2, channel in ipairs(v) do
                if channel.slug == data.channel then
                  local tPlyr = Fetch:CharacterData("ID", k)
                  if tPlyr ~= nil then
                    local tChar = tPlyr:GetData("Character")
                    if tChar ~= nil then
                      TriggerClientEvent(
                        "Phone:Client:IRC:Notify",
                        tPlyr:GetData("Source"),
                        data2,
                        false
                      )
                    end
                  end
                  break
                end
              end
            end
          end
          cb(insertId)
        else
          cb(nil)
        end
      end
    )
  end)

  exports['core']:CallbacksRegisterServer("Phone:IRC:JoinChannel", function(source, data, cb)
    local src = source
    local char = exports['core']:FetchSource(src):GetData("Character")
    local data2 = {
      slug = data.slug,
      joined = data.joined,
      character = char:GetData("ID"),
    }

    for k, v in ipairs(_channels[char:GetData("ID")]) do
      if v.slug == data2.slug then
        cb(false)
        return
      end
    end

    exports.oxmysql:insert("INSERT INTO irc_channels (slug, joined, `character`) VALUES (?, ?, ?)",
      { data2.slug, data2.joined, data2.character },
      function(insertId)
        if insertId then
          data2._id = insertId
          table.insert(_channels[char:GetData("ID")], data2)
          cb(true)
        else
          cb(false)
        end
      end
    )
  end)

  exports['core']:CallbacksRegisterServer("Phone:IRC:LeaveChannel", function(source, data, cb)
    local src = source
    local char = exports['core']:FetchSource(src):GetData("Character")
    local isDeleted = MySQL.query.await("DELETE FROM irc_channels WHERE `character` = ? AND slug = ?",
      { char:GetData("ID"), data })

    for k, v in ipairs(_channels[char:GetData("ID")]) do
      if v.slug == data then
        table.remove(_channels[char:GetData("ID")], k)
        break
      end
    end
    cb(true)
  end)
end)
