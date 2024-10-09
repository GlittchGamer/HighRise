AddEventHandler("Arcade:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Callbacks = exports["hrrp-base"]:FetchComponent("Callbacks")
  Logger = exports["hrrp-base"]:FetchComponent("Logger")
  Notification = exports["hrrp-base"]:FetchComponent("Notification")
  Hud = exports["hrrp-base"]:FetchComponent("Hud")
  Status = exports["hrrp-base"]:FetchComponent("Status")
  Progress = exports["hrrp-base"]:FetchComponent("Progress")
  PedInteraction = exports["hrrp-base"]:FetchComponent("PedInteraction")
  Keybinds = exports["hrrp-base"]:FetchComponent("Keybinds")
  Jail = exports["hrrp-base"]:FetchComponent("Jail")
  Sounds = exports["hrrp-base"]:FetchComponent("Sounds")
  Weapons = exports["hrrp-base"]:FetchComponent("Weapons")
  Jobs = exports["hrrp-base"]:FetchComponent("Jobs")
  Input = exports["hrrp-base"]:FetchComponent("Input")
  Arcade = exports["hrrp-base"]:FetchComponent("Arcade")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports["hrrp-base"]:RequestDependencies("Arcade", {
    "Callbacks",
    "Logger",
    "Notification",
    "Hud",
    "Status",
    "Progress",
    "PedInteraction",
    "Keybinds",
    "Jail",
    "Sounds",
    "Weapons",
    "Jobs",
    "Input",
    "Arcade",
  }, function(error)
    if #error > 0 then
      return
    end
    RetrieveComponents()

    TriggerEvent("Arcade:Client:Setup")

    exports['hrrp-pedinteraction']:Add("ArcadeMaster", `IG_OldRichGuy`, vector3(-1658.916, -1062.421, 11.160), 228.868, 25.0, {
      {
        icon = "clipboard-check",
        text = "Clock In",
        event = "Arcade:Client:ClockIn",
        data = { job = "avast_arcade" },
        jobPerms = {
          {
            job = "avast_arcade",
            reqOffDuty = true,
          }
        },
      },
      {
        icon = "clipboard",
        text = "Clock Out",
        event = "Arcade:Client:ClockOut",
        data = { job = "avast_arcade" },
        jobPerms = {
          {
            job = "avast_arcade",
            reqDuty = true,
          }
        },
      },
      {
        icon = "heart-pulse",
        text = "Open Arcade",
        event = "Arcade:Client:Open",
        jobPerms = {
          {
            job = "avast_arcade",
            reqDuty = true,
          }
        },
        isEnabled = function()
          return not GlobalState["Arcade:Open"]
        end,
      },
      {
        icon = "heart-pulse",
        text = "Close Arcade",
        event = "Arcade:Client:Close",
        jobPerms = {
          {
            job = "arcade",
            reqDuty = true,
          }
        },
        isEnabled = function()
          return GlobalState["Arcade:Open"]
        end,
      },
      {
        icon = "heart-pulse",
        text = "Create New Game",
        event = "Arcade:Client:CreateNew",
        isEnabled = function()
          return GlobalState["Arcade:Open"]
        end,
      },
    }, "joystick", "WORLD_HUMAN_STAND_IMPATIENT")

    RemoveEventHandler(setupEvent)
  end)
end)

AddEventHandler("Arcade:Client:ClockIn", function(_, data)
  if data and data.job then
    exports['hrrp-jobs']:JobsDutyOn(data.job)
  end
end)

AddEventHandler("Arcade:Client:ClockOut", function(_, data)
  if data and data.job then
    exports['hrrp-jobs']:JobsDutyOff(data.job)
  end
end)

AddEventHandler("Arcade:Client:Open", function()
  exports["hrrp-base"]:CallbacksServer("Arcade:Open", false, function()

  end)
end)

AddEventHandler("Arcade:Client:Close", function()
  exports["hrrp-base"]:CallbacksServer("Arcade:Close", false, function()

  end)
end)

AddEventHandler("Arcade:Client:CreateNew", function(entity, data)
  Input:Show("Create New Match", "Match Configuration", {
    {
      id = "gamemode",
      type = "select",
      select = {
        {
          label = "Team Deathmatch",
          value = "tdm",
        }
      },
      options = {},
    },
    {
      id = "map",
      type = "select",
      select = {
        {
          label = "Random",
          value = "random",
        },
        {
          label = "Legion Square",
          value = "legionsquare",
        },
      },
      options = {},
    },
  }, "Arcade:Client:SubmitGame", data)
end)

_ARCADE = {
  Gamemode = {
    Register = function(self, id, label)

    end,
  }
}

AddEventHandler("Proxy:Shared:RegisterReady", function(component)
  exports["hrrp-base"]:RegisterComponent("Arcade", _ARCADE)
end)
