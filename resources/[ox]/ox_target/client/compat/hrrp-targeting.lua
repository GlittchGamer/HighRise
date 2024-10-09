local utils = require 'client.utils'
local api = require 'client.api'
local raycastFromCamera, getNearbyZones, drawZoneSprites in utils
local cbId = 0

local playerPed = PlayerPedId()
lib.onCache("ped", function(value) playerPed = value end)

local function convert(menuArray, icon, proximity)
    for k, v in pairs(menuArray) do
        v.canInteract = v.isEnabled
		v.mainIcon = icon
        v.icon = v.icon or icon
        v.hrrptarget = true
		v.onSelect = v.callback
        if type(v.text) == "function" or type(v.text) == "table" then
            cbId += 1
            v.realName = GetInvokingResource().."_cb_"..tostring(cbId)
            v.textCb = v.text
        else
            v.label = v.text
            v.realName = v.text
        end
        v.groups = v.jobs
        v.tempJob = v.tempjob
        v.jobPerms = v.jobPerms
        if v.anyItems then
            local anyItems = {}
            for _, item in pairs(v.anyItems) do
				if type(item) == "table" then
					anyItems[item.item] = item.count
				else
					anyItems[_] = item
				end
            end
            v.anyItems = anyItems
        end
        if v.items then
            local items = {}
            for _, item in pairs(v.items) do
                items[item.item] = item.count
            end
            v.items = items
        end
        v.distance = v.minDist or proximity
        if v.event and v.type and v.type ~= 'client' then
            if v.type == 'server' then
                v.serverEvent = v.event
            elseif v.type == 'command' then
                v.command = v.event
            end

            v.event = nil
            v.type = nil
        end
    end
    return menuArray
end

local function getLabels(menuArray)
    local labels = {}
    for k, v in pairs(menuArray) do
        labels[#labels+1] = v.realName
    end
    return labels
end

_TARGETING = {
    -- objects
    AddObject = function(self, modelHash, icon, menuArray, proximity)
        menuArray = convert(menuArray, icon, proximity)
        if not modelHash then
            api.addGlobalObject(menuArray)
            return getLabels(menuArray)
        end
        if type(modelHash) ~= "table" then
            modelHash = { modelHash }
        end
        api.addModel(modelHash, menuArray)
        return getLabels(menuArray)
    end,
    RemoveObject = function(self, modelHash, labels)
        if not modelHash then
            return api.removeGlobalObject(labels)
        end
        if type(modelHash) ~= "table" then
            modelHash = { modelHash }
        end
        api.removeModel(modelHash, labels)
    end,
    AddEntity = function(self, entities, icon, menuArray, proximity)
        menuArray = convert(menuArray, icon, proximity)
        if type(entities) ~= "table" then entities = { entities } end

        for i = 1, #entities do
            local entity = entities[i]
    
            if NetworkGetEntityIsNetworked(entity) then
                api.addEntity(NetworkGetNetworkIdFromEntity(entity), menuArray)
            else
                api.addLocalEntity(entity, menuArray)
            end
        end

        return getLabels(menuArray)
    end,
    RemoveEntity = function(self, entities, labels)
        if type(entities) ~= 'table' then entities = { entities } end

        for i = 1, #entities do
            local entity = entities[i]
    
            if NetworkGetEntityIsNetworked(entity) then
                api.removeEntity(NetworkGetNetworkIdFromEntity(entity), labels)
            else
                api.removeLocalEntity(entity, labels)
            end
        end
    end,
    -- peds
    AddPed = function(self, ...)
        return self:AddEntity(...)
    end,
    RemovePed = function(self, ...)
        return self:RemoveEntity(...)
    end,
    AddGlobalPed = function(self, ...)
        return self:AddPedModel(nil, ...)
    end,
    RemoveGlobalPed = function(self, ...)
        return self:AddPedModel(nil, ...)
    end,
    AddPedModel = function(self, modelHash, icon, menuArray, proximity)
        menuArray = convert(menuArray, icon, proximity)
        if not modelHash then
            api.addGlobalPed(menuArray)
            return getLabels(menuArray)
        end
        return self:AddObject(modelHash, icon, menuArray, proximity)
    end,
    RemovePedModel = function(self, modelHash, labels)
        if not modelHash then
            return api.removeGlobalPed(labels)
        end
        return self:AddObject(modelHash, labels)
    end,
    AddGlobalPlayer = function(self, icon, menuArray, proximity)
        menuArray = convert(menuArray, icon, proximity)
        api.addGlobalPlayer(menuArray)
        return getLabels(menuArray)
    end,
    RemoveGlobalPlayer = function(self, labels)
        api.removeGlobalPlayer(labels)
    end,
    AddGlobalVehicle = function(self, icon, menuArray, proximity)
        menuArray = convert(menuArray, icon, proximity)
        api.addGlobalVehicle(menuArray)
        return getLabels(menuArray)
    end,
    RemoveGlobalVehicle = function(self, labels)
        api.removeGlobalVehicle(labels)
    end,
    -- zones
    Zones = {
      AddBox = function(self, zoneId, icon, center, length, width, options, menuArray, proximity, enabled)
          api.removeZone(zoneId, true)
          menuArray = convert(menuArray, icon, proximity)
          local z = center.z

          if not options.minZ then
              options.minZ = -100
          end
      
          if not options.maxZ then
              options.maxZ = 800
          end
      
          if not options.useZ then
              z = z
              center = vec3(center.x, center.y, z)
          end

    if options?.drawSprite ~= false then
      options.drawSprite = true
    end
      
          return api.addBoxZone({
              name = zoneId,
              coords = center,
              size = vec3(width, length, (options.useZ or not options.maxZ) and center.z or math.abs(options.maxZ - options.minZ)),
              debug = options.debugPoly,
      drawSprite = options.drawSprite,
              rotation = options.heading,
              options = menuArray,
              hrrptarget = true,
          })
      end,
      AddCircle = function(self, zoneId, icon, center, radius, options, menuArray, proximity, enabled)
          api.removeZone(zoneId, true)
          menuArray = convert(menuArray, icon, proximity)
          return api.addSphereZone({
              name = zoneId,
              coords = center,
              radius = radius,
              debug = options.debugPoly,
      drawSprite = options.drawSprite and options.drawSprite ~= false or true,
              options = menuArray,
              hrrptarget = true,
          })
      end,
      AddPoly = function(self, zoneId, icon, points, options, menuArray, proximity, enabled)
          api.removeZone(zoneId, true)
          menuArray = convert(menuArray, icon, proximity)
          local newPoints = table.create(#points, 0)
          local thickness = math.abs(options.maxZ - options.minZ)

          for i = 1, #points do
              local point = points[i]
              newPoints[i] = vec3(point.x, point.y, options.maxZ - (thickness / 2))
          end

          return api.addPolyZone({
              name = zoneId,
              points = newPoints,
              thickness = thickness,
              debug = options.debugPoly,
      drawSprite = options.drawSprite and options.drawSprite ~= false or true,
              options = menuArray,
              hrrptarget = true,
          })
      end,
      RemoveZone = function(self, zoneId)
          api.removeZone(zoneId, true)
      end
  },
    GetEntityPlayerIsLookingAt = function(self)
        local hit, entityHit, endCoords = raycastFromCamera(286)
        if hit then
            return {
                entity = entityHit,
                endCoords = endCoords,
            }
        end
        return false
    end,
}

-- idk why this was in the config
local _globalPeds = {
	{
		icon = "cannabis",
		text = "Offer Drugs",
		minDist = 2.0,
		event = "Marijuana:Client:OfferDrugs",
		isEnabled = function(_, entity)
			if isCuffed or isDead then return false end
			-- return exports["prp-marijuana"]:CanOfferDrugs(entity.entity)
      return false
		end
	},

	{
		icon = "hand-paper",
		text = "PickPocket",
		minDist = 2.0,
		event = "Pickpocket:AddTargetToPeds",
		isEnabled = function(_, entity)
      local isScriptedNPC = exports['hrrp-flags']:PedsHasFlag(entity.entity, 'isNPC')
      if isCuffed or isDead or isScriptedNPC then return false end
			return true
		end
	}
}

--#region global vehicles

local _globalVehicle = {
  {
		icon = "trash",
		isEnabled = function(data, entityData)
		if Vehicles ~= nil and Vehicles.Fuel:CanBeFueled(entityData.entity) and Vehicles.Fuel:HasNozzle() then
			return true
		end
		return false
		end,
		textFunc = function(data, entityData)
		if Vehicles ~= nil then
			local fuelData = Vehicles.Fuel:CanBeFueled(entityData.entity)
			if fuelData then
			if fuelData.needsFuel then
				return string.format("Refuel For $%d", fuelData.cost)
			else
				return "Fuel Tank Full"
			end
			end
		end
		return ""
		end,
		event = "Vehicles:Client:StartFueling",
		data = {},
		minDist = 2.0,
	},
	{
		icon = "gas-pump",
		isEnabled = function(data, entityData)
		if Vehicles ~= nil and not GlobalState.IsProduction then
			return true
		end
		return false
		end,
    text = 'Delete Vehicle',
		event = "Vehicles:Client:StartFueling",
		data = {},
		minDist = 2.0,
	},
	{
		icon = "gas-pump",
		isEnabled = function(data, entityData)
		local hasWeapon, weapon = GetCurrentPedWeapon(LocalPlayer.state.ped)
		if Vehicles ~= nil and hasWeapon and weapon == `WEAPON_PETROLCAN` and GetVehicleClass(entityData.entity) ~= 13 then
			return true
		end
		return false
		end,
		text = 'Refuel With Petrol Can',
		event = "Vehicles:Client:StartJerryFueling",
		data = {},
		minDist = 2.0,
	},
	{
		icon = "garage-open",
		isEnabled = function(data, entityData)
		if Vehicles ~= nil and Vehicles:CanBeStored(entityData.entity) then
			return true
		end
		return false
		end,
		text = "Store Vehicle",
		event = "Vehicles:Client:StoreVehicle",
		data = {},
		minDist = 4.0,
	},
	{
		icon = "truck-ramp-box",
		isEnabled = function(data, entityData)
		local vehState = Entity(entityData.entity).state
		return not LocalPlayer.state.isDead
			and vehState.VIN ~= nil
			and not vehState.wasThermited
			and GetEntityHealth(entityData.entity) > 0
			and isNearTrunk(entityData.entity, 4.0)
		end,
		text = "View Trunk",
		event = "Inventory:Client:Trunk",
		data = {},
		minDist = 3.0,
	},
	-- G6 Truck
	{ -- To the workers
		icon = "vault",
		item = "group6_bag",
		isEnabled = function(data, entityData)
		local vehState = Entity(entityData.entity).state
		if not vehState.G6TRUCK then
			return false
		end

		if vehState.G6_HACKED then
			return false
		end

		if vehState.G6_GETTINGHACKED then
			return false
		end

		local serverId = GetPlayerServerId(PlayerId())

		if not vehState.Access or not vehState.Access[serverId] then
			return false
		end

		return not LocalPlayer.state.isDead
			and vehState.VIN ~= nil
			and GetEntityHealth(entityData.entity) > 0
			and IsNearTrunk(entityData.entity, 4.0, false)
		end,
		text = "Deposit the bag",
		event = "Group6:DepositBag",
		data = {},
		minDist = 2.0,
	},
	{ -- Non workers, to crack the safe
		icon = "vault",
		isEnabled = function(data, entityData)
		local vehState = Entity(entityData.entity).state
		if not vehState.G6TRUCK then
			return false
		end

		local serverId = GetPlayerServerId(PlayerId())

		-- #TODO: Remove the comment after test is done
		-- if not vehState.Access or vehState.Access[serverId] then
		-- 	return false
		-- end

		if vehState.G6_HACKED then
			return false
		end

		if vehState.G6_GETTINGHACKED then
			return false
		end

		return not LocalPlayer.state.isDead
			and vehState.VIN ~= nil
			and GetEntityHealth(entityData.entity) > 0
			and IsNearTrunk(entityData.entity, 4.0, false)
		end,
		text = "Crack Safe",
		event = "Group6:CrackSafe",
		data = {},
		minDist = 2.0,
	},
	-- { -- Non workers, to grab the loot if the safe is cracked
	--   icon = "hand",
	--   text = "Grab Loot",
	--   event = "Group6:OpenSafe",
	--   data = {},
	--   minDist = 2.0,
	--   isEnabled = function(data, entity)
	--     local vehState = Entity(entity.entity).state

	--     local serverId = GetPlayerServerId(PlayerId())

	--     if vehState.Access and not vehState.Access[serverId] then
	--       if not vehState.G6_HACKED then
	--         return false
	--       end

	--       if vehState.G6_GETTINGHACKED then
	--         return false
	--       end
	--     elseif vehState.Access and vehState.Access[serverId] then
	--       local jobState = LocalPlayer.state.jobState
	--       if not jobState then return end
	--       if jobState ~= 3 then
	--         return false
	--       end
	--     end


	--     return not LocalPlayer.state.isDead
	--         and vehState.VIN ~= nil
	--         and GetEntityHealth(entity.entity) > 0
	--         and isNearTrunk(entity.entity, 4.0, false)
	--   end
	-- },
	{
		icon = "trash",
		text = "Toss Garbage",
		event = "Garbage:Client:TossBag",
		model = `trash2`,
		tempjob = "Garbage",
		data = {},
		minDist = 4.0,
		isEnabled = function(data, entityData)
		return isNearTrunk(entityData.entity, 4.0, true) and LocalPlayer.state.carryingGarbabge and
			LocalPlayer.state.inGarbagbeZone
		end
	},
	{
		icon = "store",
		isEnabled = function(data, entityData)
		return isNearTrunk(entityData.entity, 4.0, true)
		end,
		text = "Grab Package",
		event = "Deliveries:Client:Grab",
		model = `benson`,
		tempjob = "Deliveries",
		data = {},
		minDist = 4.0,
		isEnabled = function(data, entityData)
		return not LocalPlayer.state.hasDeliveryPackage and LocalPlayer.state.inStoreZone
		end
	},
	{
		icon = "store",
		isEnabled = function(data, entityData)
		return isNearTrunk(entityData.entity, 4.0, true)
		end,
		text = "Grab Letters",
		event = "GoPostal:Client:Grab",
		model = `boxville2`,
		tempjob = "GoPostal",
		data = {},
		minDist = 4.0,
		isEnabled = function(data, entityData)
		return not LocalPlayer.state.hasGoPostPackage and LocalPlayer.state.inHouseZone
		end
	},
	{
		icon = "capsules",
		text = "Handoff Contraband",
		event = "OxyRun:Client:MakeSale",
		item = "contraband",
		data = {},
		minDist = 3.0,
		isEnabled = function(data, entityData)
		return LocalPlayer.state.oxyJoiner ~= nil and LocalPlayer.state.oxyBuyer ~= nil and
			VehToNet(entityData.entity) == LocalPlayer.state.oxyBuyer.veh
		end,
	},
	{
		icon = "lock",
		isEnabled = function(data, entityData)
		local vehState = Entity(entityData.entity).state
		if vehState and vehState.VIN and not vehState.wasThermited and Vehicles ~= nil and Vehicles.Keys:Has(vehState.VIN) then
			return true
		end
		return false
		end,
		text = "Toggle Locks",
		event = "Vehicles:Client:ToggleLocks",
		data = {},
		minDist = 2.5,
	},
	{
		icon = "truck-tow",
		text = "Request Tow",
		event = "Vehicles:Client:RequestTow",
		data = {},
		minDist = 2.0,
		jobPerms = {
		{
			job = 'police',
			reqDuty = true,
		},
		},
		isEnabled = function(data, entityData)
		local vehState = Entity(entityData.entity).state
		if vehState and vehState.towObjective or (GlobalState["Duty:tow"] or 0) == 0 then
			return false
		end
		return true
		end,
	},
	{
		icon = "truck-tow",
		text = "Request Impound",
		event = "Vehicles:Client:RequestImpound",
		data = {},
		minDist = 2.0,
		jobPerms = {
		{
			job = 'police',
			reqDuty = true,
		},
		},
		isEnabled = function(data, entityData)
		local vehState = Entity(entityData.entity).state
		if vehState and vehState.towObjective then
			return false
		end
		return true
		end,
	},
	{
		icon = "fa-bicycle",
		isEnabled = function(data, entityData)
		return GetVehicleClass(entityData.entity) == 13
		end,
		text = "Pick Up Bike",
		event = "Vehicle:Client:PickupBike",
		data = {},
		minDist = 3.0,
	},
	{
		icon = "truck-tow",
		text = "Tow - Impound",
		event = "Tow:Client:RequestImpound",
		data = {},
		minDist = 4.0,
		jobPerms = {
		{
			job = 'tow',
			reqDuty = true,
		},
		},
		isEnabled = function(data, entityData)
		if entityData.entity and DoesEntityExist(entityData.entity) then
			if exports['hrrp-polyzone']:PolyZoneIsCoordsInZone(GetEntityCoords(entityData.entity), 'tow_impound_zone') then
			return true
			end
		end
		return false
		end,
	},

	{
		icon = "print-magnifying-glass",
		isEnabled = function(data, entityData)
		return Vehicles:HasAccess(entityData.entity) and Vehicles.Utils:IsCloseToFrontOfVehicle(entityData.entity) and
			(GetVehicleDoorAngleRatio(entityData.entity, 4) >= 0.1)
		end,
		text = "Inspect VIN",
		event = "Vehicles:Client:InspectVIN",
		data = {},
		minDist = 4.0,
	},
	{
		icon = "screwdriver",
		isEnabled = function(data, entityData)
		if DoesEntityExist(entityData.entity) then
			local vehState = Entity(entityData.entity).state
			if vehState.FakePlate then
			return ((Vehicles:HasAccess(entityData.entity, true)) or LocalPlayer.state.onDuty == "police" and LocalPlayer.state.inPdStation)
				and (
					Vehicles.Utils:IsCloseToRearOfVehicle(entityData.entity)
					or Vehicles.Utils:IsCloseToFrontOfVehicle(entityData.entity)
				)
			end
		end
		return false
		end,
		text = "Remove Plate",
		event = "Vehicles:Client:RemoveFakePlate",
		data = {},
		minDist = 4.0,
	},
	{
		icon = "screwdriver",
		isEnabled = function(data, entityData)
		if DoesEntityExist(entityData.entity) then
			local vehState = Entity(entityData.entity).state
			if vehState.Harness and vehState.Harness > 0 then
			return Vehicles:HasAccess(entityData.entity, true)
			end
		end
		return false
		end,
		text = "Remove Harness",
		event = "Vehicles:Client:RemoveHarness",
		data = {},
		minDist = 4.0,
	},
	{
		icon = "person-seat",
		text = "Seat In Vehicle",
		event = "Escort:Client:PutIn",
		data = {},
		minDist = 4.0,
		isEnabled = function(data, entity)
		if LocalPlayer.state.isEscorting == nil or LocalPlayer.state.isDead or GetVehicleDoorLockStatus(entity.entity) ~= 1 then
			return false
		else
			local vehmodel = GetEntityModel(entity.entity)
			for i = -1, GetVehicleModelNumberOfSeats(vehmodel) do
			if GetPedInVehicleSeat(entity.entity, i) == 0 then
				return true
			end
			end
			return false
		end
		end,
	},
	{
		icon = "person-seat",
		text = "Unseat From Vehicle",
		event = "Escort:Client:PullOut",
		data = {},
		minDist = 4.0,
		isEnabled = function(data, entity)
		if LocalPlayer.state.isEscorting ~= nil or LocalPlayer.state.isDead or GetVehicleDoorLockStatus(entity.entity) ~= 1 then
			return false
		else
			local vehmodel = GetEntityModel(entity.entity)
			for i = -1, GetVehicleModelNumberOfSeats(vehmodel) do
			local p = GetPedInVehicleSeat(entity.entity, i)
			if p ~= 0 and IsPedAPlayer(p) then
				return true
			end
			end
			return false
		end
		end,
	},
	{
		icon = "child",
		text = "Put In Trunk",
		event = "Trunk:Client:PutIn",
		data = {},
		minDist = 4.0,
		isEnabled = function(data, entity)
		return LocalPlayer.state.isEscorting ~= nil
			and not LocalPlayer.state.isDead
			and not LocalPlayer.state.inTrunk
			and isNearTrunk(entity.entity, 4.0, true)
		end,
	},
	{
		icon = "child",
		text = "Pull Out Of Trunk",
		event = "Trunk:Client:PullOut",
		data = {},
		minDist = 4.0,
		isEnabled = function(data, entity)
		return LocalPlayer.state.isEscorting == nil
			and not LocalPlayer.state.isDead
			and not LocalPlayer.state.inTrunk
			and isNearTrunk(entity.entity, 4.0, false)
			and GlobalState[string.format("Trunk:%s", NetworkGetNetworkIdFromEntity(entity.entity))]
			and #GlobalState[string.format("Trunk:%s", NetworkGetNetworkIdFromEntity(entity.entity))] > 0
		end,
	},
	{
		icon = "child",
		text = "Get In Trunk",
		event = "Trunk:Client:GetIn",
		data = {},
		minDist = 4.0,
		jobs = false,
		isEnabled = function(data, entityData)
		return LocalPlayer.state.isEscorting == nil
			and not LocalPlayer.state.isDead
			and not LocalPlayer.state.inTrunk
			and isNearTrunk(entityData.entity, 4.0, true)
		end,
	},
	-- Mechanic
	{
		icon = "toolbox",
		text = "Regular Body & Engine Repair",
		event = "Mechanic:Client:StartRegularRepair",
		data = {},
		isEnabled = function(data, entityData)
		if DoesEntityExist(entityData.entity) and (
				Vehicles.Utils:IsCloseToRearOfVehicle(entityData.entity)
				or Vehicles.Utils:IsCloseToFrontOfVehicle(entityData.entity)
			) and exports['hrrp-mechanic']:CanAccessVehicleAsMechanic(entityData.entity) then
			local engineHealth = GetVehicleEngineHealth(entityData.entity)
			local bodyHealth = GetVehicleBodyHealth(entityData.entity)
			if bodyHealth < 1000 or engineHealth < 900 then
			return true
			end
		end
		return false
		end,
		minDist = 4.0,
	},
	{
		icon = "car-wrench",
		text = "Run Diagnostics",
		event = "Mechanic:Client:RunDiagnostics",
		data = {},
		isEnabled = function(data, entityData)
		if DoesEntityExist(entityData.entity) and (
				Vehicles.Utils:IsCloseToRearOfVehicle(entityData.entity)
				or Vehicles.Utils:IsCloseToFrontOfVehicle(entityData.entity)
			) and exports['hrrp-mechanic']:CanAccessVehicleAsMechanic(entityData.entity) then
			return true
		end
		return false
		end,
		minDist = 4.0,
	},
	{
		icon = "gauge-simple-max",
		text = "Run Performance Diagnostics",
		event = "Mechanic:Client:RunPerformanceDiagnostics",
		data = {},
		isEnabled = function(data, entityData)
		if DoesEntityExist(entityData.entity) and (
				Vehicles.Utils:IsCloseToRearOfVehicle(entityData.entity)
				or Vehicles.Utils:IsCloseToFrontOfVehicle(entityData.entity)
			) and exports['hrrp-mechanic']:CanAccessVehicleAsMechanic(entityData.entity) then
			return true
		end
		return false
		end,
		minDist = 4.0,
	},
	{
		icon = 'car-tilt',
		isEnabled = function(data, entityData)
		if DoesEntityExist(entityData.entity) and (not IsVehicleOnAllWheels(entityData.entity)) then
			return true
		end
		return false
		end,
		text = 'Flip Vehicle',
		event = 'Vehicles:Client:FlipVehicle',
		data = {},
		minDist = 2.0,
		jobs = false
	},
	{
		icon = 'truck-tow',
		isEnabled = function(data, entityData)
		local veh = entityData.entity
		local vehEnt = Entity(veh)
		if DoesEntityExist(veh) and Tow:IsTowTruck(veh) and not vehEnt.state.towingVehicle then
			local rearWheel = GetEntityBoneIndexByName(veh, 'wheel_lr')
			local rearWheelCoords = GetWorldPositionOfEntityBone(veh, rearWheel)
			if #(rearWheelCoords - LocalPlayer.state.myPos) <= 3.0 then
			return true
			end
		end
		return false
		end,
		text = 'Tow - Attach Vehicle',
		event = 'Vehicles:Client:BeginTow',
		data = {},
		minDist = 2.0,
		jobs = false
	},
	{
		icon = 'truck-tow',
		isEnabled = function(data, entityData)
		local veh = entityData.entity
		local vehEnt = Entity(veh)
		if DoesEntityExist(veh) and Tow:IsTowTruck(veh) and vehEnt.state.towingVehicle then
			local rearWheel = GetEntityBoneIndexByName(veh, 'wheel_lr')
			local rearWheelCoords = GetWorldPositionOfEntityBone(veh, rearWheel)
			if #(rearWheelCoords - LocalPlayer.state.myPos) <= 3.0 then
			return true
			end
		end
		return false
		end,
		text = 'Tow - Detach Vehicle',
		event = 'Vehicles:Client:ReleaseTow',
		data = {},
		minDist = 2.0,
		jobs = false
	},
	{
		icon = "rectangle-barcode",
		text = "Run Plate",
		event = "Police:Client:RunPlate",
		data = {},
		minDist = 3.0,
		jobPerms = {
		{
			job = 'police',
			reqDuty = true,
		},
		}
	},
	{
		icon = "anchor",
		isEnabled = function(data, entityData)
		if not LocalPlayer.state.isDead and Entity(entityData.entity).state.VIN ~= nil then
			local vehModel = GetEntityModel(entityData.entity)
			if IsThisModelABoat(vehModel) or IsThisModelAJetski(vehModel) or IsThisModelAnAmphibiousCar(vehModel) or IsThisModelAnAmphibiousQuadbike(vehModel) then
			return true
			end
		end
		end,
		text = "Toggle Anchor",
		event = "Vehicles:Client:AnchorBoat",
		data = {},
		minDist = 5.0,
	},
	{
		icon = "screwdriver-wrench",
		isEnabled = function(data, entity)
		local entState = Entity(entity.entity).state
		return not LocalPlayer.state.isDead and LocalPlayer.state.inChopZone ~= nil and LocalPlayer.state.chopping == nil and not entState.Owned
		end,
		text = "Start Chopping",
		event = "Phone:Client:LSUnderground:Chopping:StartChop",
		data = {},
		minDist = 4.0,
	},
	{
		icon = "clothes-hanger",
		isEnabled = function(data, entity)
		local entState = Entity(entity.entity).state
		local rvModels = { [`cararv`] = true, [`guardianrv`] = true, [`sandroamer`] = true, [`sandkingrv`] = true }
		return (not LocalPlayer.state.isDead) and rvModels[GetEntityModel(entity.entity)] and
			Vehicles:HasAccess(entity.entity)
		end,
		text = "Open Wardrobe",
		event = "Wardrobe:Client:ShowBitch",
		data = {},
		minDist = 2.0,
	},
	{
		icon = "clothes-hanger",
		isEnabled = function(data, entity)
		return not LocalPlayer.state.cornering and not Entity(entity.entity).state.cornering and
			not Config.BlaclistedCornering[GetVehicleClass(entity.entity)]
		end,
		tempjob = "CornerDealing",
		text = "Start Corner Dealing",
		event = "CornerDealing:Client:StartCornering",
		data = {},
		minDist = 2.0,
	},
	{
		icon = "clothes-hanger",
		isEnabled = function(data, entity)
		return LocalPlayer.state.cornering and Entity(entity.entity).state.cornering
		end,
		tempjob = "CornerDealing",
		text = "Stop Corner Dealing",
		event = "CornerDealing:Client:StopCornering",
		data = {},
		minDist = 2.0,
	},
	{
		icon = "hand",
		text = "Grab Loot",
		event = "Robbery:Client:MoneyTruck:GrabLoot",
		model = `stockade`,
		data = {},
		minDist = 4.0,
		isEnabled = function(data, entity)
		local entState = Entity(entity.entity).state
		return isNearTrunk(entity.entity, 4.0, true) and not entState.beingLooted and entState.wasThermited and not entState.wasLooted and
			GetEntityHealth(entity.entity) > 0
		end
	},
	{
		icon = "hand",
		text = "Grab Loot",
		event = "Robbery:Client:MoneyTruck:GrabLoot",
		model = `stockade2`,
		data = {},
		minDist = 4.0,
		isEnabled = function(data, entity)
		local entState = Entity(entity.entity).state
		return isNearTrunk(entity.entity, 4.0, true) and not entState.beingLooted and entState.wasThermited and not entState.wasLooted and
			GetEntityHealth(entity.entity) > 0
		end
	},
	{
		icon = "car-garage",
		isEnabled = function(data, entityData)
		local inZone = exports['hrrp-polyzone']:PolyZoneIsCoordsInZone(GetEntityCoords(entityData.entity), false, 'dealerBuyback')
		if inZone then
			return LocalPlayer.state.onDuty == inZone.dealerId
		end
		end,
		text = "Vehicle Buy Back",
		event = "Dealerships:Client:StartBuyback",
		data = {},
		minDist = 5.0,
		jobPerms = {
		{
			permissionKey = 'dealership_buyback',
		}
		},
	},
  {
		icon = "car-wrench",
		text = "Performance Rating",
		event = "Vehicles:Client:PerfRating",
		data = {},
		isEnabled = function(data, entityData)
      if GlobalState.IsProduction then return false end
		if DoesEntityExist(entityData.entity) and (
				Vehicles.Utils:IsCloseToRearOfVehicle(entityData.entity)
				or Vehicles.Utils:IsCloseToFrontOfVehicle(entityData.entity)
			) then
			return true
		end
		return false
		end,
		minDist = 4.0,
	},
}
	--#endregion
local _globalPlayer = {
{
	icon = "magnifying-glass",
	text = "Search",
	event = "Police:Client:Search",
	data = {},
	minDist = 3.0,
	jobPerms = {
		{
		job = 'police',
		reqDuty = true,
		},
	}
	},
	{
	icon = "gun",
	text = "GSR Test",
	event = "Police:Client:GSR",
	data = {},
	minDist = 3.0,
	jobPerms = {
		{
		job = 'police',
		reqDuty = true,
		},
	}
	},
	{
	icon = "beer-mug",
	text = "BAC Test",
	event = "Police:Client:BAC",
	data = {},
	minDist = 3.0,
	jobPerms = {
		{
		job = 'police',
		reqDuty = true,
		},
		{
		job = 'ems',
		reqDuty = true,
		},
	}
	},
	{
	icon = "dna",
	text = "Take DNA Swab",
	event = "Police:Client:DNASwab",
	data = {},
	minDist = 3.0,
	jobPerms = {
		{
		job = 'police',
		reqDuty = true,
		},
		{
		job = 'ems',
		reqDuty = true,
		},
	}
	},
	{
	icon = "capsules",
	text = "Perform Drug Test",
	event = "EMS:Client:DrugTest",
	data = {},
	minDist = 3.0,
	jobPerms = {
		{
		job = 'ems',
		reqDuty = true,
		},
	}
	},
	{
	icon = "gun",
	text = "Rob",
	event = "Robbery:Client:Holdup:Do",
	data = {},
	minDist = 3.0,
	isEnabled = function(data, target)
		local playerState = Player(target.serverId).state
		return (not LocalPlayer.state.onDuty or (LocalPlayer.state.onDuty ~= "police" and LocalPlayer.state.onDuty ~= "ems"))
			and (playerState.isDead
			or playerState.isCuffed
			or IsEntityPlayingAnim(
				GetPlayerPed(GetPlayerFromServerId(target.serverId)),
				"missminuteman_1ig_2",
				"handsup_base",
				3
			))
	end,
	},
	{
	icon = "link",
	text = "Cuff",
	event = "Handcuffs:Client:SoftCuff",
	data = {},
	minDist = 1.5,
	anyItems = {
		{ item = "pdhandcuffs",     count = 1 },
		{ item = "handcuffs",       count = 1 },
		{ item = "fluffyhandcuffs", count = 1 },
	},
	isEnabled = function(data, target)
		return not Player(target.serverId).state.isCuffed
	end,
	},
	{
	icon = "link-slash",
	text = "Uncuff",
	event = "Handcuffs:Client:Uncuff",
	data = {},
	minDist = 1.5,
	anyItems = {
		{ item = "pdhandcuffs",     count = 1 },
		{ item = "handcuffs",       count = 1 },
		{ item = "fluffyhandcuffs", count = 1 },
	},
	isEnabled = function(data, target)
		return Player(target.serverId).state.isCuffed
	end,
	},
	{
	icon = "person-walking",
	text = "Uncuff Ankles",
	event = "Handcuffs:Client:SoftCuff",
	data = {},
	minDist = 1.5,
	anyItems = {
		{ item = "pdhandcuffs",     count = 1 },
		{ item = "handcuffs",       count = 1 },
		{ item = "fluffyhandcuffs", count = 1 },
	},
	isEnabled = function(data, target)
		local playerState = Player(target.serverId)
		return playerState.state.isCuffed and playerState.state.isHardCuffed
	end,
	},
	{
	icon = "money-bill",
	text = "Give Cash",
	event = "Ped:Client:GiveCash",
	data = {},
	minDist = 2.0,
	isEnabled = function(data, target)
		return not isCuffed and not isDead
	end,
	},
	{
	icon = "person-walking",
	text = "Cuff Ankles",
	event = "Handcuffs:Client:HardCuff",
	data = {},
	minDist = 1.5,
	anyItems = {
		{ item = "pdhandcuffs",     count = 1 },
		{ item = "handcuffs",       count = 1 },
		{ item = "fluffyhandcuffs", count = 1 },
	},
	isEnabled = function(data, target)
		local playerState = Player(target.serverId)
		return playerState.state.isCuffed and not playerState.state.isHardCuffed
	end,
	},
	{
	icon = "hockey-mask",
	text = "Remove Mask",
	event = "Police:Client:RemoveMask",
	data = {},
	minDist = 1.5,
	jobPerms = {
		{
		job = 'police',
		reqDuty = true,
		},
		{
		job = 'ems',
		reqDuty = true,
		}
	},
	isEnabled = function(data, target)
		return GetPedDrawableVariation(target.entity, 1) ~= -1 and GetPedDrawableVariation(target.entity, 1) ~= 0
	end,
	},
	{
	icon = "face-head-bandage",
	text = "Evaluate",
	event = "EMS:Client:Evaluate",
	minDist = 3.0,
	jobPerms = {
		{
		job = 'police',
		reqDuty = true,
		},
		{
		job = 'ems',
		reqDuty = true,
		},
	}
	},
	{
	icon = "hood-cloak",
	text = "Remove Blindfold",
	event = "HUD:Client:RemoveBlindfold",
	minDist = 3.0,
	isEnabled = function(data, target)
		local playerState = Player(target.serverId)
		return playerState.state.isBlindfolded
	end,
	},
}

function trunkOffset(ent)
	local min, max = GetModelDimensions(GetEntityModel(ent))
	return GetOffsetFromEntityInWorldCoords(ent, 0.0, min.y - 0.5, 0.0)
end

function isNearTrunk(ent, dist, open)
	return #(trunkOffset(ent) - GetEntityCoords(playerPed)) <= (dist or 1.0)
		and GetVehicleDoorLockStatus(ent) == 1
		and (not open or GetVehicleDoorAngleRatio(ent, 5) >= 0.1)
end

local setupEvent = nil
setupEvent = AddEventHandler('Proxy:Shared:RegisterReady', function()
    api.removeTargetsByProperty({ key = "hrrptarget", value = true })
    api.removeGlobalsByProperty({ key = "hrrptarget", value = true })
    api.removeZonesByProperty({ key = "hrrptarget", value = true })


    _TARGETING:AddGlobalPed(nil, _globalPeds, nil)
    _TARGETING:AddGlobalVehicle(nil, _globalVehicle, nil)
    _TARGETING:AddGlobalPlayer(nil, _globalPlayer, nil)
    RemoveEventHandler(setupEvent)
end)

RegisterNetEvent("Ped:Client:GiveCash", function(_, menuData)
	menuData.serverId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(_.entity))
    Input:Show("Give Cash", "How much cash do you want to hand over?", {
        {
            id = "amount",
            type = "number",
            options = {
                inputProps = {
                    maxLength = 10,
                },
            }
        },
    }, "Ped:Client:SendCash", menuData)
end)

RegisterNetEvent("Ped:Client:SendCash", function(cashData, menuData)
    local amountOfMoney = tonumber(cashData.amount)

    if not amountOfMoney then return end
    if amountOfMoney <= 0 then return end

    TriggerServerEvent("Ped:Server:SendCash", amountOfMoney, menuData.serverId)
end)

local function exportHandler(exportName, func)
  AddEventHandler(('__cfx_export_%s_%s'):format(GetCurrentResourceName(), exportName), function(setCB)
    setCB(function(...)
      return func(_TARGETING, ...)
    end)
  end)
end

local function createExportForObject(object, name)
  name = name or ""
  for k, v in pairs(object) do
    if type(v) == "function" then
      exportHandler(name .. k, v)
    elseif type(v) == "table" then
      createExportForObject(v, name .. k)
    end
  end
end

for k, v in pairs(_TARGETING) do
  if type(v) == "function" then
    exportHandler("Targeting" .. k, v)
  elseif type(v) == "table" then
    createExportForObject(v, "Targeting" .. k)
  end
end
