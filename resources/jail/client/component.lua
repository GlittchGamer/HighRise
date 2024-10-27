_inPickup = false
_inLogout = false
_doingMugshot = false

AddEventHandler("Jail:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Callbacks = exports['core']:FetchComponent("Callbacks")
  Logger = exports['core']:FetchComponent("Logger")
  Blips = exports['core']:FetchComponent("Blips")
  Characters = exports['core']:FetchComponent("Characters")
  Polyzone = exports['core']:FetchComponent("Polyzone")
  Sounds = exports['core']:FetchComponent("Sounds")
  Notification = exports['core']:FetchComponent("Notification")
  Action = exports['core']:FetchComponent("Action")
  PedInteraction = exports['core']:FetchComponent("PedInteraction")
  Phone = exports['core']:FetchComponent("Phone")
  Inventory = exports['core']:FetchComponent("Inventory")
  Interaction = exports['core']:FetchComponent("Interaction")
  Progress = exports['core']:FetchComponent("Progress")
  Jail = exports['core']:FetchComponent("Jail")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies("Jail", {
    "Callbacks",
    "Logger",
    "Blips",
    "Characters",
    "Polyzone",
    "Sounds",
    "Notification",
    "Action",
    "PedInteraction",
    "Phone",
    "Inventory",
    "Interaction",
    "Progress",
    "Jail",
  }, function(error)
    if #error > 0 then
      return
    end
    RetrieveComponents()

    exports['blips']:Add("prison", "Bolingbroke Penitentiary", vector3(1852.444, 2585.973, 45.672), 188, 65, 0.8)

    exports['polyzonehandler']:PolyZoneCreatePoly("prison", Config.Prison.points, Config.Prison.options)
    exports['polyzonehandler']:PolyZoneCreatePoly("prison-logout", Config.Logout.points, Config.Logout.options)
    exports['polyzonehandler']:PolyZoneCreateBox(
      "prison-pickup",
      Config.Pickup.coords,
      Config.Pickup.length,
      Config.Pickup.width,
      Config.Pickup.options
    )

    exports['ox_target']:TargetingZonesAddBox(
      string.format("bb-retreive", aptId),
      "hands-holding",
      Config.Retreival.coords,
      Config.Retreival.length,
      Config.Retreival.width,
      Config.Retreival.options,
      {
        {
          icon = "hand-holding",
          text = "Retreive Items",
          event = "Jail:Client:RetreiveItems",
          isEnabled = function()
            return _inPickup
          end,
        },
      },
      3.0,
      true
    )

    exports['ox_target']:TargetingZonesAddBox(
      "prison-check",
      "police-box",
      Config.Payphone.coords,
      Config.Payphone.length,
      Config.Payphone.width,
      Config.Payphone.options,
      {
        {
          icon = "stopwatch",
          text = "Check Remaining Sentence",
          event = "Jail:Client:CheckSentence",
          isEnabled = function()
            return Jail:IsJailed()
          end,
        },
        {
          icon = "person-from-portal",
          text = "Process Release",
          event = "Jail:Client:Released",
          isEnabled = function()
            return Jail:IsJailed() and Jail:IsReleaseEligible()
          end,
        },
      },
      3.0,
      true
    )

    exports['ox_target']:TargetingZonesAddBox(
      "prison-food",
      "fork-knife",
      Config.Cafeteria.Food.coords,
      Config.Cafeteria.Food.length,
      Config.Cafeteria.Food.width,
      Config.Cafeteria.Food.options,
      {
        {
          text = "Make Food",
          event = "Jail:Client:MakeFood",
        },
      },
      3.0,
      true
    )

    exports['ox_target']:TargetingZonesAddBox(
      "prison-drink",
      "cup-straw-swoosh",
      Config.Cafeteria.Drink.coords,
      Config.Cafeteria.Drink.length,
      Config.Cafeteria.Drink.width,
      Config.Cafeteria.Drink.options,
      {
        {
          text = "Make Drink",
          event = "Jail:Client:MakeDrink",
        },
      },
      3.0,
      true
    )

    exports['ox_target']:TargetingZonesAddBox(
      "prison-payphone",
      "square-phone-flip",
      Config.Payphones.coords,
      Config.Payphones.length,
      Config.Payphones.width,
      Config.Payphones.options,
      {
        {
          text = "Use Payphone",
          event = "Phone:Client:OpenLimited",
        },
      },
      3.0,
      true
    )

    exports['pedinteraction']:Add("PrisonJobs", `csb_janitor`, Config.Foreman.coords, Config.Foreman.heading, 25.0, {
      {
        icon = "clipboard-check",
        text = "Start Work",
        event = "Jail:Client:StartWork",
        data = {},
        isEnabled = function()
          return LocalPlayer.state.Character:GetData("TempJob") == nil
        end,
      },
      {
        icon = "clipboard",
        text = "Quit Work",
        event = "Jail:Client:QuitWork",
        tempjob = "Prison",
        data = {},
      },
    }, 'user-helmet-safety', 'WORLD_HUMAN_JANITOR')

    exports['core']:CallbacksRegisterClient("Jail:DoMugshot", function(data, cb)
      _disabled = true
      _doingMugshot = true

      Phone:Close()
      Interaction:Hide()
      Inventory.Close:All()

      DoScreenFadeOut(1000)
      while not IsScreenFadedOut() do
        Citizen.Wait(10)
      end

      exports["animations"]:EmotesPlay("mugshot", false, -1, true)

      DoBoardShit(data.jailer, data.duration, data.date)
      DisableControls()
      SetEntityCoords(
        LocalPlayer.state.ped,
        Config.Mugshot.coords.x,
        Config.Mugshot.coords.y,
        Config.Mugshot.coords.z,
        0,
        0,
        0,
        false
      )
      Citizen.Wait(100)
      SetEntityHeading(LocalPlayer.state.ped, Config.Mugshot.headings[1])
      FreezeEntityPosition(LocalPlayer.state.ped, true)

      DoScreenFadeIn(1000)
      while not IsScreenFadedIn() do
        Citizen.Wait(10)
      end

      Sounds.Play:One("mugshot.ogg", 0.2)
      Citizen.Wait(2000)
      for i = 2, #Config.Mugshot.headings do
        if LocalPlayer.state.loggedIn then
          SetEntityHeading(LocalPlayer.state.ped, Config.Mugshot.headings[i])
          Citizen.Wait(1000)
          Sounds.Play:One("mugshot.ogg", 0.2)
          Citizen.Wait(3000)
        end
      end

      SetEntityHeading(LocalPlayer.state.ped, Config.Mugshot.headings[1])
      Sounds.Play:One("mugshot.ogg", 0.2)
      Citizen.Wait(2000)

      exports["animations"]:EmotesForceCancel()
      _doingMugshot = false

      DoScreenFadeOut(1000)
      while not IsScreenFadedOut() do
        Citizen.Wait(10)
      end

      FreezeEntityPosition(LocalPlayer.state.ped, false)
      cb(true)
    end)

    RemoveEventHandler(setupEvent)
  end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
  exports['core']:RegisterComponent("Jail", _JAIL)
end)

_JAIL = {
  IsJailed = function(self)
    if LocalPlayer.state.Character == nil then
      return false
    else
      local jailed = LocalPlayer.state.Character:GetData("Jailed")
      if jailed and jailed.Released ~= nil and not jailed.Released then
        return true
      else
        return false
      end
    end
  end,
  IsReleaseEligible = function(self)
    local jailed = LocalPlayer.state.Character:GetData("Jailed")
    if jailed and jailed.Duration < 9999 and GlobalState["OS:Time"] >= (jailed.Release or 0) then
      return true
    else
      return false
    end
  end,
}
