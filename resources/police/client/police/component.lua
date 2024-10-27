local policeStationBlips = {
  vector3(-445.7, 6013.2, 100.0),
  vector3(438.7, -981.8, 100.0),
  vector3(1850.634, 3683.860, 100.0),
  vector3(372.658, -1601.816, 100.0),
  vector3(835.011, -1292.794, 100.0),
}

local _pdModels = {}

local lastTackle = 0

local _breached = {}

function loadModel(model)
  RequestModel(model)
  while not HasModelLoaded(model) do
    Citizen.Wait(1)
  end
end

AddEventHandler("Police:Shared:DependencyUpdate", PoliceComponents)
function PoliceComponents()
  Callbacks = exports['core']:FetchComponent("Callbacks")
  Inventory = exports['core']:FetchComponent("Inventory")
  Notification = exports['core']:FetchComponent("Notification")
  Input = exports['core']:FetchComponent("Input")
  Keybinds = exports['core']:FetchComponent("Keybinds")
  Handcuffs = exports['core']:FetchComponent("Handcuffs")
  Interaction = exports['core']:FetchComponent("Interaction")
  Blips = exports['core']:FetchComponent("Blips")
  Jobs = exports['core']:FetchComponent("Jobs")
  Sounds = exports['core']:FetchComponent("Sounds")
  Properties = exports['core']:FetchComponent("Properties")
  Apartment = exports['core']:FetchComponent("Apartment")
  EmergencyAlerts = exports['core']:FetchComponent("EmergencyAlerts")
  Wardrobe = exports['core']:FetchComponent("Wardrobe")
  Status = exports['core']:FetchComponent("Status")
  Game = exports['core']:FetchComponent("Game")
  Sync = exports['core']:FetchComponent("Sync")
  Polyzone = exports['core']:FetchComponent("Polyzone")
  Vehicles = exports['core']:FetchComponent("Vehicles")
  PedInteraction = exports['core']:FetchComponent("PedInteraction")
  NPCDialog = exports['core']:FetchComponent("NPCDialog")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies("Police", {
    "Callbacks",
    "Inventory",
    "Notification",
    "Input",
    "Keybinds",
    "Handcuffs",
    "Interaction",
    "Blips",
    "Jobs",
    "Sounds",
    "Properties",
    "Apartment",
    "EmergencyAlerts",
    "Wardrobe",
    "Status",
    "Game",
    "Sync",
    "Polyzone",
    "Vehicles",
    "PedInteraction",
    "NPCDialog",
  }, function(error)
    if #error > 0 then
      return
    end
    PoliceComponents()
    RegisterInteractions()
    RegisterPoliceNPC()

    CreatePDZones()

    _pdModels = GlobalState["PoliceCars"]

    exports['core']:CallbacksRegisterClient("Police:Breach", function(data, cb)
      Progress:Progress({
        name = "breach_action",
        duration = 3000,
        label = "Breaching",
        useWhileDead = false,
        canCancel = true,
        disarm = false,
        controlDisables = {
          disableMovement = true,
          disableCarMovement = true,
          disableMouse = false,
          disableCombat = true,
        },
        animation = {
          animDict = "missprologuemcs_1",
          anim = "kick_down_player_zero",
          flags = 49,
        },
      }, function(cancelled)
        cb(not cancelled)
        if not cancelled then
          --Sounds.Play:Location(LocalPlayer.state.myPos, 20, "breach.ogg", 0.15)
        end
      end)
    end)

    local _cuffCd = false
    exports['keybinds']:Add("pd_cuff", "LBRACKET", "keyboard", "Police - Cuff", function()
      if LocalPlayer.state.Character ~= nil and LocalPlayer.state.onDuty == "police" then
        if not _cuffCd then
          TriggerServerEvent("Police:Server:Cuff")
          _cuffCd = true
          Citizen.SetTimeout(3000, function()
            _cuffCd = false
          end)
        end
      end
    end)

    exports['keybinds']:Add("pd_uncuff", "RBRACKET", "keyboard", "Police - Uncuff", function()
      if LocalPlayer.state.Character ~= nil and LocalPlayer.state.onDuty == "police" then
        if not _cuffCd then
          TriggerServerEvent("Police:Server:Uncuff")
          _cuffCd = true
          Citizen.SetTimeout(3000, function()
            _cuffCd = false
          end)
        end
      end
    end)

    -- exports['keybinds']:Add("pd_toggle_cuff", "", "keyboard", "Police - Cuff / Uncuff", function()
    -- 	if LocalPlayer.state.Character ~= nil and LocalPlayer.state.onDuty == "police" then
    -- 		if not _cuffCd then
    -- 			TriggerServerEvent("Police:Server:ToggleCuff")
    -- 			_cuffCd = true
    -- 			Citizen.CreateThread(function()
    -- 				Citizen.Wait(2000)
    -- 				_cuffCd = false
    -- 			end)
    -- 		end
    -- 	end
    -- end)

    exports['keybinds']:Add("tackle", "", "keyboard", "Tackle", function()
      if LocalPlayer.state.Character ~= nil then
        if
            not LocalPlayer.state.isCuffed
            and not LocalPlayer.state.tpLocation
            and not IsPedInAnyVehicle(LocalPlayer.state.ped)
            and not LocalPlayer.state.playingCasino
        then
          if GetEntitySpeed(LocalPlayer.state.ped) > 2.0 then
            local cPlayer, dist = Game.Players:GetClosestPlayer()
            local tarPlayer = GetPlayerServerId(cPlayer)
            if tarPlayer ~= 0 and dist <= 2.0 and GetGameTimer() - lastTackle > 7000 then
              lastTackle = GetGameTimer()
              TriggerServerEvent("Police:Server:Tackle", tarPlayer)

              loadAnimDict("swimming@first_person@diving")

              if
                  IsEntityPlayingAnim(
                    LocalPlayer.state.ped,
                    "swimming@first_person@diving",
                    "dive_run_fwd_-45_loop",
                    3
                  )
              then
                ClearPedSecondaryTask(LocalPlayer.state.ped)
              else
                TaskPlayAnim(
                  LocalPlayer.state.ped,
                  "swimming@first_person@diving",
                  "dive_run_fwd_-45_loop",
                  8.0,
                  -8,
                  -1,
                  49,
                  0,
                  0,
                  0,
                  0
                )
                Citizen.Wait(350)
                ClearPedSecondaryTask(LocalPlayer.state.ped)
                SetPedToRagdoll(LocalPlayer.state.ped, 500, 500, 0, 0, 0, 0)
              end
            else
              StupidRagdoll(true)
            end
          else
            StupidRagdoll(false)
          end
        end
      end
    end)

    exports['core']:CallbacksRegisterClient("Police:DeploySpikes", function(data, cb)
      Progress:ProgressWithStartEvent({
        name = "spikestrips",
        duration = 1000,
        label = "Laying Spikes",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
          disableMovement = true,
          disableCarMovement = true,
          disableMouse = false,
          disableCombat = true,
        },
        animation = {
          animDict = "weapons@first_person@aim_rng@generic@projectile@thermal_charge@",
          anim = "plant_floor",
        },
        disarm = true,
      }, function()
        Weapons:UnequipIfEquippedNoAnim()
      end, function(status)
        if not status then
          local h = GetEntityHeading(PlayerPedId())
          local positions = {}
          for i = 1, 3 do
            table.insert(
              positions,
              GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, -1.5 + (3.5 * i), 0.15)
            )
          end
          cb({
            positions = positions,
            h = h,
          })
        else
          cb(nil)
        end
      end)
    end)

    RemoveEventHandler(setupEvent)
  end)
end)

AddEventHandler("Police:Client:DoApartmentBreach", function(values, data)
  exports['core']:CallbacksServer("Police:Breach", {
    type = "apartment",
    property = tonumber(values.unit),
    id = data,
  }, function(s)
    if s then

    end
  end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
  exports['core']:RegisterComponent("Police", POLICE)
end)

RegisterNetEvent("Characters:Client:Spawn", function()
  for k, v in ipairs(policeStationBlips) do
    exports['blips']:Add("police_station_" .. k, "Police Department", v, 137, 38, 0.6)
  end
end)

RegisterNetEvent("Police:Client:Breached", function(type, id)
  _breached[type] = _breached[type] or {}
  _breached[type][id] = GlobalState["OS:Time"] + (60 * 5)
end)

RegisterNetEvent("Police:Client:GetTackled", function(s)
  if LocalPlayer.state.loggedIn then
    SetPedToRagdoll(LocalPlayer.state.ped, math.random(3000, 5000), math.random(3000, 5000), 0, 0, 0, 0)
    lastTackle = GetGameTimer()
  end
end)

POLICE = {
  IsPdCar = function(self, entity)
    return _pdModels[GetEntityModel(entity)]
  end
}

function StupidRagdoll(tackleAnim)
  local time = 5000
  if tackleAnim then
    TaskPlayAnim(
      LocalPlayer.state.ped,
      "swimming@first_person@diving",
      "dive_run_fwd_-45_loop",
      8.0,
      -8,
      -1,
      49,
      0,
      0,
      0,
      0
    )
    time = 1000
  end
  Citizen.Wait(350)
  ClearPedSecondaryTask(LocalPlayer.state.ped)
  SetPedToRagdoll(LocalPlayer.state.ped, time, time, 0, 0, 0, 0)
end
