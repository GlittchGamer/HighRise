AddEventHandler("Weed:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Logger = exports["hrrp-base"]:FetchComponent("Logger")
  Callbacks = exports["hrrp-base"]:FetchComponent("Callbacks")
  Game = exports["hrrp-base"]:FetchComponent("Game")
  Weed = exports["hrrp-base"]:FetchComponent("Weed")
  Progress = exports["hrrp-base"]:FetchComponent("Progress")
  Notification = exports["hrrp-base"]:FetchComponent("Notification")
  ListMenu = exports["hrrp-base"]:FetchComponent("ListMenu")
  Inventory = exports["hrrp-base"]:FetchComponent("Inventory")
  PedInteraction = exports["hrrp-base"]:FetchComponent("PedInteraction")
  Polyzone = exports["hrrp-base"]:FetchComponent("Polyzone")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports["hrrp-base"]:RequestDependencies("Weed", {
    "Logger",
    "Callbacks",
    "Game",
    "Weed",
    "Progress",
    "Notification",
    "ListMenu",
    "Inventory",
    "PedInteraction",
    "Polyzone",
  }, function(error)
    if #error > 0 then
      return
    end -- Do something to handle if not all dependencies loaded
    RetrieveComponents()
    RegisterTargets()
    RegisterCallbacks()

    LoadWeedModels()
    RemoveEventHandler(setupEvent)
  end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
  exports["hrrp-base"]:RegisterComponent("Weed", WEED)
end)

function getStageByPct(pct)
  local stagePct = 100 / (#Plants - 1)
  return math.floor((pct / stagePct) + 1.5)
end

local _plants = {}
function RegisterCallbacks()
  exports["hrrp-base"]:CallbacksRegisterClient("Weed:PlantingAnim", function(data, cb)
    local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.3, 0))
    local foundGround, zPos = GetGroundZFor_3dCoord(x, y, z - 0.5, 0)
    if foundGround then
      z = zPos
    end

    local rayHandle = StartExpensiveSynchronousShapeTestLosProbe(x, y, z + 4, x, y, z - 2, 1, 0, 4)
    local retval, hit, endCoords, _, materialHash, _ = GetShapeTestResultIncludingMaterial(rayHandle)

    if hit then
      if Materials[materialHash] ~= nil and not exports['hrrp-polyzone']:PolyZoneIsCoordsInZone(vector3(x, y, z), 'cayo_perico') then
        Progress:Progress({
          name = "plant_weed",
          duration = 15000,
          label = "Planting",
          canCancel = true,
          controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
          },
          animation = {
            task = "WORLD_HUMAN_GARDENER_PLANT",
          },
        }, function(cancelled)
          if not cancelled then
            cb({
              coords = { x = x, y = y, z = z },
              material = materialHash,
            })
          else
            cb({ error = 3 })
          end
        end)
      else
        cb({ error = 2 })
      end
    else
      cb({ error = 1 })
    end
  end)

  exports["hrrp-base"]:CallbacksRegisterClient("Weed:RollingAnim", function(data, cb)
    Progress:Progress({
      name = "rolling_weed",
      duration = 3000,
      label = "Rolling Joints",
      canCancel = true,
      ignoreModifier = true,
      controlDisables = {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
      },
      animation = {
        animDict = "amb@world_human_clipboard@male@idle_a",
        anim = "idle_c",
        flags = 49,
      },
    }, function(cancelled)
      cb(not cancelled)
    end)
  end)

  exports["hrrp-base"]:CallbacksRegisterClient("Weed:MakingBrick", function(data, cb)
    Progress:Progress({
      name = "making_brick",
      duration = data.time * 1000,
      label = data.label,
      canCancel = true,
      ignoreModifier = true,
      controlDisables = {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
      },
      animation = {
        animDict = "amb@world_human_clipboard@male@idle_a",
        anim = "idle_c",
        flags = 49,
      },
    }, function(cancelled)
      cb(not cancelled)
    end)
  end)

  exports["hrrp-base"]:CallbacksRegisterClient("Weed:SmokingAnim", function(data, cb)
    local ticks = 1
    Progress:ProgressWithTickEvent({
      name = "smoking_weed",
      duration = 8000,
      tickrate = 1000,
      label = "Smoking",
      canCancel = true,
      ignoreModifier = true,
      controlDisables = {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
      },
      animation = not IsPedInAnyVehicle(LocalPlayer.state.ped, true) and {
        task = "WORLD_HUMAN_DRUG_DEALER",
      } or false,
    }, function()
      local armor = GetPedArmour(LocalPlayer.state.ped)
      if armor < 50 then
        SetPedArmour(LocalPlayer.state.ped, armor + 3)
      end
      ticks = ticks + 1
    end, function(cancelled)
      cb(not cancelled, ticks)
    end)
  end)
end

WEED = {}
