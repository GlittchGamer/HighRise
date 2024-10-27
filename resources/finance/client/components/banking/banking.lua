local withinBranchZone = false
local showingAction = false

function RunBankingStartup()
  AddBankingATMs()

  for k, v in pairs(_bankBranches) do
    if v.interactZone then
      exports['polyzonehandler']:PolyZoneCreateBox("banking-" .. k, v.interactZone.center, v.interactZone.length, v.interactZone.width, {
        heading = v.interactZone.heading,
        minZ = v.interactZone.minZ,
        maxZ = v.interactZone.maxZ,
      }, {
        bank_branch = k,
      })
    end
  end
end

AddEventHandler("Characters:Client:Spawn", function()
  for k, v in pairs(_bankBranches) do
    if v.blip then
      if v.special then
        exports['blips']:Add("bank_" .. k, "Pacific Bank", v.blip, 272, 15, 0.8)
      else
        exports['blips']:Add("bank_" .. k, "Bank", v.blip, 272, 69, 0.6)
      end
    end
  end
end)

AddEventHandler("Polyzone:Enter", function(id, point, insideZone, data)
  if data.bank_branch then
    withinBranchZone = data.bank_branch

    if not GlobalState[string.format("Fleeca:Disable:%s", data.bank_branch)] then
      exports['hud']:ActionShow("banking", "{keybind}primary_action{/keybind} Open Bank")
    else
      exports['hud']:ActionShow("banking", "Bank Unavailable")
    end

    showingAction = true
  end
end)

AddEventHandler("Polyzone:Exit", function(id, point, insideZone, data)
  if withinBranchZone and data and data.bank_branch then
    withinBranchZone = false
    if showingAction then
      exports['hud']:ActionHide("banking")
      showingAction = false
    end
  end
end)

AddEventHandler("Keybinds:Client:KeyUp:primary_action", function()
  if
      withinBranchZone
      and not LocalPlayer.state.doingAction
      and not GlobalState[string.format("Fleeca:Disable:%s", withinBranchZone)]
  then
    TriggerEvent("Finance:Client:OpenUI")
  end
end)
