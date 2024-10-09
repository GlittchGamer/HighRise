GLOBAL_VEH = nil

IsInAnimation = false

_isPointing = false
_isCrouched = false

walkStyle = 'default'
facialExpression = 'default'
emoteBinds = {}

_doingStateAnimation = false

AddEventHandler('Animations:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
  Callbacks = exports['hrrp-base']:FetchComponent('Callbacks')
  Utils = exports['hrrp-base']:FetchComponent('Utils')
  Notification = exports['hrrp-base']:FetchComponent('Notification')
  Menu = exports['hrrp-base']:FetchComponent('Menu')
  Damage = exports['hrrp-base']:FetchComponent('Damage')
  Keybinds = exports['hrrp-base']:FetchComponent('Keybinds')
  Interaction = exports['hrrp-base']:FetchComponent('Interaction')
  Hud = exports['hrrp-base']:FetchComponent('Hud')
  Weapons = exports['hrrp-base']:FetchComponent('Weapons')
  ListMenu = exports['hrrp-base']:FetchComponent('ListMenu')
  Input = exports['hrrp-base']:FetchComponent('Input')
  Sounds = exports['hrrp-base']:FetchComponent('Sounds')
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['hrrp-base']:RequestDependencies('Animations', {
    'Callbacks',
    'Utils',
    'Notification',
    'Menu',
    'Damage',
    'Keybinds',
    'Interaction',
    'Hud',
    'Weapons',
    'ListMenu',
    'Input',
    'Sounds',
  }, function(error)
    if #error > 0 then return; end
    RetrieveComponents()
    RegisterKeybinds()

    RegisterChairTargets()

    Interaction:RegisterMenu("expressions", 'Expressions', "face-confounded", function()
      Interaction:Hide()
      ANIMATIONS:OpenExpressionsMenu()
    end)

    Interaction:RegisterMenu("walks", 'Walk Styles', "person-walking", function()
      Interaction:Hide()
      ANIMATIONS:OpenWalksMenu()
    end)

    RemoveEventHandler(setupEvent)
  end)
end)

AddEventHandler('Characters:Client:Spawn', function()
  ANIMATIONS.Emotes:Cancel()
  TriggerEvent('Animations:Client:StandUp', true, true)

  Citizen.CreateThread(function()
    while LocalPlayer.state.loggedIn do
      Citizen.Wait(5000)
      if not _isCrouched and not LocalPlayer.state.drunkMovement then
        ANIMATIONS.PedFeatures:RequestFeaturesUpdate()
      end
    end
  end)

  Citizen.CreateThread(function()
    while LocalPlayer.state.loggedIn do
      Citizen.Wait(5)
      DisableControlAction(0, 36, true)
      if IsDisabledControlJustPressed(0, 36) then
        ANIMATIONS.PedFeatures:ToggleCrouch()
      end
      if IsInAnimation and IsPedShooting(LocalPlayer.state.ped) then
        ANIMATIONS.Emotes:ForceCancel()
      end
    end
  end)
end)


RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
  ANIMATIONS.Emotes:ForceCancel()
  Citizen.Wait(20)

  LocalPlayer.state:set('anim', false, true)
end)

RegisterNetEvent('Vehicles:Client:EnterVehicle')
AddEventHandler('Vehicles:Client:EnterVehicle', function(veh)
  GLOBAL_VEH = veh
end)

RegisterNetEvent('Vehicles:Client:ExitVehicle')
AddEventHandler('Vehicles:Client:ExitVehicle', function()
  GLOBAL_VEH = nil
end)

RegisterNetEvent('Animations:Client:RecieveStoredAnimSettings')
AddEventHandler('Animations:Client:RecieveStoredAnimSettings', function(data)
  if data then
    walkStyle, facialExpression, emoteBinds = data.walk, data.expression, data.emoteBinds
    ANIMATIONS.PedFeatures:RequestFeaturesUpdate()
  else -- There is non stored and reset back to default
    walkStyle, facialExpression, emoteBinds = Config.DefaultSettings.walk, Config.DefaultSettings.expression, Config.DefaultSettings.emoteBinds
    ANIMATIONS.PedFeatures:RequestFeaturesUpdate()
  end
end)


function RegisterKeybinds()
  exports['hrrp-keybinds']:Add('pointing', 'b', 'keyboard', 'Pointing - Toggle', function()
    if _isPointing then
      StopPointing()
    else
      StartPointing()
    end
  end)

  exports['hrrp-keybinds']:Add('emote_cancel', 'x', 'keyboard', 'Emotes - Cancel Current', function()
    ANIMATIONS.Emotes:Cancel()

    TriggerEvent('Animations:Client:StandUp')
    TriggerEvent('Animations:Client:Selfie', false)
  end)

  -- Don't specify and key so then players can set it themselves if they want to use...
  exports['hrrp-keybinds']:Add('emote_menu', '', 'keyboard', 'Emotes - Open Menu', function()
    ANIMATIONS:OpenMainEmoteMenu()
  end)

  -- There are 5 emote binds and by default they use numbers 5, 6, 7, 8 and 9
  for bindNum = 1, 5 do
    exports['hrrp-keybinds']:Add('emote_bind_' .. bindNum, tostring(4 + bindNum), 'keyboard', 'Emotes - Bind #' .. bindNum, function()
      ANIMATIONS.EmoteBinds:Use(bindNum)
    end)
  end
end
