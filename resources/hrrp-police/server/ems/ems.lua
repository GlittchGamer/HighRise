AddEventHandler("EMS:Shared:DependencyUpdate", EMSComponents)
function EMSComponents()
  Middleware = exports["hrrp-base"]:FetchComponent("Middleware")
  Callbacks = exports["hrrp-base"]:FetchComponent("Callbacks")
  Logger = exports["hrrp-base"]:FetchComponent("Logger")
  Fetch = exports["hrrp-base"]:FetchComponent("Fetch")
  Inventory = exports["hrrp-base"]:FetchComponent("Inventory")
  Damage = exports["hrrp-base"]:FetchComponent("Damage")
  Execute = exports["hrrp-base"]:FetchComponent("Execute")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports["hrrp-base"]:RequestDependencies("EMS", {

    "Middleware",
    "Callbacks",
    "Logger",
    "Fetch",
    "Inventory",
    "Damage",
    "Execute",
  }, function(error)
    if #error > 0 then
      return
    end -- Do something to handle if not all dependencies loaded
    EMSComponents()
    EMSCallbacks()
    EMSItems()

    RemoveEventHandler(setupEvent)
  end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
  exports["hrrp-base"]:RegisterComponent("EMS", _EMS)
end)

RegisterNetEvent("EMS:Server:CheckICUPatients", function()
  local src = source
  local count = 0
  for k, v in ipairs(Fetch:All()) do
    local c = v:GetData("Character")
    if c ~= nil then
      if c:GetData("ICU") ~= nil and not c:GetData("ICU").Released then
        count = count + 1
      end
    end
  end

  if count > 0 then
    if count == 1 then
      exports['hrrp-base']:ExecuteClient(src, "Notification", "Info", "There Is 1 Patient In ICU")
    else
      exports['hrrp-base']:ExecuteClient(src, "Notification", "Info", string.format("There Are %s Patients In ICU", count))
    end
  else
    exports['hrrp-base']:ExecuteClient(src, "Notification", "Info", "There Are No Patients In ICU")
  end
end)

RegisterNetEvent("EMS:Server:RequestHelp", function()
  local src = source
  TriggerEvent("EmergencyAlerts:Server:ServerDoPredefined", src, "injuredPerson")
end)

function EMSCallbacks()
  exports['hrrp-base']:CallbacksRegisterServer("EMS:Stabilize", function(source, data, cb)
    local myChar = exports['hrrp-base']:FetchSource(source):GetData("Character")
    local plyr = exports['hrrp-base']:FetchSource(tonumber(data))
    if plyr ~= nil then
      local char = plyr:GetData("Character")
      if Inventory.Items:Has(myChar:GetData("SID"), 1, "traumakit", 1) then
        if exports['hrrp-jobs']:JobsPermissionsHasJob(source, "ems") then
          exports['hrrp-base']:LoggerInfo(
            "EMS",
            string.format(
              "%s %s (%s) Stabilized %s %s (%s)",
              myChar:GetData("First"),
              myChar:GetData("Last"),
              myChar:GetData("SID"),
              char:GetData("First"),
              char:GetData("Last"),
              char:GetData("SID")
            ),
            {
              console = true,
              file = true,
              database = true,
            }
          )
          exports["hrrp-base"]:CallbacksClient(data, "Damage:FieldStabalize")
          cb({ error = false })
        else
          cb({ error = true, code = 3 })
        end
      else
        cb({ error = true, code = 2 })
      end
    else
      cb({ error = true, code = 1 })
    end
  end)

  exports['hrrp-base']:CallbacksRegisterServer("EMS:FieldTreatWounds", function(source, data, cb)
    local myChar = exports['hrrp-base']:FetchSource(source):GetData("Character")
    if exports['hrrp-jobs']:JobsPermissionsHasJob(source, "ems") then
      if Inventory.Items:Has(myChar:GetData("SID"), 1, "traumakit", 1) then
        exports['hrrp-base']:ExecuteClient(data, "Notification", "Success", "Your Wounds Were Treated")
        cb({ error = false })
      else
        cb({ error = true, code = 2 })
      end
    else
      cb({ error = true, code = 1 })
    end
  end)

  -- exports['hrrp-base']:CallbacksRegisterServer("EMS:ApplyGauze", function(source, data, cb)
  -- 	local myChar = exports['hrrp-base']:FetchSource(source):GetData("Character")
  -- 	if exports['hrrp-jobs']:JobsPermissionsHasJob(source, "ems") then
  -- 		if Inventory.Items:Remove(myChar:GetData("SID"), 1, "gauze", 1) then
  -- 			local target = exports['hrrp-base']:FetchSource(data)
  -- 			if target ~= nil then
  -- 				local tChar = target:GetData("Character")
  -- 				if tChar ~= nil then
  -- 					local dmg = tChar:GetData("Damage")
  -- 					if dmg.Bleed > 1 then
  -- 						dmg.Bleed = dmg.Bleed - 1
  -- 						tChar:SetData("Damage", dmg)
  -- 					else
  -- 						exports['hrrp-base']:ExecuteClient(data, "Notification", "Error", "You continue bleeding through the gauze")
  -- 					end
  -- 					cb({ error = false })
  -- 				else
  -- 					cb({ error = true, code = 4 })
  -- 				end
  -- 			else
  -- 				cb({ error = true, code = 3 })
  -- 			end
  -- 		else
  -- 			cb({ error = true, code = 2 })
  -- 		end
  -- 	else
  -- 		cb({ error = true, code = 1 })
  -- 	end
  -- end)

  exports['hrrp-base']:CallbacksRegisterServer("EMS:ApplyBandage", function(source, data, cb)
    local myChar = exports['hrrp-base']:FetchSource(source):GetData("Character")
    if exports['hrrp-jobs']:JobsPermissionsHasJob(source, "ems") then
      if Inventory.Items:Remove(myChar:GetData("SID"), 1, "bandage", 1) then
        local ped = GetPlayerPed(data)
        local currHp = GetEntityHealth(ped)
        if currHp < (GetEntityMaxHealth(ped) * 0.75) then
          local p = promise.new()

          exports["hrrp-base"]:CallbacksClient(data, "EMS:ApplyBandage", {}, function(s)
            p:resolve(s)
          end)

          Citizen.Await(p)
          exports['hrrp-base']:ExecuteClient(data, "Notification", "Success", "A Bandage Was Applied To You")
          cb({ error = false })
        else
          cb({ error = true, code = 3 })
        end
      else
        cb({ error = true, code = 2 })
      end
    else
      cb({ error = true, code = 1 })
    end
  end)

  exports['hrrp-base']:CallbacksRegisterServer("EMS:ApplyMorphine", function(source, data, cb)
    local myChar = exports['hrrp-base']:FetchSource(source):GetData("Character")
    if exports['hrrp-jobs']:JobsPermissionsHasJob(source, "ems") then
      if Inventory.Items:Remove(myChar:GetData("SID"), 1, "morphine", 1) then
        Damage.Effects:Painkiller(tonumber(data), 3)
        exports['hrrp-base']:ExecuteClient(data, "Notification", "Success", "You Received A Morphine Shot")
        cb({ error = false })
      else
        cb({ error = true, code = 2 })
      end
    else
      cb({ error = true, code = 1 })
    end
  end)

  exports['hrrp-base']:CallbacksRegisterServer("EMS:TreatWounds", function(source, data, cb)
    local myChar = exports['hrrp-base']:FetchSource(source):GetData("Character")
    if exports['hrrp-jobs']:JobsPermissionsHasJob(source, "ems") then
      exports["hrrp-base"]:CallbacksClient(data, "Damage:Heal", true)
      --TriggerClientEvent("Hospital:Client:GetOut", data)
      exports['hrrp-base']:ExecuteClient(source, "Notification", "Success", "Patient Has Been Treated")
      exports['hrrp-base']:ExecuteClient(data, "Notification", "Success", "You've Been Treated")
      cb({ error = false })
    else
      cb({ error = true, code = 1 })
    end
  end)

  exports['hrrp-base']:CallbacksRegisterServer("EMS:CheckDamage", function(source, data, cb)
    local myChar = exports['hrrp-base']:FetchSource(source):GetData("Character")
    if exports['hrrp-jobs']:JobsPermissionsHasJob(source, "ems") or exports['hrrp-jobs']:JobsPermissionsHasJob(source, "police") then
      local tPlyr = exports['hrrp-base']:FetchSource(data)
      if tPlyr ~= nil then
        local tChar = tPlyr:GetData("Character")
        if tChar ~= nil then
          cb(tChar:GetData("Damage"))
        else
          cb(nil)
        end
      else
        cb(nil)
      end
    else
      cb(nil)
    end
  end)

  exports['hrrp-base']:CallbacksRegisterServer("EMS:DrugTest", function(source, data, cb)
    local plyr = exports['hrrp-base']:FetchSource(source)
    if plyr ~= nil then
      local char = plyr:GetData("Character")
      if char ~= nil then
        local pState = Player(source).state
        if pState.onDuty == "ems" then
          local target = exports['hrrp-base']:FetchSource(data)
          if target ~= nil then
            local tarChar = target:GetData("Character")
            if tarChar ~= nil then
              local tarStates = tarChar:GetData("DrugStates") or {}
              local output = {}
              for k, v in pairs(tarStates) do
                if v.expires > os.time() then
                  local item = Inventory.Items:GetData(v.item)
                  local pct = ((v.expires - os.time()) / item.drugState.duration) * 100
                  if pct <= 25 and pct >= 5 then
                    table.insert(
                      output,
                      string.format("Low Presence of %s", Config.Drugs[item.drugState.type])
                    )
                  elseif pct <= 50 then
                    table.insert(
                      output,
                      string.format("Moderate Presence of %s", Config.Drugs[item.drugState.type])
                    )
                  elseif pct <= 75 then
                    table.insert(
                      output,
                      string.format("High Presence of %s", Config.Drugs[item.drugState.type])
                    )
                  elseif pct > 5 then
                    table.insert(
                      output,
                      string.format("Very High Presence of %s", Config.Drugs[item.drugState.type])
                    )
                  end
                end
              end

              if #output > 0 then
                local str = string.format(
                  "Drug Test Results For %s %s:<br/><ul>",
                  tarChar:GetData("First"),
                  tarChar:GetData("Last")
                )
                for k, v in ipairs(output) do
                  str = str .. string.format("<li>%s</li>", v)
                end
                str = str .. "</ul>"
                Chat.Send.Services:TestResult(source, str)
              else
                Chat.Send.Services:TestResult(
                  source,
                  "Drug Test Results:<br/><ul><li>All Results Are Negative</li></ul>"
                )
              end
            end
          end
        end
      end
    end

    cb(true)
  end)
end

RegisterNetEvent("EMS:Server:Panic", function(isAlpha)
  local src = source
  local char = exports['hrrp-base']:FetchSource(src):GetData("Character")
  if Player(src).state.onDuty == "ems" then
    local coords = GetEntityCoords(GetPlayerPed(src))
    exports["hrrp-base"]:CallbacksClient(src, "EmergencyAlerts:GetStreetName", coords, function(location)
      if isAlpha then
        EmergencyAlerts:Create(
          "13-A",
          "Medic Down",
          2,
          location,
          string.format("%s - %s %s", char:GetData("Callsign"), char:GetData("First"), char:GetData("Last")),
          true,
          {
            icon = 303,
            size = 1.2,
            color = 48,
            duration = (60 * 10),
          },
          1
        )
      else
        EmergencyAlerts:Create(
          "13-B",
          "Medic Down",
          2,
          location,
          string.format("%s - %s %s", char:GetData("Callsign"), char:GetData("First"), char:GetData("Last")),
          false,
          {
            icon = 303,
            size = 0.9,
            color = 48,
            duration = (60 * 10),
          },
          1
        )
      end
    end)
  end
end)

_EMS = {}
