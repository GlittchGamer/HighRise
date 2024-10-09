local _JOB = "GoPostal"
local _joiners = {}
local _GoPostal = {}
local _GoPostalDeliverys = {
  {
    id = 1,
    coords = vector3(207.2148, -85.1660, 69.1744),
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
  {
    id = 2,
    coords = vector3(319.9483, -121.5708, 68.3529),
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
  {
    id = 3,
    coords = vector3(330.2487, -202.4634, 54.0863),
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
  {
    id = 4,
    coords = vector3(-315.4421, -3.8527, 48.2074),
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
  {
    id = 5,
    coords = vector3(-482.8853, -17.0622, 45.1096),
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
  {
    id = 6,
    coords = vector3(121.7368, 40.6532, 73.5203),
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
  {
    id = 7,
    coords = vector3(401.0720, 98.8446, 101.4821),
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
  {
    id = 8,
    coords = vector3(172.5186, 183.4933, 105.7279),
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
  {
    id = 9,
    coords = vector3(-85.1545, 38.4993, 71.8986),
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
  {
    id = 10,
    coords = vector3(-599.0895, -251.0332, 36.2791),
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
  {
    id = 11,
    coords = vector3(-722.4756, -98.1867, 38.2038),
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
  {
    id = 12,
    coords = vector3(825.2067, -96.1942, 80.5994),
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
  {
    id = 13,
    coords = vector3(-96.1451, 44.0776, 71.7142),
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
  {
    id = 14,
    coords = vector3(-88.8524, 214.9003, 96.4104),
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
  {
    id = 15,
    coords = vector3(-239.0045, 205.8020, 83.8769),
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
}

AddEventHandler("Labor:Server:Startup", function()
  exports['hrrp-base']:CallbacksRegisterServer("GoPostal:StartJob", function(source, data, cb)
    if _GoPostal[data] ~= nil and _GoPostal[data].state == 0 then
      _GoPostal[data].state = 1
      Labor.Offers:Task(_joiners[source], _JOB, "Ask the Foreman for a vehicle.")
      TriggerClientEvent(string.format("GoPostal:Client:%s:Startup", data), -1)
      cb(true)
    else
      cb(false)
    end
  end)

  exports['hrrp-base']:CallbacksRegisterServer("GoPostal:GoPostalSpawn", function(source, data, cb)
    if _joiners[source] ~= nil and _GoPostal[_joiners[source]].truck == nil and _GoPostal[_joiners[source]].state == 1 then
      Vehicles:SpawnTemp(source, `boxville2`, vector3(130.4967, 88.7683, 82.1197), 248.5475, function(veh, VIN)
        Vehicles.Keys:Add(source, VIN)
        _GoPostal[_joiners[source]].truck = veh
        local availRoutes = {}
        for k, v in ipairs(_GoPostalDeliverys) do
          table.insert(availRoutes, k)
        end
        local randRoute = math.random(#availRoutes)
        _GoPostal[_joiners[source]].route = deepcopy(_GoPostalDeliverys[availRoutes[randRoute]])
        table.remove(availRoutes, randRoute)
        _GoPostal[_joiners[source]].routes = availRoutes
        _GoPostal[_joiners[source]].state = 2
        TriggerClientEvent(string.format("GoPostal:Client:%s:NewRoute", _joiners[source]), -1, _GoPostal[_joiners[source]].route)
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

  exports['hrrp-base']:CallbacksRegisterServer("GoPostal:GoPostalSpawnRemove", function(source, data, cb)
    if _joiners[source] ~= nil and _GoPostal[_joiners[source]].truck ~= nil then
      if _GoPostal[_joiners[source]].state == 3 then
        local TRUCK_COORDS = GetEntityCoords(_GoPostal[_joiners[source]].truck)
        local PED_COORDS = GetEntityCoords(GetPlayerPed(source))
        local distance = #(PED_COORDS - TRUCK_COORDS)
        if distance <= 25 then
          Vehicles:Delete(_GoPostal[_joiners[source]].truck, function()
            _GoPostal[_joiners[source]].truck = nil
            _GoPostal[_joiners[source]].state = 4
            TriggerClientEvent(string.format("GoPostal:Client:%s:ReturnTruck", _joiners[source]), -1)
            Labor.Offers:Task(_joiners[source], _JOB, "Speak with the Delivery Foreman")
          end)
        else
          exports['hrrp-base']:ExecuteClient(source, "Notification", "Error", "Truck Needs To Be With You")
        end
      end
    end
  end)

  exports['hrrp-base']:CallbacksRegisterServer("GoPostal:PackageGrab", function(source, data, cb)
    if _joiners[source] ~= nil then
      exports["hrrp-base"]:CallbacksClient(source, "GoPostal:DoingSomeAction", "GRAB_BOX")
      cb(true)
    else
      cb(false)
    end
  end)

  exports['hrrp-base']:CallbacksRegisterServer("GoPostal:DeliverPackage", function(source, data, cb)
    local char = exports['hrrp-base']:FetchSource(source):GetData("Character")
    if char:GetData("TempJob") == _JOB and _joiners[source] ~= nil and _GoPostal[_joiners[source]] ~= nil then
      if Labor.Offers:Update(_joiners[source], _JOB, 1, true) then
        if _GoPostal[_joiners[source]].tasks < 2 then
          _GoPostal[_joiners[source]].tasks = _GoPostal[_joiners[source]].tasks + 1
          local randRoute = math.random(#_GoPostal[_joiners[source]].routes)
          _GoPostal[_joiners[source]].route = deepcopy(_GoPostalDeliverys[_GoPostal[_joiners[source]].routes[randRoute]])
          table.remove(_GoPostal[_joiners[source]].routes, randRoute)
          Labor.Offers:Start(
            _joiners[source],
            _JOB,
            string.format("Deliver Goods"),
            2
          )
          TriggerClientEvent(string.format("GoPostal:Client:%s:NewRoute", _joiners[source]), -1, _GoPostal[_joiners[source]].route)
        else
          _GoPostal[_joiners[source]].state = 3
          TriggerClientEvent(string.format("GoPostal:Client:%s:EndRoutes", _joiners[source]), -1)
          Labor.Offers:Task(_joiners[source], _JOB, "Return your truck")
        end
      end
      cb(true)
    else
      cb(false)
    end
  end)

  exports['hrrp-base']:CallbacksRegisterServer("GoPostal:TurnIn", function(source, data, cb)
    if _joiners[source] ~= nil and _GoPostal[_joiners[source]].tasks >= 2 then
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

AddEventHandler("GoPostal:Server:OnDuty", function(joiner, members, isWorkgroup)
  _joiners[joiner] = joiner
  _GoPostal[joiner] = {
    joiner = joiner,
    isWorkgroup = isWorkgroup,
    started = os.time(),
    state = 0,
    tasks = 0,
  }

  local char = exports['hrrp-base']:FetchSource(joiner):GetData("Character")
  char:SetData("TempJob", _JOB)
  Phone.Notification:Add(joiner, "Labor Activity", "You started a job", os.time() * 1000, 6000, "labor", {})
  TriggerClientEvent("GoPostal:Client:OnDuty", joiner, joiner, os.time())

  Labor.Offers:Task(joiner, _JOB, "Speak with the GoPostal Boss")
  if #members > 0 then
    for k, v in ipairs(members) do
      _joiners[v.ID] = joiner
      local member = exports['hrrp-base']:FetchSource(v.ID):GetData("Character")
      member:SetData("TempJob", _JOB)
      Phone.Notification:Add(v.ID, "Labor Activity", "You started a job", os.time() * 1000, 6000, "labor", {})
      TriggerClientEvent("GoPostal:Client:OnDuty", v.ID, joiner, os.time())
    end
  end
end)

AddEventHandler("GoPostal:Server:OffDuty", function(source, joiner)
  _joiners[source] = nil
  TriggerClientEvent("GoPostal:Client:OffDuty", source)
end)

AddEventHandler("GoPostal:Server:FinishJob", function(joiner)
  _GoPostal[joiner] = nil
end)
