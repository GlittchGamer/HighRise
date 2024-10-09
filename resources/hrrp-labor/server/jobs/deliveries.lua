local _JOB = "Deliveries"
local _joiners = {}
local _Deliveries = {}
local _DeliveryStores = {
  { -- North Rockford Drive Store
    id = 1,
    coords = vector3(-1821.900, 787.738, 138.177),
    Target = {
      Coords = vector3(-1826.6, 800.48, 138.11),
      Data = {
        First = 0.8,
        Second = 1.8,
        Heading = 310,
        MinZ = 137.11,
        MaxZ = 138.51
      }
    },
  },
  { -- Paleto Bay LS Fwy
    id = 2,
    coords = vector3(1730.506, 6410.445, 34.994),
    Target = {
      Coords = vector3(1734.28, 6421.93, 35.04),
      Data = {
        First = 0.6,
        Second = 2.4,
        Heading = 335,
        MinZ = 34.04,
        MaxZ = 36.04
      }
    },
  },
  { -- Grapeseed Store
    id = 3,
    coords = vector3(1697.999, 4929.863, 42.078),
    Target = {
      Coords = vector3(1705.9, 4918.01, 42.06),
      Data = {
        First = 2.2,
        Second = 1,
        Heading = 55,
        MinZ = 41.06,
        MaxZ = 42.46,
      }
    },
  },
  { -- LS Fwy Store
    id = 4,
    coords = vector3(2682.446, 3282.024, 55.241),
    Target = {
      Coords = vector3(2671.69, 3286.07, 55.24),
      Data = {
        First = 2.4,
        Second = 0.6,
        Heading = 330,
        MinZ = 54.24,
        MaxZ = 56.04,
      }
    },
  },
  { -- Palomino Fwy Store
    id = 5,
    coords = vector3(2560.300, 385.432, 108.621),
    Target = {
      Coords = vector3(2548.49, 383.93, 108.62),
      Data = {
        First = 2.4,
        Second = 0.6,
        Heading = 0,
        MinZ = 107.62,
        MaxZ = 109.42,
      }
    },
  },
  { -- Little Seoul Store
    id = 6,
    coords = vector3(-711.836, -917.488, 19.214),
    Target = {
      Coords = vector3(-706.36, -904.7, 19.22),
      Data = {
        First = 1.8,
        Second = 1,
        Heading = 0,
        MinZ = 18.22,
        MaxZ = 19.42,
      }
    },
  },
  { -- Great Ocean Store 2
    id = 7,
    coords = vector3(-3238.846, 1004.475, 12.455),
    Target = {
      Coords = vector3(-3250.86, 1003.44, 12.83),
      Data = {
        First = 2.4,
        Second = 0.6,
        Heading = 355,
        MinZ = 11.83,
        MaxZ = 13.63,
      }
    },
  },
  { -- Great Ocean Store 1
    id = 8,
    coords = vector3(-3037.872, 589.765, 7.816),
    Target = {
      Coords = vector3(-3048.38, 584.42, 7.91),
      Data = {
        First = 2.4,
        Second = 0.8,
        Heading = 20,
        MinZ = 6.91,
        MaxZ = 8.71,
      }
    },
  },
  { -- Innocense Blvd Store
    id = 9,
    coords = vector3(29.076, -1350.254, 29.333),
    Target = {
      Coords = vector3(27.23, -1338.51, 29.5),
      Data = {
        First = 0.6,
        Second = 2.4,
        Heading = 0,
        MinZ = 28.5,
        MaxZ = 30.3,
      }
    },
  },
  { -- Southside Gas Station Store
    id = 10,
    coords = vector3(288.833, -1266.845, 29.441),
    Target = {
      Coords = vector3(301.94, -1272.3, 29.44),
      Data = {
        First = 1.0,
        Second = 2.2,
        Heading = 0,
        MinZ = 28.44,
        MaxZ = 29.64,
      }
    },
  },
  { -- Sandy Shores Store
    id = 11,
    coords = vector3(1965.605, 3739.884, 32.322),
    Target = {
      Coords = vector3(1958.06, 3749.02, 32.38),
      Data = {
        First = 0.6,
        Second = 2.4,
        Heading = 30,
        MinZ = 31.38,
        MaxZ = 33.18,
      }
    },
  },
  { -- Clinton Ave Store
    id = 12,
    coords = vector3(376.398, 322.417, 103.436),
    Target = {
      Coords = vector3(377.4, 334.29, 103.57),
      Data = {
        First = 0.6,
        Second = 2.4,
        Heading = 345,
        MinZ = 102.57,
        MaxZ = 104.37,
      }
    },
  },
  { -- Harmony Store
    id = 13,
    coords = vector3(544.068, 2673.345, 42.153),
    Target = {
      Coords = vector3(547.54, 2662.2, 42.16),
      Data = {
        First = 0.6,
        Second = 2.4,
        Heading = 10,
        MinZ = 41.16,
        MaxZ = 42.96,
      }
    },
  },
  { -- Mirror Park Store
    id = 14,
    coords = vector3(1159.568, -328.084, 69.040),
    Target = {
      Coords = vector3(1162.84, -313.85, 69.21),
      Data = {
        First = 2.2,
        Second = 1.0,
        Heading = 10,
        MinZ = 68.21,
        MaxZ = 69.61,
      }
    },
  },
  { -- Paleto Bay Store
    id = 15,
    coords = vector3(161.342, 6635.928, 31.584),
    Target = {
      Coords = vector3(168.7, 6645.97, 31.7),
      Data = {
        First = 2.4,
        Second = 0.6,
        Heading = 45,
        MinZ = 30.7,
        MaxZ = 32.5,
      }
    },
  },
  { -- Grove St Store
    id = 16,
    coords = vector3(-53.623, -1757.219, 29.440),
    Target = {
      Coords = vector3(-41.3, -1750.8, 29.46),
      Data = {
        First = 0.8,
        Second = 2.0,
        Heading = 50,
        MinZ = 28.46,
        MaxZ = 29.66,
      }
    },
  },
}

AddEventHandler("Labor:Server:Startup", function()
  exports['hrrp-base']:CallbacksRegisterServer("Deliveries:StartJob", function(source, data, cb)
    if _Deliveries[data] ~= nil and _Deliveries[data].state == 0 then
      _Deliveries[data].state = 1
      Labor.Offers:Task(_joiners[source], _JOB, "Ask the Foreman for a vehicle.")
      TriggerClientEvent(string.format("Deliveries:Client:%s:Startup", data), -1)
      cb(true)
    else
      cb(false)
    end
  end)

  exports['hrrp-base']:CallbacksRegisterServer("Deliveries:DeliveriesSpawn", function(source, data, cb)
    if _joiners[source] ~= nil and _Deliveries[_joiners[source]].truck == nil and _Deliveries[_joiners[source]].state == 1 then
      Vehicles:SpawnTemp(source, `benson`, vector3(913.094, -1254.024, 25.520), 35.074, function(veh, VIN)
        Vehicles.Keys:Add(source, VIN)
        _Deliveries[_joiners[source]].truck = veh
        local availRoutes = {}
        for k, v in ipairs(_DeliveryStores) do
          table.insert(availRoutes, k)
        end
        local randRoute = math.random(#availRoutes)
        _Deliveries[_joiners[source]].route = deepcopy(_DeliveryStores[availRoutes[randRoute]])
        table.remove(availRoutes, randRoute)
        _Deliveries[_joiners[source]].routes = availRoutes
        _Deliveries[_joiners[source]].state = 2
        TriggerClientEvent(string.format("Deliveries:Client:%s:NewRoute", _joiners[source]), -1, _Deliveries[_joiners[source]].route)
        Labor.Offers:Start(
          _joiners[source],
          _JOB,
          string.format("Deliver Goods"),
          2
        )

        cb(veh)
      end)
    end
  end)

  exports['hrrp-base']:CallbacksRegisterServer("Deliveries:DeliveriesSpawnRemove", function(source, data, cb)
    if _joiners[source] ~= nil and _Deliveries[_joiners[source]].truck ~= nil then
      if _Deliveries[_joiners[source]].state == 3 then
        local TRUCK_COORDS = GetEntityCoords(_Deliveries[_joiners[source]].truck)
        local PED_COORDS = GetEntityCoords(GetPlayerPed(source))
        local distance = #(PED_COORDS - TRUCK_COORDS)
        if distance <= 25 then
          Vehicles:Delete(_Deliveries[_joiners[source]].truck, function()
            _Deliveries[_joiners[source]].truck = nil
            _Deliveries[_joiners[source]].state = 4
            TriggerClientEvent(string.format("Deliveries:Client:%s:ReturnTruck", _joiners[source]), -1)
            Labor.Offers:Task(_joiners[source], _JOB, "Speak with the Delivery Foreman")
          end)
        else
          exports['hrrp-base']:ExecuteClient(source, "Notification", "Error", "Truck Needs To Be With You")
        end
      end
    end
  end)

  exports['hrrp-base']:CallbacksRegisterServer("Deliveries:PackageGrab", function(source, data, cb)
    if _joiners[source] ~= nil then
      exports["hrrp-base"]:CallbacksClient(source, "Deliveries:DoingSomeAction", "GRAB_BOX")
      cb(true)
    else
      cb(false)
    end
  end)

  exports['hrrp-base']:CallbacksRegisterServer("Deliveries:DeliverPackage", function(source, data, cb)
    local char = exports['hrrp-base']:FetchSource(source):GetData("Character")
    if char:GetData("TempJob") == _JOB and _joiners[source] ~= nil and _Deliveries[_joiners[source]] ~= nil then
      if Labor.Offers:Update(_joiners[source], _JOB, 1, true) then
        if _Deliveries[_joiners[source]].tasks < 2 then
          _Deliveries[_joiners[source]].tasks = _Deliveries[_joiners[source]].tasks + 1
          local randRoute = math.random(#_Deliveries[_joiners[source]].routes)
          _Deliveries[_joiners[source]].route = deepcopy(_DeliveryStores[_Deliveries[_joiners[source]].routes[randRoute]])
          table.remove(_Deliveries[_joiners[source]].routes, randRoute)
          Labor.Offers:Start(
            _joiners[source],
            _JOB,
            string.format("Deliver Goods"),
            2
          )
          TriggerClientEvent(string.format("Deliveries:Client:%s:NewRoute", _joiners[source]), -1, _Deliveries[_joiners[source]].route)
        else
          _Deliveries[_joiners[source]].state = 3
          TriggerClientEvent(string.format("Deliveries:Client:%s:EndRoutes", _joiners[source]), -1)
          Labor.Offers:Task(_joiners[source], _JOB, "Return your truck")
        end
      end
      cb(true)
    else
      cb(false)
    end
  end)

  exports['hrrp-base']:CallbacksRegisterServer("Deliveries:TurnIn", function(source, data, cb)
    if _joiners[source] ~= nil and _Deliveries[_joiners[source]].tasks >= 2 then
      local char = exports['hrrp-base']:FetchSource(source):GetData("Character")
      if char:GetData("TempJob") == _JOB then
        Labor.Offers:ManualFinish(_joiners[source], _JOB)
        cb(true)
      else
        exports['hrrp-base']:ExecuteClient(source, "Notification", "Error", "Unable To Finish Job")
        cb(false)
      end
    else
      exports['hrrp-base']:ExecuteClient(source, "Notification", "Error", "You've Not Completed All Routes")
      cb(false)
    end
  end)
end)

AddEventHandler("Deliveries:Server:OnDuty", function(joiner, members, isWorkgroup)
  _joiners[joiner] = joiner
  _Deliveries[joiner] = {
    joiner = joiner,
    isWorkgroup = isWorkgroup,
    started = os.time(),
    state = 0,
    tasks = 0,
  }

  local char = exports['hrrp-base']:FetchSource(joiner):GetData("Character")
  char:SetData("TempJob", _JOB)
  Phone.Notification:Add(joiner, "Labor Activity", "You started a job", os.time() * 1000, 6000, "labor", {})
  TriggerClientEvent("Deliveries:Client:OnDuty", joiner, joiner, os.time())

  Labor.Offers:Task(joiner, _JOB, "Speak with the Delivery Foreman")
  if #members > 0 then
    for k, v in ipairs(members) do
      _joiners[v.ID] = joiner
      local member = exports['hrrp-base']:FetchSource(v.ID):GetData("Character")
      member:SetData("TempJob", _JOB)
      Phone.Notification:Add(v.ID, "Labor Activity", "You started a job", os.time() * 1000, 6000, "labor", {})
      TriggerClientEvent("Deliveries:Client:OnDuty", v.ID, joiner, os.time())
    end
  end
end)

AddEventHandler("Deliveries:Server:OffDuty", function(source, joiner)
  _joiners[source] = nil
  TriggerClientEvent("Deliveries:Client:OffDuty", source)
end)

AddEventHandler("Deliveries:Server:FinishJob", function(joiner)
  _Deliveries[joiner] = nil
end)
