DRIVING_VEHICLE, VEHICLE_INSIDE = nil, nil

local _fueling = false
local _lowtick = 0
local _engineShutoff = false
local _Prop = 0
_hasNozzle = false

local pumpModels = {
  `prop_gas_pump_1a`,
  `prop_gas_pump_1b`,
  `prop_gas_pump_1c`,
  `prop_gas_pump_1d`,
  `prop_vintage_pump`,
  `prop_gas_pump_old2`,
  `prop_gas_pump_old3`,
}

AddEventHandler("Vehicles:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Callbacks = exports["hrrp-base"]:FetchComponent("Callbacks")
  Notification = exports["hrrp-base"]:FetchComponent("Notification")
  Action = exports["hrrp-base"]:FetchComponent("Action")
  Vehicles = exports["hrrp-base"]:FetchComponent("Vehicles")
  Progress = exports["hrrp-base"]:FetchComponent("Progress")
  Polyzone = exports["hrrp-base"]:FetchComponent("Polyzone")
  Utils = exports["hrrp-base"]:FetchComponent("Utils")
  Blips = exports["hrrp-base"]:FetchComponent("Blips")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports["hrrp-base"]:RequestDependencies("Vehicles", {
    "Callbacks",
    "Notification",
    "Action",
    "Vehicles",
    "Utils",
    "Progress",
    "Polyzone",
    "Blips",
  }, function(error)
    if #error > 0 then
      return
    end
    RetrieveComponents()
    CreateFuelStationPolyzones()


    SetFuelConsumptionState(true)

    print('Are we running?', GetFuelConsumptionState())

    for k, v in ipairs(pumpModels) do
      exports['ox_target']:TargetingAddObject(v, "gas-pump", {
        {
          text = "Refill Petrol Can",
          icon = "gas-pump",
          textFunc = function()
            local current = GetAmmoInPedWeapon(LocalPlayer.state.ped, `WEAPON_PETROLCAN`)
            local pct = current / 4500
            return string.format(
              "Refill Petrol Can ($%s)",
              math.ceil(CalculateFuelCost(0, math.floor(100 - (pct * 100))))
            )
          end,
          event = "Fuel:Client:FillCan",
          minDist = 3.0,
          isEnabled = function()
            local isArmed, hash = GetCurrentPedWeapon(LocalPlayer.state.ped)
            local current = GetAmmoInPedWeapon(LocalPlayer.state.ped, `WEAPON_PETROLCAN`)
            local pct = current / 4500
            local cost = math.ceil(CalculateFuelCost(0, math.floor(100 - (pct * 100))))
            return (
              isArmed
              and hash == `WEAPON_PETROLCAN`
              and GetAmmoInPedWeapon(LocalPlayer.state.ped, `WEAPON_PETROLCAN`) < 4500
              and LocalPlayer.state.Character:GetData("Cash") >= cost
            )
          end,
        },
        {
          text = "Grab Nozzle",
          icon = "hand",
          minDist = 3.0,
          event = 'Fuel:Client:GrabNozzle',
          isEnabled = function()
            return not _hasNozzle
          end
        },
        {
          text = "Return Nozzle",
          icon = "backward",
          minDist = 3.0,
          event = 'Fuel:Client:ReturnNozzle',
          isEnabled = function()
            return _hasNozzle
          end
        },
      }, 3.0)
    end

    RemoveEventHandler(setupEvent)
  end)
end)

function CreateFuelStationPolyzones()
  for k, v in ipairs(Config.FuelStations) do
    exports['hrrp-polyzone']:PolyZoneCreateBox("fuel_" .. k, v.center, v.length, v.width, {
      heading = v.heading,
      minZ = v.minZ,
      maxZ = v.maxZ,
    }, {
      fuel = true,
      restricted = v.restricted,
      id = k,
    })
  end
end

AddEventHandler("Characters:Client:Spawn", function()
  -- Adding them on the map looks to dumb
  -- for k, v in ipairs(Config.FuelStations) do
  -- 	if not v.restricted then
  -- 		exports['hrrp-blips']:Add('fuel-station-'.. k, 'Fuel Station', v.center, 361, 64, 0.4)
  -- 	end
  -- end
end)

AddEventHandler('Fuel:Client:GrabNozzle', function()
  _hasNozzle = true

  _Prop = CreateObject(GetHashKey("prop_cs_fuel_nozle"), 0, 0, 0, true, true, true)
  AttachEntityToEntity(_Prop, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0xDEAD), 0.13, 0.04, -0.03, 80.0, 100.0, 190.0, true, true, false, true, 1, true)
end)

AddEventHandler('Fuel:Client:ReturnNozzle', function()
  _hasNozzle = false
  if DoesEntityExist(_Prop) then
    DeleteEntity(_Prop)
    _Prop = 0
  end
end)

AddEventHandler("Fuel:Client:FillCan", function()
  local current = GetAmmoInPedWeapon(LocalPlayer.state.ped, `WEAPON_PETROLCAN`)
  local pct = current / 4500

  Progress:Progress({
    name = "fill_petrol_can",
    duration = math.min(math.ceil(10 - (10 * pct)), 2) * 10000,
    label = "Filling Petrol Can",
    canCancel = true,
    disarm = false,
    controlDisables = {
      disableMovement = true,
      disableCarMovement = true,
      disableMouse = false,
      disableCombat = true,
    },
    animation = nil,
  }, function(cancelled)
    if not cancelled then
      exports["hrrp-base"]:CallbacksServer("Fuel:FillCan", {
        current = current,
        pct = pct,
      }, function(s)
        if s then
          SetPedAmmo(LocalPlayer.state.ped, `WEAPON_PETROLCAN`, 5000)
        end
      end)
    end
  end)
end)

RegisterNetEvent("Characters:Client:Logout", function()
  DRIVING_VEHICLE = nil
  VEHICLE_INSIDE = nil
end)

AddEventHandler("Vehicles:Client:BecameDriver", function(veh, seat, class)
  DRIVING_VEHICLE = veh

  local myFuelLevel = GetVehicleFuelLevel(DRIVING_VEHICLE)
  local vehEntity = Entity(DRIVING_VEHICLE)

  local maxFuelCapacity = GetVehicleHandlingFloat(veh, "CHandlingData", "fPetrolTankVolume")
  if not vehEntity.state.Fuel then
    vehEntity.state:set("Fuel", math.random(1, maxFuelCapacity) + 0.0, true)
  else
    print("Setting Fuel Level", vehEntity.state.Fuel)
    if vehEntity.state.Fuel > maxFuelCapacity then
      myFuelLevel = maxFuelCapacity
      vehEntity.state:set("Fuel", maxFuelCapacity, true)
    end
    SetVehicleFuelLevel(DRIVING_VEHICLE, myFuelLevel)
  end


  local vehState = Entity(veh).state
  if vehState.VIN and vehState.Fuel ~= nil and class ~= 13 then
    TriggerEvent("Vehicles:Client:Fuel", {
      fuelLevel = vehState.Fuel,
      fuelTankCapacity = GetVehicleHandlingFloat(veh, "CHandlingData", "fPetrolTankVolume"),
    }, false)
    Citizen.CreateThread(function()
      while LocalPlayer.state.loggedIn and DRIVING_VEHICLE do
        if GetPedInVehicleSeat(DRIVING_VEHICLE, -1) == LocalPlayer.state.ped then
          RunFuelTick(DRIVING_VEHICLE)
        end
        Citizen.Wait(3000)
      end
    end)
  else
    TriggerEvent("Vehicles:Client:Fuel", {
      fuelLevel = myFuelLevel,
      fuelTankCapacity = GetVehicleHandlingFloat(veh, "CHandlingData", "fPetrolTankVolume"),
    }, true)
  end
end)

AddEventHandler("Vehicles:Client:EnterVehicle", function(veh)
  VEHICLE_INSIDE = veh
  local myFuelLevel = GetVehicleFuelLevel(VEHICLE_INSIDE)
  local vehEntity = Entity(VEHICLE_INSIDE)

  local maxFuelCapacity = GetVehicleHandlingFloat(veh, "CHandlingData", "fPetrolTankVolume")
  if not vehEntity.state.Fuel then
    vehEntity.state:set("Fuel", math.random(1, maxFuelCapacity) + 0.0, true)
  else
    print("Setting Fuel Level", vehEntity.state.Fuel)
    if vehEntity.state.Fuel > maxFuelCapacity then
      myFuelLevel = maxFuelCapacity
      vehEntity.state:set("Fuel", maxFuelCapacity, true)
    end
    SetVehicleFuelLevel(DRIVING_VEHICLE, myFuelLevel)
  end

  Citizen.CreateThread(function()
    Citizen.Wait(500)
    while VEHICLE_INSIDE and not DRIVING_VEHICLE do
      if DoesEntityExist(VEHICLE_INSIDE) then
        if vehEntity and vehEntity.state and type(vehEntity.state.Fuel) == "number" then
          TriggerEvent("Vehicles:Client:Fuel", {
            fuelLevel = myFuelLevel,
            fuelTankCapacity = GetVehicleHandlingFloat(veh, "CHandlingData", "fPetrolTankVolume"),
          })
        end
      end
      Citizen.Wait(3000)
    end
  end)
end)

AddEventHandler("Vehicles:Client:ExitVehicle", function()
  DRIVING_VEHICLE = nil
  VEHICLE_INSIDE = nil
end)

AddEventHandler("Vehicles:Client:SwitchVehicleSeat", function(veh, seat)
  if seat ~= -1 then
    DRIVING_VEHICLE = nil
  end
end)

function RunFuelTick(veh)
  if veh and IsVehicleEngineOn(veh) then
    local vehState = Entity(veh).state

    local myFuelLevel = GetVehicleFuelLevel(veh)

    if myFuelLevel <= 0.0 then
      myFuelLevel = 0.0
      Vehicles.Engine:Force(veh, false)
    elseif myFuelLevel <= 5.0 then
      if _lowtick >= 3 then
        _lowtick = 0
        LowFuelEffects(veh)
      else
        _lowtick = _lowtick + 1
      end
    end

    TriggerEvent("Vehicles:Client:Fuel", {
      fuelLevel = myFuelLevel,
      fuelTankCapacity = GetVehicleHandlingFloat(veh, "CHandlingData", "fPetrolTankVolume"),
    })
    vehState:set("Fuel", myFuelLevel, true)
  end
end

function LowFuelEffects(veh)
  if _engineShutoff then
    return
  end

  _engineShutoff = true
  Citizen.SetTimeout(2000, function()
    _engineShutoff = false
  end)

  Citizen.CreateThread(function()
    while _engineShutoff do
      SetVehicleEngineOn(veh, false, true)
      Citizen.Wait(1)
    end
  end)
end

AddEventHandler("Vehicles:Client:StartFueling", function(entityData)
  local fuelData = Vehicles.Fuel:CanBeFueled(entityData.entity)
  if not fuelData then
    return
  end

  if not fuelData.needsFuel then
    exports['hrrp-hud']:NotificationError("Vehicle Does Not Need Refueling")
    return
  end

  if LocalPlayer.state.Character:GetData("Cash") < fuelData.cost then
    exports['hrrp-hud']:NotificationError("Not Enough Cash to Refuel")
    return
  end

  local secondsElapsed = 0
  local time = math.min(math.ceil(fuelData.requiredFuel / 2), 40)

  Progress:ProgressWithStartAndTick({
    name = "idle",
    duration = time * 1000,
    label = "Refueling Vehicle",
    canCancel = true,
    tickrate = 1000,
    ignoreModifier = true,
    controlDisables = {
      disableMovement = true,
      disableCarMovement = true,
      disableMouse = false,
      disableCombat = true,
    },
    animation = {
      animDict = "anim@heists@keycard@",
      anim = "idle_a",
      flags = 50,
    },
    disarm = true,
  }, function()
    _fueling = true
  end, function()
    secondsElapsed = secondsElapsed + 1

    local playerCoords = GetEntityCoords(LocalPlayer.state.ped)
    local vehicleCoords = GetEntityCoords(entityData.entity)
    if
        not LocalPlayer.state.loggedIn
        or not DoesEntityExist(entityData.entity)
        or IsEntityDead(entityData.entity)
        or #(playerCoords - vehicleCoords) > 5.0
    then
      Progress:Cancel()
      return
    end

    if GetIsVehicleEngineRunning(entityData.entity) then
      math.randomseed(GetGameTimer())
      local chance = math.random(0, 200)
      if chance == 69 then
        local _fuelFires = {}
        table.insert(_fuelFires, StartScriptFire(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, 25, true))

        for i = 1, 5, 1 do
          local offsetX = math.random(-5, 5) + 0.0
          local offsetY = math.random(-5, 5) + 0.0
          local fireCoords = GetOffsetFromEntityInWorldCoords(nearPump, offsetX, offsetY, 0)
          table.insert(_fuelFires, StartScriptFire(fireCoords.x, fireCoords.y, fireCoords.z, 25, true))
        end

        -- For Good Measure 🙂
        if NetworkHasControlOfEntity(entityData.entity) then
          NetworkExplodeVehicle(entityData.entity, true, true, true)
        end

        exports['hrrp-hud']:NotificationInfo("Nice One Champ")

        Citizen.SetTimeout(60000, function()
          for k, v in ipairs(_fuelFires) do
            RemoveScriptFire(v)
          end
          _fuelFires = nil
        end)

        Progress:Cancel()
        return
      end
    end
  end, function(wasCancelled)
    _fueling = false
    local fuelAmount = fuelData.requiredFuel
    if wasCancelled then
      fuelAmount = math.ceil(fuelData.requiredFuel * (secondsElapsed / time))
    end

    exports["hrrp-base"]:CallbacksServer("Fuel:CompleteFueling", {
      vehNet = VehToNet(entityData.entity),
      vehClass = GetVehicleClass(entityData.entity),
      fuelAmount = fuelAmount,
    }, function(success, amount)
      if success and amount then
        exports['hrrp-hud']:NotificationSuccess(string.format("Refueled Vehicle for $%d", amount))
        SetVehicleFuelLevel(entityData.entity, GetVehicleFuelLevel(entityData.entity) + fuelAmount)
      else
        exports['hrrp-hud']:NotificationSuccess("Error Refueling")
      end
    end)
  end)
end)

AddEventHandler("Vehicles:Client:StartJerryFueling", function(entityData)
  local vehicle = entityData.entity
  if DoesEntityExist(vehicle) and GetVehicleClass(vehicle) ~= 13 then
    local vehState = Entity(vehicle).state
    if vehState.VIN and vehState.Fuel ~= nil then
      local requiredFuel = 100 - vehState.Fuel
      if requiredFuel and requiredFuel > 1 then
        local secondsElapsed = 0

        local hasWeapon, weapon = GetCurrentPedWeapon(LocalPlayer.state.ped)
        local ammoAmount = GetPedAmmoByType(LocalPlayer.state.ped, `AMMO_PETROLCAN`)
        local fuelAmount = 50 * ammoAmount / 4500
        local fuck = fuelAmount
        local fuelAmountAfterUse = 0

        if not hasWeapon or weapon ~= `WEAPON_PETROLCAN` then
          return
        end

        if fuelAmount <= 0 then
          return exports['hrrp-hud']:NotificationError("The Petrol Can Is Empty")
        end

        if requiredFuel < fuelAmount then
          fuelAmount = requiredFuel
          fuelAmountAfterUse = math.floor(fuelAmount - requiredFuel)
        end

        local time = math.ceil(fuelAmount / 2)

        Progress:ProgressWithStartAndTick({
          name = "idle",
          duration = time * 1000,
          label = "Refueling Vehicle",
          canCancel = true,
          tickrate = 1000,
          ignoreModifier = true,
          controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
          },
          animation = {
            animDict = "weapons@misc@jerrycan@",
            anim = "fire",
            flags = 49,
          },
          -- prop = {
          -- 	model = "prop_jerrycan_01a",
          -- 	bone = 60309,
          -- 	coords = { x = 0.0, y = 0.1, z = 0.5 },
          -- 	rotation = { x = 364.0, y = 180.0, z = 90.0 },
          -- },
          disarm = false,
        }, function()
          _fueling = true
        end, function()
          secondsElapsed = secondsElapsed + 1

          local playerCoords = GetEntityCoords(LocalPlayer.state.ped)
          local vehicleCoords = GetEntityCoords(entityData.entity)

          local hasWeapon, weapon = GetCurrentPedWeapon(LocalPlayer.state.ped)

          if
              not LocalPlayer.state.loggedIn
              or not hasWeapon
              or weapon ~= `WEAPON_PETROLCAN`
              or not DoesEntityExist(entityData.entity)
              or IsEntityDead(entityData.entity)
              or #(playerCoords - vehicleCoords) > 5.0
          then
            Progress:Cancel()
            return
          end

          if GetIsVehicleEngineRunning(entityData.entity) then
            math.randomseed(GetGameTimer())
            local chance = math.random(0, 200)
            if chance == 69 then
              local _fuelFires = {}
              table.insert(
                _fuelFires,
                StartScriptFire(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, 25, true)
              )

              for i = 1, 5, 1 do
                local offsetX = math.random(-5, 5) + 0.0
                local offsetY = math.random(-5, 5) + 0.0
                local fireCoords = GetOffsetFromEntityInWorldCoords(nearPump, offsetX, offsetY, 0)
                table.insert(
                  _fuelFires,
                  StartScriptFire(fireCoords.x, fireCoords.y, fireCoords.z, 25, true)
                )
              end

              -- For Good Measure 🙂
              if NetworkHasControlOfEntity(entityData.entity) then
                NetworkExplodeVehicle(entityData.entity, true, true, true)
              end

              exports['hrrp-hud']:NotificationInfo("Nice One Champ")

              Citizen.SetTimeout(60000, function()
                for k, v in ipairs(_fuelFires) do
                  RemoveScriptFire(v)
                end
                _fuelFires = nil
              end)

              Progress:Cancel()
              return
            end
          end
        end, function(wasCancelled)
          _fueling = false
          if wasCancelled then
            fuelAmount = math.ceil(fuelAmount * (secondsElapsed / time))
            fuelAmountAfterUse = math.floor(fuck - fuelAmount)
          end

          SetPedAmmoByType(LocalPlayer.state.ped, `AMMO_PETROLCAN`, (fuelAmountAfterUse / 50 * 4500))

          exports["hrrp-base"]:CallbacksServer("Fuel:CompleteJerryFueling", {
            vehNet = VehToNet(entityData.entity),
            newAmount = math.floor(vehState.Fuel + fuelAmount + 0.0),
          }, function(success)
            if success then
              exports['hrrp-hud']:NotificationSuccess("Refueled Vehicle")
            else
              exports['hrrp-hud']:NotificationError("Error Refueling")
            end
          end)
        end)
      else
        exports['hrrp-hud']:NotificationError("Vehicle Does Not Need Refueling")
      end
    end
  end
end)

-- TODO: Add Fuel Can

RegisterNetEvent('Polyzone:Exit', function(zone)
  if string.find(zone, 'fuel_') then
    if _hasNozzle then
      _hasNozzle = false
      if DoesEntityExist(_Prop) then
        DeleteEntity(_Prop)
        _Prop = 0
      end
    end
  end
end)