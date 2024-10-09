local _activeTowVehicles = {}
local maxActive = 10

_activeTowers = {}

AddEventHandler('Tow:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
  Middleware = exports['hrrp-base']:FetchComponent('Middleware')
  Callbacks = exports['hrrp-base']:FetchComponent('Callbacks')
  Logger = exports['hrrp-base']:FetchComponent('Logger')
  Jobs = exports['hrrp-base']:FetchComponent('Jobs')
  Fetch = exports['hrrp-base']:FetchComponent('Fetch')
  Chat = exports['hrrp-base']:FetchComponent('Chat')
  Execute = exports['hrrp-base']:FetchComponent('Execute')
  Vehicles = exports['hrrp-base']:FetchComponent('Vehicles')
  Phone = exports['hrrp-base']:FetchComponent('Phone')
  Banking = exports['hrrp-base']:FetchComponent('Banking')
  Tow = exports['hrrp-base']:FetchComponent('Tow')
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['hrrp-base']:RequestDependencies('Tow', {
    'Middleware',
    'Callbacks',
    'Logger',
    'Jobs',
    'Fetch',
    'Chat',
    'Execute',
    'Vehicles',
    'Phone',
    'Banking',
    'Tow',
  }, function(error)
    if #error > 0 then return; end
    RetrieveComponents()

    Middleware:Add("Characters:Logout", function(source)
      Tow:CleanupPickup(source)
      _activeTowers[source] = nil
    end)

    Middleware:Add("playerDropped", function(source)
      Tow:CleanupPickup(source)
      _activeTowers[source] = nil
    end)

    exports['hrrp-base']:CallbacksRegisterServer('Tow:RequestJob', function(source, data, cb)
      local char = exports['hrrp-base']:FetchSource(source):GetData('Character')
      if not exports['hrrp-jobs']:JobsPermissionsHasJob(source, 'tow') and char then
        cb(Jobs:GiveJob(char:GetData('SID'), 'tow', false, 'employee'))
      else
        cb(false)
      end
    end)

    exports['hrrp-base']:CallbacksRegisterServer('Tow:QuitJob', function(source, data, cb)
      local char = exports['hrrp-base']:FetchSource(source):GetData('Character')
      if exports['hrrp-jobs']:JobsPermissionsHasJob(source, 'tow') and char then
        _activeTowers[source] = nil
        cb(Jobs:RemoveJob(char:GetData('SID'), 'tow'))
      else
        cb(false)
      end
    end)

    exports['hrrp-base']:CallbacksRegisterServer('Tow:OnDuty', function(source, data, cb)
      local char = exports['hrrp-base']:FetchSource(source):GetData('Character')
      local dutyData = exports['hrrp-jobs']:JobsDutyGetDutyData('tow')
      if exports['hrrp-jobs']:JobsPermissionsHasJob(source, 'tow') and char then
        if not dutyData or (dutyData and dutyData.Count < maxActive) then
          if exports['hrrp-jobs']:JobsDutyOn(source, 'tow', true) then
            _activeTowers[source] = {
              next = os.time() + (math.random(1, 3) * 60),
            }
            exports['hrrp-base']:ExecuteClient(
              source,
              'Notification',
              'Info',
              [[
                                You are now on Duty as a Tow Truck Driver.<br><br>
                                Get a Tow Truck from Jerry in the Tow Lot.<br>
                                To Impound Vehicles, Bring them to the Tow Lot and
                                Fill out the Paperwork.
                            ]],
              10000,
              'truck-tow'
            )
          else
            exports['hrrp-base']:ExecuteClient(source, 'Notification', 'Error', 'Failed to Go On Duty', 5000, 'truck-tow')
          end
        else
          exports['hrrp-base']:ExecuteClient(source, 'Notification', 'Error', 'Too Many Tow Employees on Duty', 5000, 'truck-tow')
        end
      else
        exports['hrrp-base']:ExecuteClient(source, 'Notification', 'Error', 'Failed to Go On Duty', 5000, 'truck-tow')
      end
    end)

    exports['hrrp-base']:CallbacksRegisterServer('Tow:OffDuty', function(source, data, cb)
      local char = exports['hrrp-base']:FetchSource(source):GetData('Character')
      if char and exports['hrrp-jobs']:JobsDutyGet(source, 'tow') then
        local stateId = char:GetData('SID')
        if not _activeTowVehicles[stateId] then
          exports['hrrp-jobs']:JobsDutyOff(source, 'tow')
          Tow:CleanupPickup(source)
          _activeTowers[source] = nil
          Phone.Notification:RemoveById(source, "TOW_OBJ")
        else
          exports['hrrp-base']:ExecuteClient(source, 'Notification', 'Error', 'Return the Tow Truck Before Going Off Duty', 5000, 'truck-tow')
        end
      else
        exports['hrrp-base']:ExecuteClient(source, 'Notification', 'Error', 'Failed to Go Off Duty', 5000, 'truck-tow')
      end
    end)

    exports['hrrp-base']:CallbacksRegisterServer('Tow:RequestTruck', function(source, spaceCoords, cb)
      local char = exports['hrrp-base']:FetchSource(source):GetData('Character')
      if char and Player(source).state.onDuty == 'tow' then
        local stateId = char:GetData('SID')
        if not _activeTowVehicles[stateId] then
          Vehicles:SpawnTemp(source, `flatbed`, spaceCoords.xyz, spaceCoords.w, function(spawnedVehicle, VIN, plate)
            if spawnedVehicle then
              Vehicles.Keys:Add(source, VIN)

              _activeTowVehicles[stateId] = {
                SID = stateId,
                veh = spawnedVehicle,
                net = NetworkGetNetworkIdFromEntity(spawnedVehicle),
                VIN = VIN,
                plate = plate,
              }

              GlobalState[string.format('TowTrucks:%s', stateId)] = NetworkGetNetworkIdFromEntity(spawnedVehicle)

              exports['hrrp-base']:ExecuteClient(source, 'Notification', 'Success', 'Your Tow Truck Was Provided', 5000, 'truck-tow')
              cb(spawnedVehicle)
            else
              exports['hrrp-base']:ExecuteClient(source, 'Notification', 'Error', 'Truck Spawn Failed', 5000, 'truck-tow')
              cb(nil)
            end
          end, {
            Make = 'MTL',
            Model = 'Flatbed',
            Value = 50000,
          })
        else
          exports['hrrp-base']:ExecuteClient(source, 'Notification', 'Error', 'We Already Gave You a Truck', 5000, 'truck-tow')
          cb(nil)
        end
      end
    end)

    exports['hrrp-base']:CallbacksRegisterServer('Tow:ReturnTruck', function(source, data, cb)
      local char = exports['hrrp-base']:FetchSource(source):GetData('Character')
      if char then
        local stateId = char:GetData('SID')
        local hasTruck = _activeTowVehicles[stateId]
        if hasTruck and hasTruck.veh and DoesEntityExist(hasTruck.veh) then
          local truckCoords = GetEntityCoords(hasTruck.veh)
          if #(truckCoords - _towSpaces[1].xyz) <= 20.0 then
            Vehicles:Delete(hasTruck.veh, function(success)
              if success then
                _activeTowVehicles[stateId] = nil
                GlobalState[string.format('TowTrucks:%s', stateId)] = false
                exports['hrrp-base']:ExecuteClient(source, 'Notification', 'Success', 'Thanks for Returning Your Tow Truck', 5000,
                  'truck-tow')
              else
                exports['hrrp-base']:ExecuteClient(source, 'Notification', 'Error', 'Error Returning Truck', 5000, 'truck-tow')
              end
            end)
          else
            exports['hrrp-base']:ExecuteClient(source, 'Notification', 'Error', 'Your Tow Truck Isn\'t Nearby', 5000, 'truck-tow')
          end
        else
          exports['hrrp-base']:ExecuteClient(source, 'Notification', 'Error', 'You Don\'t Have a Truck to Return', 5000, 'truck-tow')
        end
      end
    end)

    RemoveEventHandler(setupEvent)
  end)
end)

TOW = {
  PayoutPickup = function(self, source)
    if _activeTowers[source] ~= nil then
      local char = exports['hrrp-base']:FetchSource(source):GetData("Character")
      Banking.Balance:Deposit(Banking.Accounts:GetPersonal(char:GetData("SID")).Account, 300, {
        type = 'paycheck',
        title = "Tow Fee",
        description = 'Your Fee For A Vehicle Pickup',
        data = 300
      })
      Phone.Notification:RemoveById(source, "TOW_OBJ")
      Phone.Notification:Add(source, "Yard Manager",
        "Good work, I've sent your fee to your account. I'll let you know when I got another job for you",
        os.time() * 1000, 10000, {
          color = '#247919',
          label = 'Los Santos Tow',
          icon = 'truck-tow',
        }, {}, nil)

      Tow:CleanupPickup(source)
    end
  end,
  CleanupPickup = function(self, source)
    if _activeTowers[source] ~= nil then
      if _activeTowers[source].veh ~= nil and DoesEntityExist(_activeTowers[source].veh) then
        DeleteEntity(veh)
        _activeTowers[source].veh = nil
      end

      if _activeTowers[source].location ~= nil then
        _inuse[_activeTowers[source].location] = false
        _activeTowers[source].location = nil
      end

      _activeTowers[source].next = os.time() + (math.random(5, 10) * 60)
      _activeTowers[source].onTask = false
      TriggerClientEvent("Tow:Client:CleanupPickup", source)
    end
  end,
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
  exports['hrrp-base']:RegisterComponent('Tow', TOW)
end)
