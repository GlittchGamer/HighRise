AddEventHandler("Arcade:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Callbacks = exports['core']:FetchComponent("Callbacks")
  Logger = exports['core']:FetchComponent("Logger")
  Notification = exports['core']:FetchComponent("Notification")
  Hud = exports['core']:FetchComponent("Hud")
  Status = exports['core']:FetchComponent("Status")
  Progress = exports['core']:FetchComponent("Progress")
  PedInteraction = exports['core']:FetchComponent("PedInteraction")
  Keybinds = exports['core']:FetchComponent("Keybinds")
  Jail = exports['core']:FetchComponent("Jail")
  Sounds = exports['core']:FetchComponent("Sounds")
  Weapons = exports['core']:FetchComponent("Weapons")
  Jobs = exports['core']:FetchComponent("Jobs")
  Input = exports['core']:FetchComponent("Input")
  Arcade = exports['core']:FetchComponent("Arcade")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies("Arcade", {
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

    exports['pedinteraction']:Add("ArcadeMaster", `IG_OldRichGuy`, vector3(-1658.916, -1062.421, 11.160), 228.868, 25.0, {
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
    exports['jobs']:JobsDutyOn(data.job)
  end
end)

AddEventHandler("Arcade:Client:ClockOut", function(_, data)
  if data and data.job then
    exports['jobs']:JobsDutyOff(data.job)
  end
end)

AddEventHandler("Arcade:Client:Open", function()
  exports['core']:CallbacksServer("Arcade:Open", false, function()

  end)
end)

AddEventHandler("Arcade:Client:Close", function()
  exports['core']:CallbacksServer("Arcade:Close", false, function()

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
  exports['core']:RegisterComponent("Arcade", _ARCADE)
end)
