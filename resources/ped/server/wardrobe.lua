AddEventHandler("Wardrobe:Shared:DependencyUpdate", RetrieveWardrobeComponents)
function RetrieveWardrobeComponents()
  Chat = exports['core']:FetchComponent("Chat")
  Fetch = exports['core']:FetchComponent("Fetch")
  Callbacks = exports['core']:FetchComponent("Callbacks")
  Middleware = exports['core']:FetchComponent("Middleware")
  Logger = exports['core']:FetchComponent("Logger")
  Ped = exports['core']:FetchComponent("Ped")
  Wardrobe = exports['core']:FetchComponent("Wardrobe")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies("Wardrobe", {
    "Chat",
    "Fetch",
    "Callbacks",
    "Middleware",
    "Locations",
    "Logger",
    "Ped",
    "Wardrobe",
  }, function(error)
    if #error > 0 then
      return
    end -- Do something to handle if not all dependencies loaded
    RetrieveWardrobeComponents()
    RegisterWardrobeCallbacks()
    RegisterWardrobeMiddleware()
    RegisterChatCommands()

    RemoveEventHandler(setupEvent)
  end)
end)

WARDROBE = {}
AddEventHandler("Proxy:Shared:RegisterReady", function()
  exports['core']:RegisterComponent("Wardrobe", WARDROBE)
end)

function RegisterChatCommands()
  Chat:RegisterAdminCommand("wardrobe", function(source, args, rawCommand)
    TriggerClientEvent("Wardrobe:Client:ShowBitch", source)
  end, {
    help = "Test Notification",
  })
end

function RegisterWardrobeMiddleware()
  Middleware:Add("Characters:Creating", function(source, cData)
    return { {
      Wardrobe = {},
    } }
  end)
end

function RegisterWardrobeCallbacks()
  exports['core']:CallbacksRegisterServer("Wardrobe:GetAll", function(source, data, cb)
    local player = exports['core']:FetchComponent("Fetch"):Source(source)
    local char = player:GetData("Character")
    local wardrobe = char:GetData("Wardrobe") or {}

    local wr = {}

    for k, v in ipairs(wardrobe) do
      table.insert(wr, {
        label = v.label,
      })
    end

    cb(wr)
  end)

  exports['core']:CallbacksRegisterServer("Wardrobe:Save", function(source, data, cb)
    local player = exports['core']:FetchComponent("Fetch"):Source(source)
    local char = player:GetData("Character")

    if char ~= nil then
      local ped = char:GetData("Ped")
      local wardrobe = char:GetData("Wardrobe") or {}

      local outfit = {
        label = data.name,
        data = ped.customization,
      }
      table.insert(wardrobe, outfit)
      char:SetData("Wardrobe", wardrobe)
      cb(true)
    else
      cb(false)
    end
  end)

  exports['core']:CallbacksRegisterServer("Wardrobe:SaveExisting", function(source, data, cb)
    local player = exports['core']:FetchComponent("Fetch"):Source(source)
    local char = player:GetData("Character")

    if char ~= nil then
      local ped = char:GetData("Ped")
      local wardrobe = char:GetData("Wardrobe") or {}

      if wardrobe[data] ~= nil then
        wardrobe[data].data = ped.customization
        char:SetData("Wardrobe", wardrobe)
        cb(true)
      else
        cb(false)
      end
    else
      cb(false)
    end
  end)

  exports['core']:CallbacksRegisterServer("Wardrobe:Rename", function(source, data, cb)
    local player = exports['core']:FetchComponent("Fetch"):Source(source)
    local char = player:GetData("Character")
    if char ~= nil then
      local ped = char:GetData("Ped")
      local wardrobe = char:GetData("Wardrobe") or {}
      if wardrobe[data.index] ~= nil then
        wardrobe[data.index].label = data.name
        char:SetData("Wardrobe", wardrobe)
        cb(true)
      else
        cb(false)
      end
    else
      cb(false)
    end
  end)

  exports['core']:CallbacksRegisterServer("Wardrobe:MoveUp", function(source, _data, cb)
    local player = exports['core']:FetchComponent("Fetch"):Source(source)
    local char = player:GetData("Character")
    local data = _data
    if char ~= nil then
      local ped = char:GetData("Ped")
      local wardrobe = char:GetData("Wardrobe") or {}
      if wardrobe[data.index] ~= nil then
        -- Move up
        char:SetData("Wardrobe", moveItem(wardrobe, data.index, true))
        cb(true)
      else
        cb(false)
      end
    else
      cb(false)
    end
  end)

  exports['core']:CallbacksRegisterServer("Wardrobe:MoveDown", function(source, _data, cb)
    local player = exports['core']:FetchComponent("Fetch"):Source(source)
    local char = player:GetData("Character")
    local data = _data
    if char ~= nil then
      local ped = char:GetData("Ped")
      local wardrobe = char:GetData("Wardrobe") or {}
      if wardrobe[data.index] ~= nil then
        -- Move Down
        char:SetData("Wardrobe", moveItem(wardrobe, data.index, false))
        cb(true)
      else
        cb(false)
      end
    else
      cb(false)
    end
  end)

  exports['core']:CallbacksRegisterServer("Wardrobe:Equip", function(source, data, cb)
    local player = exports['core']:FetchComponent("Fetch"):Source(source)
    local char = player:GetData("Character")
    if char ~= nil then
      local outfit = char:GetData("Wardrobe")[tonumber(data)]
      if outfit ~= nil then
        Ped:ApplyOutfit(source, outfit)
        cb(true)
      else
        cb(false)
      end
    else
      cb(false)
    end
  end)

  exports['core']:CallbacksRegisterServer("Wardrobe:Share", function(source, data, cb)
    local player = exports['core']:FetchComponent("Fetch"):Source(source)
    local char = player:GetData("Character")
    if char ~= nil then
      local outfit = char:GetData("Wardrobe")[tonumber(data)]
      if outfit ~= nil then
        local myPed = GetPlayerPed(source)
        local myCoords = GetEntityCoords(myPed)
        local myBucket = GetPlayerRoutingBucket(source)
        for k, v in pairs(Fetch:All()) do
          local tSource = v:GetData("Source")
          local tPed = GetPlayerPed(tSource)
          local coords = GetEntityCoords(tPed)
          if tSource ~= source and #(myCoords - coords) <= 5.0 and GetPlayerRoutingBucket(tSource) == myBucket then
            exports['core']:CallbacksClient(tSource, "Wardrobe:Sharing:Begin", {
              label = outfit?.label,
              components = outfit?.data?.components,
              props = outfit?.data?.props
            }, function(acceptedOutfit)
              if acceptedOutfit then
                local tChar = v:GetData("Character")
                if tChar ~= nil then
                  local ped = tChar:GetData("Ped")
                  local wardrobe = tChar:GetData("Wardrobe") or {}

                  local newOutfit = {
                    label = outfit?.label,
                    data = ped.customization,
                  }

                  if outfit.data.components then
                    local originalHair = newOutfit.data.components.hair
                    newOutfit.data.components = outfit.data.components
                    newOutfit.data.components.hair = originalHair -- This is used so our characters hair isn't overidden by the outfit hair
                  end

                  if outfit?.data?.props then
                    newOutfit.data.props = outfit.data.props
                  end

                  table.insert(wardrobe, newOutfit)
                  tChar:SetData("Wardrobe", wardrobe)
                end
              end
            end)

            cb(true)
          end
        end
      else
        cb(false)
      end
    else
      cb(false)
    end
  end)

  exports['core']:CallbacksRegisterServer("Wardrobe:Delete", function(source, data, cb)
    local player = exports['core']:FetchComponent("Fetch"):Source(source)
    local char = player:GetData("Character")
    if char ~= nil then
      local wardrobe = char:GetData("Wardrobe") or {}
      table.remove(wardrobe, data)
      char:SetData("Wardrobe", wardrobe)
      cb(true)
    else
      cb(false)
    end
  end)
end

function moveItem(tables, oldindex, up) -- Well this looks like ass lmfao
  local function swap(_tables, new)
    _tables[oldindex], _tables[new] = _tables[new], _tables[oldindex]
    return _tables
  end
  if up then
    if oldindex == 1 then
      return tables;                    -- Already at top, ignore.
    else
      return swap(tables, oldindex - 1) -- Move up.
    end
  else
    if oldindex ~= #tables then
      return swap(tables, oldindex + 1) -- Move down.
    else
      return tables;                    -- Already at bottom, ignore.
    end
  end
end
