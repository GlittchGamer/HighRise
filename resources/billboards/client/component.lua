AddEventHandler("Billboards:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Logger = exports['core']:FetchComponent("Logger")
  Fetch = exports['core']:FetchComponent("Fetch")
  Callbacks = exports['core']:FetchComponent("Callbacks")
  Game = exports['core']:FetchComponent("Game")
  Utils = exports['core']:FetchComponent("Utils")
  Notification = exports['core']:FetchComponent("Notification")
  Polyzone = exports['core']:FetchComponent("Polyzone")
  Jobs = exports['core']:FetchComponent("Jobs")
  Weapons = exports['core']:FetchComponent("Weapons")
  Progress = exports['core']:FetchComponent("Progress")
  Vehicles = exports['core']:FetchComponent("Vehicles")
  ListMenu = exports['core']:FetchComponent("ListMenu")
  Action = exports['core']:FetchComponent("Action")
  Sounds = exports['core']:FetchComponent("Sounds")
  PedInteraction = exports['core']:FetchComponent("PedInteraction")
  Blips = exports['core']:FetchComponent("Blips")
  Keybinds = exports['core']:FetchComponent("Keybinds")
  Minigame = exports['core']:FetchComponent("Minigame")
  Input = exports['core']:FetchComponent("Input")
  Interaction = exports['core']:FetchComponent("Interaction")
  Inventory = exports['core']:FetchComponent("Inventory")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies("Billboards", {
    "Logger",
    "Fetch",
    "Callbacks",
    "Game",
    "Menu",
    "Notification",
    "Utils",
    "Polyzone",
    "Jobs",
    "Weapons",
    "Progress",
    "Vehicles",
    "ListMenu",
    "Action",
    "Sounds",
    "PedInteraction",
    "Blips",
    "Keybinds",
    "Minigame",
    "Input",
    "Interaction",
    "Inventory",
  }, function(error)
    if #error > 0 then return; end
    RetrieveComponents()

    RemoveEventHandler(setupEvent)
    -- print('testing biatch')
    -- local dui = CreateBillboardDUI('https://i.imgur.com/Zlf40QZ.png', 1024, 512)
    -- AddReplaceTexture('ch2_03b_cg2_03b_bb', 'ch2_03b_bb_lowdown', dui.dictionary, dui.texture)

    -- Citizen.Wait(10000)

    -- print(dui.id)

    -- ReleaseBillboardDUI(dui.id)
    -- RemoveReplaceTexture('ch2_03b_cg2_03b_bb', 'ch2_03b_bb_lowdown')

    StartUp()
  end)
end)

local started = false
local _billboardDUIs = {}

function StartUp()
  if started then
    return
  end

  started = true

  for k, v in pairs(_billboardConfig) do
    v.url = GlobalState[string.format("Billboards:%s", k)]
  end
end

AddEventHandler('Characters:Client:Spawn', function()
  Citizen.CreateThread(function()
    while LocalPlayer.state.loggedIn do
      for k, v in pairs(_billboardConfig) do
        local dist = #(GetEntityCoords(LocalPlayer.state.ped) - v.coords)
        if dist <= v.range then
          if not _billboardDUIs[k] and v.url then
            local createdDui = CreateBillboardDUI(v.url, v.width, v.height)
            AddReplaceTexture(v.originalDictionary, v.originalTexture, createdDui.dictionary, createdDui.texture)

            _billboardDUIs[k] = createdDui
          end
        elseif _billboardDUIs[k] then
          ReleaseBillboardDUI(_billboardDUIs[k].id)
          RemoveReplaceTexture(v.originalDictionary, v.originalTexture)
          _billboardDUIs[k] = nil
        end
      end
      Citizen.Wait(1500)
    end
  end)
end)


RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
  for k, v in pairs(_billboardConfig) do
    if _billboardDUIs[k] then
      ReleaseBillboardDUI(_billboardDUIs[k].id)
      RemoveReplaceTexture(v.originalDictionary, v.originalTexture)
      _billboardDUIs[k] = nil
    end
  end
end)

RegisterNetEvent("Billboards:Client:UpdateBoardURL", function(id, url)
  if not _billboardConfig[id] then
    return
  end

  if _billboardDUIs[id] then
    if url then
      UpdateBillboardDUI(_billboardDUIs[id].id, url)
      AddReplaceTexture(_billboardConfig[id].originalDictionary, _billboardConfig[id].originalTexture, _billboardDUIs[id].dictionary, _billboardDUIs[id].texture)
    else
      ReleaseBillboardDUI(_billboardDUIs[id].id)
      RemoveReplaceTexture(_billboardConfig[id].originalDictionary, _billboardConfig[id].originalTexture)
      _billboardDUIs[id] = nil
    end
  end

  _billboardConfig[id].url = url
end)
