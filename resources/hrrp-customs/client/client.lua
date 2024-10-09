_characterLoaded, GLOBAL_PED = false, nil

DRIVING_VEHICLE = nil
DRIVING_VEHICLE_CLASS = nil

CUSTOMS_OPEN = false

local withinCustoms = false
local withinCustomsType = 0
local showingAction = false

AddEventHandler('VehicleCustoms:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
  Callbacks = exports['hrrp-base']:FetchComponent('Callbacks')
  Notification = exports['hrrp-base']:FetchComponent('Notification')
  Game = exports['hrrp-base']:FetchComponent('Game')
  Action = exports['hrrp-base']:FetchComponent('Action')
  Progress = exports['hrrp-base']:FetchComponent('Progress')
  Vehicles = exports['hrrp-base']:FetchComponent('Vehicles')
  Blips = exports['hrrp-base']:FetchComponent('Blips')
  Menu = exports['hrrp-base']:FetchComponent('Menu')
  Utils = exports['hrrp-base']:FetchComponent('Utils')
  Logger = exports['hrrp-base']:FetchComponent('Logger')
  Keybinds = exports['hrrp-base']:FetchComponent('Keybinds')
  Polyzone = exports['hrrp-base']:FetchComponent('Polyzone')
  PedInteraction = exports['hrrp-base']:FetchComponent('PedInteraction')
  ListMenu = exports['hrrp-base']:FetchComponent('ListMenu')
  UISounds = exports['hrrp-base']:FetchComponent('UISounds')
  Police = exports['hrrp-base']:FetchComponent('Police')
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['hrrp-base']:RequestDependencies('VehicleCustoms', {
    'Callbacks',
    'Notification',
    'Game',
    'Action',
    'Progress',
    'Vehicles',
    'Blips',
    'Menu',
    'Utils',
    'Logger',
    'Keybinds',
    'Polyzone',
    'PedInteraction',
    'ListMenu',
    'UISounds',
    'Police',
  }, function(error)
    if #error > 0 then return; end
    RetrieveComponents()

    CreateCustomsZones()
    RemoveEventHandler(setupEvent)
  end)
end)

RegisterNetEvent("Characters:Client:Spawn")
AddEventHandler("Characters:Client:Spawn", function()
  _characterLoaded = true

  Citizen.CreateThread(function()
    while _characterLoaded do
      GLOBAL_PED = PlayerPedId()
      Citizen.Wait(2500)
    end
  end)

  for k, v in ipairs(_customsLocations) do
    if v.blip then
      if v.aircraft then
        exports['hrrp-blips']:Add('veh_customs_' .. k, 'Aircraft Vehicle Customs', v.blip, 643, 34, 0.6)
      else
        exports['hrrp-blips']:Add('veh_customs_' .. k, 'Vehicle Customs', v.blip, 643, 12, 0.6)
      end
    end
  end
end)

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
  _characterLoaded = false

  if withinCustoms then
    ForceCloseVehicleCustoms()
  end
end)

AddEventHandler('Vehicles:Client:BecameDriver', function(veh, seat, class)
  DRIVING_VEHICLE = veh
  DRIVING_VEHICLE_CLASS = class
end)

AddEventHandler('Vehicles:Client:SwitchVehicleSeat', function(veh, seat)
  if seat ~= -1 then
    DRIVING_VEHICLE = nil
    DRIVING_VEHICLE_CLASS = nil

    if withinCustoms then
      ForceCloseVehicleCustoms()
    end
  end
end)

AddEventHandler('Vehicles:Client:ExitVehicle', function()
  DRIVING_VEHICLE = nil
  DRIVING_VEHICLE_CLASS = nil

  if withinCustoms then
    ForceCloseVehicleCustoms()
  end
end)

function CreateCustomsZones()
  for k, v in ipairs(_customsLocations) do
    local data = {
      veh_customs_id = k,
      veh_customs_wheels = v.fitment,
    }

    if v.zone and v.zone.type == 'poly' and v.zone.points then
      exports['hrrp-polyzone']:PolyZoneCreatePoly('veh_customs_' .. k, v.zone.points, {
        minZ = v.zone.minZ,
        maxZ = v.zone.maxZ,
      }, data)
    elseif v.zone and v.zone.type == 'box' and v.zone.center and v.zone.length and v.zone.width then
      exports['hrrp-polyzone']:PolyZoneCreateBox('veh_customs_' .. k, v.zone.center, v.zone.length, v.zone.width, {
        heading = v.zone.heading,
        minZ = v.zone.minZ,
        maxZ = v.zone.maxZ,
      }, data)
    end
  end
end

AddEventHandler('Polyzone:Enter', function(id, point, insideZone, data)
  if data.veh_customs_id then
    withinCustoms = data.veh_customs_id
    withinCustomsType = _customsLocations[withinCustoms].type
    if DRIVING_VEHICLE then
      local locationData = _customsLocations[withinCustoms]
      if locationData then
        if CheckClassRestriction(DRIVING_VEHICLE_CLASS, locationData.restrictClass) then
          showingAction = true
          if withinCustomsType == 0 then
            exports['hrrp-hud']:ActionShow('{keybind}primary_action{/keybind} Customize Vehicle')
          elseif withinCustomsType == 1 then
            exports['hrrp-hud']:ActionShow('{keybind}primary_action{/keybind} Repair Vehicle')
          end
        end
      end
    end
  end
end)

AddEventHandler('Polyzone:Exit', function(id, point, insideZone, data)
  if withinCustoms and data and data.veh_customs_id then
    withinCustoms = false
    ForceCloseVehicleCustoms()
    if showingAction then
      exports['hrrp-hud']:ActionHide()
      showingAction = false
    end
  end
end)

AddEventHandler('Keybinds:Client:KeyUp:primary_action', function()
  if withinCustoms and DRIVING_VEHICLE and not LocalPlayer.state.doingAction then
    local locationData = _customsLocations[withinCustoms]
    if locationData then
      if not CheckClassRestriction(DRIVING_VEHICLE_CLASS, locationData.restrictClass) then
        return
      end

      local vehEnt = Entity(DRIVING_VEHICLE)
      if not vehEnt or not vehEnt.state.VIN then
        return
      end

      if not CheckJobRestriction(locationData.restrictJobs) then
        exports['hrrp-hud']:NotificationError('Authorized Vehicles & Personnel Only')
        return
      end

      if Police:IsPdCar(DRIVING_VEHICLE) and LocalPlayer.state.onDuty ~= "police" then
        exports['hrrp-hud']:NotificationError('Authorized Vehicles & Personnel Only')
        return
      end
    end

    local cash = LocalPlayer.state.Character:GetData('Cash')
    local engineHealth = GetVehicleEngineHealth(DRIVING_VEHICLE)
    local bodyHealth = GetVehicleBodyHealth(DRIVING_VEHICLE)

    local cost = math.ceil((800 - bodyHealth) + (1000 - engineHealth))

    if cost < 150 then
      cost = 150
    end

    if Police:IsPdCar(DRIVING_VEHICLE) and LocalPlayer.state.onDuty == "police" then
      cost = 0
    end

    local enoughCash = (cash >= cost)

    if withinCustomsType == 0 then
      if bodyHealth < 1000 or engineHealth < 1000 then
        ListMenu:Show({
          main = {
            label = 'Customs - Repair Required',
            items = {
              {
                label = 'Pay $' .. cost .. ' for Repairs & Continue',
                description = enoughCash and ('Pay $' .. cost .. ' For Repairs') or ('Not Enough Cash - You Need $' .. cost),
                disabled = not enoughCash,
                event = 'Vehicles:Client:OpenVehicleCustoms',
                data = { cost = cost, customs = true }
              },
            }
          }
        })
      else
        StartOpeningVehicleCustoms()
      end
    elseif withinCustomsType == 1 then
      if bodyHealth < 1000 or engineHealth < 1000 then
        ListMenu:Show({
          main = {
            label = 'Repair Shop',
            items = {
              {
                label = 'Pay $' .. cost .. ' for Repairs',
                description = (not enoughCash and ('Not Enough Cash - You Need $' .. cost) or false),
                disabled = not enoughCash,
                event = 'Vehicles:Client:OpenVehicleCustoms',
                data = { cost = cost, customs = false }
              },
            }
          }
        })
      else
        exports['hrrp-hud']:NotificationError('Vehicle Doesn\'t Need Repairs')
      end
    end
  end
end)

AddEventHandler('Vehicles:Client:OpenVehicleCustoms', function(data)
  if not data or not data.cost then return; end
  -- TODO: Do Repair Cash Payment & Check Success
  DoSlowVehicleNormalRepair(data.cost, function(s)
    if s then
      exports['hrrp-hud']:NotificationSuccess('Repaired Vehicle For $' .. data.cost)
      if data.customs then
        StartOpeningVehicleCustoms()
      end
    end
  end)
end)

function StartOpeningVehicleCustoms()
  if withinCustoms and DRIVING_VEHICLE then
    local vehEnt = Entity(DRIVING_VEHICLE)
    if vehEnt and vehEnt.state.VIN then
      if Vehicles.Keys:Has(vehEnt.state.VIN, vehEnt.state.GroupKeys) then
        OpenVehicleCustoms(_customsLocations[withinCustoms] and _customsLocations[withinCustoms].canInstallPerformance,
          _customsLocations[withinCustoms] and _customsLocations[withinCustoms].costMultiplier or 1.0,
          _customsLocations[withinCustoms] and _customsLocations[withinCustoms].settings or {})
      else
        exports['hrrp-hud']:NotificationError('Cannot Modify a Vehicle That You Don\'t Have Keys For')
      end
    else
      exports['hrrp-hud']:NotificationError('Error')
    end
  end
end

AddEventHandler('Vehicles:Client:ExitVehicle', function()
  if withinCustoms then
    ForceCloseVehicleCustoms()
  end
end)

function DoSlowVehicleNormalRepair(cost, cb)
  if not cost then
    cost = 1000
  end

  local time = cost * 10
  if time < 5000 then
    time = 5000
  end
  if time > 15000 then
    time = 15000
  end

  Progress:Progress({
    name = "vehicle_quick_repair",
    duration = time,
    label = "Repairing Vehicle",
    useWhileDead = false,
    canCancel = false,
    ignoreModifier = true,
    controlDisables = {
      disableMovement = true,
      disableCarMovement = true,
      disableMouse = false,
      disableCombat = true,
    },
  }, function(cancelled)
    if not cancelled and DRIVING_VEHICLE then
      exports["hrrp-base"]:CallbacksServer('Vehicles:CompleteRepair', {
        cost = cost,
      }, function(success)
        if success then
          Vehicles.Repair:Normal(DRIVING_VEHICLE)
          UISounds.Play:FrontEnd(-1, "PURCHASE", "HUD_LIQUOR_STORE_SOUNDSET")
          cb(true)
        else
          cb(false)
        end
      end)
    else
      cb(false)
    end
  end)
end
