_cachedInventory = nil
SecondInventory = {}

_inUse = false
_disabled = false
local _openCd = false
local _hkCd = false
local _container = nil
local trunkOpen = false

function dropAnim(drop)
  if LocalPlayer.state.doingAction then
    return
  end
  if drop then
    loadAnimDict("pickup_object")
    TaskPlayAnim(PlayerPedId(), "pickup_object", "putdown_low", 5.0, 1.0, 1.0, 48, 0.0, 0, 0, 0)
  else
    loadAnimDict("pickup_object")
    TaskPlayAnim(PlayerPedId(), "pickup_object", "pickup_low", 5.0, 1.0, 1.0, 48, 0.0, 0, 0, 0)
  end
end

AddEventHandler("Inventory:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Callbacks = exports["hrrp-base"]:FetchComponent("Callbacks")
  Inventory = exports["hrrp-base"]:FetchComponent("Inventory")
  Utils = exports["hrrp-base"]:FetchComponent("Utils")
  Notification = exports["hrrp-base"]:FetchComponent("Notification")
  Action = exports["hrrp-base"]:FetchComponent("Action")
  Keybinds = exports["hrrp-base"]:FetchComponent("Keybinds")
  Progress = exports["hrrp-base"]:FetchComponent("Progress")
  Crafting = exports["hrrp-base"]:FetchComponent("Crafting")
  Interaction = exports["hrrp-base"]:FetchComponent("Interaction")
  UISounds = exports["hrrp-base"]:FetchComponent("UISounds")
  Blips = exports["hrrp-base"]:FetchComponent("Blips")
  PedInteraction = exports["hrrp-base"]:FetchComponent("PedInteraction")
  Polyzone = exports["hrrp-base"]:FetchComponent("Polyzone")
  Hud = exports["hrrp-base"]:FetchComponent("Hud")
  Phone = exports["hrrp-base"]:FetchComponent("Phone")
  Jobs = exports["hrrp-base"]:FetchComponent("Jobs")
  Reputation = exports["hrrp-base"]:FetchComponent("Reputation")
  Vehicles = exports["hrrp-base"]:FetchComponent("Vehicles")
  Sounds = exports["hrrp-base"]:FetchComponent("Sounds")
  ListMenu = exports["hrrp-base"]:FetchComponent("ListMenu")
  NPCDialog = exports["hrrp-base"]:FetchComponent("NPCDialog")

  --Weapons = exports['hrrp-base']:FetchComponent('Weapons')
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports["hrrp-base"]:RequestDependencies("Inventory", {
    "Callbacks",
    "Inventory",
    "Utils",
    "Notification",
    "Action",
    "Progress",
    "Crafting",
    "Interaction",
    "UISounds",
    "Blips",
    "PedInteraction",
    "Polyzone",
    "Hud",
    "Phone",
    "Jobs",
    "Reputation",
    "Vehicles",
    "Sounds",
    "ListMenu",
    "NPCDialog",
    --'Weapons',
  }, function(error)
    if #error > 0 then
      return
    end
    RetrieveComponents()
    RegisterKeyBinds()
    RegisterRandomItems()
    LoadItems()

    exports["hrrp-base"]:CallbacksRegisterClient("Inventory:ForceClose", function(data, cb)
      Inventory.Close:All()
      cb(true)
    end)

    exports["hrrp-base"]:CallbacksRegisterClient("Inventory:Container:Open", function(data, cb)
      if SecondInventory.owner ~= nil then
        exports["hrrp-base"]:CallbacksServer("Inventory:CloseSecondary", SecondInventory, function()
          _container = data.item
          SecondInventory = { invType = _items[data.item.Name].container, owner = data.container }
          cb(true)
        end)
      else
        _container = data.item
        SecondInventory = { invType = _items[data.item.Name].container, owner = data.container }
        cb(true)
      end
    end)

    exports["hrrp-base"]:CallbacksRegisterClient("Inventory:Compartment:Open", function(data, cb)
      if SecondInventory.owner ~= nil then
        exports["hrrp-base"]:CallbacksServer("Inventory:CloseSecondary", SecondInventory, function()
          SecondInventory = data
          cb(true)
        end)
      else
        SecondInventory = data
        cb(true)
      end
    end)

    exports["hrrp-base"]:CallbacksRegisterClient("Inventory:ItemUse", function(item, cb)
      if item.anim and (not item.pbConfig or not item.pbConfig.animation) then
        exports["hrrp-animations"]:EmotesPlay(item.anim, false, item.time, true)
      end

      if item.pbConfig ~= nil then
        Progress:Progress({
          name = item.pbConfig.name,
          duration = item.time,
          label = item.pbConfig.label,
          useWhileDead = item.pbConfig.useWhileDead,
          canCancel = item.pbConfig.canCancel,
          vehicle = item.pbConfig.vehicle,
          disarm = item.pbConfig.disarm,
          ignoreModifier = item.pbConfig.ignoreModifier or true,
          animation = item.pbConfig.animation or false,
          controlDisables = {
            disableMovement = item.pbConfig.disableMovement,
            disableCarMovement = item.pbConfig.disableCarMovement,
            disableMouse = item.pbConfig.disableMouse,
            disableCombat = item.pbConfig.disableCombat,
          },
        }, function(cancelled)
          exports["hrrp-animations"]:EmotesForceCancel()
          cb(not cancelled)
        end)
      else
        cb(true)
      end
    end)

    CreateVendingMachines()

    RemoveEventHandler(setupEvent)
  end)
end)

RegisterNetEvent("Inventory:Client:ReloadItems", function()
  exports['hrrp-hud']:NotificationInfo("Reloading Item Definitions, Things May Lag For A Second")
  LoadItems()
  exports['hrrp-hud']:NotificationInfo("Item Definition Load Finished")
end)

local _openCd = false
function startCd()
  Citizen.CreateThread(function()
    _openCd = true
    Citizen.Wait(1000)
    _openCd = false
  end)
end

RegisterNetEvent("UI:Client:Reset", function(force)
  if force then
    _startup = false
    LoadItems()
  end
  Inventory.Close:All()
  Inventory:Enable()
end)

RegisterNetEvent("Inventory:Client:Cache", function(inventory, refresh)
  _cachedInventory = inventory

  if refresh then
    TriggerEvent("Weapons:Client:Attach")
  end
end)

RegisterNetEvent("Inventory:Client:Open", function(inventory, inventory2)
  if inventory ~= nil then
    LocalPlayer.state.inventoryOpen = true
    Inventory.Set.Player:Inventory(inventory)

    if inventory2 ~= nil then
      Inventory.Set.Secondary:Inventory(inventory2)
      Inventory.Set.Secondary.Data.Open = true
      Inventory.Open:Secondary()
    else
      Inventory.Set.Secondary.Data.Open = false
    end
    Inventory.Set.Player.Data.Open = true

    if SecondInventory?.invType == 10 then
      dropAnim(true)
    end

    SendNUIMessage({
      type = "SET_MODE",
      data = {
        mode = "inventory",
      },
    })
    SendNUIMessage({
      type = "APP_SHOW",
    })
    SetNuiFocus(true, true)

    Citizen.CreateThread(function()
      while LocalPlayer.state.inventoryOpen do
        Citizen.Wait(50)
      end
      TriggerServerEvent("Inventory:server:closePlayerInventory", LocalPlayer.state.Character:GetData("SID"))
    end)
  else
    LocalPlayer.state.inventoryOpen = false
  end
end)

RegisterNetEvent("Inventory:Client:Load", function(inventory, inventory2)
  if inventory ~= nil then
    Inventory.Set.Player:Inventory(inventory)
    if inventory2 ~= nil then
      Inventory.Set.Secondary:Inventory(inventory2)
    end
  else
    LocalPlayer.state.inventoryOpen = false
  end
end)

AddEventHandler("Characters:Client:Updated", function(key)
  if key == "InventorySettings" then
    SendNUIMessage({
      type = "UPDATE_SETTINGS",
      data = {
        settings = LocalPlayer.state.Character:GetData("InventorySettings") or {},
      }
    })
  end
end)

AddEventHandler("Vehicles:Client:ExitVehicle", function()
  if LocalPlayer.state.inventoryOpen then
    Inventory.Close:All()
  end
end)

function PlayTrunkOpenAnim()
  local playerPed = PlayerPedId()
  RequestAnimDict('anim@heists@prison_heiststation@cop_reactions')

  while not HasAnimDictLoaded('anim@heists@prison_heiststation@cop_reactions') do
    Wait(100)
  end

  TaskPlayAnim(playerPed, 'anim@heists@prison_heiststation@cop_reactions', 'cop_b_idle', 3.0, 3.0, -1, 49, 0.0, 0, 0, 0)

  RemoveAnimDict('anim@heists@prison_heiststation@cop_reactions')
end

function PlayTrunkCloseAnim()
  local playerPed = PlayerPedId()
  RequestAnimDict('anim@heists@fleeca_bank@scope_out@return_case')

  while not HasAnimDictLoaded('anim@heists@fleeca_bank@scope_out@return_case') do
    Wait(100)
  end

  TaskPlayAnim(playerPed, 'anim@heists@fleeca_bank@scope_out@return_case', 'trevor_action', 2.0, 2.0, -1, 49, 0.25, 0.0, 0.0, GetEntityHeading(playerPed))
  RemoveAnimDict('anim@heists@fleeca_bank@scope_out@return_case')
end

INVENTORY = {
  _required = { "IsEnabled", "Open", "Close", "Set", "Enable", "Disable", "Toggle", "Check" },
  IsEnabled = function(self)
    return _startup and not _disabled and not _openCd and not exports['hrrp-hud']:IsDisabled()
  end,
  Open = {
    Player = function(self, doSecondary)
      if Inventory:IsEnabled() then
        Phone:Close()
        exports['hrrp-hud']:InteractionHide()
        if not LocalPlayer.state.inventoryOpen then
          LocalPlayer.state.inventoryOpen = true
          TriggerServerEvent("Inventory:Server:Request", doSecondary and SecondInventory or false)
        end
      end
    end,
    Secondary = function(self)
      SendNUIMessage({
        type = "SHOW_SECONDARY_INVENTORY",
      })
    end,
  },
  Close = {
    All = function(self)
      SendNUIMessage({
        type = "APP_HIDE",
      })
      SetNuiFocus(false, false)

      LocalPlayer.state.inventoryOpen = false
      LocalPlayer.state.craftingOpen = false
      Inventory.Set.Player.Data.Open = false

      if trunkOpen and trunkOpen > 0 then
        PlayTrunkCloseAnim()
        Wait(900)
        Vehicles.Sync.Doors:Shut(trunkOpen, 5, false)
        trunkOpen = false
        ClearPedTasks(PlayerPedId())
      end

      if Inventory.Set.Secondary.Data.Open then
        Inventory.Close:Secondary()
      end
      TriggerServerEvent("Inventory:Server:InventoryClosed", SecondInventory)
    end,
    Secondary = function(self)
      if trunkOpen and trunkOpen > 0 then
        PlayTrunkCloseAnim()
        Wait(900)
        Vehicles.Sync.Doors:Shut(trunkOpen, 5, false)
        trunkOpen = false
        ClearPedTasks(PlayerPedId())
      end

      if Inventory.Set.Secondary.Data.Open then
        exports["hrrp-base"]:CallbacksServer("Inventory:CloseSecondary", SecondInventory, function()
          SecondInventory = {}
          _container = nil
          Inventory.Set.Secondary.Data.Open = false
        end)
      end
    end,
  },
  Set = {
    Player = {
      Data = {
        allowOpen = true,
        Open = false,
      },
      Inventory = function(self, data)
        if not data then
          LocalPlayer.state.inventoryOpen = false
          LocalPlayer.state.craftingOpen = false
          Inventory.Set.Player.Data.Open = false
          return
        end
        SendNUIMessage({
          type = "SET_PLAYER_INVENTORY",
          data = data,
        })
      end,
      Slot = function(self, slot)
        SendNUIMessage({
          type = "SET_PLAYER_SLOT",
          data = {
            slot = slot,
          },
        })
      end,
    },
    Secondary = {
      Data = {
        Open = false,
      },
      Inventory = function(self, data)
        Inventory.Set.Secondary.Data.Open = true
        SendNUIMessage({
          type = "SET_SECONDARY_INVENTORY",
          data = data,
        })
      end,
      Slot = function(self, slot)
        SendNUIMessage({
          type = "SET_SECONDARY_SLOT",
          data = {
            slot = slot,
          },
        })
      end,
    },
  },
  Used = {
    HotKey = function(self, control)
      if not _hkCd and not _inUse and not exports['hrrp-hud']:IsDisabled() then
        SendNUIMessage({
          type = "USE_ITEM_PLAYER",
          data = {
            originSlot = control,
          },
        })
        _hkCd = true
        exports["hrrp-base"]:CallbacksServer("Inventory:UseSlot", { slot = control }, function(state)
          if not state then
            SendNUIMessage({
              type = "SLOT_NOT_USED",
              data = {
                originSlot = control,
              },
            })
          end

          Citizen.SetTimeout(3000, function()
            _hkCd = false
          end)
        end)
      end
    end,
  },
  -- ALL OF THIS NEEDS TO BE VALIDATED SERVER SIDE
  -- THIS IS BEING ADDED TO SAVE A CLIENT > SERVER > CLIENT CALL
  Items = {
    GetCount = function(self, item, bundleWeapons)
      local counts = Inventory.Items:GetCounts(bundleWeapons)
      return counts[item] or 0
    end,
    GetCounts = function(self, bundleWeapons)
      if _cachedInventory == nil or _cachedInventory.inventory == nil or #_cachedInventory.inventory == 0 then
        return {}
      end
      local counts = {}

      if LocalPlayer.state.Character == nil then
        return counts
      end

      for k, v in ipairs(_cachedInventory.inventory) do
        if
            _items[v.Name].durability == nil
            or not _items[v.Name].isDestroyed
            or (((v.CreateDate or 0) + _items[v.Name].durability) >= GetCloudTimeAsInt())
        then
          local itemData = Inventory.Items:GetData(v.Name)

          if bundleWeapons and itemData?.weapon then
            counts[itemData?.weapon] = (counts[itemData?.weapon] or 0) + v.Count
          end
          counts[v.Name] = (counts[v.Name] or 0) + v.Count
        end
      end

      return counts
    end,
    GetTypeCounts = function(self)
      local counts = {}

      if LocalPlayer.state.Character == nil or _cachedInventory == nil then
        return counts
      end

      for k, v in ipairs(_cachedInventory.inventory) do
        if
            _items[v.Name].durability == nil
            or not _items[v.Name].isDestroyed
            or (((v.CreateDate or 0) + _items[v.Name].durability) >= GetCloudTimeAsInt())
        then
          local itemData = Inventory.Items:GetData(v.Name)
          counts[itemData.type] = (counts[itemData.type] or 0) + v.Count
        end
      end

      return counts
    end,
    Has = function(self, item, count, bundleWeapons)
      return Inventory.Items:GetCount(item, bundleWeapons) >= count
    end,
    HasType = function(self, itemType, count)
      return (Inventory.Items:GetTypeCounts()[itemType] or 0) >= count
    end,
    GetData = function(self, name)
      if name ~= nil then
        return _items[name]
      else
        return _items
      end
    end,
    GetWithStaticMetadata = function(self, masterKey, mainIdName, textureIdName, gender, data)
      for k, v in pairs(_items) do
        if
            v.staticMetadata ~= nil
            and v.staticMetadata[masterKey] ~= nil
            and v.staticMetadata[masterKey][gender][mainIdName] == data[mainIdName]
            and v.staticMetadata[masterKey][gender][textureIdName] == data[textureIdName]
        then
          return k
        end
      end

      return nil
    end,
  },
  Check = {
    Player = {
      HasItem = function(self, item, count)
        return Inventory.Items:Has(item, count)
      end,
      HasItems = function(self, items)
        for k, v in ipairs(items) do
          if not Inventory.Items:Has(v.item, v.count, true) then
            return false
          end
        end
        return true
      end,
      HasAnyItems = function(self, items)
        for k, v in ipairs(items) do
          if Inventory.Items:Has(v.item, v.count) then
            return true
          end
        end

        return false
      end,
    },
  },
  Enable = function(self)
    _disabled = false
  end,
  Disable = function(self)
    _disabled = true
  end,
  Toggle = function(self)
    _disabled = not _disabled
  end,
  Dumbfuck = {
    Open = function(self, data)
      exports["hrrp-base"]:CallbacksServer("Inventory:Server:Open", data, function(state)
        if state then
          SecondInventory = { invType = data.invType, owner = data.owner }
        end
      end)
    end,
  },
  Stash = {
    Open = function(self, type, identifier)
      exports["hrrp-base"]:CallbacksServer("Stash:Server:Open", {
        type = type,
        identifier = identifier,
      }, function(state)
        if state ~= nil then
          SecondInventory = state
        end
      end)
    end,
  },
  Shop = {
    Open = function(self, identifier)
      exports["hrrp-base"]:CallbacksServer("Shop:Server:Open", {
        identifier = identifier,
      }, function(state)
        if state then
          SecondInventory = { invType = state, owner = string.format("shop:%s", identifier) }
        end
      end)
    end,
  },
  Search = {
    Character = function(self, serverId)
      exports["hrrp-base"]:CallbacksServer("Inventory:Search", {
        serverId = serverId,
      }, function(owner)
        if owner then
          SecondInventory = { invType = 1, owner = owner }
        end
      end)
    end,
  },
  StaticTooltip = {
    Open = function(self, item)
      SendNUIMessage({
        type = "OPEN_STATIC_TOOLTIP",
        data = {
          item = item,
        }
      })
    end,
    Close = function(self)
      SendNUIMessage({
        type = "CLOSE_STATIC_TOOLTIP",
      })
    end,
  }
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
  exports["hrrp-base"]:RegisterComponent("Inventory", INVENTORY)
end)

local function exportHandler(exportName, func)
  AddEventHandler(('__cfx_export_%s_%s'):format(GetCurrentResourceName(), exportName), function(setCB)
    setCB(function(...)
      return func(INVENTORY, ...)
    end)
  end)
end

local function createExportForObject(object, name)
  name = name or ""
  for k, v in pairs(object) do
    if type(v) == "function" then
      exportHandler(name .. k, v)
    elseif type(v) == "table" then
      createExportForObject(v, name .. k)
    end
  end
end

for k, v in pairs(INVENTORY) do
  if type(v) == "function" then
    exportHandler("Inventory" .. k, v)
  elseif type(v) == "table" then
    createExportForObject(v, "Inventory" .. k)
  end
end


local Sounds = {
  ["SELECT"] = { id = -1, sound = "SELECT", library = "HUD_FRONTEND_DEFAULT_SOUNDSET" },
  ["BACK"] = { id = -1, sound = "CANCEL", library = "HUD_FRONTEND_DEFAULT_SOUNDSET" },
  ["UPDOWN"] = { id = -1, sound = "NAV_UP_DOWN", library = "HUD_FRONTEND_DEFAULT_SOUNDSET" },
  ["DISABLED"] = { id = -1, sound = "ERROR", library = "HUD_FRONTEND_DEFAULT_SOUNDSET" },
}
RegisterNUICallback("FrontEndSound", function(data, cb)
  cb("ok")
  if Sounds[data] ~= nil then
    UISounds.Play:FrontEnd(Sounds[data].id, Sounds[data].sound, Sounds[data].library)
  end
end)

RegisterNUICallback("UpdateSettings", function(data, cb)
  cb('OK')
  TriggerServerEvent("Inventory:Server:UpdateSettings", data)
end)

RegisterNUICallback("SubmitAction", function(data, cb)
  cb('OK')
  Inventory.Close:All()
  TriggerServerEvent("Inventory:Server:TriggerAction", data)
end)

RegisterNUICallback("Close", function(data, cb)
  startCd()
  cb(true)
  Inventory.Close:All()
  Inventory:Enable()
end)

RegisterNUICallback("BrokeShit", function(data, cb)
  cb(true)
  startCd()
  Inventory.Close:All()
  Inventory:Enable()
  exports['hrrp-hud']:NotificationError("Something Is Broken And Your Inventory Isn't Working, You May Need To Hard Nap To Fix")
end)

RegisterNetEvent("Characters:Client:Spawn", function()
  exports["hrrp-base"]:CallbacksServer("Inventory:Server:retreiveStores", {}, function(shopsData)
    Shops = shopsData
    setupStores(shopsData)
    startDropsTick()
  end)

  SendNUIMessage({
    type = "UPDATE_SETTINGS",
    data = {
      settings = LocalPlayer.state.Character:GetData("InventorySettings") or {},
    }
  })

  WeaponsThread()
end)

RegisterNetEvent("Characters:Client:Logout", function()
  Shops = {}
  _cachedInventory = nil
end)

AddEventHandler("Ped:Client:Died", function()
  Inventory.Close:All()
end)

AddEventHandler("Inventory:Client:Trunk", function(entity, data)
  local vehClass = GetVehicleClass(entity.entity)
  local vehModel = GetEntityModel(entity.entity)

  exports["hrrp-base"]:CallbacksServer("Inventory:OpenTrunk", {
    netId = VehToNet(entity.entity),
    class = vehClass,
    model = vehModel,
  }, function(s)
    if s then
      SecondInventory = {
        netId = VehToNet(entity.entity),
        invType = 4,
        owner = Entity(entity.entity).state.VIN,
        class = vehClass,
        model = vehModel,
      }
      trunkOpen = entity.entity
      SetVehicleHasBeenOwnedByPlayer(entity.entity, true)
      SetEntityAsMissionEntity(entity.entity, true, true)
      --SetVehicleDoorOpen(entity.entity, 5, true, false)
      Vehicles.Sync.Doors:Open(entity.entity, 5, false, false)
      PlayTrunkOpenAnim()
    end
  end)
end)

RegisterNetEvent("Inventory:Client:InUse", function(state)
  LocalPlayer.state.inUse = state
  SendNUIMessage({
    type = "USE_IN_PROGRESS",
    data = {
      state = state,
    },
  })
end)

RegisterNetEvent("Inventory:Container:Move", function(from, to)
  if _container ~= nil and _container.Slot == from then
    _container.Slot = to
  end
end)

RegisterNetEvent("Inventory:Container:Remove", function(data, from)
  if _container ~= nil and _container.Slot == from then
    Inventory.Close:All()
  end
end)

RegisterNetEvent("Inventory:Client:SetSlot", function(owner, type, slot)
  if SecondInventory?.owner == owner and SecondInventory?.invType == type then
    Inventory.Set.Secondary:Slot(slot)
  else
    Inventory.Set.Player:Slot(slot)
  end
end)

local runningId = 0
RegisterNetEvent("Inventory:Client:Changed", function(type, item, count, slot)
  if type == "holster" then
    local equipped = Weapons:GetEquippedItem()
    if equipped ~= nil and equipped.Slot == slot and equipped.Name == item then
      type = "Holstered"
    else
      type = "Equipped"
    end
  end
  runningId = runningId + 1
  SendNUIMessage({
    type = "ADD_ALERT",
    data = {
      alert = {
        id = runningId,
        type = type,
        item = item,
        count = count,
      },
    },
  })
end)

function OpenInventory()
  if Inventory:IsEnabled() then
    local playerPed = PlayerPedId()
    local plate
    local requestSecondary = false
    local isPedInVehicle = IsPedInAnyVehicle(playerPed, true)

    -- do trunk check here as well maybe?
    if isPedInVehicle then
      local v = GetVehiclePedIsIn(playerPed)
      if v ~= nil and v > 0 then
        local vin = Entity(v).state.VIN
        if vin ~= nil then
          SecondInventory = {
            netId = VehToNet(v),
            invType = 5,
            owner = vin,
            class = GetVehicleClass(v),
            model = GetEntityModel(v),
          }
          requestSecondary = true
        end
      end
    elseif _inInvPoly ~= nil then
      SecondInventory = { invType = _inInvPoly.inventory.invType, owner = _inInvPoly.inventory.owner }
      requestSecondary = true
    elseif not IsPedFalling(playerPed) and not IsPedClimbing(playerPed) and not IsPedDiving(playerPed) and not LocalPlayer.state.playingCasino then
      local p = promise.new()

      while GetEntitySpeed(playerPed) > 2.5 do
        Citizen.Wait(1)
      end

      if Inventory:IsEnabled() then
        exports["hrrp-base"]:CallbacksServer("Inventory:CheckIfNearDropZone", {}, function(dropzone)
          if dropzone ~= nil and not isPedInVehicle and not requestSecondary then
            p:resolve({ invType = 10, owner = dropzone.id, position = dropzone.position })
          else
            local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 0, -0.99))
            p:resolve({
              invType = 10,
              owner = string.format("%s:%s", math.ceil(x), math.ceil(y)),
              position = vector3(x, y, z),
            })
          end
        end)
        local s = Citizen.Await(p)
        if s ~= nil then
          SecondInventory = s
          requestSecondary = true
        end
      end
    end

    Inventory.Open:Player(requestSecondary)
    -- if requestSecondary then
    -- 	TriggerServerEvent("Inventory:Server:requestSecondaryInventory", SecondInventory)
    -- end
  end
end

RegisterNUICallback("MergeSlot", function(data, cb)
  cb("OK")
  data.class = SecondInventory.class
  data.model = SecondInventory.model
  data.inventory = SecondInventory

  exports["hrrp-base"]:CallbacksServer("Inventory:MergeItem", data, function(success)
    if success and success.success then
      if SecondInventory.netId then
        local veh = NetToVeh(SecondInventory.netId)
        if veh then
          local vEnt = Entity(veh)
          if vEnt and not vEnt.state.Owned and not vEnt.state.PleaseDoNotFuckingDelete then
            TriggerServerEvent("Vehicles:Server:StopDespawn", SecondInventory.netId)
          end
        end
      end
      if SecondInventory ~= nil and SecondInventory.invType == 10 and (data.ownerFrom ~= data.ownerTo) then
        dropAnim(data.invTypeTo == 10)
      end
    else
      if success and success.reason then
        exports['hrrp-hud']:NotificationError(success.reason, 3600)
      end
    end
  end)
end)

RegisterNUICallback("SwapSlot", function(data, cb)
  cb("OK")
  data.class = SecondInventory.class
  data.model = SecondInventory.model
  data.inventory = SecondInventory

  exports["hrrp-base"]:CallbacksServer("Inventory:SwapItem", data, function(success)
    if success and success.success then
      if SecondInventory.netId then
        local veh = NetToVeh(SecondInventory.netId)
        if veh then
          local vEnt = Entity(veh)
          if vEnt and not vEnt.state.Owned and not vEnt.state.PleaseDoNotFuckingDelete then
            TriggerServerEvent("Vehicles:Server:StopDespawn", SecondInventory.netId)
          end
        end
      end
      if SecondInventory ~= nil and SecondInventory.invType == 10 and (data.ownerFrom ~= data.ownerTo) then
        dropAnim(data.invTypeTo == 10)
      end
    else
      if success and success.reason then
        exports['hrrp-hud']:NotificationError(success.reason, 3600)
      end
    end
  end)
end)

RegisterNUICallback("MoveSlot", function(data, cb)
  cb("OK")
  data.class = SecondInventory.class
  data.model = SecondInventory.model
  data.inventory = SecondInventory

  exports["hrrp-base"]:CallbacksServer("Inventory:MoveItem", data, function(success)
    if success and success.success then
      if SecondInventory.netId then
        local veh = NetToVeh(SecondInventory.netId)
        if veh then
          local vEnt = Entity(veh)
          if vEnt and not vEnt.state.Owned and not vEnt.state.PleaseDoNotFuckingDelete then
            TriggerServerEvent("Vehicles:Server:StopDespawn", SecondInventory.netId)
          end
        end
      end
      if SecondInventory ~= nil and SecondInventory.invType == 10 and (data.ownerFrom ~= data.ownerTo) then
        dropAnim(data.invTypeTo == 10)
      end
    else
      if success and success.reason then
        exports['hrrp-hud']:NotificationError(success.reason, 3600)
      end
    end
  end)
end)

RegisterNUICallback("SendNotify", function(data, cb)
  cb("OK")
  if data then
    if data.alert == "success" then
      exports['hrrp-hud']:NotificationSuccess(data.message, data.time)
    elseif data.alert == "warning" then
      Notification:Warning(data.message, data.time)
    elseif data.alert == "error" then
      exports['hrrp-hud']:NotificationError(data.message, data.time)
    end
  end
end)

RegisterNUICallback("UseItem", function(data, cb)
  cb("OK")
  if LocalPlayer.state.doingAction then
    return
  end
  exports["hrrp-base"]:CallbacksServer("Inventory:UseItem", {
    slot = data.slot,
    owner = data.owner,
    invType = data.invType,
  }, function(success) end)
end)

RegisterNetEvent("Inventory:CloseUI", function()
  startCd()
  Inventory.Close:All()
  Inventory:Enable()
end)
