local _joiner = nil
local _working = false
local _blips = {}
local _blip = nil
local _state = 0
local eventHandlers = {}
local _route = nil
local location = nil

loadAnimDict = function(dict)
  RequestAnimDict(dict)
  while not HasAnimDictLoaded(dict) do
    Citizen.Wait(10)
  end
end

AddEventHandler("Labor:Client:Setup", function()
  exports['pedinteraction']:Add("GoPostalJob", GetHashKey("s_m_y_construct_01"), vector3(919.87, -1256.43, 24.52), 34.85, 25.0, {
    {
      icon = "person",
      text = "Interact",
      event = "GoPostal:NPC:Interact",
      tempjob = "GoPostal",
    },
  }, "store")

  exports['core']:CallbacksRegisterClient("GoPostal:DoingSomeAction", function(item, cb)
    local ped = PlayerPedId()
    if item == "GRAB_BOX" then
      exports['ox_target']:TargetingZonesAddBox('GoPostal_DROP_OFF', "boxes-stacked", _route.Target.Coords, _route.Target.Data.First, _route.Target.Data
        .Second, {
          heading = _route.Target.Data.Heading,
          debugPoly = false,
          minZ = _route.Target.Data.MinZ,
          maxZ = _route.Target.Data.MaxZ,
        }, {
          {
            icon = "box",
            text = "Deliver Package",
            event = 'GoPostal:Client:DeliverPackage',
            tempjob = "GoPostal",
            isEnabled = function(data)
              return LocalPlayer.state.hasGoPostPackage
            end,
          },
        }, 3.0, true)

      local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
      GoPostalPackage = CreateObject(GetHashKey('hei_prop_heist_box'), x, y, z + 0.2, true, true, true)
      AttachEntityToEntity(GoPostalPackage, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 60309), 0.025, 0.08, 0.255, -145.0, 290.0, 0.0, true, true, false, true,
        1, true)


      CreateThread(function()
        while LocalPlayer.state.hasGoPostPackage do
          Wait(100)
          if not IsEntityPlayingAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 3) then
            loadAnimDict("anim@heists@box_carry@")
            TaskPlayAnim(ped, "anim@heists@box_carry@", "idle", 6.0, -6.0, -1, 49, 0, 0, 0, 0)
          end
        end
      end)
    elseif item == "DELIVER_PACKAGE" then
      exports['ox_target']:TargetingZonesRemoveZone('GoPostal_DROP_OFF')

      DeleteObject(GoPostalPackage)
      ClearPedTasks(ped)
    end
  end)
end)

GenerateDeliveryOptions = function()
  return {
    {
      text = "Start Work",
      event = "GoPostal:Client:StartJob",
      isEnabled = not _working
    },
    {
      text = "Borrow GoPostal Truck",
      event = "GoPostal:Client:GoPostalSpawn",
      isEnabled = _working and _state == 1
    },
    {
      text = "Return GoPostal Truck",
      event = "GoPostal:Client:GoPostalSpawnRemove",
      isEnabled = _working and _state == 3
    },
    {
      text = "Complete Job",
      event = "GoPostal:Client:TurnIn",
      isEnabled = _working and _state == 4
    },
  }
end

RegisterNetEvent('GoPostal:NPC:Interact', function(entity)
  Options = {}

  for k, v in ipairs(GenerateDeliveryOptions()) do
    if v.isEnabled then
      table.insert(Options, {
        label = v.text,
        data = { close = true, event = v.event }
      })
    end
  end

  table.insert(Options, {
    label = 'See you later',
    data = { close = true }
  })

  NPCDialog.Open(entity.entity, {
    first_name = 'Paul',
    last_name = 'Postage',
    Tag = '💸',
    description = 'Drop packages to houses around the city.',
    buttons = Options
  })
end)

RegisterNetEvent("GoPostal:Client:OnDuty", function(joiner, time)
  _joiner = joiner
  DeleteWaypoint()

  _blip = exports['blips']:Add("GoPostalStart", "GoPostal Boss", { x = 918.01, y = -1255.28, z = 0 }, 478, 3, 1.4)

  eventHandlers["startup"] = RegisterNetEvent(string.format("GoPostal:Client:%s:Startup", joiner), function()
    _working = true
    _state = 1

    Citizen.CreateThread(function()
      while _working do
        if _route ~= nil then
          local dist = #(vector3(LocalPlayer.state.myPos.x, LocalPlayer.state.myPos.y, LocalPlayer.state.myPos.z) - vector3(_route.coords.x, _route.coords.y, _route.coords.z))
          if dist <= 25 then
            LocalPlayer.state.inHouseZone = true
          else
            LocalPlayer.state.inHouseZone = false
          end
        end
        Citizen.Wait(1000)
      end
    end)
  end)

  eventHandlers["new-route"] = RegisterNetEvent(string.format("GoPostal:Client:%s:NewRoute", joiner), function(r)
    _state = 2
    _route = r
    DeleteWaypoint()
    SetNewWaypoint(_route.coords)

    exports['ox_target']:TargetingZonesRemoveZone('GoPostal_DROP_OFF')

    if LocalPlayer.state.hasGoPostPackage then
      DetachEntity(GoPostalPackage, 1, false)
      DeleteObject(GoPostalPackage)
    end

    if _blip ~= nil then
      exports['blips']:Remove("GoPostalStart")
      RemoveBlip(_blip)
      _blip = nil
    end

    _blip = exports['blips']:Add("GoPostalStart", "Delivery Location", { x = _route.coords.x, y = _route.coords.y, z = _route.coords.z }, 478, 3, 1.4)
    SetBlipColour(_blip, 3)
  end)

  eventHandlers["end-pickup"] = RegisterNetEvent(string.format("GoPostal:Client:%s:EndRoutes", joiner), function()
    DeleteWaypoint()
    SetNewWaypoint(919.155, -1255.813)

    exports['ox_target']:TargetingZonesRemoveZone('GoPostal_DROP_OFF')

    if LocalPlayer.state.hasGoPostPackage then
      DetachEntity(GoPostalPackage, 1, false)
      DeleteObject(GoPostalPackage)
    end

    if _blip ~= nil then
      exports['blips']:Remove("GoPostalStart")
      RemoveBlip(_blip)
      _blip = nil
    end

    _blip = exports['blips']:Add("GoPostalStart", "GoPostal Boss", { x = 918.01, y = -1255.28, z = 0 }, 478, 3, 1.4)
    _state = 3
  end)

  eventHandlers["GoPostal-drop"] = AddEventHandler("GoPostal:Client:DeliverPackage", function(entity, data)
    if GoPostalPackage ~= nil then
      DetachEntity(GoPostalPackage, 1, false)
      DeleteObject(GoPostalPackage)
      GoPostalPackage = nil
    end

    exports['core']:CallbacksServer("GoPostal:DeliverPackage", {}, function(s)
      if s then
        LocalPlayer.state.hasGoPostPackage = false
        Wait(1000)
        ClearPedTasksImmediately(PlayerPedId())
      end
    end)
  end)

  eventHandlers["GoPostal-grab"] = AddEventHandler("GoPostal:Client:Grab", function()
    exports['core']:CallbacksServer("GoPostal:PackageGrab", {}, function(s)
      if s then
        LocalPlayer.state.hasGoPostPackage = true
      end
    end)
  end)

  eventHandlers["spawn-truck"] = AddEventHandler("GoPostal:Client:GoPostalSpawn", function()
    exports['core']:CallbacksServer("GoPostal:GoPostalSpawn", {}, function(netId)
      SetEntityAsMissionEntity(NetToVeh(netId))
    end)
  end)

  eventHandlers["despawn-truck"] = AddEventHandler("GoPostal:Client:GoPostalSpawnRemove", function()
    exports['core']:CallbacksServer("GoPostal:GoPostalSpawnRemove", {})
  end)

  eventHandlers["return-truck"] = RegisterNetEvent(string.format("GoPostal:Client:%s:ReturnTruck", joiner), function()
    _state = 4
  end)

  eventHandlers["turn-in"] = AddEventHandler("GoPostal:Client:TurnIn", function()
    exports['core']:CallbacksServer("GoPostal:TurnIn", _joiner)
  end)
end)

AddEventHandler("GoPostal:Client:StartJob", function()
  exports['core']:CallbacksServer("GoPostal:StartJob", _joiner, function(state)
    if not state then
      exports['hud']:NotificationError("Unable To Start Job")
    end
  end)
end)

RegisterNetEvent("GoPostal:Client:OffDuty", function(time)
  for k, v in pairs(eventHandlers) do
    RemoveEventHandler(v)
  end

  if _blip ~= nil then
    exports['blips']:Remove("GoPostalStart")
    RemoveBlip(_blip)
    _blip = nil
  end

  exports['ox_target']:TargetingZonesRemoveZone('GoPostal_DROP_OFF')

  if LocalPlayer.state.hasGoPostPackage or GoPostalPackage ~= nil then
    DetachEntity(GoPostalPackage, 1, false)
    DeleteObject(GoPostalPackage)
    LocalPlayer.state.hasGoPostPackage = false
  end

  eventHandlers = {}
  _joiner = nil
  _working = false
  _route = nil
  GoPostalPackage = nil
  _state = 0
  LocalPlayer.state.inHouseZone = false
end)
