AddEventHandler("Properties:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Callbacks = exports['core']:FetchComponent("Callbacks")
  Middleware = exports['core']:FetchComponent("Middleware")
  Logger = exports['core']:FetchComponent("Logger")
  Fetch = exports['core']:FetchComponent("Fetch")

  Chat = exports['core']:FetchComponent("Chat")
  Properties = exports['core']:FetchComponent("Properties")
  Routing = exports['core']:FetchComponent("Routing")
  Phone = exports['core']:FetchComponent("Phone")
  Jobs = exports['core']:FetchComponent("Jobs")
  Inventory = exports['core']:FetchComponent("Inventory")
  Police = exports['core']:FetchComponent("Police")
  Crafting = exports['core']:FetchComponent("Crafting")
  Pwnzor = exports['core']:FetchComponent("Pwnzor")
  Banking = exports['core']:FetchComponent("Banking")
  Loans = exports['core']:FetchComponent("Loans")
  Billing = exports['core']:FetchComponent("Billing")
  Utils = exports['core']:FetchComponent("Utils")
  RegisterChatCommands()
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies("Properties", {
    "Callbacks",
    "Middleware",
    "Logger",
    "Fetch",

    "Chat",
    "Properties",
    "Routing",
    "Phone",
    "Jobs",
    "Inventory",
    "Police",
    "Crafting",
    "Pwnzor",
    "Banking",
    "Loans",
    "Billing",
    "Utils",
  }, function(error)
    if #error > 0 then
      return
    end -- Do something to handle if not all dependencies loaded
    RetrieveComponents()
    RegisterCallbacks()
    RegisterMiddleware()
    Startup()

    CreateFurnitureCallbacks()

    SetupPropertyCrafting()

    RemoveEventHandler(setupEvent)
  end)
end)


PROPERTIES = {
  Manage = {


    Add = function(self, source, type, interior, price, label, pos)
      if PropertyTypes[type] then
        if PropertyInteriors[interior] and PropertyInteriors[interior].type == type then
          local doc = {
            type = type,
            label = label,
            price = price,
            sold = false,
            owner = false,
            location = {
              front = pos,
            },
            upgrades = {
              interior = interior,
            }
          }

          local insertedId = MySQL.insert.await(
            'INSERT INTO properties (type, label, price, sold, owner, location, upgrades) VALUES (@type, @label, @price, @sold, @owner, @location, @upgrades)',
            {
              ['@type'] = doc.type,
              ['@label'] = doc.label,
              ['@price'] = doc.price,
              ['@sold'] = doc.sold,
              ['@owner'] = doc.owner,
              ['@location'] = json.encode(doc.location),
              ['@upgrades'] = json.encode(doc.upgrades)
            })

          if insertedId then
            doc.id = insertedId
            doc.interior = interior
            doc.locked = true

            for k, v in pairs(doc.location) do
              for k2, v2 in pairs(v) do
                doc.location[k][k2] = doc.location[k][k2] + 0.0
              end
            end

            _properties[doc.id] = doc

            Chat.Send.Server:Single(source, "Property Added, Property ID: " .. doc.id)

            TriggerClientEvent("Properties:Client:Update", -1, doc.id, doc)
            return true
          else
            return false
          end
        else
          Chat.Send.Server:Single(source, "Invalid Interior Combination")
          return false
        end
      else
        Chat.Send.Server:Single(source, "Invalid Property Type")
        return false
      end
    end,


    AddFrontdoor = function(self, id, pos)
      if not _properties[id] or not pos then
        return false
      end

      local currentLocation = MySQL.query.await('SELECT location FROM properties WHERE id = @id', {
        ['@id'] = id
      })

      if currentLocation and currentLocation[1] and currentLocation[1].location then
        local locationData = json.decode(currentLocation[1].location)

        locationData.front = pos

        local updatedLocation = json.encode(locationData)

        local success = MySQL.query.await('UPDATE properties SET location = @location WHERE id = @id', {
          ['@location'] = updatedLocation,
          ['@id'] = id
        })

        if success > 0 then
          if _properties[id] and _properties[id].location then
            _properties[id].location.front = pos
            TriggerClientEvent("Properties:Client:Update", -1, id, _properties[id])
          end
          return true
        else
          return false
        end
      else
        return false
      end
    end,


    AddBackdoor = function(self, id, pos)
      if not _properties[id] or not pos then
        return false
      end

      local currentLocation = MySQL.query.await('SELECT location FROM properties WHERE id = @id', {
        ['@id'] = id
      })

      if currentLocation and currentLocation[1] and currentLocation[1].location then
        local locationData = json.decode(currentLocation[1].location)

        locationData.backdoor = pos

        local updatedLocation = json.encode(locationData)

        local success = MySQL.query.await('UPDATE properties SET location = @location WHERE id = @id', {
          ['@location'] = updatedLocation,
          ['@id'] = id
        })

        if success > 0 then
          if _properties[id] and _properties[id].location then
            _properties[id].location.backdoor = pos
            TriggerClientEvent("Properties:Client:Update", -1, id, _properties[id])
          end
          return true
        else
          return false
        end
      else
        return false
      end
    end,

    AddGarage = function(self, id, pos)
      if not _properties[id] or pos == nil then
        return false
      end

      local currentLocation = MySQL.query.await('SELECT location FROM properties WHERE id = @id', {
        ['@id'] = id
      })

      if currentLocation and currentLocation[1] and currentLocation[1].location then
        local locationData = json.decode(currentLocation[1].location)

        locationData.garage = pos

        local updatedLocation = json.encode(locationData)

        local success = MySQL.query.await('UPDATE properties SET location = @location WHERE id = @id', {
          ['@location'] = updatedLocation,
          ['@id'] = id
        })

        if success > 0 then
          if _properties[id] and _properties[id].location then
            _properties[id].location.garage = pos
            TriggerClientEvent("Properties:Client:Update", -1, id, _properties[id])
          end
          return true
        else
          return false
        end
      else
        return false
      end
    end,

    SetLabel = function(self, id, label)
      if not _properties[id] or not label then
        return false
      end

      local success = MySQL.query.await('UPDATE properties SET label = @label WHERE id = @id', {
        ['@label'] = label,
        ['@id'] = id
      })

      if success > 0 then
        if _properties[id] then
          _properties[id].label = label
          TriggerClientEvent("Properties:Client:Update", -1, id, _properties[id])
        end
        return true
      else
        return false
      end
    end,


    SetPrice = function(self, id, price)
      if not _properties[id] or not price then
        return false
      end

      local success = MySQL.query.await('UPDATE properties SET price = @price WHERE id = @id', {
        ['@price'] = price,
        ['@id'] = id
      })

      if success > 0 then
        if _properties[id] then
          _properties[id].price = price
          TriggerClientEvent("Properties:Client:Update", -1, id, _properties[id])
        end
        return true
      else
        return false
      end
    end,


    SetData = function(self, id, key, value)
      if not key or not _properties[id] then
        return false
      end

      -- Fetch the current data
      local result = MySQL.single.await('SELECT data FROM properties WHERE id = @id', {
        ['@id'] = id
      })

      if result[1] then
        local data = json.decode(result[1].data) or {}
        data[key] = value

        local success = MySQL.query.await('UPDATE properties SET data = @data WHERE id = @id', {
          ['@data'] = json.encode(data),
          ['@id'] = id
        })

        if success > 0 then
          if _properties[id] then
            if not _properties[id].data then _properties[id].data = {} end
            _properties[id].data[key] = value
            TriggerClientEvent("Properties:Client:Update", -1, id, _properties[id])
          end
          return true
        else
          return false
        end
      else
        return false
      end
    end,

    Delete = function(self, id)
      local success = MySQL.query.await('DELETE FROM properties WHERE id = @id', {
        ['@id'] = id
      })

      if success > 0 then
        _properties[id] = nil
        TriggerClientEvent("Properties:Client:Update", -1, id, nil)
        return true
      else
        return false
      end
    end,

  },
  Upgrades = {

    Set = function(self, id, upgrade, level)
      local property = _properties[id]
      if property then
        local upgradeData = PropertyUpgrades[property.type][upgrade]
        if upgradeData and upgrade ~= "interior" then
          if level < 1 then
            level = 1
          end

          if level > #upgradeData.levels then
            level = #upgradeData.levels
          end

          local success = MySQL.query.await('UPDATE properties SET ' .. upgrade .. ' = @level WHERE id = @id', {
            ['@level'] = level,
            ['@id'] = id
          })

          if success > 0 then
            if not _properties[id].upgrades then _properties[id].upgrades = {} end
            _properties[id].upgrades[upgrade] = level

            TriggerClientEvent("Properties:Client:Update", -1, id, _properties[id])
            return true
          end
        end
      end

      return false
    end,


    Get = function(self, id, upgrade)
      local property = _properties[id]
      if property and property.upgrades and property.upgrades[upgrade] then
        return property.upgrades[upgrade]
      end
      return 1
    end,
    Increase = function(self, id, upgrade)
      local property = _properties[id]
      if property then
        local currentLevel = Properties.Upgrades:Get(id, upgrade)
        local success = Properties.Upgrades:Set(id, upgrade, currentLevel + 1)

        return success
      end
      return false
    end,
    Decrease = function(self, id, upgrade)
      local property = _properties[id]
      if property then
        local currentLevel = Properties.Upgrades:Get(id, upgrade)
        local success = Properties.Upgrades:Set(id, upgrade, currentLevel - 1)

        return success
      end
      return false
    end,

    SetInterior = function(self, id, interior)
      local property = _properties[id]
      if property then
        local intData = PropertyInteriors[interior]

        if intData and intData.type == property.type then
          local result = MySQL.single.await('SELECT upgrades FROM properties WHERE id = @id', {
            ['@id'] = id
          })

          if result[1] then
            local upgrades = json.decode(result[1].upgrades) or {}
            upgrades["interior"] = interior

            local success = MySQL.query.await('UPDATE properties SET upgrades = @upgrades WHERE id = @id', {
              ['@upgrades'] = json.encode(upgrades),
              ['@id'] = id
            })

            if success > 0 then
              if not _properties[id].upgrades then _properties[id].upgrades = {} end
              _properties[id].upgrades["interior"] = interior

              TriggerClientEvent("Properties:Client:Update", -1, id, _properties[id])
              return true
            end
          end
        end
      end

      return false
    end,


  },
  Commerce = {

    Sell = function(self, id)
      local success = MySQL.query.await('UPDATE properties SET sold = @sold, owner = @owner WHERE id = @id', {
        ['@sold'] = false,
        ['@owner'] = false,
        ['@id'] = id
      })

      if success > 0 and _properties[id] then
        _properties[id].sold = false

        if _properties[id].keys then
          for k, v in pairs(_properties[id].keys) do
            local t = GlobalState[string.format("Char:Properties:%s", v.Char)]
            if t ~= nil then
              for k2, v2 in ipairs(t) do
                if v2 == id then
                  table.remove(t, k2)
                  GlobalState[string.format("Char:Properties:%s", v.Char)] = t
                  break
                end
              end
            end
          end
        end

        _properties[id].keys = nil
        TriggerClientEvent("Properties:Client:Update", -1, id, _properties[id])
        return true
      else
        return false
      end
    end,

    Buy = function(self, id, owner, payment)
      local affectedRows = MySQL.query.await(
        'UPDATE `properties` SET `soldAt` = @soldAt, `sold` = @sold, `owner` = @owner, `keys` = @keys WHERE `id` = @id',
        {
          ['@soldAt'] = os.time(),
          ['@sold'] = true,
          ['@owner'] = json.encode(owner),
          ['@keys'] = json.encode({ [owner.Char] = owner }),
          ['@id'] = id
        })

      if affectedRows > 0 then
        _properties[id].sold = true
        _properties[id].keys = {
          [owner.Char] = owner,
        }
        _properties[id].soldAt = os.time()

        table.insert(GlobalState[string.format("Char:Properties:%s", owner.Char)], id)

        TriggerClientEvent("Properties:Client:Update", -1, id, _properties[id])
      end

      return affectedRows > 0
    end,


    Foreclose = function(self, id, state)
      if not _properties[id] or state == nil then
        return false
      end

      local success = MySQL.query.await(
        'UPDATE properties SET foreclosed = @state, foreclosedTime = @time WHERE id = @id', {
          ['@state'] = state,
          ['@time'] = state and os.time() or nil,
          ['@id'] = id
        })

      if success > 0 then
        if _properties[id] then
          _properties[id].foreclosed = state
          TriggerClientEvent("Properties:Client:Update", -1, id, _properties[id])
        end
        return true
      else
        return false
      end
    end,

  },
  Utils = {
    IsNearProperty = function(self, source)
      local myPos = GetEntityCoords(GetPlayerPed(source))
      local closest = nil
      for k, v in pairs(_properties) do
        local dist = #(myPos - vector3(v.location.front.x, v.location.front.y, v.location.front.z))
        if dist < 3.0 and (not closest or dist < closest.dist) then
          closest = {
            dist = dist,
            propertyId = v.id,
          }
        end
      end
      return closest
    end,
    SetLock = function(self, id, locked)
      if _properties[id] then
        _properties[id].locked = locked
        TriggerClientEvent("Properties:Client:SetLocks", -1, id, _properties[id].locked)
        return true
      else
        return false
      end
    end,
    ToggleLock = function(self, id)
      if _properties[id] then
        _properties[id].locked = not _properties[id].locked
        TriggerClientEvent("Properties:Client:SetLocks", -1, id, _properties[id].locked)
        return true
      else
        return false
      end
    end,
  },
  Keys = {

    Give = function(self, charData, id, isOwner, permissions, updating)
      local success = MySQL.query.await('UPDATE properties SET keys = @keys WHERE id = @id', {
        ['@keys'] = json.encode({
          [charData.ID] = {
            Char = charData.ID,
            First = charData.First,
            Last = charData.Last,
            SID = charData.SID,
            Owner = isOwner,
            Permissions = permissions
          }
        }),
        ['@id'] = id
      })

      if success > 0 then
        local result = MySQL.query.await('SELECT * FROM properties WHERE id = @id', {
          ['@id'] = id
        })

        if result[1] then
          _properties[id] = doPropertyThings(result[1])

          TriggerClientEvent("Properties:Client:Update", -1, id, _properties[id])

          if not updating then
            if GlobalState[string.format("Char:Properties:%s", charData.ID)] ~= nil then
              local t = GlobalState[string.format("Char:Properties:%s", charData.ID)]
              table.insert(t, id)
              GlobalState[string.format("Char:Properties:%s", charData.ID)] = t
            else
              GlobalState[string.format("Char:Properties:%s", charData.ID)] = { id }
            end
          end

          if charData.Source then
            TriggerClientEvent("Properties:Client:AddBlips", charData.Source)
          end

          return true
        end
      end

      return false
    end,

    Take = function(self, target, id)
      local success = MySQL.query.await('UPDATE properties SET keys = JSON_REMOVE(keys, ?) WHERE id = ?',
        { string.format('$.%s', target), id })

      if success > 0 then
        local result = MySQL.query.await('SELECT * FROM properties WHERE id = ?', { id })
        if result[1] then
          _properties[id] = doPropertyThings(result[1])

          TriggerClientEvent("Properties:Client:Update", -1, id, _properties[id])

          local t = GlobalState[string.format("Char:Properties:%s", target)]
          if t ~= nil then
            for k, v in ipairs(t) do
              if v == id then
                table.remove(t, k)
                break
              end
            end

            GlobalState[string.format("Char:Properties:%s", target)] = t
          end
        end
        return true
      else
        return false
      end
    end,

    Has = function(self, id, charId)
      if _properties[id] and _properties[id].keys ~= nil then
        return _properties[id].keys[charId]
      end
      return false
    end,
    HasBySID = function(self, id, stateId)
      if _properties[id] and _properties[id].keys ~= nil then
        for k, v in pairs(_properties[id].keys) do
          if v.SID == stateId then
            return true
          end
        end
      end
      return false
    end,
    HasAccessWithData = function(self, source, key, value) -- Has Access to a Property with a specific data/key value
      local char = exports['core']:FetchSource(source):GetData("Character")
      if char then
        local propertyKeys = GlobalState[string.format("Char:Properties:%s", char:GetData("ID"))]

        for _, propertyId in ipairs(propertyKeys) do
          local property = _properties[propertyId]
          if property and property.data and ((value == nil and property.data[key]) or property.data[key] == value) then
            return property.id
          end
        end
      end
      return false
    end,
  },
  Get = function(self, propertyId)
    return _properties[propertyId]
  end,
  ForceEveryoneLeave = function(self, propertyId)
    local property = _properties[propertyId]
    if property then
      if _insideProperties[property.id] then
        for k, v in pairs(_insideProperties[property.id]) do
          TriggerClientEvent("Properties:Client:ForceExitProperty", k, property.id)
        end
      end
    end
  end,
  GetMaxParkingSpaces = function(self, propertyId)
    local property = _properties[propertyId]
    if property then
      local garageLevel = property?.upgrades?.garage or 1

      if garageLevel and garageLevel >= 1 and PropertyGarage[property.type] and PropertyGarage[property.type][garageLevel] then
        return PropertyGarage[property.type][garageLevel].parking
      end
    end
  end
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
  exports['core']:RegisterComponent("Properties", PROPERTIES)
end)
