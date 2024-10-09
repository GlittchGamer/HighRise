AddEventHandler('Admin:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
  Callbacks = exports['hrrp-base']:FetchComponent('Callbacks')
  Utils = exports['hrrp-base']:FetchComponent('Utils')
  Logger = exports['hrrp-base']:FetchComponent('Logger')
  Menu = exports['hrrp-base']:FetchComponent('Menu')
  Notification = exports['hrrp-base']:FetchComponent('Notification')
  Status = exports['hrrp-base']:FetchComponent('Status')
  Jobs = exports['hrrp-base']:FetchComponent('Jobs')
  Keybinds = exports['hrrp-base']:FetchComponent('Keybinds')
  Vehicles = exports['hrrp-base']:FetchComponent('Vehicles')
  VOIP = exports['hrrp-base']:FetchComponent('VOIP')
  NetSync = exports['hrrp-base']:FetchComponent('NetSync')
  Sounds = exports['hrrp-base']:FetchComponent('Sounds')
end

ADMIN = {
  OpenMenu = function(self)
    OpenMenu()
  end,
  CopyClipboard = function(self, txt)
    CopyClipboard(txt)
  end,
}

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['hrrp-base']:RequestDependencies('Admin', {
    'Callbacks',
    'Utils',
    'Logger',
    'Menu',
    'Notification',
    'Status',
    'Jobs',
    'Keybinds',
    'Vehicles',
    'VOIP',
    'NetSync',
    'Sounds',
  }, function(error)
    if #error > 0 then return; end
    RetrieveComponents()

    exports['hrrp-keybinds']:Add('admin_menu', 'HOME', 'keyboard', '[Admin] Open Admin Menu', function()
      ADMIN:OpenMenu()
    end)

    exports['hrrp-keybinds']:Add('admin_noclip', 'END', 'keyboard', '[Admin] Toggle NoClip', function()
      exports["hrrp-base"]:CallbacksServer('Admin:NoClip', {
        active = not ADMIN.NoClip:IsActive()
      }, function(isAdmin)
        if isAdmin then
          ADMIN.NoClip:Toggle()
        end
      end)
    end)

    exports['hrrp-keybinds']:Add('admin_debug1', '', 'keyboard', '[Admin] Debug 1', function()
      DoAdminVehicleAction('repair_engine')
    end)

    exports['hrrp-keybinds']:Add('admin_debug2', '', 'keyboard', '[Admin] Debug 2', function()
      DoAdminVehicleAction('repair')
    end)

    exports['hrrp-keybinds']:Add('admin_debug3', '', 'keyboard', '[Admin] Debug IDs', function()
      if LocalPlayer.state.isDev then
        ToggleAdminPlayerIDs()
      end
    end)

    RemoveEventHandler(setupEvent)
  end)
end)

local function exportHandler(exportName, func)
  AddEventHandler(('__cfx_export_%s_%s'):format(GetCurrentResourceName(), exportName), function(setCB)
    setCB(function(...)
      return func(ADMIN, ...)
    end)
  end)
end

for k, v in pairs(ADMIN) do
  if type(v) == "function" then
    exportHandler(k, v)
  end
end

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
  ADMIN.NoClip:Stop() --!Fuck sake
  _drawingCoords = false
end)

function DrawShittyText(text)
  SetTextColour(186, 186, 186, 255)
  SetTextFont(4)
  SetTextScale(0.378, 0.378)
  SetTextWrap(0.0, 1.0)
  SetTextCentre(false)
  SetTextDropshadow(0, 0, 0, 0, 255)
  SetTextEdge(1, 0, 0, 0, 205)
  SetTextEntry("STRING")
  AddTextComponentString(text)
  DrawText(0.40, 0.00)
end

RegisterNetEvent('Admin:Client:Marker', function(x, y)
  SetNewWaypoint(x, y)
end)

RegisterNetEvent('Admin:Client:CopyCoords', function(action)
  local ped = PlayerPedId()
  local pedCoords = GetEntityCoords(ped)
  local pedHeading = GetEntityHeading(ped)
  local petRotation = GetEntityRotation(ped)

  if action == 'vec4' then
    CopyClipboard(string.format('vector4(%.3f, %.3f, %.3f, %.3f)', pedCoords.x, pedCoords.y, pedCoords.z, pedHeading))
  elseif action == 'vec2' then
    CopyClipboard(string.format('vector2(%.3f, %.3f)', pedCoords.x, pedCoords.y))
  elseif action == 'z' then
    CopyClipboard(string.format('%.3f', pedCoords.z))
  elseif action == 'h' then
    CopyClipboard(string.format('%.3f', pedHeading))
  elseif action == 'table' then
    CopyClipboard(string.format([[
            x = %.3f,
            y = %.3f,
            z = %.3f,
            h = %.3f,]], pedCoords.x, pedCoords.y, pedCoords.z, pedHeading))
  elseif action == 'rot' then
    CopyClipboard(string.format('vector3(%.3f, %.3f, %.3f)', petRotation.x, petRotation.y, petRotation.z))
  elseif action == 'cctv' then
    CopyClipboard(string.format('x = %.3f, y = %.3f, z = %.3f, r = { x = %.3f, y = %.3f, z = %.3f }', pedCoords.x, pedCoords.y, pedCoords.z, petRotation.x,
      petRotation.y, petRotation.z))
  else
    CopyClipboard(string.format('vector3(%.3f, %.3f, %.3f)', pedCoords.x, pedCoords.y, pedCoords.z))
  end
end)

RegisterNetEvent('Admin:Client:Recording', function(action)
  if action == 'record' then
    StartRecording(1)
  elseif action == 'stop' then
    StopRecordingAndSaveClip()
  elseif action == 'delete' then
    StopRecordingAndDiscardClip()
  elseif action == 'editor' then
    NetworkSessionLeaveSinglePlayer()
    ActivateRockstarEditor()
  end
end)

RegisterNetEvent('Admin:Client:ChangePed', function(model)
  local hash = GetHashKey(model)
  if IsModelValid(hash) then
    if not HasModelLoaded(hash) then
      RequestModel(hash)
      while not HasModelLoaded(hash) do
        Citizen.Wait(100)
      end
    end

    SetPlayerModel(PlayerId(), hash)
    SetPedDefaultComponentVariation(PlayerPedId())
    SetModelAsNoLongerNeeded(hash)
  end
end)

function DoAdminVehicleAction(action)
  local insideVehicle = GetVehiclePedIsIn(LocalPlayer.state.ped, false)
  if LocalPlayer.state.isDev and insideVehicle and insideVehicle > 0 and DoesEntityExist(insideVehicle) and NetworkHasControlOfEntity(insideVehicle) then
    exports["hrrp-base"]:CallbacksServer('Admin:CurrentVehicleAction', { action = action }, function(canDo)
      if canDo then
        if action == 'repair' then
          if Vehicles.Repair:Normal(insideVehicle) then

          end
        elseif action == 'repair_full' then
          if Vehicles.Repair:Full(insideVehicle) then

          end
        elseif action == 'repair_engine' then
          if Vehicles.Repair:Engine(insideVehicle) then

          end
        end
      end
    end)
  end
end
