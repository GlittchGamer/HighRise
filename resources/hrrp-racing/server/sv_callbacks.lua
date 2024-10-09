function RegisterCallbacks()
  exports['hrrp-base']:CallbacksRegisterServer('Racing:Server:SaveRace', function(src, data, cb)
    local char = exports['hrrp-base']:FetchSource(src):GetData("Character")
    local alias = char:GetData("Alias").redline
    local isPDTrack = false
    if data.raceVariant == 'blueline' then
      alias = tostring(char:GetData("Callsign"))
      isPDTrack = true
    end

    local insertId = MySQL.insert.await('INSERT INTO `racing_tracks` (`Name`, `Distance`, `Type`, `Checkpoints`, `isPD`) VALUES (?, ?, ?, ?, ?)', {
      data.track.Name,
      data.track.Distance,
      data.raceType,
      json.encode(data.track.Checkpoints),
      isPDTrack
    })

    if insertId == 0 or not insertId then
      return cb(false)
    end

    data.track.id = insertId
    data.track.isPDTrack = isPDTrack
    --Insert Track into global list
    table.insert(Racing.Tracks, data.track)

    TriggerClientEvent('Phone:Client:AddData', -1, 'racing_tracks', data.track)
    return cb(true)
  end)

  exports['hrrp-base']:CallbacksRegisterServer('Racing:Server:DeleteRace', function(src, data, cb)
    local char = exports['hrrp-base']:FetchSource(src):GetData("Character")
    local alias = char:GetData("Alias").redline
    local isPDTrack = false
    if data.raceVariant == 'blueline' then
      alias = tostring(char:GetData("Callsign"))
      isPDTrack = true
    end

    local deleteId = MySQL.Sync.execute('DELETE FROM `racing_tracks` WHERE `id` = ?', { data.track.id })

    if deleteId == 0 or not deleteId then
      return cb(false)
    end

    --Remove Track from global list
    for i, track in ipairs(Racing.Tracks) do
      if track.id == data.track.id then
        table.remove(Racing.Tracks, i)
        break
      end
    end

    -- TriggerClientEvent('Phone:Client:RemoveData', -1, 'racing_tracks', data.track.id)
    return cb(true)
  end)

  exports['hrrp-base']:CallbacksRegisterServer('Racing:Server:CreateRace', function(src, data, cb)
    local char = exports['hrrp-base']:FetchSource(src):GetData("Character")
    local alias = char:GetData("Alias").redline
    if data.isPD then
      alias = tostring(char:GetData("Callsign"))
    end

    local hasPermission = false

    if data.isPD then
      hasPermission = exports['hrrp-jobs']:JobsPermissionsHasJob(src, "police", false, false, false, false, "PD_MANAGE_TRIALS")
    else
      hasPermission = hasValue(char:GetData("States") or {}, "RACE_DONGLE")
    end

    if not hasPermission then
      print("No perms")
      return cb({ failed = true, message = "You do not have permission to start a race" })
    end

    local newRace = data

    Races.RaceID = Races.RaceID + 1 --! We will increment first to prevent any issues with duplicate race IDs

    newRace.id = Races.RaceID
    newRace.state = 0
    newRace.host_id = char:GetData("ID")
    newRace.host_src = src
    newRace.time = os.time() * 1000
    newRace.racers = {
      [alias] = {
        source = src,
        sid = char:GetData("SID"),
        firstName = char:GetData("First"),
        lastName = char:GetData("Last"),
        Lap = 1,
        Checkpoint = 1
      }
    }
    newRace.isPD = data.isPD

    for k, v in ipairs(Races.Tracks) do
      if newRace.track == v.id then
        newRace.trackData = v
        break
      end
    end

    if not newRace.trackData then
      return cb({ failed = true, message = 'Track does not exist' })
    end

    Races.ActiveRaces[#Races.ActiveRaces + 1] = newRace

    TriggerClientEvent('Racing:Client:CreateRace', src, newRace)

    if data.isPD then
      print("Adding active race")
      TriggerClientEvent("Phone:Client:Blueline:CreateRace", -1, newRace)
    else
      TriggerClientEvent("Phone:Client:Redline:CreateRace", -1, newRace)
    end

    -- for k, v in pairs(exports['hrrp-base']:FetchAll()) do
    --   local c = v:GetData("Character")
    --   if c ~= nil then
    --     if data.isPD then
    --       -- TriggerClientEvent("Phone:Client:Blueline:CreateRace", v:GetData("Source"), newRace)
    --     else
    --       -- Phone.Notification:Add(
    --       --   v:GetData("Source"),
    --       --   string.format("%s", cancelled and "Event Cancelled" or "Event Finished"),
    --       --   string.format("%s has %s", _races[id].name, cancelled and "been cancelled" or "finished"),
    --       --   os.time() * 1000,
    --       --   10000,
    --       --   "redline",
    --       --   {
    --       --     view = "2",
    --       --   }
    --       -- )
    --       print("Phone notify, init cuzzeh")
    --     end
    --   end
    -- end
    print("Race created")
    return cb(newRace)
  end)

  exports['hrrp-base']:CallbacksRegisterServer('Racing:Server:CancelRace', function(src, data, cb)
    local char = exports['hrrp-base']:FetchSource(src):GetData("Character")

    if Races.ActiveRaces[data].host_id ~= char:GetData("ID") then
      return cb(false)
    end


    Races.ActiveRaces[data].state = -1
    cb(true)
    if Races.ActiveRaces[data].isPD then
      TriggerClientEvent("Phone:Client:Blueline:CancelRace", -1, data)
    else
      TriggerClientEvent("Phone:Client:Redline:CancelRace", -1, data)
    end
  end)

  exports['hrrp-base']:CallbacksRegisterServer('Racing:Server:StartRace', function(src, data, cb)
    local char = exports['hrrp-base']:FetchSource(src):GetData("Character")

    if Races.ActiveRaces[data].host_id ~= char:GetData("ID") then
      return cb(false)
    end

    local ploc = GetEntityCoords(GetPlayerPed(src))
    local dist = #(
      vector3(
        Races.ActiveRaces[data].trackData.Checkpoints[1].coords.x,
        Races.ActiveRaces[data].trackData.Checkpoints[1].coords.y,
        Races.ActiveRaces[data].trackData.Checkpoints[1].coords.z
      ) - ploc
    )

    if dist > 25 then
      return cb({ failed = true, message = "Too Far From Starting Point" })
    end

    Races.ActiveRaces[data].state = 1
    Races.ActiveRaces[data].total = 0

    for k, v in pairs(Races.ActiveRaces[data].racers) do
      Races.ActiveRaces[data].total = Races.ActiveRaces[data].total + 1
    end

    if Races.ActiveRaces[data].isPD then
      TriggerClientEvent("Phone:Client:Blueline:StartRace", -1, data)
    else
      TriggerClientEvent("Phone:Client:Redline:StartRace", -1, data)
    end
    TriggerClientEvent('Racing:Client:StartRace', -1, data)
    return cb(true)
  end)

  exports['hrrp-base']:CallbacksRegisterServer('Racing:Server:EndRace', function(src, data, cb)
    local char = exports['hrrp-base']:FetchSource(src):GetData("Character")

    if Races.ActiveRaces[data].host_id ~= char:GetData("ID") then
      return cb(false)
    end

    --Function to fjnish races
  end)

  exports['hrrp-base']:CallbacksRegisterServer('Racing:Server:JoinRace', function(src, data, cb)
    local char = exports['hrrp-base']:FetchSource(src):GetData("Character")

    local raceData = Races.ActiveRaces[data]

    local alias = char:GetData("Alias").redline
    local hasPermissionToJoinRace = hasValue(char:GetData("States") or {}, "RACE_DONGLE")
    if raceData.isPD then
      alias = tostring(char:GetData("Callsign"))
      hasPermissionToJoinRace = exports['hrrp-jobs']:JobsPermissionsHasJob(src, "police")
    end
    --Check the racer is currently not in any other face, if they are - remove them.
    for k, v in pairs(Races.ActiveRaces) do
      if v.racers[alias] and v.state == 0 then
        v.racers[alias] = nil
        -- if v.isPD then
        --   TriggerClientEvent("Phone:Client:Blueline:LeaveRace", -1, k, alias)
        -- else
        --   TriggerClientEvent("Phone:Client:Redline:LeaveRace", -1, k, alias)
        -- end
        TriggerClientEvent('Racing:Client:LeaveRace', -1, k, alias, v.isPD)
      end
    end

    if not raceData then
      return cb(false)
    end

    if not hasPermissionToJoinRace then
      return cb(false)
    end

    Races.ActiveRaces[alias] = {
      source = src,
      sid = char:GetData("SID"),
      firstName = char:GetData("First"),
      lastName = char:GetData("Last"),
      Lap = 1,
      Checkpoint = 1
    }

    cb(Races.ActiveRaces[alias])

    -- if raceData.isPD then
    --   TriggerClientEvent("Phone:Client:Blueline:JoinRace", -1, data, alias)
    -- else
    --   TriggerClientEvent("Phone:Client:Redline:JoinRace", -1, data, alias)
    -- end
    TriggerClientEvent('Racing:Client:JoinRace', -1, data, alias, raceData.isPD)
  end)

  exports['hrrp-base']:CallbacksRegisterServer('Racing:Server:LeaveRace', function(src, data, cb)
    local char = exports['hrrp-base']:FetchSource(src):GetData("Character")
    local alias = char:GetData("Alias").redline
    if data.isPD then
      alias = tostring(char:GetData("Callsign"))
    end

    if alias ~= nil and Races.ActiveRaces[data].racers[alias] and Races.ActiveRaces[data].state == 0 then
      Races.ActiveRaces[data].racers[alias] = nil
      if Races.ActiveRaces[data].isPD then
        TriggerClientEvent("Phone:Client:Blueline:LeaveRace", -1, data, alias)
      else
        TriggerClientEvent("Phone:Client:Redline:LeaveRace", -1, data, alias)
      end
      return cb(true)
    end
    return cb(false)
  end)
end
