_loadedScenes = {}
_nearbyScenes = {}

_hiddenScenes = {}

AddEventHandler('Scenes:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
  Logger = exports['core']:FetchComponent('Logger')
  Fetch = exports['core']:FetchComponent('Fetch')
  Callbacks = exports['core']:FetchComponent('Callbacks')
  Game = exports['core']:FetchComponent('Game')
  Utils = exports['core']:FetchComponent('Utils')
  Notification = exports['core']:FetchComponent('Notification')
  Polyzone = exports['core']:FetchComponent('Polyzone')
  Jobs = exports['core']:FetchComponent('Jobs')
  Weapons = exports['core']:FetchComponent('Weapons')
  Progress = exports['core']:FetchComponent('Progress')
  Vehicles = exports['core']:FetchComponent('Vehicles')
  ListMenu = exports['core']:FetchComponent('ListMenu')
  Action = exports['core']:FetchComponent('Action')
  Sounds = exports['core']:FetchComponent('Sounds')
  Scenes = exports['core']:FetchComponent('Scenes')
  Menu = exports['core']:FetchComponent('Menu')
  Input = exports['core']:FetchComponent('Input')
  Keybinds = exports['core']:FetchComponent('Keybinds')
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies('Scenes', {
    'Logger',
    'Fetch',
    'Callbacks',
    'Game',
    'Menu',
    'Notification',
    'Utils',
    'Polyzone',
    'Jobs',
    'Weapons',
    'Progress',
    'Vehicles',
    'ListMenu',
    'Action',
    'Sounds',
    'Scenes',
    'Input',
    'Keybinds',
  }, function(error)
    if #error > 0 then return; end
    RetrieveComponents()

    exports['keybinds']:Add('scene_create', '', 'keyboard', 'Scenes - Create Scene', function()
      _SCENES:BeginCreation()
    end)

    RemoveEventHandler(setupEvent)
  end)
end)

RegisterNetEvent('Characters:Client:Spawn')
AddEventHandler('Characters:Client:Spawn', function()
  Citizen.CreateThread(function()
    while LocalPlayer.state.loggedIn do
      Citizen.Wait(2000)
      local playerCoords = GetEntityCoords(LocalPlayer.state.ped)
      _nearbyScenes = {}
      collectgarbage()

      for k, v in pairs(_loadedScenes) do
        if (#(playerCoords - v.coords) <= 75.0) and (v.route == LocalPlayer.state.currentRoute) then
          table.insert(_nearbyScenes, v)
        end
      end
    end
  end)

  Citizen.CreateThread(function()
    while LocalPlayer.state.loggedIn do
      if #_nearbyScenes > 0 then
        local playerCoords = GetEntityCoords(LocalPlayer.state.ped)
        for k, v in ipairs(_nearbyScenes) do
          if #(playerCoords - v.coords) <= v.distance and not _hiddenScenes[v._id] then
            DrawScene(v)
          end
        end
      else
        Citizen.Wait(250)
      end
      Citizen.Wait(3)
    end
  end)
end)

RegisterNetEvent('Scenes:Client:ReceiveScenes', function(scenes)
  for k, v in pairs(scenes) do
    if v and v.coords then
      local decodedCoords = json.decode(v.coords)
      v.coords = vector3(decodedCoords.x, decodedCoords.y, decodedCoords.z)
    end
  end

  _loadedScenes = scenes
end)

RegisterNetEvent('Scenes:Client:AddScene', function(id, scene)
  scene.coords = vector3(scene.coords.x, scene.coords.y, scene.coords.z)
  _loadedScenes[id] = scene
end)

RegisterNetEvent('Scenes:Client:RemoveScene', function(id)
  _loadedScenes[id] = nil
end)

RegisterNetEvent('Scenes:Client:RemoveScenes', function(ids)
  for k, v in ipairs(ids) do
    _loadedScenes[v] = nil
  end
end)

_creationOpen = false
_creationMenu = nil

_SCENES = {
  BeginCreation = function(self, text, staff)
    if _creationOpen then
      return
    end

    local hitting, endCoords, entity = GetEntityPlayerIsLookingAt(15.0, LocalPlayer.state.ped)

    if not hitting then
      return exports['hud']:NotificationError('Cannot Place Here')
    end

    if #(GetEntityCoords(LocalPlayer.state.ped) - endCoords) > 5.0 then
      return exports['hud']:NotificationError('Cannot Place That Far Away')
    end

    if IsEntityAVehicle(entity) or IsEntityAPed(entity) then
      return exports['hud']:NotificationError('Cannot Place On a Vehicle or Person')
    end

    Input:Show(
      'Scene Creation',
      'Scene Text. Use ~n~ For a Newline',
      {
        {
          id = 'text',
          type = 'multiline',
          options = {
            inputProps = {
              value = text,
              maxLength = 290,
            },
          },
        },
      },
      'Scenes:Client:OpenOptionsMenu',
      {
        staff = staff,
        coords = endCoords,
        entity = entity,
      }
    )
  end,
  Deletion = function(self)
    if _nearbyScenes and #_nearbyScenes > 0 then
      local hitting, endCoords, entity = GetEntityPlayerIsLookingAt(15.0, LocalPlayer.state.ped)
      if hitting and endCoords then
        local pedCoords = GetEntityCoords(LocalPlayer.state.ped)
        local lastDist = nil
        local lastId = nil
        for k, v in pairs(_nearbyScenes) do
          local dist = #(pedCoords - v.coords)
          if (not lastDist) or (lastDist and dist < lastDist) then
            lastDist = dist
            lastId = v._id
          end
        end

        exports['core']:CallbacksServer('Scenes:Delete', lastId, function(success, invalidPermissions)
          if success then
            exports['hud']:NotificationSuccess('Scene Deleted')
          else
            if invalidPermissions then
              exports['hud']:NotificationError('Invalid Permissions to Delete This Scene')
            else
              exports['hud']:NotificationError('Failed to Delete Scene')
            end
          end
        end)
      end
    end
  end,
  Edit = function(self)
    if _nearbyScenes and #_nearbyScenes > 0 then
      local hitting, endCoords, entity = GetEntityPlayerIsLookingAt(15.0, LocalPlayer.state.ped)
      if hitting and endCoords then
        local pedCoords = GetEntityCoords(LocalPlayer.state.ped)
        local lastDist = nil
        local lastId = nil
        for k, v in pairs(_nearbyScenes) do
          local dist = #(pedCoords - v.coords)
          if (not lastDist) or (lastDist and dist < lastDist) then
            lastDist = dist
            lastId = v._id
          end
        end

        exports['core']:CallbacksServer('Scenes:CanEdit', lastId, function(success, isStaff)
          if success then
            EditScene(lastId, _loadedScenes[lastId], { staff = isStaff })
          else
            exports['hud']:NotificationError('Invalid Permissions to Edit This Scene')
          end
        end)
      end
    end
  end,
}

_lastData = nil

AddEventHandler('Scenes:Client:OpenOptionsMenu', function(values, data)
  if _creationOpen then return; end
  local creatingSceneData = deepcopy(_defaultSceneData)

  if _lastData then
    creatingSceneData = _lastData
  end

  creatingSceneData.text.text = values.text
  creatingSceneData.coords = vector3(data.coords.x, data.coords.y, data.coords.z)
  creatingSceneData.route = LocalPlayer.state.currentRoute

  _creationMenu = exports['menu']:Create('scenes', 'Scene Creation', function()
    _creationOpen = true
    Citizen.CreateThread(function()
      while _creationOpen do
        DrawScene(creatingSceneData)
        Citizen.Wait(2)
      end
    end)

    Citizen.CreateThread(function()
      while _creationOpen do
        if (#(GetEntityCoords(LocalPlayer.state.ped) - creatingSceneData.coords) > 10.0) then
          exports['hud']:NotificationError('Scene Creation Cancelled - Too Far Away')

          _creationMenu:Close()
          break
        end
        Citizen.Wait(2500)
      end
    end)
  end, function()
    _creationMenu = nil
    _creationOpen = false
    collectgarbage()
  end, true)

  _creationMenu.Add:Text('The Scene Will Be Created Where Your Camera is Pointed<br>Press SHIFT to Toggle Control of the Camera',
    { 'pad', 'code', 'center', 'textLarge' })

  _creationMenu.Add:Input('Scene Text', {
    disabled = false,
    max = 290,
    current = creatingSceneData.text.text,
  }, function(data)
    creatingSceneData.text.text = data.data.value
  end)

  -- Text Font

  local fontMenuList = {}

  for k, v in ipairs(_sceneFonts) do
    table.insert(fontMenuList, {
      label = v.name,
      value = k,
    })
  end

  _creationMenu.Add:Select('Text Font', {
    disabled = false,
    current = creatingSceneData.text.font,
    list = fontMenuList,
  }, function(data)
    creatingSceneData.text.font = data.data.value
  end)

  _creationMenu.Add:Slider('Font Size', {
    current = creatingSceneData.text.size,
    min = 0.25,
    max = 0.7,
    step = 0.05,
  }, function(data)
    creatingSceneData.text.size = tonumber(data.data.value) or creatingSceneData.text.size
  end)

  _creationMenu.Add:ColorPicker({
    current = creatingSceneData.text.color
  }, function(data)
    creatingSceneData.text.color = data.data.color
  end)

  _creationMenu.Add:Select('Text Outline', {
    disabled = false,
    current = creatingSceneData.text.outline,
    list = {
      { label = 'None',    value = false },
      { label = 'Outline', value = 'outline' },
      { label = 'Shadow',  value = 'shadow' },
    },
  }, function(data)
    creatingSceneData.text.outline = data.data.value
  end)

  local backgroundMenuList = {
    { label = 'None', value = 0 }
  }

  for k, v in ipairs(_sceneBackgrounds) do
    table.insert(backgroundMenuList, {
      label = v.name,
      value = k,
    })
  end

  _creationMenu.Add:Select('Background', {
    disabled = false,
    current = creatingSceneData.background.type,
    list = backgroundMenuList,
  }, function(data)
    creatingSceneData.background.type = data.data.value
  end)

  _creationMenu.Add:ColorPicker({
    current = creatingSceneData.background.color
  }, function(data)
    creatingSceneData.background.color = data.data.color
  end)

  _creationMenu.Add:Slider('Adjust Background Height', {
    current = creatingSceneData.background.h,
    min = -0.05,
    max = 0.6,
    step = 0.01,
  }, function(data)
    creatingSceneData.background.h = tonumber(data.data.value) or creatingSceneData.background.h
  end)

  _creationMenu.Add:Slider('Adjust Background Width', {
    current = creatingSceneData.background.w,
    min = -0.05,
    max = 0.5,
    step = 0.01,
  }, function(data)
    creatingSceneData.background.w = tonumber(data.data.value) or creatingSceneData.background.w
  end)

  _creationMenu.Add:Slider('Adjust Background X', {
    current = creatingSceneData.background.x,
    min = -0.05,
    max = 0.05,
    step = 0.005,
  }, function(data)
    creatingSceneData.background.x = tonumber(data.data.value) or creatingSceneData.background.x
  end)

  _creationMenu.Add:Slider('Adjust Background Y', {
    current = creatingSceneData.background.y,
    min = -0.05,
    max = 0.05,
    step = 0.005,
  }, function(data)
    creatingSceneData.background.y = tonumber(data.data.value) or creatingSceneData.background.y
  end)

  _creationMenu.Add:Slider('Adjust Background Rotation', {
    current = creatingSceneData.background.rotation,
    min = 0,
    max = 180,
    step = 1,
  }, function(data)
    creatingSceneData.background.rotation = tonumber(data.data.value) or creatingSceneData.background.rotation
  end)

  _creationMenu.Add:Slider('Distance Visible', {
    current = creatingSceneData.distance,
    min = 1.0,
    max = 10.0,
    step = 0.5,
  }, function(data)
    creatingSceneData.distance = tonumber(data.data.value) or creatingSceneData.distance
  end)

  local timeList = {
    { label = '1 Hour',   value = 1 },
    { label = '2 Hours',  value = 2 },
    { label = '3 Hours',  value = 3 },
    { label = '6 Hours',  value = 6 },
    { label = '12 Hours', value = 12 },
    { label = '24 Hours', value = 24 },
  }

  if data.staff then
    table.insert(timeList, {
      label = 'Permanent (Staff)',
      value = false,
    })
  end

  _creationMenu.Add:Select('Time Length', {
    disabled = false,
    current = creatingSceneData.length,
    list = timeList,
  }, function(data)
    if data.data.value then
      creatingSceneData.length = tonumber(data.data.value) or creatingSceneData.length
    else
      creatingSceneData.length = false
    end
  end)

  _creationMenu.Add:Button('Create Scene', { success = true }, function()
    _lastData = creatingSceneData

    exports['core']:CallbacksServer('Scenes:Create', {
      scene = creatingSceneData,
      data = data,
    }, function(success)
      if success then
        exports['hud']:NotificationSuccess('Scene Placed')
      else
        exports['hud']:NotificationError('Failed to Place Scene')
      end
    end)

    _creationMenu:Close()
  end)

  _creationMenu:Show()
end)

function EditScene(id, fuckface, data)
  if _creationOpen then return; end
  local creatingSceneData = deepcopy(fuckface)

  _creationMenu = exports['menu']:Create('scenes', 'Edit Scene', function()
    _creationOpen = true
    _hiddenScenes[fuckface._id] = true
    Citizen.CreateThread(function()
      while _creationOpen do
        DrawScene(creatingSceneData)
        Citizen.Wait(2)
      end

      _hiddenScenes[fuckface._id] = nil
    end)

    Citizen.CreateThread(function()
      while _creationOpen do
        if (#(GetEntityCoords(LocalPlayer.state.ped) - creatingSceneData.coords) > 10.0) then
          exports['hud']:NotificationError('Scene Edit Cancelled - Too Far Away')

          _creationMenu:Close()
          break
        end
        Citizen.Wait(2500)
      end
    end)
  end, function()
    _creationMenu = nil
    _creationOpen = false
    collectgarbage()
  end, true)


  _creationMenu.Add:Input('Scene Text', {
    disabled = false,
    max = 290,
    current = creatingSceneData.text.text,
  }, function(data)
    creatingSceneData.text.text = data.data.value
  end)

  -- Text Font

  local fontMenuList = {}

  for k, v in ipairs(_sceneFonts) do
    table.insert(fontMenuList, {
      label = v.name,
      value = k,
    })
  end

  _creationMenu.Add:Select('Text Font', {
    disabled = false,
    current = creatingSceneData.text.font,
    list = fontMenuList,
  }, function(data)
    creatingSceneData.text.font = data.data.value
  end)

  _creationMenu.Add:Slider('Font Size', {
    current = creatingSceneData.text.size,
    min = 0.25,
    max = 0.7,
    step = 0.05,
  }, function(data)
    creatingSceneData.text.size = tonumber(data.data.value) or creatingSceneData.text.size
  end)

  _creationMenu.Add:ColorPicker({
    current = creatingSceneData.text.color
  }, function(data)
    creatingSceneData.text.color = data.data.color
  end)

  _creationMenu.Add:Select('Text Outline', {
    disabled = false,
    current = creatingSceneData.text.outline,
    list = {
      { label = 'None',    value = false },
      { label = 'Outline', value = 'outline' },
      { label = 'Shadow',  value = 'shadow' },
    },
  }, function(data)
    creatingSceneData.text.outline = data.data.value
  end)

  local backgroundMenuList = {
    { label = 'None', value = 0 }
  }

  for k, v in ipairs(_sceneBackgrounds) do
    table.insert(backgroundMenuList, {
      label = v.name,
      value = k,
    })
  end

  _creationMenu.Add:Select('Background', {
    disabled = false,
    current = creatingSceneData.background.type,
    list = backgroundMenuList,
  }, function(data)
    creatingSceneData.background.type = data.data.value
  end)

  _creationMenu.Add:ColorPicker({
    current = creatingSceneData.background.color
  }, function(data)
    creatingSceneData.background.color = data.data.color
  end)

  _creationMenu.Add:Slider('Adjust Background Height', {
    current = creatingSceneData.background.h,
    min = -0.05,
    max = 0.6,
    step = 0.01,
  }, function(data)
    creatingSceneData.background.h = tonumber(data.data.value) or creatingSceneData.background.h
  end)

  _creationMenu.Add:Slider('Adjust Background Width', {
    current = creatingSceneData.background.w,
    min = -0.05,
    max = 0.5,
    step = 0.01,
  }, function(data)
    creatingSceneData.background.w = tonumber(data.data.value) or creatingSceneData.background.w
  end)

  _creationMenu.Add:Slider('Adjust Background X', {
    current = creatingSceneData.background.x,
    min = -0.05,
    max = 0.05,
    step = 0.005,
  }, function(data)
    creatingSceneData.background.x = tonumber(data.data.value) or creatingSceneData.background.x
  end)

  _creationMenu.Add:Slider('Adjust Background Y', {
    current = creatingSceneData.background.y,
    min = -0.05,
    max = 0.05,
    step = 0.005,
  }, function(data)
    creatingSceneData.background.y = tonumber(data.data.value) or creatingSceneData.background.y
  end)

  _creationMenu.Add:Slider('Adjust Background Rotation', {
    current = creatingSceneData.background.rotation,
    min = 0,
    max = 180,
    step = 1,
  }, function(data)
    creatingSceneData.background.rotation = tonumber(data.data.value) or creatingSceneData.background.rotation
  end)

  _creationMenu.Add:Slider('Distance Visible', {
    current = creatingSceneData.distance,
    min = 1.0,
    max = 10.0,
    step = 0.5,
  }, function(data)
    creatingSceneData.distance = tonumber(data.data.value) or creatingSceneData.distance
  end)

  local timeList = {
    { label = '1 Hour',   value = 1 },
    { label = '2 Hours',  value = 2 },
    { label = '3 Hours',  value = 3 },
    { label = '6 Hours',  value = 6 },
    { label = '12 Hours', value = 12 },
    { label = '24 Hours', value = 24 },
  }

  if data.staff then
    table.insert(timeList, {
      label = 'Permanent (Staff)',
      value = false,
    })
  end

  _creationMenu.Add:Select('Time Length', {
    disabled = false,
    current = creatingSceneData.length,
    list = timeList,
  }, function(data)
    if data.data.value then
      creatingSceneData.length = tonumber(data.data.value) or creatingSceneData.length
    else
      creatingSceneData.length = false
    end
  end)

  _creationMenu.Add:Button('Edit Scene', { success = true }, function()
    exports['core']:CallbacksServer('Scenes:Edit', {
      id = id,
      scene = creatingSceneData,
      data = data,
    }, function(success)
      if success then
        exports['hud']:NotificationSuccess('Scene Edited')
      else
        exports['hud']:NotificationError('Failed to Edit Scene')
      end
    end)

    _creationMenu:Close()
  end)

  _creationMenu:Show()
end

AddEventHandler('Proxy:Shared:RegisterReady', function()
  exports['core']:RegisterComponent('Scenes', _SCENES)
end)

RegisterNetEvent('Scenes:Client:Creation', function(args, asStaff)
  _SCENES:BeginCreation(#args > 0 and table.concat(args, ' ') or nil, asStaff)
end)

RegisterNetEvent('Scenes:Client:Deletion', function()
  _SCENES:Deletion()
end)

RegisterNetEvent('Scenes:Client:StartEdit', function()
  _SCENES:Edit()
end)

Citizen.CreateThread(function()
  while not HasStreamedTextureDictLoaded('arpscenes') do
    Citizen.Wait(100)
    RequestStreamedTextureDict('arpscenes', true)
  end
end)
