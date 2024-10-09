local _threading = false
function StartLombankThreads()
  if _threading then return end
  _threading = true

  Citizen.CreateThread(function()
    while _threading do
      if _lbGlobalReset ~= nil then
        if os.time() > _lbGlobalReset then
          exports['hrrp-base']:LoggerInfo("Robbery", "Lombank Heist Has Been Reset")
          ResetLombank()
        end
      end
      Citizen.Wait(30000)
    end
  end)

  Citizen.CreateThread(function()
    while _threading do
      local powerDisabled = IsLBPowerDisabled()
      if not powerDisabled and not exports['hrrp-doors']:IsLocked("lombank_hidden_entrance") then
        exports['hrrp-doors']:SetLock("lombank_hidden_entrance", true)
        exports['hrrp-doors']:SetLock("lombank_lasers", true)
      elseif powerDisabled and exports['hrrp-doors']:IsLocked("lombank_hidden_entrance") then
        exports['hrrp-doors']:SetLock("lombank_hidden_entrance", false)
      end
      Citizen.Wait((1000 * 60) * 1)
    end
  end)

  Citizen.CreateThread(function()
    while _threading do
      for i = #_unlockingDoors, 1, -1 do
        local v = _unlockingDoors[i]
        if os.time() > v.expires then
          exports['hrrp-doors']:SetLock(v.door, false)
          if v.forceOpen then
            exports['hrrp-doors']:SetForcedOpen(v.door)
          end
          exports['hrrp-base']:ExecuteClient(v.source, "Notification", "Info", "Door Unlocked")
          table.remove(_unlockingDoors, i)
        end
      end
      Citizen.Wait(30000)
    end
  end)

  Citizen.CreateThread(function()
    while _threading do
      if _lbGlobalReset ~= nil and os.time() > _lbGlobalReset then
        ResetLombank()
        _lbGlobalReset = nil
      end
      Citizen.Wait(60000)
    end
  end)

  -- Citizen.CreateThread(function()
  --     while _threading do
  --         local powerDisabled = IsLBPowerDisabled()
  --         if not powerDisabled and not exports['hrrp-doors']:IsLocked("lombank_hidden_entrance") then
  --             exports['hrrp-doors']:SetLock("lombank_hidden_entrance", true)
  --         end
  --         Citizen.Wait((1000 * 60) * 1)
  --     end
  -- end)
end
