VEHICLE_INSIDE = nil
LOCAL_CACHED_EVIDENCE = {}

_ammoNames = {
  AMMO_STUNGUN = 'Stungun Ammo',
  AMMO_PISTOL = 'Pistol Ammo',
  AMMO_SMG = 'SMG Ammo',
  AMMO_RIFLE = 'Rifle Ammo',
  AMMO_SHOTGUN = 'Shotgun Ammo',
  AMMO_SNIPER = 'Sniper Ammo',
  AMMO_FLARE = 'Flare Ammo',
  AMMO_MG = 'Machine Gun Ammo',
}

AddEventHandler('Evidence:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
  Logger = exports['hrrp-base']:FetchComponent('Logger')
  Fetch = exports['hrrp-base']:FetchComponent('Fetch')
  Callbacks = exports['hrrp-base']:FetchComponent('Callbacks')
  Game = exports['hrrp-base']:FetchComponent('Game')
  Utils = exports['hrrp-base']:FetchComponent('Utils')
  Notification = exports['hrrp-base']:FetchComponent('Notification')
  Polyzone = exports['hrrp-base']:FetchComponent('Polyzone')
  Jobs = exports['hrrp-base']:FetchComponent('Jobs')
  Weapons = exports['hrrp-base']:FetchComponent('Weapons')
  Progress = exports['hrrp-base']:FetchComponent('Progress')
  Vehicles = exports['hrrp-base']:FetchComponent('Vehicles')
  ListMenu = exports['hrrp-base']:FetchComponent('ListMenu')
  Action = exports['hrrp-base']:FetchComponent('Action')
  Sounds = exports['hrrp-base']:FetchComponent('Sounds')
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['hrrp-base']:RequestDependencies('Evidence', {
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
  }, function(error)
    if #error > 0 then return; end
    RetrieveComponents()

    exports['hrrp-polyzone']:PolyZoneCreateBox('evidence_ballistics_mrpd', vector3(483.41, -993.34, 30.69), 1.6, 2.4, {
      heading = 359,
      minZ = 29.69,
      maxZ = 31.89
    }, {
      ballistics = true,
    })

    exports['hrrp-polyzone']:PolyZoneCreateBox('evidence_dna_mrpd', vector3(486.98, -993.51, 30.69), 1.0, 1.2, {
      heading = 0,
      minZ = 29.69,
      maxZ = 32.09
    }, {
      dna = true,
    })

    exports['hrrp-polyzone']:PolyZoneCreateBox('evidence_ballistics_dpd', vector3(369.46, -1590.37, 25.45), 1.2, 1.6, {
      heading = 359,
      minZ = 24.45,
      maxZ = 27.25
    }, {
      ballistics = true,
    })

    exports['hrrp-polyzone']:PolyZoneCreateBox('evidence_dna_dpd', vector3(367.9, -1592.18, 25.45), 1.2, 1.6, {
      heading = 0,
      minZ = 24.45,
      maxZ = 27.25
    }, {
      dna = true,
    })

    exports['hrrp-polyzone']:PolyZoneCreateBox('evidence_ballistics_lmpd', vector3(849.52, -1311.05, 28.24), 1.8, 2, {
      heading = 0,
      --debugPoly=true,
      minZ = 27.24,
      maxZ = 29.84
    }, {
      ballistics = true,
    })

    exports['hrrp-polyzone']:PolyZoneCreateBox('evidence_dna_lmpd', vector3(853.45, -1292.58, 28.24), 1.8, 1, {
      heading = 0,
      --debugPoly=true,
      minZ = 27.24,
      maxZ = 29.64
    }, {
      dna = true,
    })

    exports['hrrp-polyzone']:PolyZoneCreateBox('evidence_dna_mt_zona_1', vector3(-444.11, -296.49, 34.91), 3.6, 1.6, {
      heading = 290,
      --debugPoly=true,
      minZ = 33.91,
      maxZ = 36.11
    }, {
      dna = true,
    })

    exports['hrrp-polyzone']:PolyZoneCreateBox('evidence_dna_mt_zona_2', vector3(-442.69, -299.56, 34.91), 3.6, 1.6, {
      heading = 290,
      --debugPoly=true,
      minZ = 33.91,
      maxZ = 36.11
    }, {
      dna = true,
    })

    RemoveEventHandler(setupEvent)
  end)
end)

AddEventHandler('Vehicles:Client:EnterVehicle', function(veh)
  VEHICLE_INSIDE = veh
end)

AddEventHandler("Vehicles:Client:ExitVehicle", function()
  VEHICLE_INSIDE = nil
end)

local pendingEvidenceUpdate = false

function UpdateCachedEvidence()
  if not pendingEvidenceUpdate then
    pendingEvidenceUpdate = true
    Citizen.SetTimeout(5000, function()
      pendingEvidenceUpdate = false
      SendCachedEvidence()
    end)
  end
end

function SendCachedEvidence()
  TriggerServerEvent('Evidence:Server:RecieveEvidence', LOCAL_CACHED_EVIDENCE)
  LOCAL_CACHED_EVIDENCE = {}
end