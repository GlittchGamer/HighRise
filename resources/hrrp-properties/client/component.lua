_properties = {}

_propertiesLoaded = false

_insideProperty = false
_insideInterior = false
_insideFurniture = {}

_furnitureCategory = {}
_furnitureCategoryCurrent = 1

_placingFurniture = false

_allowBrowse = true
_skipPhone = false

AddEventHandler("Properties:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Callbacks = exports["hrrp-base"]:FetchComponent("Callbacks")
  Inventory = exports["hrrp-base"]:FetchComponent("Inventory")
  Logger = exports["hrrp-base"]:FetchComponent("Logger")
  Utils = exports["hrrp-base"]:FetchComponent("Utils")
  Notification = exports["hrrp-base"]:FetchComponent("Notification")
  Action = exports["hrrp-base"]:FetchComponent("Action")
  Sounds = exports["hrrp-base"]:FetchComponent("Sounds")
  Characters = exports["hrrp-base"]:FetchComponent("Characters")
  Wardrobe = exports["hrrp-base"]:FetchComponent("Wardrobe")
  Interaction = exports["hrrp-base"]:FetchComponent("Interaction")
  Inventory = exports["hrrp-base"]:FetchComponent("Inventory")
  Properties = exports["hrrp-base"]:FetchComponent("Properties")
  Jobs = exports["hrrp-base"]:FetchComponent("Jobs")
  Sync = exports["hrrp-base"]:FetchComponent("Sync")
  Blips = exports["hrrp-base"]:FetchComponent("Blips")
  Crafting = exports["hrrp-base"]:FetchComponent("Crafting")
  Polyzone = exports["hrrp-base"]:FetchComponent("Polyzone")
  Keybinds = exports["hrrp-base"]:FetchComponent("Keybinds")
  ObjectPlacer = exports["hrrp-base"]:FetchComponent("ObjectPlacer")
  Phone = exports["hrrp-base"]:FetchComponent("Phone")
  InfoOverlay = exports["hrrp-base"]:FetchComponent("InfoOverlay")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports["hrrp-base"]:RequestDependencies("Properties", {
    "Callbacks",
    "Inventory",
    "Logger",
    "Utils",
    "Notification",
    "Action",
    "Sounds",
    "Characters",
    "Wardrobe",
    "Interaction",
    "Inventory",
    "Properties",
    "Jobs",
    "Sync",
    "Crafting",
    "Blips",
    "Polyzone",
    "Keybinds",
    "ObjectPlacer",
    "Phone",
    "InfoOverlay",
  }, function(error)
    if #error > 0 then
      return
    end
    RetrieveComponents()

    CreatePropertyDoor(false)
    CreatePropertyDoor(true)

    Interaction:RegisterMenu("house-exit", "Exit", "door-open", function(data)
      Interaction:Hide()
      ExitProperty(data, data == 'back')
    end, function()
      if _insideProperty and _insideInterior then
        local interior = PropertyInteriors[_insideInterior]

        if interior then
          local dist = #(vector3(LocalPlayer.state.myPos.x, LocalPlayer.state.myPos.y, LocalPlayer.state.myPos.z) - interior.locations.front.coords)

          if dist <= 2.0 then
            return 'front'
          elseif interior.locations.back then
            backDist = #(vector3(LocalPlayer.state.myPos.x, LocalPlayer.state.myPos.y, LocalPlayer.state.myPos.z) - interior.locations.back.coords)
            if backDist <= 2.0 then
              return 'back'
            end
          end
        end
      end

      return false
    end)

    Interaction:RegisterMenu("house-lock", "Lock", "lock", function(data)
      Interaction:Hide()
      exports["hrrp-base"]:CallbacksServer("Properties:ChangeLock", {
        id = data,
        state = true,
      }, function(state)
        if state then
          exports['hrrp-hud']:NotificationSuccess("Property Locked")
        else
          exports['hrrp-hud']:NotificationError("Unable to Lock Property")
        end
      end)
    end, function()
      if _insideProperty and _insideInterior and _propertiesLoaded then
        if _properties[_insideProperty.id].locked then
          return false
        end

        local interior = PropertyInteriors[_insideInterior]

        local dist = #(vector3(LocalPlayer.state.myPos.x, LocalPlayer.state.myPos.y, LocalPlayer.state.myPos.z) - interior.locations.front.coords)
        local backDist
        if interior.locations.back then
          backDist = #(vector3(LocalPlayer.state.myPos.x, LocalPlayer.state.myPos.y, LocalPlayer.state.myPos.z) - interior.locations.back.coords)
        end

        if (dist <= 2.0 or (backDist and backDist <= 2.0)) then
          return _insideProperty.id
        end
      end

      return false
    end)

    Interaction:RegisterMenu("house-unlock", "Unlock", "unlock", function(data)
      Interaction:Hide()
      exports["hrrp-base"]:CallbacksServer("Properties:ChangeLock", {
        id = data,
        state = false,
      }, function(state)
        if state then
          exports['hrrp-hud']:NotificationSuccess("Property Unlocked")
        else
          exports['hrrp-hud']:NotificationError("Unable to Unlock Property")
        end
      end)
    end, function()
      if _insideProperty and _insideInterior and _propertiesLoaded then
        local property = _properties[_insideProperty.id]
        if
            property.locked
            and (
              (property.keys ~= nil and property.keys[LocalPlayer.state.Character:GetData("ID")] ~= nil)
              or (
                not property.sold
                and LocalPlayer.state.onDuty == "realestate"
                and exports['hrrp-jobs']:JobsPermissionsHasPermissionInJob("realestate", "JOB_DOORS")
              )
            )
        then
          local interior = PropertyInteriors[_insideInterior]
          local dist = #(vector3(LocalPlayer.state.myPos.x, LocalPlayer.state.myPos.y, LocalPlayer.state.myPos.z) - interior.locations.front.coords)
          local backDist
          if interior.locations.back then
            backDist = #(vector3(LocalPlayer.state.myPos.x, LocalPlayer.state.myPos.y, LocalPlayer.state.myPos.z) - interior.locations.back.coords)
          end

          if (dist <= 2.0 or (backDist and backDist <= 2.0)) then
            return _insideProperty.id
          end
        else
          return false
        end
      else
        return false
      end

      return false
    end)

    for k, v in pairs(PropertyInteriors) do
      if v.zone then
        exports['hrrp-polyzone']:PolyZoneCreateBox(
          string.format("property-int-zone-%s", k),
          v.zone.center,
          v.zone.length,
          v.zone.width,
          v.zone.options,
          {
            PROPERTY_INTERIOR_ZONE = true,
          }
        )
      end
    end

    exports['hrrp-keybinds']:Add("furniture_prev", "LEFT", "keyboard", "Furniture - Previous Item", function()
      if _placingFurniture then
        CycleFurniture()
      elseif _previewingInterior and not _previewingInteriorSwitching then
        PrevPreview()
      end
    end)

    exports['hrrp-keybinds']:Add("furniture_next", "RIGHT", "keyboard", "Furniture - Next Item", function()
      if _placingFurniture then
        CycleFurniture(true)
      elseif _previewingInterior and not _previewingInteriorSwitching then
        NextPreview()
      end
    end)

    RemoveEventHandler(setupEvent)
  end)
end)

function CreatePropertyDoor(isBackdoor)
  Interaction:RegisterMenu(isBackdoor and "property-backdoor" or "property",
    isBackdoor and "Property Backdoor" or "Property", isBackdoor and "house-window" or "house", function(data)
      local pMenu = {
        {
          icon = "door-open",
          label = isBackdoor and "Enter Backdoor" or "Enter",
          action = function()
            EnterProperty(data, isBackdoor)
          end,
          shouldShow = function()
            if not _propertiesLoaded then
              return false
            end

            local prop = _properties[data.propertyId]
            return ((prop.keys ~= nil and prop.keys[LocalPlayer.state.Character:GetData("ID")] ~= nil)
              or (not prop.sold and LocalPlayer.state.onDuty == "realestate" and exports['hrrp-jobs']:JobsPermissionsHasPermissionInJob(
                "realestate",
                "JOB_DOORS"
              ))
              or not prop.locked) and not prop.foreclosed
          end,
        },
        {
          icon = "lock-open",
          label = "Unlock",
          action = function()
            exports["hrrp-base"]:CallbacksServer("Properties:ChangeLock", {
              id = data.propertyId,
              state = false,
            }, function(state)
              if state then
                exports['hrrp-hud']:NotificationSuccess("Property Unlocked")
              else
                exports['hrrp-hud']:NotificationError("Unable to Unlock Property")
              end
              Interaction:Hide()
            end)
          end,
          shouldShow = function()
            if not _propertiesLoaded then
              return false
            end
            local prop = _properties[data.propertyId]
            if
                ((prop.keys ~= nil and prop.keys[LocalPlayer.state.Character:GetData("ID")] ~= nil)
                  or (
                    not prop.sold
                    and LocalPlayer.state.onDuty == "realestate"
                    and exports['hrrp-jobs']:JobsPermissionsHasPermissionInJob("realestate", "JOB_DOORS")
                  )) and not prop.foreclosed
            then
              return prop.locked
            else
              return false
            end
          end,
        },
        {
          icon = "lock",
          label = "Lock",
          action = function()
            exports["hrrp-base"]:CallbacksServer("Properties:ChangeLock", {
              id = data.propertyId,
              state = true,
            }, function(state)
              if state then
                exports['hrrp-hud']:NotificationSuccess("Property Locked")
              else
                exports['hrrp-hud']:NotificationError("Unable to Unlock Property")
              end
              Interaction:Hide()
            end)
          end,
          shouldShow = function()
            if not _propertiesLoaded then
              return false
            end
            local prop = _properties[data.propertyId]

            if
                ((prop.keys ~= nil and prop.keys[LocalPlayer.state.Character:GetData("ID")] ~= nil)
                  or (
                    not prop.sold
                    and LocalPlayer.state.onDuty == "realestate"
                    and exports['hrrp-jobs']:JobsPermissionsHasPermissionInJob("realestate", "JOB_DOORS")
                  )) and not prop.foreclosed
            then
              return not prop.locked
            else
              return false
            end
          end,
        },
        {
          icon = "house-chimney-crack",
          label = "Property is Foreclosed",
          action = function()
            exports['hrrp-hud']:NotificationError('This Property Has Been Foreclosed! This is why you should pay your property loans...',
              10000)
          end,
          shouldShow = function()
            if not _propertiesLoaded then
              return false
            end
            local prop = _properties[data.propertyId]
            return prop.foreclosed
          end,
        },
      }

      if not isBackdoor then
        table.insert(pMenu, {
          icon = "bells",
          label = "Ring Doorbell",
          action = function()
            exports["hrrp-base"]:CallbacksServer("Properties:RingDoorbell", data.propertyId, function()
              Sounds.Play:One("doorbell.ogg", 0.75)
            end)
          end,
          shouldShow = function()
            if not _propertiesLoaded then
              return false
            end
            local prop = _properties[data.propertyId]
            return prop.sold and not prop.foreclosed and prop.type == "house"
          end,
        })

        table.insert(pMenu, {
          icon = "sign-hanging",
          label = "Request Agent",
          action = function()
            exports["hrrp-base"]:CallbacksServer("Properties:RequestAgent", data.propertyId, function(state)
              if state then
                exports['hrrp-hud']:NotificationSuccess("Notification Sent")
              else
                exports['hrrp-hud']:NotificationError("Unable To Send Notification")
              end
              Interaction:Hide()
            end)
          end,
          shouldShow = function()
            if not _propertiesLoaded then
              return false
            end
            local prop = _properties[data.propertyId]
            return prop and not prop.sold
          end,
        })
      end

      Interaction:ShowMenu(pMenu)
    end, function()
      if not _propertiesLoaded then
        return false
      end

      if isBackdoor then
        return Properties:GetNearHouseBackdoor()
      else
        return Properties:GetNearHouse()
      end
    end, function()
      if not _propertiesLoaded then
        return false
      end
      if isBackdoor then
        local prop = Properties:GetNearHouseBackdoor()
        return type(prop) == "table" and _properties[prop.propertyId]?.label or 'Property'
      else
        local prop = Properties:GetNearHouse()
        return type(prop) == "table" and _properties[prop.propertyId]?.label or 'Property'
      end
    end)
end

RegisterNetEvent("Properties:Client:Load", function(props)
  _properties = props

  _propertiesLoaded = true
end)

RegisterNetEvent("Properties:Client:Update", function(id, data)
  if _properties and _propertiesLoaded then
    _properties[id] = data
  end
end)

RegisterNetEvent("Properties:Client:SetLocks", function(id, state)
  if _properties and _propertiesLoaded and _properties[id] then
    _properties[id].locked = state
  end
end)

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
  _propertiesLoaded = false
  _properties = {}

  collectgarbage()

  DestroyFurniture()

  _insideProperty = false
  _insideInterior = false

  _placingFurniture = false
  LocalPlayer.state.placingFurniture = false
  LocalPlayer.state.furnitureEdit = false
end)

PROPERTIES = {
  Enter = function(self, id)
    EnterProperty({
      propertyId = id,
    }, false)
  end,
  GetProperties = function(self)
    if _propertiesLoaded then
      return _properties
    end
    return false
  end,
  GetPropertiesWithAccess = function(self)
    if LocalPlayer.state.loggedIn and _propertiesLoaded then
      local props = {}
      for k, v in pairs(_properties) do
        if v and v.keys and v.keys[LocalPlayer.state.Character:GetData("ID")] then
          table.insert(props, v)
        end
      end

      return props
    end
    return false
  end,
  Get = function(self, pId)
    return _properties[pId]
  end,
  GetUpgradesConfig = function(self)
    return PropertyUpgrades
  end,
  GetNearHouse = function(self)
    if LocalPlayer.state.currentRoute ~= 0 or not _propertiesLoaded then
      return false
    end

    local myPos = GetEntityCoords(LocalPlayer.state.ped)
    local closest = nil
    for k, v in pairs(_properties) do
      local dist = #(myPos - vector3(v.location.front.x, v.location.front.y, v.location.front.z))
      if dist < 3.0 and (not closest or dist < closest.dist) then
        closest = {
          dist = dist,
          propertyId = v._id,
        }
      end
    end
    return closest
  end,
  GetNearHouseBackdoor = function(self)
    if LocalPlayer.state.currentRoute ~= 0 or not _propertiesLoaded then
      return false
    end

    local myPos = GetEntityCoords(LocalPlayer.state.ped)
    local closest = nil
    for k, v in pairs(_properties) do
      if v.location.backdoor then
        local dist = #(myPos - vector3(v.location.backdoor.x, v.location.backdoor.y, v.location.backdoor.z))
        if dist < 3.0 and (not closest or dist < closest.dist) then
          closest = {
            dist = dist,
            propertyId = v._id,
          }
        end
      end
    end
    return closest
  end,
  GetNearHouseGarage = function(self, coordOverride)
    if LocalPlayer.state.currentRoute ~= 0 or not _propertiesLoaded then
      return false
    end

    local myPos = GetEntityCoords(LocalPlayer.state.ped)
    local closest = nil
    for k, v in pairs(_properties) do
      if v.location.garage then
        local dist = #(myPos - vector3(v.location.garage.x, v.location.garage.y, v.location.garage.z))
        if dist < 3.0 and (not closest or dist < closest.dist) then
          closest = {
            coords = v.location.garage,
            dist = dist,
            propertyId = v._id,
          }
        end
      end
    end
    return closest
  end,
  GetInside = function(self)
    return _insideProperty
  end,
  Extras = {
    Stash = function(self)
      exports["hrrp-base"]:CallbacksServer("Properties:Validate", {
        id = GlobalState[string.format("%s:Property", LocalPlayer.state.ID)],
        type = "stash",
      })
    end,
    Closet = function(self)
      exports["hrrp-base"]:CallbacksServer("Properties:Validate", {
        id = GlobalState[string.format("%s:Property", LocalPlayer.state.ID)],
        type = "closet",
      }, function(state)
        if state then
          Wardrobe:Show()
        end
      end)
    end,
    Logout = function(self)
      exports["hrrp-base"]:CallbacksServer("Properties:Validate", {
        id = GlobalState[string.format("%s:Property", LocalPlayer.state.ID)],
        type = "logout",
      }, function(state)
        if state then
          Characters:Logout()
        end
      end)
    end,
  },
  Keys = {
    HasAccessWithData = function(self, key, value) -- Has Access to a Property with a specific data/key value
      if LocalPlayer.state.loggedIn and _propertiesLoaded then
        local propertyKeys = GlobalState[string.format("Char:Properties:%s", LocalPlayer.state.Character:GetData("ID"))]

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
  Furniture = {
    GetCurrent = function(self, property)
      if _insideProperty and _insideProperty.id == property._id then
        for k, v in ipairs(_insideFurniture) do
          v.dist = #(GetEntityCoords(LocalPlayer.state.ped) - vector3(v.coords.x, v.coords.y, v.coords.z))
        end
        return {
          success = true,
          furniture = _insideFurniture,
          catalog = FurnitureConfig,
          categories = FurnitureCategories,
        }
      end

      return {
        err = "Must be Inside the Property!"
      }
    end,
    EditMode = function(self, state)
      if state == nil then
        state = not LocalPlayer.state.furnitureEdit
      end

      if _insideProperty then
        SetFurnitureEditMode(state)
      end
    end,
    Place = function(self, model, category, metadata, blockBrowse, skipPhone)
      if not _insideProperty then
        return false
      end

      if not category then
        category = FurnitureConfig[model].cat
      end

      _allowBrowse = not blockBrowse

      _placingFurniture = true
      LocalPlayer.state.placingFurniture = true

      _furnitureCategory = {}
      for k, v in pairs(FurnitureConfig) do
        if v.cat == category then
          table.insert(_furnitureCategory, k)
        end
      end

      table.sort(_furnitureCategory, function(a, b)
        return (FurnitureConfig[a]?.id or 1) < (FurnitureConfig[b]?.id or 1)
      end)

      for k, v in ipairs(_furnitureCategory) do
        if v == model then
          _furnitureCategoryCurrent = k
        end
      end

      local fData = FurnitureConfig[model]
      if fData then
        InfoOverlay:Show(fData.name,
          string.format("Category: %s | Model: %s", FurnitureCategories[fData.cat]?.name or "Unknown", model))
      end

      exports['hrrp-objects']:Start(GetHashKey(model), "Furniture:Client:Place", metadata, true, "Furniture:Client:Cancel", true,
        fData.placeGround)
      if not skipPhone then
        Phone:Close(true, true)
      end
      _skipPhone = skipPhone

      DisablePauseMenu(true)

      return true
    end,
    Move = function(self, id, skipPhone)
      if not _insideProperty then
        return false
      end

      for k, v in ipairs(_insideFurniture) do
        if v.id == id then
          furn = v
        end
      end

      if not furn then
        return false
      end

      _placingFurniture = true
      LocalPlayer.state.placingFurniture = true

      local ns = {}
      for k, v in ipairs(_spawnedFurniture) do
        if v.id == id then
          DeleteEntity(v.entity)
          exports['ox_target']:TargetingRemoveEntity(v.entity)
        else
          table.insert(ns, v)
        end
      end
      _spawnedFurniture = ns

      local fData = FurnitureConfig[model]

      exports['hrrp-objects']:Start(GetHashKey(furn.model), "Furniture:Client:Move", { id = id }, true,
        "Furniture:Client:CancelMove", true, fData?.placeGround)
      if not skipPhone then
        Phone:Close(true, true)
      end
      _skipPhone = skipPhone

      DisablePauseMenu(true)

      return true
    end,
    Delete = function(self, id)
      if not _insideProperty then
        return false
      end

      local catCounts = {
        ["storage"] = 0,
      }
      local fData
      for k, v in ipairs(_insideFurniture) do
        if v.id == id then
          fData = FurnitureConfig[v.model]
        else
          local d = FurnitureConfig[v.model]
          if not catCounts[d.cat] then
            catCounts[d.cat] = 0
          end

          catCounts[d.cat] += 1
        end
      end

      if fData.cat == "storage" and catCounts["storage"] < 1 then
        exports['hrrp-hud']:NotificationError("You Are Required to Have At Least One Storage Container!")
        return false
      end

      local p = promise.new()

      exports["hrrp-base"]:CallbacksServer("Properties:DeleteFurniture", {
        id = id,
      }, function(success, furniture)
        if success then
          exports['hrrp-hud']:NotificationSuccess("Deleted Item")
          for k, v in ipairs(furniture) do
            v.dist = #(GetEntityCoords(LocalPlayer.state.ped) - vector3(v.coords.x, v.coords.y, v.coords.z))
          end
          p:resolve(furniture)
        else
          p:resolve(false)
          exports['hrrp-hud']:NotificationError("Error")
        end
      end)

      return Citizen.Await(p)
    end
  },
  Interiors = {
    Preview = function(self, int)
      StartPreview(int)
    end,
  }
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
  exports["hrrp-base"]:RegisterComponent("Properties", PROPERTIES)
end)

AddEventHandler("RealEstate:Client:AcceptTransfer", function()
  TriggerServerEvent("RealEstate:Server:AcceptTransfer")
end)

AddEventHandler("RealEstate:Client:DenyTransfer", function()
  TriggerServerEvent("RealEstate:Server:DenyTransfer")
end)