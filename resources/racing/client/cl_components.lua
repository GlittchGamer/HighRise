Racing = {
  RaceID = nil,
  ActiveRace = nil,
  plyPed = nil,
  raceStarted = false,
  currentCheckpoint = 1,
  safeCheckpoint = -1,
  currentLap = 1,
  completedCheckpoints = {},
  StartRace = function(self)
    Racing.plyPed = PlayerPedId()

    SetupTrack()

    local countdownMax = tonumber(Racing.ActiveRace.countdown) or 20
    local countdown = 0

    repeat
      exports['hud']:NotificationInfo(string.format("Race Starting In %s", countdownMax - countdown))
      exports['sounds']:PlayFrontEnd(-1, "5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET")
      countdown = countdown + 1
      Wait(1000)
    until countdown >= countdownMax

    CreateThread(function()
      Racing.raceStarted = true

      Racing:CheckPosition()

      exports['hud']:NotificationInfo("Race Started")
      exports['sounds']:PlayFrontEnd(-1, "GO", "HUD_MINI_GAME_SOUNDSET")

      while Racing.raceStarted do
        local myPos = GetEntityCoords(Racing.plyPed)
        local checkpoint = Racing.ActiveRace.trackData.Checkpoints[Racing.currentCheckpoint]
        if checkpoint == nil then
          checkpoint = Racing.ActiveRace.trackData.Checkpoints[1]
        end

        local dist = #(vector3(checkpoint.coords.x, checkpoint.coords.y, checkpoint.coords.z) - myPos)

        if dist <= checkpoint.size or Racing.safeCheckpoint == -1 then
          local blip = raceBlips[Racing.currentCheckpoint]
          if Racing.currentCheckpoint == 1 and #Racing.completedCheckpoints == #Racing.ActiveRace.trackData.Checkpoints and Racing.ActiveRace.trackData.Type ~= "p2p" then
            Racing.currentLap = Racing.currentLap + 1
            Racing.completedCheckpoints = {}
            if Racing.currentLap <= tonumber(Racing.ActiveRace.laps) then
              exports['hud']:NotificationInfo(string.format("Lap %s", Racing.currentLap))
              exports['sounds']:PlayFrontEnd(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET")
              SendNUIMessage({
                type = "RACE_LAP",
              })

              TriggerServerEvent('Phone:SV:Racing:LapCompleted', Racing.RaceID, Racing.currentCheckpoint)
            end
          end

          if Racing.safeCheckpoint ~= -1 then
            SetBlipColour(blip, 0)
            SetBlipScale(blip, 0.75)
            table.insert(Racing.completedCheckpoints, Racing.currentCheckpoint)
            exports['sounds']:PlayFrontEnd(-1, "CHECKPOINT_NORMAL", "HUD_MINI_GAME_SOUNDSET")
            if Racing.currentCheckpoint < #Racing.ActiveRace.trackData.Checkpoints then
              Racing.currentCheckpoint = Racing.currentCheckpoint + 1
              SendNUIMessage({
                type = "RACE_CP",
                data = {
                  cp = #Racing.completedCheckpoints,
                },
              })
              TriggerServerEvent('Phone:SV:Racing:PassedCheckpoin', Racing.RaceID, Racing.currentCheckpoint)
            elseif Racing.ActiveRace.trackData.Type ~= "p2p" then
              Racing.currentCheckpoint = 1
              SendNUIMessage({
                type = "RACE_CP",
                data = {
                  cp = #Racing.ActiveRace.trackData.Checkpoints,
                },
              })
            end
          end

          if Racing.ActiveRace.trackData.Type == "p2p" and #Racing.completedCheckpoints == #Racing.ActiveRace.trackData.Checkpoints or Racing.currentLap > tonumber(Racing.ActiveRace.laps) then
            exports['hud']:NotificationInfo("Race Finished")
            Cleanup()
            exports['sounds']:PlayFrontEnd(-1, "FIRST_PLACE", "HUD_MINI_GAME_SOUNDSET")
            SendNUIMessage({
              type = "RACE_END",
            })
            SendNUIMessage({
              type = "PD_I_RACE",
              data = {
                state = false,
              },
            })
            Racing.raceStarted = false
            return
          end

          checkpoint = Racing.ActiveRace.trackData.Checkpoints[Racing.currentCheckpoint]
          blip = raceBlips[Racing.currentCheckpoint]
          SetBlipColour(blip, 6)
          SetBlipScale(blip, 1.3)
          SetBlipColour(raceBlips[Racing.currentCheckpoint + 1], 6)
          SetBlipScale(raceBlips[Racing.currentCheckpoint + 1], 1.15)

          -- Like what the fuck is this code?
          local ftr = nil
          if Racing.currentCheckpoint + 1 > #Racing.ActiveRace.trackData.Checkpoints then
            ftr = Racing.ActiveRace.trackData.Checkpoints[1]
          else
            ftr = Racing.ActiveRace.trackData.Checkpoints[Racing.currentCheckpoint + 1]
          end

          if Racing.currentLap > tonumber(Racing.ActiveRace.laps) or (Racing.ActiveRace.trackData.Type == "p2p" and Racing.currentCheckpoint == #Racing.ActiveRace.trackData.Checkpoints)
          then
            ftr = checkpoint
          end

          if Racing.currentCheckpoint + 1 > #Racing.ActiveRace.trackData.Checkpoints then
            handleFlare(Racing.ActiveRace.trackData.Checkpoints[1])
          else
            handleFlare(Racing.ActiveRace.trackData.Checkpoints[Racing.currentCheckpoint + 1])
          end

          local v = GetVehiclePedIsIn(LocalPlayer.state.ped, false)
          if v ~= 0 and GetPedInVehicleSeat(v, -1) then
            SetNewWaypoint(ftr.coords.x, ftr.coords.y)
          end
          Racing.safeCheckpoint = Racing.currentCheckpoint
        end

        if not IsWaypointActive() then
          local ftr = nil
          if Racing.currentCheckpoint + 1 > #Racing.ActiveRace.trackData.Checkpoints then
            ftr = Racing.ActiveRace.trackData.Checkpoints[1]
          else
            ftr = Racing.ActiveRace.trackData.Checkpoints[Racing.currentCheckpoint + 1]
          end
          local v = GetVehiclePedIsIn(LocalPlayer.state.ped, false)
          if v ~= 0 and GetPedInVehicleSeat(v, -1) then
            SetNewWaypoint(ftr.coords.x, ftr.coords.y)
          end
        end

        Wait(0)
      end
    end)
  end,
  EndRace = function(self)
  end,
  CheckPosition = function(self)
    CreateThread(function()
      while Racing.raceStarted do
        Wait(1000)
      end
    end)
  end
}

Creator = {
  creating = false,
  MAX_SIZE = 75.0,
  MIN_SIZE = 5.0,
  CURR_SIZE = 20.0,
  PENDING_TRACK = {
    Checkpoints = {},
    History = {},
  },
  tempCheckpointObj = {
    l = false,
    r = false,
  },
  Start = function(self, raceType)
    if self.creating then return end
    self.creating = true
    RunCreatorThread()
  end,
  IsCreating = function(self)
    return self.creating
  end,
  Stop = function(self, returnParams)
    local cachedTrack = self.PENDING_TRACK
    self.creating = false

    if not returnParams then return true end

    if returnParams then
      return {
        cachedTrack = cachedTrack,
        raceType = self.raceType,
      }
    end
  end
}

local function exportHandlerForRacing(exportName, func)
  AddEventHandler(('__cfx_export_%s_%s'):format(GetCurrentResourceName(), exportName), function(setCB)
    setCB(function(...)
      return func(Racing, ...)
    end)
  end)
end

for k, v in pairs(Racing) do
  if type(v) == "function" then
    exportHandlerForRacing('Racing' .. k, v)
  end
end

local function exportHandlerForCreator(exportName, func)
  AddEventHandler(('__cfx_export_%s_%s'):format(GetCurrentResourceName(), exportName), function(setCB)
    setCB(function(...)
      return func(Creator, ...)
    end)
  end)
end

for k, v in pairs(Creator) do
  if type(v) == "function" then
    exportHandlerForCreator('Creator' .. k, v)
  end
end
