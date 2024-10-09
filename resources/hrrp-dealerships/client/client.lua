characterLoaded = false
_withinShowroom = false
_withinCatalog = false

_justBoughtFuckingBike = {}
-- DEALERSHIPS = {}

AddEventHandler('Dealerships:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
  Logger = exports['hrrp-base']:FetchComponent('Logger')
  Utils = exports['hrrp-base']:FetchComponent('Utils')
  Game = exports['hrrp-base']:FetchComponent('Game')
  Callbacks = exports['hrrp-base']:FetchComponent('Callbacks')
  Jobs = exports['hrrp-base']:FetchComponent('Jobs')
  Fetch = exports['hrrp-base']:FetchComponent('Fetch')
  Blips = exports['hrrp-base']:FetchComponent('Blips')
  Polyzone = exports['hrrp-base']:FetchComponent('Polyzone')
  Action = exports['hrrp-base']:FetchComponent('Action')
  Menu = exports['hrrp-base']:FetchComponent('Menu')
  Hud = exports['hrrp-base']:FetchComponent('Hud')
  Vehicles = exports['hrrp-base']:FetchComponent('Vehicles')
  ListMenu = exports['hrrp-base']:FetchComponent('ListMenu')
  PedInteraction = exports['hrrp-base']:FetchComponent('PedInteraction')
  Notification = exports['hrrp-base']:FetchComponent('Notification')
  Input = exports['hrrp-base']:FetchComponent('Input')
  Confirm = exports['hrrp-base']:FetchComponent('Confirm')
  --Dealerships = exports['hrrp-base']:FetchComponent('Dealerships')
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['hrrp-base']:RequestDependencies('Dealerships', {
    'Logger',
    'Utils',
    'Game',
    'Callbacks',
    'Jobs',
    'Fetch',
    'Polyzone',
    'Blips',
    'Action',
    'Menu',
    'Hud',
    'Vehicles',
    'ListMenu',
    'PedInteraction',
    'Notification',
    'Input',
    'Confirm',
    --'Dealerships',
  }, function(error)
    if #error > 0 then
      return
    end
    RetrieveComponents()
    CreateDealerships()

    CreateRentalSpots()
    CreateBikeStands()
    CreateGovermentFleetShops()

    RemoveEventHandler(setupEvent)
  end)
end)

RegisterNetEvent('Characters:Client:Spawn')
AddEventHandler('Characters:Client:Spawn', function()
  characterLoaded = true

  CreateDealershipBlips()
  CreateRentalSpotsBlips()
  CreateBikeStandBlips()
end)

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
  characterLoaded = false

  _justBoughtFuckingBike = {}
end)

-- AddEventHandler('Proxy:Shared:RegisterReady', function()
--     exports['hrrp-base']:RegisterComponent('Dealerships', DEALERSHIPS)
-- end)

function CreatePolyzone(id, zone, data)
  if zone.type == 'poly' then
    exports['hrrp-polyzone']:PolyZoneCreatePoly('dealerships_' .. id, zone.points, zone.options, data)
  elseif zone.type == 'box' then
    exports['hrrp-polyzone']:PolyZoneCreateBox('dealerships_' .. id, zone.center, zone.length, zone.width, zone.options, data)
  elseif zone.type == 'circle' then
    exports['hrrp-polyzone']:PolyZoneCreateCircle('dealerships_' .. id, zone.center, zone.radius, zone.options, data)
  end
end

function CreateDealerships()
  for dealerId, data in pairs(_dealerships) do
    -- Polyzones
    if data.zones then
      if data.zones.dealership then
        CreatePolyzone(dealerId .. '_main', data.zones.dealership, {
          dealer = true,
          dealerId = dealerId,
          type = 'main',
        })
      end

      if #data.zones.catalog > 0 then
        for k, v in ipairs(data.zones.catalog) do
          CreatePolyzone((dealerId .. '_catalog_' .. k), v, {
            dealer = true,
            dealerId = dealerId,
            type = 'catalog',
          })
        end
      end

      if data.zones.buyback then
        CreatePolyzone(dealerId .. '_buyback', data.zones.buyback, {
          dealer = true,
          dealerId = dealerId,
          type = 'buyback',
          dealerBuyback = true,
        })
      end
    end

    -- Targets
    if data.zones and #data.zones.employeeInteracts > 0 then
      for k, v in ipairs(data.zones.employeeInteracts) do
        exports['ox_target']:TargetingZonesAddBox(string.format('dealership_%s_employee_%s', dealerId, k), 'car-building', v.center, v.length, v.width, v
          .options, {
            {
              icon = 'car-garage',
              text = 'Edit Showroom',
              event = 'Dealerships:Client:ShowroomManagement',
              data = { dealerId = dealerId },
              jobPerms = {
                {
                  job = dealerId,
                  reqDuty = true,
                  permissionKey = 'dealership_showroom',
                }
              },
            },
            -- {
            --     icon = 'magnifying-glass-dollar',
            --     text = 'Run Credit Check',
            --     event = 'Dealerships:Client:StartRunningCredit',
            --     data = { dealerId = dealerId },
            --     jobPerms = {
            --         {
            --             job = dealerId,
            --             reqDuty = true,
            --             permissionKey = 'dealership_sell',
            --         }
            --     },
            -- },
            -- {
            --     icon = 'file-invoice-dollar',
            --     text = 'Sell Vehicle',
            --     event = 'Dealerships:Client:OpenSales',
            --     data = { dealerId = dealerId },
            --     jobPerms = {
            --         {
            --             job = dealerId,
            --             reqDuty = true,
            --             permissionKey = 'dealership_sell',
            --         }
            --     },
            -- },
            -- {
            --     icon = 'memo-pad',
            --     text = 'View Stock',
            --     event = 'Dealerships:Client:StockViewing',
            --     data = { dealerId = dealerId },
            --     jobPerms = {
            --         {
            --             job = dealerId,
            --             reqDuty = true,
            --             permissionKey = 'dealership_stock',
            --         }
            --     },
            -- },
            -- {
            --     icon = 'pen-to-square',
            --     text = 'Dealer Management',
            --     event = 'Dealerships:Client:StartManagement',
            --     data = { dealerId = dealerId },
            --     jobPerms = {
            --         {
            --             job = dealerId,
            --             reqDuty = true,
            --             permissionKey = 'dealership_manage',
            --         }
            --     },
            -- },
            {
              icon = 'briefcase-clock',
              text = 'Go On Duty',
              event = 'Dealerships:Client:ToggleDuty',
              data = { dealerId = dealerId, state = true },
              jobPerms = {
                {
                  job = dealerId,
                  reqOffDuty = true,
                }
              },
            },
            {
              icon = 'briefcase-clock',
              text = 'Go Off Duty',
              event = 'Dealerships:Client:ToggleDuty',
              data = { dealerId = dealerId, state = false },
              jobPerms = {
                {
                  job = dealerId,
                  reqDuty = true,
                }
              },
            },
            {
              icon = 'tablet-screen',
              text = 'Open Tablet',
              event = 'MDT:Client:Toggle',
              data = {},
              jobPerms = {
                {
                  job = dealerId,
                  reqDuty = true,
                }
              },
            },
          }, 3.5)
      end
    end
  end
end

function CreateDealershipBlips()
  for dealerId, data in pairs(_dealerships) do
    if data.blip then
      exports['hrrp-blips']:Add('dealership_' .. dealerId, data.name, data.blip.coords, data.blip.sprite, data.blip.colour, data.blip.scale)
    end
  end
end

AddEventHandler('Polyzone:Enter', function(id, point, insideZones, data)
  if characterLoaded and data and data.dealer and data.dealerId and data.type then
    if data.type == 'main' then
      _withinShowroom = data.dealerId
      SpawnShowroom(data.dealerId)
    elseif data.type == 'catalog' and _dealerships[data.dealerId] then
      _withinCatalog = data.dealerId
      exports['hrrp-hud']:ActionShow('{keybind}primary_action{/keybind} View ' .. _dealerships[data.dealerId].abbreviation .. ' Catalog')
    end
  end
end)

AddEventHandler('Polyzone:Exit', function(id, point, insideZones, data)
  if data and data.dealer and data.dealerId and data.type then
    if data.type == 'main' then
      DeleteShowroom(data.dealerId)
      _withinShowroom = false
    elseif data.type == 'catalog' then
      exports['hrrp-hud']:ActionHide()
      _withinCatalog = false
      ForceCloseCatalog()
    end
  end
end)

AddEventHandler('Keybinds:Client:KeyUp:primary_action', function()
  if _withinCatalog then
    exports['hrrp-hud']:ActionHide()
    OpenCatalog(_withinCatalog)
  end
end)

AddEventHandler('Dealerships:Client:ToggleDuty', function(entityData, data)
  if data and data.dealerId then
    if data.state then
      exports['hrrp-jobs']:JobsDutyOn(data.dealerId)
    else
      exports['hrrp-jobs']:JobsDutyOff(data.dealerId)
    end
  end
end)
