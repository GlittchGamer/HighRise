local _breached = {}
local _swabCounter = 1

local _generatedNames = {}

AddEventHandler("Police:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Middleware = exports['core']:FetchComponent("Middleware")
  Callbacks = exports['core']:FetchComponent("Callbacks")
  Logger = exports['core']:FetchComponent("Logger")
  Jobs = exports['core']:FetchComponent("Jobs")
  Fetch = exports['core']:FetchComponent("Fetch")
  Chat = exports['core']:FetchComponent("Chat")
  Execute = exports['core']:FetchComponent("Execute")
  Police = exports['core']:FetchComponent("Police")
  Handcuffs = exports['core']:FetchComponent("Handcuffs")
  Inventory = exports['core']:FetchComponent("Inventory")
  Routing = exports['core']:FetchComponent("Routing")
  EmergencyAlerts = exports['core']:FetchComponent("EmergencyAlerts")
  MDT = exports['core']:FetchComponent("MDT")
  Radar = exports['core']:FetchComponent("Radar")
  Generator = exports['core']:FetchComponent("Generator")
  Vehicles = exports['core']:FetchComponent("Vehicles")
  Ped = exports['core']:FetchComponent("Ped")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies("Police", {

    "Middleware",
    "Callbacks",
    "Logger",
    "Jobs",
    "Fetch",
    "Chat",
    "Execute",
    "Police",
    "Handcuffs",
    "Routing",
    "EmergencyAlerts",
    "MDT",
    "Radar",
    "Generator",
    "Vehicles",
    "Ped",
  }, function(error)
    if #error > 0 then
      return
    end -- Do something to handle if not all dependencies loaded
    RetrieveComponents()
    PoliceItems()
    RegisterCommands()

    GlobalState["PoliceCars"] = Config.PoliceCars

    for k, v in pairs(Config.Armories) do
      exports['core']:LoggerTrace("Police", string.format("Registering Poly Inventory ^2%s^7 For ^3%s^7", v.id, v.name))
      Inventory.Poly:Create(v)
    end

    Inventory.Items:RegisterUse("spikes", "Police", function(source, slot, itemData)
      if GetVehiclePedIsIn(GetPlayerPed(source)) == 0 then
        exports['core']:CallbacksClient(source, "Police:DeploySpikes", {}, function(data)
          if data ~= nil then
            TriggerClientEvent("Police:Client:AddDeployedSpike", -1, data.positions, data.h, source)

            local newValue = slot.CreateDate - math.ceil(itemData.durability / 4)
            if (os.time() - itemData.durability >= newValue) then
              Inventory.Items:RemoveId(slot.Owner, slot.invType, slot)
            else
              Inventory:SetItemCreateDate(
                slot.id,
                newValue
              )
            end

            exports['core']:ExecuteClient(source, "Notification", "Success", "You Deployed Spikes (Despawn In 20s)")
          end
        end)
      end
    end)

    exports['core']:CallbacksRegisterServer("Police:GSRTest", function(source, data, cb)
      local char = exports['core']:FetchSource(source):GetData("Character")

      local pState = Player(source).state
      if pState.onDuty == "police" or pState.onDuty == "ems" then
        local target = Player(data)
        if target ~= nil then
          if target.state?.GSR ~= nil and (os.time() - target.state.GSR) <= (60 * 10) then
            Chat.Send.System:Single(source, "GSR: Positive")
          else
            Chat.Send.System:Single(source, "GSR: Negative")
          end
        else
          exports['core']:ExecuteClient(source, "Notification", "Error", "Invalid Target")
        end
      end
    end)

    exports['core']:CallbacksRegisterServer("Police:BACTest", function(source, data, cb)
      local char = exports['core']:FetchSource(source):GetData("Character")

      local pState = Player(source).state
      if pState.onDuty == "police" or pState.onDuty == "ems" then
        local target = Player(data)
        if target ~= nil then
          -- Great Code Kapp
          if target.state.isDrunk and target.state.isDrunk > 0 then
            if target.state.isDrunk >= 70 then
              Chat.Send.System:Single(source, "BAC: 0.22% - Above Limit")
            elseif target.state.isDrunk >= 40 then
              Chat.Send.System:Single(source, "BAC: 0.13% - Above Limit")
            elseif target.state.isDrunk >= 30 then
              Chat.Send.System:Single(source, "BAC: 0.1% - Above Limit")
            elseif target.state.isDrunk >= 25 then
              Chat.Send.System:Single(source, "BAC: 0.085% - Above Limit")
            elseif target.state.isDrunk >= 15 then
              Chat.Send.System:Single(source, "BAC: 0.04% - Below Limit")
            else
              Chat.Send.System:Single(source, "BAC: 0.025% - Below Limit")
            end
          else
            Chat.Send.System:Single(source, "BAC: Not Drunk")
          end
        else
          exports['core']:ExecuteClient(source, "Notification", "Error", "Invalid Target")
        end
      end

      cb(true)
    end)

    exports['core']:CallbacksRegisterServer("Police:DNASwab", function(source, data, cb)
      local char = exports['core']:FetchSource(source):GetData("Character")

      local pState = Player(source).state
      if char and pState.onDuty == "police" or pState.onDuty == "ems" then
        local tPlayer = exports['core']:FetchSource(data)
        if tPlayer ~= nil then
          local tChar = tPlayer:GetData("Character")
          if tChar ~= nil then
            local coords = GetEntityCoords(GetPlayerPed(data))
            _swabCounter += 1

            Inventory:AddItem(char:GetData('SID'), 'evidence-dna', 1, {
              EvidenceType = 'blood',
              EvidenceId = string.format('%s-%s', os.date('%d%m%y-%H%M%S', os.time()), 950000 + _swabCounter),
              EvidenceCoords = { x = coords.x, y = coords.y, z = coords.z },
              EvidenceDNA = tChar:GetData("SID"),
              EvidenceSwab = true,
              EvidenceDegraded = false,
            }, 1)

            return
          end
        end

        exports['core']:ExecuteClient(source, "Notification", "Error", "Invalid Target")
      end
    end)

    exports['core']:CallbacksRegisterServer("Police:Breach", function(source, data, cb)
      local char = exports['core']:FetchSource(source):GetData("Character")

      if (data?.type == nil or data?.property == nil) then
        cb(false)
        return
      end

      if Player(source).state.onDuty == "police" then
        _breached[data.type] = _breached[data.type] or {}

        if data.type == "property" then
          if (_breached[data.type][data.property] or 0) > os.time() then
            cb(true)
            exports['core']:ExecuteClient(source, "Properties", "Enter", data.property)
          else
            exports['core']:CallbacksClient(source, "Police:Breach", {}, function(s)
              if s then
                _breached[data.type][data.property] = os.time() + (60 * 10)
                exports['core']:ExecuteClient(source, "Properties", "Enter", data.property)
                cb(true)
              else
                cb(false)
              end
            end)
          end
        elseif data.type == "robbery" then
          if (_breached[data.type][data.property] or 0) > os.time() then
            TriggerEvent("Labor:Server:HouseRobbery:Breach", source, data.property)

            cb(true)
          else
            exports['core']:CallbacksClient(source, "Police:Breach", {}, function(s)
              if s then
                TriggerEvent("Labor:Server:HouseRobbery:Breach", source, data.property)

                cb(true)
              else
                cb(false)
              end
            end)
          end
        elseif data.type == "apartment" then
          local aptTier = Fetch:GetOfflineData(data.property, "Apartment")

          if aptTier ~= nil then
            local id = aptTier or 1
            if id == aptTier then
              if (_breached[data.type][data.property] or 0) > os.time() then
                exports['core']:ExecuteClient(source, "Apartment", "Enter", aptTier, data.property)

                return cb(data.property)
              else
                exports['core']:CallbacksClient(source, "Police:Breach", {}, function(s)
                  if s then
                    _breached[data.type][data.property] = os.time() + (60 * 10)
                    exports['core']:ExecuteClient(source, "Apartment", "Enter", aptTier, data.property)

                    return cb(data.property)
                  else
                    cb(false)
                  end
                end)
              end
            else
              exports['core']:ExecuteClient(source, "Notification", "Error", "Target Does Not Reside Here")
              return cb(false)
            end
          else
            exports['core']:ExecuteClient(source, "Notification", "Error", "Target Not Online")
            return cb(false)
          end
        end
      else
        cb(false)
      end
    end)

    exports['core']:CallbacksRegisterServer("Police:AccessRifleRack", function(source, data, cb)
      local plyr = exports['core']:FetchSource(source)
      if plyr ~= nil then
        local char = plyr:GetData("Character")
        if char ~= nil then
          local myDuty = Player(source).state.onDuty
          if myDuty == 'police' then
            local veh = GetVehiclePedIsIn(GetPlayerPed(source))
            if veh ~= 0 then
              if Config.PoliceCars[GetEntityModel(veh)] then
                local entState = Entity(veh).state
                if Vehicles.Keys:Has(source, entState.VIN, 'police') then
                  exports['core']:CallbacksClient(source, "Inventory:Compartment:Open", {
                    invType = 3,
                    owner = ("pdrack:%s"):format(entState.VIN),
                  }, function()
                    Inventory:OpenSecondary(source, 3, ("pdrack:%s"):format(entState.VIN))
                  end)
                else
                  exports['core']:ExecuteClient(source, "Notification", "Error", "Can't Access The Locked Compartment")
                end
              else
                exports['core']:ExecuteClient(source, "Notification", "Error", "Vehicle Not Outfitted With A Secured Compartment")
              end
            else
              exports['core']:ExecuteClient(source, "Notification", "Error", "Not In A Vehicle")
            end
          end
        end
      end
    end)

    exports['core']:CallbacksRegisterServer("Police:RemoveMask", function(source, data, cb)
      local plyr = exports['core']:FetchSource(source)
      if plyr ~= nil then
        local char = plyr:GetData("Character")
        if char ~= nil then
          local myDuty = Player(source).state.onDuty
          if myDuty == 'police' then
            local tPlyr = exports['core']:FetchSource(source)
            if tPlyr ~= nil then
              local tChar = tPlyr:GetData("Character")
              if tChar ~= nil then
                Ped.Mask:Unequip(data)
              end
            end
          end
        end
      end
    end)

    RemoveEventHandler(setupEvent)
  end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
  exports['core']:RegisterComponent("Police", POLICE)
end)

RegisterNetEvent("Police:Server:Cuff", function()
  local src = source
  local plyr = exports['core']:FetchSource(src)
  if plyr ~= nil then
    local char = plyr:GetData("Character")
    if char ~= nil then
      local myDuty = Player(src).state.onDuty
      if myDuty and myDuty == "police" then
        Handcuffs:SoftCuff(source)
      end
    end
  end
end)

RegisterNetEvent("Police:Server:Uncuff", function()
  local src = source
  local plyr = exports['core']:FetchSource(src)
  if plyr ~= nil then
    local char = plyr:GetData("Character")
    if char ~= nil then
      local myDuty = Player(src).state.onDuty
      if myDuty and myDuty == "police" then
        Handcuffs:Uncuff(source)
      end
    end
  end
end)

RegisterNetEvent("Police:Server:RunPlate", function(plate, VIN, model)
  local src = source
  local plyr = exports['core']:FetchSource(src)
  if plyr ~= nil then
    local char = plyr:GetData("Character")
    if char ~= nil then
      local myDuty = Player(src).state.onDuty
      if myDuty and myDuty == "police" then
        Police:RunPlate(src, plate, {
          VIN = VIN,
          model = model
        })
      end
    end
  end
end)

-- RegisterNetEvent("Police:Server:ToggleCuff", function()
-- 	local src = source
-- 	local plyr = exports['core']:FetchSource(src)
-- 	if plyr ~= nil then
-- 		local char = plyr:GetData("Character")
-- 		if char ~= nil then
-- 			local myDuty = Player(src).state.onDuty
-- 			if myDuty and myDuty == "police" then
-- 				Handcuffs:ToggleCuffs(source)
-- 			end
-- 		end
-- 	end
-- end)

RegisterNetEvent("Police:Server:Panic", function(isAlpha)
  local src = source
  local char = exports['core']:FetchSource(src):GetData("Character")
  if Player(src).state.onDuty == "police" then
    local coords = GetEntityCoords(GetPlayerPed(src))
    exports['core']:CallbacksClient(src, "EmergencyAlerts:GetStreetName", coords, function(location)
      if isAlpha then
        EmergencyAlerts:Create("13-A", "Officer Down", 2, location, string.format(
          "%s - %s %s",
          char:GetData("Callsign"),
          char:GetData("First"),
          char:GetData("Last")
        ), true, {
          icon = 303,
          size = 1.2,
          color = 26,
          duration = (60 * 10),
        }, 1)
      else
        EmergencyAlerts:Create("13-B", "Officer Down", 2, location, string.format(
          "%s - %s %s",
          char:GetData("Callsign"),
          char:GetData("First"),
          char:GetData("Last")
        ), false, {
          icon = 303,
          size = 0.9,
          color = 26,
          duration = (60 * 10),
        }, 1)
      end
    end)
  end
end)

RegisterNetEvent('Police:Server:Tackle', function(target)
  local src = source
  if #(GetEntityCoords(GetPlayerPed(src)) - GetEntityCoords(GetPlayerPed(target))) < 5.0 then
    TriggerClientEvent('Police:Client:GetTackled', target)
  end
end)

POLICE = {
  IsInBreach = function(self, source, type, id, extraCheck)
    if Player(source)?.state?.onDuty == "police" and (not extraCheck or exports['jobs']:JobsPermissionsHasPermissionInJob(source, 'police', 'PD_RAID')) then
      if _breached[type] and _breached[type][id] and ((_breached[type][id] or 0) > os.time()) then
        if extraCheck then
          local player = exports['core']:FetchSource(source)
          if player then
            local char = player:GetData('Character')
            if char then
              exports['core']:LoggerWarn(
                "Police",
                string.format(
                  "Police Raid - %s [%s] - Character %s %s (%s) - Accessing Property %s (%s)",
                  player:GetData("Name"),
                  player:GetData("AccountID"),
                  char:GetData("First"),
                  char:GetData("Last"),
                  char:GetData("SID"),
                  id,
                  type
                ),
                {
                  console = true,
                  discord = {
                    embed = true,
                    type = 'info',
                  }
                }
              )
            end
          end
        end

        return true
      end
    end

    return false
  end,
  RunPlate = function(self, source, plate, wasEntity)
    local result = MySQL.Sync.fetchAll('SELECT * FROM vehicles WHERE RegisteredPlate = @plate OR FakePlate = @plate', {
      ['@plate'] = plate
    })
    if #result == 0 then
      local stolen = exports['radar']:CheckPlate(plate)
      if stolen then
        if not _generatedNames[plate] then
          _generatedNames[plate] = string.format(
            "%s %s",
            Generator.Name:First(),
            Generator.Name:Last()
          )
        end

        if wasEntity then
          Chat.Send.Services:Dispatch(
            source,
            string.format(
              "<b>Owner</b>: %s<br /><b>VIN</b>: %s<br /><b>Make & Model</b>: %s<br /><b>Plate</b>: %s<br /><b>Class</b>: Unknown<br /><br />%s",
              _generatedNames[plate],
              wasEntity.VIN,
              wasEntity.model,
              plate,
              stolen
            )
          )
        else
          Chat.Send.Services:Dispatch(
            source,
            string.format(
              "<b>Owner</b>: %s<br /><b>VIN</b>: Unknown<br /><b>Make & Model</b>: Unknown<br /><b>Plate</b>: %s<br /><b>Class</b>: Unknown<br /><br />%s",
              _generatedNames[plate],
              plate,
              stolen
            )
          )
        end
      elseif wasEntity then
        if not _generatedNames[plate] then
          _generatedNames[plate] = string.format(
            "%s %s",
            Generator.Name:First(),
            Generator.Name:Last()
          )
        end

        Chat.Send.Services:Dispatch(
          source,
          string.format(
            "<b>Owner</b>: %s<br /><b>VIN</b>: %s<br /><b>Make & Model</b>: %s<br /><b>Plate</b>: %s<br /><b>Class</b>: Unknown",
            _generatedNames[plate],
            wasEntity.VIN,
            wasEntity.model,
            plate
          )
        )
      else
        Chat.Send.Services:Dispatch(source, "No Plate Match")
      end
      return
    end

    if #result > 1 then
      Chat.Send.Services:Dispatch(source, "Multiple Matches, Please Use MDT")
    else
      local vehicle = results[1]
      if vehicle.FakePlate and vehicle.FakePlateData then
        local stolen = exports['radar']:CheckPlate(plate)
        if stolen then
          Chat.Send.Services:Dispatch(
            source,
            string.format(
              "<b>Owner</b>: %s (%s)<br /><b>VIN</b>: %s<br /><b>Make & Model</b>: %s<br /><b>Plate</b>: %s<br /><b>Class</b>: Unknown<br /><br />%s",
              vehicle.FakePlateData.OwnerName,
              vehicle.FakePlateData.SID,
              vehicle.FakePlateData.VIN,
              vehicle.FakePlateData.Vehicle or string.format('%s %s', vehicle.Make, vehicle.Model),
              vehicle.FakePlate,
              stolen
            )
          )
        else
          Chat.Send.Services:Dispatch(
            source,
            string.format(
              "<b>Owner</b>: %s (%s)<br /><b>VIN</b>: %s<br /><b>Make & Model</b>: %s<br /><b>Plate</b>: %s<br /><b>Class</b>: Unknown",
              vehicle.FakePlateData.OwnerName,
              vehicle.FakePlateData.SID,
              vehicle.FakePlateData.VIN,
              vehicle.FakePlateData.Vehicle or string.format('%s %s', vehicle.Make, vehicle.Model),
              vehicle.FakePlate
            )
          )
        end
      else
        local owner = MDT.People:View(vehicle.Owner.Id)

        local stolen = false
        if vehicle.Flags then
          for k, v in ipairs(vehicle.Flags) do
            if v.Type == "stolen" then
              stolen = v.Description
              break
            end
          end
        end

        if stolen then
          Chat.Send.Services:Dispatch(
            source,
            string.format(
              "<b>Owner</b>: %s %s (%s)<br /><b>VIN</b>: %s<br /><b>Make & Model</b>: %s %s<br /><b>Plate</b>: %s<br /><b>Class</b>: %s<br /><br /><b>Vehicle Reported Stolen</b>: %s",
              owner.First,
              owner.Last,
              vehicle.Owner.Id,
              vehicle.VIN,
              vehicle.Make,
              vehicle.Model,
              vehicle.RegisteredPlate,
              vehicle.Class,
              stolen
            )
          )
        else
          Chat.Send.Services:Dispatch(
            source,
            string.format(
              "Owner: %s %s (%s)\nVIN: %s\nMake & Model: %s %s\nPlate: %s\nClass: %s",
              owner.First,
              owner.Last,
              vehicle.Owner.Id,
              vehicle.VIN,
              vehicle.Make,
              vehicle.Model,
              vehicle.RegisteredPlate,
              vehicle.Class
            )
          )
        end
      end
    end
  end,
}

RegisterNetEvent("Police:Server:RemoveSpikes", function()
  TriggerClientEvent("Police:Client:RemoveSpikes", -1, source)
end)

RegisterNetEvent("Police:Server:Slimjim", function()
  local src = source

  if Player(src).state.onDuty == "police" then
    exports['core']:CallbacksClient(src, "Vehicles:Slimjim", true, function()

    end)
  end
end)
