_cuffPromise = nil

local MAX_CUFF_ATTEMPTS = 2

AddEventHandler("Handcuffs:Shared:DependencyUpdate", HandcuffComponents)
function HandcuffComponents()
  Callbacks = exports["hrrp-base"]:FetchComponent("Callbacks")
  Inventory = exports["hrrp-base"]:FetchComponent("Inventory")
  PedInteraction = exports["hrrp-base"]:FetchComponent("PedInteraction")
  Minigame = exports["hrrp-base"]:FetchComponent("Minigame")
  Notification = exports["hrrp-base"]:FetchComponent("Notification")
  Weapons = exports["hrrp-base"]:FetchComponent("Weapons")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports["hrrp-base"]:RequestDependencies("Handcuffs", {
    "Callbacks",
    "Inventory",
    "PedInteraction",
    "Minigame",
    "Notification",
    "Weapons",
  }, function(error)
    if #error > 0 then
      return
    end
    HandcuffComponents()

    exports["hrrp-base"]:CallbacksRegisterClient("Handcuffs:VehCheck", function(data, cb)
      cb(IsPedInAnyVehicle(LocalPlayer.state.ped))
    end)

    exports["hrrp-base"]:CallbacksRegisterClient("Handcuffs:DoCuff", function(data, cb)
      if not IsPedInAnyVehicle(LocalPlayer.state.ped, true) then
        if _cuffPromise == nil then
          if not LocalPlayer.state.isCuffed then
            beingCuffedAnim(data.cuffer)
          end

          if _attempts < MAX_CUFF_ATTEMPTS and (not data.forced and not LocalPlayer.state.isCuffed and not LocalPlayer.state.isDead) then
            CuffAttempt()
            _cuffPromise = promise.new()
            Minigame.Play:RoundSkillbar(1.0 + (0.2 * (_attempts or 1)), 5 - _attempts, {
              onSuccess = "Handcuffs:Client:DoCuffBreak",
              onFail = "Handcuffs:Client:FailCuffBreak",
            }, {
              animation = false,
            })
            cb(Citizen.Await(_cuffPromise))
          else
            ResetTimer()
            cb(false)

            if data.isHardCuffed then
              _cuffFlags = 17
            else
              _cuffFlags = 49
            end

            cuffAnim()
          end
        else
          cb(-1)
        end

        _cuffPromise = nil
      else
        cb(-1)
      end
    end)

    RemoveEventHandler(setupEvent)
  end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
  exports["hrrp-base"]:RegisterComponent("Handcuffs", _HANDCUFFS)
end)

_HANDCUFFS = {}