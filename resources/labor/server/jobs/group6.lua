local _JOB = "Group6"
local _joiners, _group6 = {}, {}
local _busy = {}

_G6 = {
  Route = {
    ---Mark the route as busy
    ---@param route string
    ---@param index number
    MarkBusy = function(self, route, index)
      if not _busy[route] then
        _busy[route] = {}
      end

      _busy[route][index] = true
    end,

    ---Check if the route is busy
    ---@param route string
    ---@param index number
    IsBusy = function(self, route, index)
      if not _busy[route] then
        return false
      end

      return _busy[route][index]
    end,

    ---Set the route back to avaliable
    ---@param route string
    ---@param index number
    SetAvaliable = function(_, route, index)
      if not _busy[route] then
        return false
      end

      _busy[route][index] = nil
    end,

    ---Get all the avaliable routes
    ---@param route string
    ---@return table
    GetAvaliable = function(_, route)
      local routes = Group6.Routes[route].Collection
      local availRoutes = {}
      for index, position in ipairs(routes) do
        if not _busy[route][index] then
          availRoutes[#availRoutes + 1] = {
            Position = position,
            Index = index
          }
        end
      end

      return availRoutes
    end,

    ---Generate routes for the job
    ---@param route string|table
    ---@param amount? number @The amount of routes to generate, if not set it will generate 3 routes
    Generate = function(self, route, amount)
      if not amount then amount = 3 end

      if type(route) == 'table' then
        local availRoutes = {}

        for _, _route in ipairs(route) do
          local routes = Group6.Routes[_route].Collection
          for index, position in ipairs(routes) do
            if not self:IsBusy(_route, index) then
              availRoutes[#availRoutes + 1] = {
                Route = _route,
                Position = position,
                Index = index
              }
            end
          end
        end

        if #availRoutes < amount then
          return false, 'Not enough routes available'
        end

        local collection = {}

        -- Shuffle the routes, so we get a random collection
        for i = 1, #availRoutes do
          local j = math.random(i, #availRoutes)
          availRoutes[i], availRoutes[j] = availRoutes[j], availRoutes[i]
        end

        -- Get random routes, and mark them as busy so they can't be used again until they are set back to avaliable
        for i = 1, amount do
          local randRoute = math.random(#availRoutes)
          collection[i] = availRoutes[randRoute]
          self:MarkBusy(availRoutes[randRoute].Route, availRoutes[randRoute].Index)
          table.remove(availRoutes, randRoute)
        end

        return {
          Collection = collection,
          Dropoff = Group6.Routes[route[1]].DropOff[math.random(#Group6.Routes[route[1]].DropOff)]
        }
      end

      -- In case we not passing a table, we just get the routes from the single route
      local availRoutes = self:GetAvaliable(route)

      if #availRoutes < amount then
        return false, 'Not enough routes available'
      end

      local collection = {}

      for i = 1, amount do
        local randRoute = math.random(#availRoutes)
        collection[i] = availRoutes[randRoute]
        self:MarkBusy(route, availRoutes[randRoute].Index)
        table.remove(availRoutes, randRoute)
      end

      return {
        Collection = collection,
        Dropoff = Group6.Routes[route].DropOff[math.random(#Group6.Routes[route].DropOff)]
      }
    end
  },
  Task = {
    ---Create tasks for the job
    ---@param route string|table
    ---@param amount number
    ---@return table|boolean, string?
    CreateTasks = function(self, route, amount)
      local tasks, errorMessage = _G6.Route:Generate(route, amount)

      if not tasks then
        return false, errorMessage
      end

      return tasks
    end,

    ---Get the next task for the job
    ---@param source number
    ---@return table|boolean, string?
    Next = function(self, source, taskString)
      local joiner = _joiners[source]

      if not _group6[joiner] then
        return false, 'No group found'
      end

      if _group6[joiner].state == 3 then
        _group6[joiner].state = 4
        TriggerClientEvent(string.format("Group6:Client:%s:ReturnTruck", _joiners[source]), -1)
        Labor.Offers:Start(
          _joiners[source],
          _JOB,
          'Bring back the truck',
          1
        )
        return
      end

      if _group6[joiner].state >= 4 then
        return false, 'Job is already finished'
      end

      -- If the current task is not nil, then we need to set it back to avaliable
      if _group6[joiner].currentTask and next(_group6[joiner].currentTask) then
        _G6.Route:SetAvaliable(_group6[joiner].currentTask.Route, _group6[joiner].currentTask.Index)
        _group6[joiner].currentTask = nil
      end

      local task = _group6[joiner].tasks.Collection[1]
      table.remove(_group6[joiner].tasks.Collection, 1)

      if task then
        _group6[joiner].currentTask = task
        _G6.Inventory:CreateJobPickup(joiner)
        TriggerClientEvent(string.format("Group6:Client:%s:NewTask", _joiners[source]), -1, task,
          _group6[joiner].state)
        Labor.Offers:Start(
          _joiners[source],
          _JOB,
          taskString or '',
          5
        )
        return task
      else
        _group6[joiner].state = 3
        TriggerClientEvent(string.format("Group6:Client:%s:Dropoff", _joiners[source]), -1, _group6[joiner].tasks.Dropoff, 3)
        Labor.Offers:Start(
          _joiners[source],
          _JOB,
          'Drop off the items',
          15
        )

        return _group6[joiner].tasks.Dropoff
      end
    end,
  },
  Object = {
    Create = function(self, source, model, coords, heading)
      return Objects:Create(source, 1, true, model, coords, heading, true)
    end,
    Delete = function(self, id)
      TriggerClientEvent("Objects:Client:Delete", -1, id)
    end
  },
  Vehicle = {
    Spawn = function(self, source, model, coords, heading, cb)
      Vehicles:SpawnTemp(source, model, coords, heading, cb)
    end,
    Delete = function(self, entity)
      Vehicles:Delete(entity, function() end)
    end
  },
  Inventory = {
    -- owner = CID, VIN etc.
    Count = function(self, owner, invType)
      return MySQL.single.await('SELECT COUNT(id) as count FROM inventory WHERE name = ?', {
        string.format("%s-%s", owner, invType)
      }).count
    end,

    CreateJobPickup = function(self, group)
      Inventory.Items:RemoveAll(group, 3003, "group6_bag")
      Inventory:AddItem(group, 'group6_bag', 5, {}, 3003, nil, nil, nil, false, nil, nil)
    end,

    OpenJobPickup = function(self, playerSrc, group)
      Inventory:OpenSecondary(playerSrc, 3003, group, nil, nil, false, nil, nil, nil)
    end,

    DepositBag = function(self, playerSrc, VIN)
      local char = exports['core']:FetchSource(playerSrc):GetData("Character")
      if char:GetData("TempJob") == _JOB and _joiners[playerSrc] ~= nil and _group6[_joiners[playerSrc]] ~= nil then
        local count = Inventory.Items:GetCount(char:GetData("SID"), 1, "group6_bag")
        if count and count > 0 then
          if VIN and count > (_group6[_joiners[playerSrc]].bagDeposited and 5 - _group6[_joiners[playerSrc]].bagDeposited or 5) then
            count = _group6[_joiners[playerSrc]].bagDeposited and 5 - _group6[_joiners[playerSrc]].bagDeposited or 5
          elseif not VIN and count > (_group6[_joiners[playerSrc]].bagDeposited and 15 - _group6[_joiners[playerSrc]].bagDeposited or 15) then
            count = _group6[_joiners[playerSrc]].bagDeposited and 15 - _group6[_joiners[playerSrc]].bagDeposited or 15
          end

          if Inventory.Items:Remove(char:GetData("SID"), 1, "group6_bag", count) then
            if VIN then
              if count ~= 5 then
                _group6[_joiners[playerSrc]].bagDeposited = count
              end
              Inventory:AddItem(VIN, 'group6_bag', count, {}, 3004, nil, nil, nil, false, nil, nil)
              if Labor.Offers:Update(_joiners[playerSrc], _JOB, count, true) then
                _group6[_joiners[playerSrc]].bagDeposited = nil
                local success, errorMessage = _G6.Task:Next(playerSrc, 'Deposit Bags to the truck')
                if not success then
                  return false, errorMessage
                end
                return true
              end
            else
              if count ~= 15 then
                _group6[_joiners[playerSrc]].bagDeposited = count
              end
              if Labor.Offers:Update(_joiners[playerSrc], _JOB, count, true) then
                _group6[_joiners[playerSrc]].bagDeposited = nil
                _G6.Task:Next(playerSrc, 'Bring back the truck')
                return true
              end
            end
          else
            return false, 'Failed to remove the item'
          end
        else
          return false, 'You do not have the item'
        end
      else
        return false, 'You are not on the job'
      end
    end,

    OpenSafe = function(self, playerSrc, VIN)
      Inventory:OpenSecondary(playerSrc, 3004, VIN, nil, nil, false, nil, nil, nil)
    end,

    CleanUp = function(self, groupID, VIN)
      Inventory.Items:RemoveAll(groupID, 3003)
      Inventory.Items:RemoveAll(VIN, 3004)
    end
  }
}

AddEventHandler("Labor:Server:Startup", function()
  exports['core']:CallbacksRegisterServer("Group6:StartJob", function(source, data, cb)
    if _group6[data] ~= nil and _group6[data].state == 0 then
      _group6[_joiners[source]].state = 1
      Labor.Offers:Start(_joiners[source], _JOB, "Pick up you vehicle", 1)
      TriggerClientEvent(string.format("Group6:Client:%s:Startup", data), -1)
      cb(true)
    else
      cb(false)
    end
  end)

  exports['core']:CallbacksRegisterServer("Group6:VehicleSpawn", function(source, data, cb)
    if _joiners[source] ~= nil and _group6[_joiners[source]].truck == nil and _group6[_joiners[source]].state == 1 then
      local leaderRank = 0 --Reputation:GetLevel(source, _JOB)
      local errorMessage
      Vehicles:SpawnTemp(source, Group6.Vehicles[leaderRank] or Group6.Vehicles[0], Group6.Spawn.Position,
        Group6.Spawn.Heading, function(veh, VIN)
          Vehicles.Keys:Add(source, VIN)
          _group6[_joiners[source]].truck = veh
          _group6[_joiners[source]].data = Group6.Tasks[leaderRank] or Group6.Tasks[0]
          _group6[_joiners[source]].state = 2
          _group6[_joiners[source]].tasks, errorMessage = _G6.Task:CreateTasks(
            _group6[_joiners[source]].data.Routes, 3)

          if not _group6[_joiners[source]].tasks then
            _G6.Vehicle:Delete(veh)
            cb(false, errorMessage)
            return
          end

          local success
          success, errorMessage = _G6.Task:Next(source, 'Deposit Bags to the truck')
          if not success then
            --_G6.Vehicle:Delete(veh)
            cb(false, errorMessage)
          end

          local access = {}

          for k, v in pairs(_joiners) do
            if v == _joiners[source] then
              access[k] = true
            end
          end

          local hackData = {
            Device = _group6[_joiners[source]]?.data.Device,
            Minigame = _group6[_joiners[source]]?.data.Minigame
          }

          Entity(veh).state:set('G6TRUCK', true, true)
          Entity(veh).state:set('Access', access or {}, true)
          Entity(veh).state:set('HackData', hackData or nil, true)
          cb(veh)
        end)
    end
  end)

  exports['core']:CallbacksRegisterServer('Group6:DepositBag', function(source, data, cb)
    local VIN = Entity(_group6[_joiners[source]].truck).state.VIN

    if data and data.depo then
      VIN = nil
    end

    local success, errorMessage = _G6.Inventory:DepositBag(source, VIN)

    if not success then
      cb(false, errorMessage)
      return
    end

    cb(true)
  end)

  exports['core']:CallbacksRegisterServer('Group6:OpenSafe', function(source, data, cb)
    if not data then
      cb(false, 'No VIN provided')
      return
    end

    local VIN = data.vin

    if not VIN then
      cb(false, 'No VIN provided')
      return
    end

    _G6.Inventory:OpenSafe(source, VIN)
    cb(true)
  end)

  exports['core']:CallbacksRegisterServer('Group6:GrabBag', function(source, data, cb)
    if _joiners[source] and _group6[_joiners[source]].truck and _group6[_joiners[source]].state == 2 then
      _G6.Inventory:OpenJobPickup(source, _joiners[source])
      cb(true)
    else
      exports['core']:ExecuteClient(source, "Notification", "Error", "You are not on the job")
      cb(false)
    end
  end)

  exports['core']:CallbacksRegisterServer("Group6:DespawnVehicle", function(source, data, cb)
    local char = exports['core']:FetchSource(source):GetData("Character")
    if _joiners[source] and _group6[_joiners[source]].truck and _group6[_joiners[source]].state == 4 then
      local garCoords = Group6.Spawn.Position
      local pedCoords = GetEntityCoords(GetPlayerPed(source))
      local distance = #(pedCoords - garCoords)
      if distance <= 25 then
        Vehicles:Delete(_group6[_joiners[source]].truck, function()
          if char:GetData("TempJob") == _JOB then
            _G6.Inventory:CleanUp(_joiners[source], Entity(_group6[_joiners[source]].truck).state.VIN)
            Labor.Offers:ManualFinish(_joiners[source], _JOB)
            cb(true)
          else
            exports['core']:ExecuteClient(source, "Notification", "Error", "Unable To Finish Job")
            cb(false)
          end
        end)
      else
        exports['core']:ExecuteClient(source, "Notification", "Error", "Truck Needs To Be With You")
      end
    else
      exports['core']:ExecuteClient(source, "Notification", "Error", "You've Not Completed All Routes")
      cb(false)
    end
  end)

  RegisterNetEvent('Group6:Server:CrackSafe', function(netID)
    local source = source
    local entity = NetworkGetEntityFromNetworkId(netID)

    if not entity then
      return
    end

    local vehState = Entity(entity).state
    local VIN = vehState.VIN
    local itemNeeded = vehState.HackData?.Device

    if not VIN or not itemNeeded then
      return false, 'Invalid vehicle'
    end

    local char = exports['core']:FetchSource(source):GetData("Character")
    local count = Inventory.Items:GetCount(char:GetData("SID"), 1, itemNeeded)
    if count and count > 0 then
      if Inventory.Items:Remove(char:GetData("SID"), 1, itemNeeded, 1) then
        vehState:set('G6_GETTINGHACKED', true, true)
        exports['core']:CallbacksClient(source, "Group6:Client:CrackSafe", netID, function(success)
          if success then
            vehState:set('G6_HACKED', true, true)
            Wait(2000)
            _G6.Inventory:OpenSafe(source, VIN)
          end
          vehState:set('G6_GETTINGHACKED', nil, true)
        end)
      else
        exports['core']:ExecuteClient(source, "Notification", "Error", "Failed to remove the item")
        return
      end
    else
      exports['core']:ExecuteClient(source, "Notification", "Error", "You do not have the item")
      return
    end
  end)
end)

AddEventHandler("Group6:Server:OnDuty", function(joiner, members, isWorkgroup)
  _joiners[joiner] = joiner
  _group6[joiner] = {
    joiner = joiner,
    isWorkgroup = isWorkgroup,
    started = os.time(),
    state = 0,
  }

  local char = exports['core']:FetchSource(joiner):GetData("Character")
  char:SetData("TempJob", _JOB)
  TriggerClientEvent("Group6:Client:OnDuty", joiner, joiner, os.time())

  Labor.Offers:Task(joiner, _JOB, "Talk to the boss")
  if #members > 0 then
    for k, v in ipairs(members) do
      _joiners[v.ID] = joiner
      local member = exports['core']:FetchSource(v.ID):GetData("Character")
      member:SetData("TempJob", _JOB)
      TriggerClientEvent("Group6:Client:OnDuty", v.ID, joiner, os.time())
    end
  end
end)

AddEventHandler("Group6:Server:OffDuty", function(source, joiner)
  _joiners[source] = nil
  TriggerClientEvent("Group6:Client:OffDuty", source)
end)

AddEventHandler("Group6:Server:FinishJob", function(joiner)
  if not _group6[joiner] then return end
  local routes = _group6[joiner].route?.Collection

  if routes then
    for _, route in ipairs(routes) do
      _G6.Route:SetAvaliable(route.Route, route.Index)
    end
  end

  if _group6[joiner]?.truck and DoesEntityExist(_group6[joiner].truck) then
    _G6.Vehicle:Delete(_group6[joiner].truck)
  end

  _group6[joiner] = nil
end)

AddEventHandler("Group6:Server:CancelJob", function(joiner)
  if not _group6[joiner] then return end
  local routes = _group6[joiner].route?.Collection

  if routes then
    for _, route in ipairs(routes) do
      _G6.Route:SetAvaliable(route.Route, route.Index)
    end
  end

  if _group6[joiner]?.truck and DoesEntityExist(_group6[joiner].truck) then
    _G6.Vehicle:Delete(_group6[joiner].truck)
  end

  _group6[joiner] = nil
end)

AddEventHandler('onResourceStop', function(resName)
  if GetCurrentResourceName() ~= resName then
    return
  end

  for joiner, data in pairs(_group6) do
    local routes = _group6[joiner].route?.Collection

    if routes then
      for _, route in ipairs(routes) do
        _G6.Route:SetAvaliable(route.Route, route.Index)
      end
    end

    if _group6[joiner]?.truck and DoesEntityExist(_group6[joiner].truck) then
      _G6.Vehicle:Delete(_group6[joiner].truck)
    end

    _group6[joiner] = nil
  end
end)
