local trackerJobs = {
  police = true,
  ems = true,
  prison = true
}

function RegisterEACallbacks()
  exports['core']:CallbacksRegisterServer("EmergencyAlerts:DisablePDTracker", function(source, target, cb)
    local char = exports['core']:FetchSource(source)
    if char then
      local tState = Player(target).state
      local targetChar = exports['core']:FetchSource(target)
      if targetChar and tState and trackerJobs[tState.onDuty] and not tState.trackerDisabled then
        tState.trackerDisabled = true
        EmergencyAlerts:DisableTracker(target, true)


        local coords = GetEntityCoords(GetPlayerPed(target))
        exports['core']:CallbacksClient(target, "EmergencyAlerts:GetStreetName", coords, function(location)
          local radioFreq = "Unknown Radio Frequency"
          if tState?.onRadio then
            radioFreq = string.format("Radio Freq: %s", tState.onRadio)
          else
            radioFreq = "Not On Radio"
          end


          if tState.onDuty == "police" then
            EmergencyAlerts:Create("13-C", "Officer Tracker Disabled", "police_alerts", location, {
              icon = "circle-exclamation",
              details = string.format(
                "%s - %s %s | %s",
                targetChar:GetData("Callsign") or "UNKN",
                targetChar:GetData("First"),
                targetChar:GetData("Last"),
                radioFreq
              )
            }, false, {
              icon = 303,
              size = 1.2,
              color = 26,
              duration = (60 * 10),
            }, 1)
          elseif tState.onDuty == "prison" then
            EmergencyAlerts:Create("13-C", "DOC Officer Tracker Disabled", { "police_alerts", "doc_alerts" }, location, {
              icon = "circle-exclamation",
              details = string.format(
                "%s - %s %s | %s",
                targetChar:GetData("Callsign") or "UNKN",
                targetChar:GetData("First"),
                targetChar:GetData("Last"),
                radioFreq
              )
            }, false, {
              icon = 303,
              size = 1.2,
              color = 26,
              duration = (60 * 10),
            }, 1)
          elseif tState.onDuty == "ems" then
            EmergencyAlerts:Create("13-C", "Medic Tracker Disabled", { "police_alerts", "ems_alerts" }, location, {
              icon = "circle-exclamation",
              details = string.format(
                "%s - %s %s | %s",
                targetChar:GetData("Callsign") or "UNKN",
                targetChar:GetData("First"),
                targetChar:GetData("Last"),
                radioFreq
              )
            }, false, {
              icon = 303,
              size = 1.2,
              color = 48,
              duration = (60 * 10),
            }, 2)
          end
        end)

        exports['core']:ExecuteClient(target, "Notification", "Info", "Your Tracker Has Been Disabled")
        cb(true)
        return
      end
    end
    cb(false)
  end)

  -- PD re-enabling their own tracker
  exports['core']:CallbacksRegisterServer("EmergencyAlerts:EnablePDTracker", function(source, target, cb)
    local char = exports['core']:FetchSource(source)
    local pState = Player(source).state
    if char and trackerJobs[pState.onDuty] and pState.trackerDisabled then
      pState.trackerDisabled = false
      EmergencyAlerts:DisableTracker(source, false)

      local job = Player(source).state.onDuty

      exports['jobs']:JobsDutyOff(source, false, true)
      Citizen.Wait(250)
      exports['jobs']:JobsDutyOn(source, job, true)

      cb(true)
    else
      cb(false)
    end
  end)
end
