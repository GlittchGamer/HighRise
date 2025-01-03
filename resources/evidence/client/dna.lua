_withinDNATesting = true

RegisterNetEvent("Evidence:Client:RanDNA", function(tooDegraded, success, evidenceId)
  exports["animations"]:EmotesPlay("type3", false, 5500, true, true)
  Progress:Progress({
    name = "dna_test",
    duration = 5000,
    label = "Running DNA Through Database",
    useWhileDead = false,
    canCancel = false,
    ignoreModifier = true,
    controlDisables = {
      disableMovement = true,
      disableCarMovement = false,
      disableMouse = false,
      disableCombat = true,
    },
  }, function(status)
    if not status then
      if tooDegraded then
        return exports['hud']:NotificationError("DNA too Degraded to Run")
      end
      if success then
        exports['hud']:NotificationSuccess("DNA Match Found")

        ListMenu:Show({
          main = {
            label = "DNA Comparison Results",
            items = {
              {
                label = "DNA Evidence Identifier",
                description = evidenceId,
              },
              {
                label = string.format("DNA Match to State ID %s", success.SID),
                description = string.format(
                  "Name: %s. %s<br>Age: %s",
                  string.upper(success.First:sub(1, 1)),
                  success.Last,
                  success.Age
                ),
              },
            },
          },
        })
      else
        exports['hud']:NotificationError("Could Not Match DNA")
      end
    end
  end)
end)

AddEventHandler("Polyzone:Enter", function(id, point, insideZone, data)
  if data and data.dna and (LocalPlayer.state.onDuty == "police" or LocalPlayer.state.onDuty == "ems") then
    _withinDNATesting = true
    exports['hud']:ActionShow("{key}Use DNA Evidence{/key} Run DNA Sample")
  end
end)

AddEventHandler("Polyzone:Exit", function(id, point, insideZone, data)
  if
      _withinDNATesting
      and data
      and data.dna
      and (LocalPlayer.state.onDuty == "police" or LocalPlayer.state.onDuty == "ems")
  then
    _withinDNATesting = false
    exports['hud']:ActionHide()
  end
end)
