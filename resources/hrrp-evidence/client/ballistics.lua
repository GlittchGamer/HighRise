_withinBallistics = false
_holdingGun = nil

AddEventHandler('Polyzone:Enter', function(id, point, insideZone, data)
  if data and data.ballistics and LocalPlayer.state.onDuty == 'police' then
    _withinBallistics = true
    exports['hrrp-hud']:ActionShow('{keybind}primary_action{/keybind} Test & File Gun Ballistics | {key}Use Projectile Evidence{/key} File Projectile & Compare')
  end
end)

AddEventHandler('Polyzone:Exit', function(id, point, insideZone, data)
  if _withinBallistics and data and data.ballistics and LocalPlayer.state.onDuty == 'police' then
    _withinBallistics = false
    exports['hrrp-hud']:ActionHide()
  end
end)

AddEventHandler('Keybinds:Client:KeyUp:primary_action', function()
  if _withinBallistics and LocalPlayer.state.loggedIn then
    if _holdingGun ~= nil then
      exports['hrrp-hud']:ActionHide()
      local data = _holdingGun
      exports["hrrp-base"]:CallbacksServer('Evidence:Ballistics:FileGun', data, function(success, alreadyFiled, matchingEvidence, policeWeaponId)
        exports["hrrp-animations"]:EmotesPlay('type3', false, 8000, true, true)
        Progress:Progress({
          name = 'gun_ballistics_test',
          duration = 8000,
          label = 'Testing Gun Ballistics',
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
            if success then
              if alreadyFiled then
                exports['hrrp-hud']:NotificationSuccess('Ballistics Filed Successfully - Gun Was Already Filed')
              else
                exports['hrrp-hud']:NotificationSuccess('Ballistics Filed Successfully - Gun Now Filed')
              end

              local items = {}

              if policeWeaponId then
                table.insert(items, {
                  label = 'Police Weapon Identifier',
                  description = string.format('Since the weapon had no serial number, a police identifier was given.<br>Identifier: %s', policeWeaponId),
                })
              else
                table.insert(items, {
                  label = 'Weapon Serial Number',
                  description = string.format('Serial: %s', data.serial),
                })
              end

              if matchingEvidence and #matchingEvidence > 0 then
                Sounds.Play:Distance(4, "demo.ogg", 0.4)
                table.insert(items, {
                  label = 'Ballistics Matches Found',
                  description = string.format('%s Projectile Matches Found When Compared to Filed Weapons', #matchingEvidence),
                })
                for k, v in ipairs(matchingEvidence) do
                  table.insert(items, {
                    label = string.format('Evidence %s', v),
                  })
                end
              else
                table.insert(items, {
                  label = 'No Ballistics Matches Found',
                })
              end

              ListMenu:Show({
                main = {
                  label = 'Ballistics Comparison - Results',
                  items = items,
                },
              })
            else
              exports['hrrp-hud']:NotificationError('Ballistics Testing Failed')
            end
          end
        end)
      end)
    else
      exports['hrrp-hud']:NotificationError('Hold the Gun You Want to Test')
    end
  end
end)

AddEventHandler('Weapons:Client:SwitchedWeapon', function(weapon, weaponData, weaponItemData)
  if weapon and weaponItemData and weaponItemData.gun and weaponData.MetaData then
    _holdingGun = {
      slotNum = weaponData.Slot,
      serial = weaponData.MetaData.SerialNumber or weaponData.MetaData.ScratchedSerialNumber
    }
  else
    _holdingGun = nil
  end
end)

RegisterNetEvent('Evidence:Client:FiledProjectile', function(tooDegraded, success, alreadyFiled, filedEvidenceData, matchingWeaponData, evidenceId)
  if tooDegraded then
    return exports['hrrp-hud']:NotificationError('Projectile too Degraded to Run Ballistics')
  end

  exports["hrrp-animations"]:EmotesPlay('type3', false, 5500, true, true)
  Progress:Progress({
    name = 'projectile_ballistics_test',
    duration = 5000,
    label = 'Testing Projectile Ballistics',
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
      if success then
        if alreadyFiled then
          exports['hrrp-hud']:NotificationSuccess('Projectile Was Already Filed', 7500)
        else
          exports['hrrp-hud']:NotificationSuccess('Projectile Filed Successfully', 7500)
        end

        local desc, label

        if matchingWeaponData and matchingWeaponData.FiledByPolice then
          label = string.format('Successfully Matched to a %s', matchingWeaponData.Model)

          if matchingWeaponData.Scratched then
            desc = string.format('Matched to a Weapon with no Serial Number<br>Assigned Police Weapon ID: %s', matchingWeaponData.PoliceWeaponId)
          else
            desc = string.format('Serial Number: %s', matchingWeaponData.Serial)
          end
        else
          label = 'No Matching Weapon Found'
          desc = 'There are currently no weapons filed that match this projectile'
        end

        if label and desc then
          ListMenu:Show({
            main = {
              label = 'Ballistics Comparison - Results',
              items = {
                {
                  label = 'Projectile Evidence Identifier',
                  description = evidenceId,
                },
                {
                  label = label,
                  description = desc,
                }
              },
            },
          })
        end
      else
        exports['hrrp-hud']:NotificationError('Ballistics Testing Failed')
      end
    end
  end)
end)
