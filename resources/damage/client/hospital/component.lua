_curBed = nil
_done = false

_healEnd = nil
_leavingBed = false

AddEventHandler("Hospital:Shared:DependencyUpdate", HospitalComponents)
function HospitalComponents()
  Callbacks = exports['core']:FetchComponent("Callbacks")
  Notification = exports['core']:FetchComponent("Notification")
  Damage = exports['core']:FetchComponent("Damage")
  Notification = exports['core']:FetchComponent("Notification")
  Hospital = exports['core']:FetchComponent("Hospital")
  Progress = exports['core']:FetchComponent("Progress")
  PedInteraction = exports['core']:FetchComponent("PedInteraction")
  Escort = exports['core']:FetchComponent("Escort")
  Action = exports['core']:FetchComponent("Action")
  Polyzone = exports['core']:FetchComponent("Polyzone")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies("Hospital", {
    "Callbacks",
    "Notification",
    "Damage",
    "Hospital",
    "Progress",
    "PedInteraction",
    "Escort",
    "Polyzone",
    "Action",
  }, function(error)
    if #error > 0 then
      return
    end
    HospitalComponents()
    Init()

    while GlobalState["HiddenHospital"] == nil do
      Citizen.Wait(5)
    end

    exports['pedinteraction']:Add("HiddenHospital", `s_m_m_doctor_01`, GlobalState["HiddenHospital"].coords, GlobalState["HiddenHospital"].heading, 25.0, {
      {
        icon = "heart-pulse",
        text = "Revive Escort (20 $PLEB)",
        event = "Hospital:Client:HiddenRevive",
        data = LocalPlayer.state.isEscorting or {},
        isEnabled = function()
          if LocalPlayer.state.isEscorting ~= nil and not LocalPlayer.state.isDead then
            local ps = Player(LocalPlayer.state.isEscorting).state
            return ps.isDead and not ps.deadData?.isMinor
          else
            return false
          end
        end,
      },
    }, 'suitcase-medical', 'CODE_HUMAN_MEDIC_KNEEL')

    exports['polyzonehandler']:PolyZoneCreateBox('hospital-check-in-zone', vector3(-436.09, -326.23, 34.91), 2.0, 3.0, {
      heading = 338,
      --debugPoly=true,
      minZ = 33.91,
      maxZ = 36.31
    }, {})

    exports['ox_target']:TargetingZonesAddBox("icu-checkout", "bell-concierge", vector3(-492.49, -336.15, 69.52), 0.8, 7.2, {
      name = "hospital",
      heading = 353,
      --debugPoly=true,
      minZ = 68.52,
      maxZ = 70.52
    }, {
      {
        icon = "bell-concierge",
        text = "Request Personnel",
        event = "Hospital:Client:RequestEMS",
        isEnabled = function()
          return (LocalPlayer.state.Character:GetData("ICU") ~= nil and not LocalPlayer.state.Character:GetData("ICU").Released) and
              (not _done or _done < GetCloudTimeAsInt())
        end,
      }
    })

    RemoveEventHandler(setupEvent)
  end)
end)

AddEventHandler("Hospital:Client:RequestEMS", function()
  if not _done or _done < GetCloudTimeAsInt() then
    TriggerServerEvent("EmergencyAlerts:Server:DoPredefined", "icurequest")
    _done = GetCloudTimeAsInt() + (60 * 10)
  end
end)

AddEventHandler('Proxy:Shared:RegisterReady', function() --! Complete
  exports['core']:RegisterComponent('Hospital', HOSPITAL)
end)

local _bedId = nil
HOSPITAL = {
  CheckIn = function(self)
    exports['core']:CallbacksServer('Hospital:Treat', {}, function(bed)
      if bed ~= nil then
        _countdown = Config.HealTimer
        LocalPlayer.state:set("isHospitalized", true, true)
        self:SendToBed(Config.Beds[bed], false, bed)
      else
        exports['hud']:NotificationError('No Beds Available')
      end
    end)
  end,
  SendToBed = function(self, bed, isRp, bedId)
    local fuck = false

    if bedId then
      local p = promise.new()
      exports['core']:CallbacksServer('Hospital:OccupyBed', bedId, function(s)
        p:resolve(s)
      end)

      fuck = Citizen.Await(p)
    else
      fuck = true
    end

    _bedId = bedId

    if bed ~= nil and fuck then
      SetBedCam(bed)
      if isRp then
        _healEnd = GetCloudTimeAsInt()
        Hud.DeathTexts:Show("hospital_rp", GetCloudTimeAsInt(), _healEnd, "primary_action")
      else
        _healEnd = GetCloudTimeAsInt() + (60 * 1)
        Hud.DeathTexts:Show("hospital", GetCloudTimeAsInt(), _healEnd, "primary_action")
        Citizen.SetTimeout(((_healEnd - GetCloudTimeAsInt()) - 10) * 1000, function()
          if LocalPlayer.state.loggedIn and LocalPlayer.state.isHospitalized then
            Damage:Revive()
          end
        end)
      end
    else
      exports['hud']:NotificationError('Invalid Bed or Bed Occupied')
    end
  end,
  FindBed = function(self, object)
    local coords = GetEntityCoords(object)
    exports['core']:CallbacksServer('Hospital:FindBed', coords, function(bed)
      if bed ~= nil then
        self:SendToBed(Config.Beds[bed], true, bed)
      else
        self:SendToBed({
          x = coords.x,
          y = coords.y,
          z = coords.z,
          h = GetEntityHeading(object),
          freeBed = true,
        }, true)
      end
    end)
  end,
  LeaveBed = function(self)
    exports['core']:CallbacksServer('Hospital:LeaveBed', _bedId, function()
      _bedId = nil
    end)
  end,
}

local function exportHandler(exportName, func)
  AddEventHandler(('__cfx_export_%s_%s'):format(GetCurrentResourceName(), exportName), function(setCB)
    setCB(function(...)
      return func(HOSPITAL, ...)
    end)
  end)
end

for k, v in pairs(HOSPITAL) do
  if type(v) == "function" then
    exportHandler(k, v)
  end
end

local _inCheckInZone = false

AddEventHandler('Polyzone:Enter', function(id, point, insideZone, data)
  if id == 'hospital-check-in-zone' then
    _inCheckInZone = true

    if not LocalPlayer.state.isEscorted and (GlobalState["ems:pmc:doctor"] == nil or GlobalState["ems:pmc:doctor"] == 0) then
      if not GlobalState["Duty:ems"] or GlobalState["Duty:ems"] == 0 then
        exports['hud']:ActionShow('{keybind}primary_action{/keybind} Check In {key}$150{/key}')
      else
        exports['hud']:ActionShow('{keybind}primary_action{/keybind} Check In {key}$5000{/key}')
      end
    end
  end
end)

AddEventHandler('Polyzone:Exit', function(id, point, insideZone, data)
  if id == 'hospital-check-in-zone' then
    _inCheckInZone = false
    exports['hud']:ActionHide()
  end
end)

AddEventHandler('Keybinds:Client:KeyUp:primary_action', function()
  if _inCheckInZone then
    if not LocalPlayer.state.doingAction and not LocalPlayer.state.isEscorted and (GlobalState["ems:pmc:doctor"] == nil or GlobalState["ems:pmc:doctor"] == 0) then
      TriggerEvent('Hospital:Client:CheckIn')
    end
  else
    if _curBed ~= nil and LocalPlayer.state.isHospitalized and GetCloudTimeAsInt() > _healEnd and not _leavingBed then
      _leavingBed = true
      Hud.DeathTexts:Release()
      LeaveBed()
    end
  end
end)
