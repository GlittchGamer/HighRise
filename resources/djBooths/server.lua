local xSound = exports.xsound
previousSongs = {}
CurrentBooths = {}

local startupEvent = nil
startupEvent = AddEventHandler("Core:Shared:Ready", function()
  RegisterCallbacks()
  RemoveEventHandler(startupEvent)
end)

function RegisterCallbacks()
  exports['core']:CallbacksRegisterServer("dj:server:songInfo", function(source, data, cb)
    cb(previousSongs)
  end)

  exports['core']:CallbacksRegisterServer("dj:server:playMusic", function(source, data, cb)
    local src = source
    local coords = GetEntityCoords(ped)
    local zoneNum = data.zoneNum
    local song = data.song
    local Booth = Config.Locations[zoneNum]
    local zoneLabel = ""
    if song == "" or song == nil then
      cb(false, nil)
      return
    end
    if Booth.job then
      zoneLabel = Config.Locations[zoneNum].job .. zoneNum
    elseif Booth.gang then
      zoneLabel = Config.Locations[zoneNum].gang .. zoneNum
    end
    if not previousSongs[zoneLabel] then
      previousSongs[zoneLabel] = { [1] = song }
    elseif previousSongs[zoneLabel] then
      local songList = previousSongs[zoneLabel]
      --if not songList[#songList] == song then --Stopped adding NEW links to the list so disabled for now..
      songList[#songList + 1] = song
      previousSongs[zoneLabel] = songList
      --end
    end
    local bCoords = Booth.coords
    if Booth.soundLoc then -- If soundLoc is found, change the location of the music
      bcoords = Booth.soundLoc
    end
    local vol = Booth.DefaultVolume
    if Booth.CurrentVolume then
      vol = Booth.CurrentVolume
    end
    xSound:PlayUrlPos(-1, zoneLabel, song, vol, bCoords)
    xSound:Distance(-1, zoneLabel, Booth.radius)
    Config.Locations[zoneNum].playing = true
    cb(true, zoneNum)
  end)

  exports['core']:CallbacksRegisterServer("dj:server:changeVolume", function(source, data, cb)
    local src = source
    local zoneNum = data.zoneNum
    local volume = data.volume
    local zoneLabel = ""
    if Config.Locations[zoneNum].job then
      zoneLabel = Config.Locations[zoneNum].job .. zoneNum
    elseif Config.Locations[zoneNum].gang then
      zoneLabel = Config.Locations[zoneNum].gang .. zoneNum
    end
    if not tonumber(volume) then
      cb(false, nil)
      return
    end
    if Config.Locations[zoneNum].playing then
      xSound:setVolume(-1, zoneLabel, volume)
      Config.Locations[zoneNum].CurrentVolume = volume
      cb(true, zoneNum)
      return
    end
    cb(false, nil)
  end)

  exports['core']:CallbacksRegisterServer("dj:server:stopMusic", function(source, data, cb)
    local src = source
    local zoneLabel = data.zoneName
    if Config.Locations[data.zoneNum].playing then
      Config.Locations[data.zoneNum].playing = nil
      Config.Locations[data.zoneNum].CurrentVolume = nil
      xSound:Destroy(-1, zoneLabel)
    end
    TriggerClientEvent("dj:client:playMusic", src, { zone = data.zoneNum })
  end)

  exports['core']:CallbacksRegisterServer("dj:server:pauseMusic", function(source, data, cb)
    local src = source
    local zoneLabel = data.zoneName
    if Config.Locations[data.zoneNum].playing then
      Config.Locations[data.zoneNum].playing = nil
      xSound:Pause(-1, zoneLabel)
    end
    TriggerClientEvent("dj:client:playMusic", src, { zone = data.zoneNum })
  end)

  exports['core']:CallbacksRegisterServer("dj:server:resumeMusic", function(source, data, cb)
    local src = source
    local zoneLabel = data.zoneName
    if not Config.Locations[data.zoneNum].playing then
      Config.Locations[data.zoneNum].playing = true
      xSound:Resume(-1, zoneLabel)
    end
    TriggerClientEvent("dj:client:playMusic", src, { zone = data.zoneNum })
  end)
end
