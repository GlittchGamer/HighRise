AddEventHandler("Businesses:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Logger = exports['core']:FetchComponent("Logger")
  Fetch = exports['core']:FetchComponent("Fetch")
  Callbacks = exports['core']:FetchComponent("Callbacks")
  Game = exports['core']:FetchComponent("Game")
  Utils = exports['core']:FetchComponent("Utils")
  Notification = exports['core']:FetchComponent("Notification")
  Polyzone = exports['core']:FetchComponent("Polyzone")
  Jobs = exports['core']:FetchComponent("Jobs")
  Weapons = exports['core']:FetchComponent("Weapons")
  Progress = exports['core']:FetchComponent("Progress")
  Vehicles = exports['core']:FetchComponent("Vehicles")
  ListMenu = exports['core']:FetchComponent("ListMenu")
  Action = exports['core']:FetchComponent("Action")
  Sounds = exports['core']:FetchComponent("Sounds")
  PedInteraction = exports['core']:FetchComponent("PedInteraction")
  Blips = exports['core']:FetchComponent("Blips")
  Keybinds = exports['core']:FetchComponent("Keybinds")
  Minigame = exports['core']:FetchComponent("Minigame")
  Input = exports['core']:FetchComponent("Input")
  Interaction = exports['core']:FetchComponent("Interaction")
  Inventory = exports['core']:FetchComponent("Inventory")
  StorageUnits = exports['core']:FetchComponent("StorageUnits")
  HUD = exports['core']:FetchComponent("Hud")
  Crafting = exports['core']:FetchComponent("Crafting")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies("Businesses", {
    "Logger",
    "Fetch",
    "Callbacks",
    "Game",
    "Menu",
    "Notification",
    "Utils",
    "Polyzone",
    "Jobs",
    "Weapons",
    "Progress",
    "Vehicles",
    "ListMenu",
    "Action",
    "Sounds",
    "PedInteraction",
    "Blips",
    "Keybinds",
    "Minigame",
    "Input",
    "Interaction",
    "Inventory",
    "StorageUnits",
    "Hud",
    "Crafting",
  }, function(error)
    if #error > 0 then return; end
    RetrieveComponents()

    TriggerEvent("Businesses:Client:Startup")

    RemoveEventHandler(setupEvent)
  end)
end)

RegisterNetEvent("Characters:Client:Spawn")
AddEventHandler("Characters:Client:Spawn", function()
  exports['blips']:Add("shopping-mall", "Shopping Mall", vector3(-555.491, -597.852, 34.682), 59, 50, 0.6)

  --exports['blips']:Add("redline-performance", "Mechanic: Redline Performance", vector3(-600.028, -929.695, 23.866), 483, 59, 0.6, 2, 11)
  exports['blips']:Add("pizza_this", "Pizza This", vector3(793.905, -758.289, 26.779), 267, 52, 0.5, 2, 11)
  exports['blips']:Add("uwu_cafe", "UwU Cafe", vector3(-581.098, -1070.048, 22.330), 621, 34, 0.6, 2, 11)
  --exports['blips']:Add("arcade", "Business: Arcade", vector3(-1651.675, -1082.294, 13.156), 484, 58, 0.8, 2, 11)

  --exports['blips']:Add("tuna", "Business: McDougle Motors", vector3(161.992, -3036.946, 6.683), 611, 83, 0.6, 2, 11)
  exports['blips']:Add("triad", "Triad Records", vector3(-832.578, -698.627, 27.280), 614, 76, 0.5, 2, 11)

  exports['blips']:Add("bballs", "Bobs Balls", vector3(756.944, -768.288, 26.337), 536, 23, 0.4, 2, 11)

  --exports['blips']:Add("cabco", "Business: Downtown Cab Co.", vector3(908.036, -160.553, 74.142), 198, 5, 0.4, 2, 11)

  --exports['blips']:Add("tirenutz", "Mechanic: Tire Nutz", vector3(-73.708, -1338.770, 29.257), 488, 62, 0.7, 2, 11)
  --exports['blips']:Add("atomic", "Mechanic: Atomic Mechanics", vector3(482.176, -1889.637, 26.095), 544, 33, 1.0, 2, 11)
  exports['blips']:Add("hayes", "Hayes Autos", vector3(-1418.532, -445.162, 35.910), 544, 63, 1.0, 2, 11)
  exports['blips']:Add("autoexotics", "Auto Exotics", vector3(539.754, -182.979, 54.487), 488, 68, 0.7, 2, 11)
  exports['blips']:Add("harmony", "Harmony Repairs", vector3(1176.567, 2657.295, 37.972), 542, 7, 0.5, 2, 11)


  exports['blips']:Add("bakery", "Bakery", vector3(-1255.273, -293.090, 37.383), 106, 31, 0.5, 2, 11)
  exports['blips']:Add("noodle", "Noodle Exchange", vector3(-1194.746, -1161.401, 7.692), 414, 6, 0.5, 2, 11)
  exports['blips']:Add("burgershot", "Burger Shot", vector3(-1183.511, -884.722, 13.800), 106, 6, 0.5, 2, 11)

  exports['blips']:Add("lasttrain", "Last Train Diner", vector3(-361.137, 275.310, 86.422), 208, 6, 0.5, 2, 11)
  exports['blips']:Add("beanmachine", "Business: Bean Machine", vector3(116.985, -1039.424, 29.278), 536, 52, 0.5, 2, 11)

  exports['blips']:Add("tequila", "Tequi-la-la", vector3(-564.575, 276.170, 83.119), 93, 81, 0.6, 2, 11)

  exports['blips']:Add("dyn8", "Dynasty 8 Real Estate", vector3(-708.271, 268.543, 83.147), 374, 52, 0.65, 2)

  exports['blips']:Add("unicorn", "Vanilla Unicorn", vector3(110.380, -1313.496, 29.210), 121, 48, 0.7, 2, 11)

  exports['blips']:Add("smokeonwater", "Smoke on the Water", vector3(-1169.751, -1571.643, 4.667), 140, 52, 0.6, 2, 11)

  exports['blips']:Add("digitalden", "Digital Den", vector3(390.766, -830.339, 29.300), 355, 58, 0.6, 2, 11)

  exports['blips']:Add("rockford_records", "Rockford Records", vector3(-1007.658, -267.795, 39.040), 614, 63, 0.5, 2, 11)

  exports['blips']:Add("gruppe6", "Gruppe 6 Security", vector3(22.813, -123.661, 55.978), 487, 24, 0.8, 2, 11)

  exports['blips']:Add("ferrari_pawn", "Ferrari Pawn", vector3(181.282, -1318.973, 29.363), 605, 1, 0.6, 2, 11)

  exports['blips']:Add("ottos_autos", "Ottos Autos", vector3(838.241, -814.669, 26.321), 483, 25, 0.8, 2, 11)

  exports['blips']:Add("fightclub", "The Fightclub", vector3(1059.197, -2409.773, 29.928), 311, 8, 0.6, 2, 11)

  exports['blips']:Add("sagma", "San Andreas Gallery of Modern Art", vector3(-424.835, 21.379, 46.269), 674, 5, 0.6, 2, 11)

  exports['blips']:Add("dreamworks", "Dreamworks Mechanics", vector3(-739.396, -1514.290, 5.055), 524, 6, 0.7, 2, 11)

  exports['blips']:Add("prego", "Cafe Prego", vector3(-1114.819, -1452.965, 5.147), 267, 6, 0.7, 2, 11)

  exports['blips']:Add("white_law", "White & Associates", vector3(-1370.389, -502.949, 33.158), 457, 10, 0.7, 2, 11)
end)

RegisterNetEvent("Businesses:Client:CreatePoly", function(pickups, onSpawn)
  for k, v in ipairs(pickups) do
    local data = GlobalState[string.format("Businesses:Pickup:%s", v)]
    if data ~= nil then
      exports['ox_target']:TargetingZonesAddBox(data.id, "box-open", data.coords, data.width, data.length, data.options, {
        {
          icon = "box-open",
          text = string.format("Pickup Order (#%s)", data.num),
          event = "Businesses:Client:Pickup",
          data = data.data,
        },
        {
          icon = "money-check-dollar-pen",
          text = "Set Contactless Payment",
          event = "Businesses:Client:CreateContactlessPayment",
          isEnabled = function(data)
            return not GlobalState[string.format("PendingContactless:%s", data.id)]
          end,
          data = data,
          jobPerms = {
            {
              job = data.job,
              reqDuty = true,
            }
          },
        },
        {
          icon = "money-check-dollar-pen",
          text = "Clear Contactless Payment",
          event = "Businesses:Client:ClearContactlessPayment",
          isEnabled = function(data)
            return GlobalState[string.format("PendingContactless:%s", data.id)]
          end,
          data = data,
          jobPerms = {
            {
              job = data.job,
              reqDuty = true,
            }
          },
        },
        {
          icon = "money-check-dollar",
          isEnabled = function(data)
            return GlobalState[string.format("PendingContactless:%s", data.id)] and GlobalState[string.format("PendingContactless:%s", data.id)] > 0
          end,
          textFunc = function(data)
            if GlobalState[string.format("PendingContactless:%s", data.id)] and GlobalState[string.format("PendingContactless:%s", data.id)] > 0 then
              return string.format("Pay Contactless ($%s)", GlobalState[string.format("PendingContactless:%s", data.id)])
            end
          end,
          event = "Businesses:Client:PayContactlessPayment",
          data = data,
          item = "phone",
        },
      }, 2.0, true)
    end
  end
end)

AddEventHandler("Businesses:Client:Pickup", function(entity, data)
  Inventory.Dumbfuck:Open(data.inventory)
end)

function GetBusinessClockInMenu(businessName)
  return {
    {
      icon = "clipboard-check",
      text = "Clock In",
      event = "Businesses:Client:ClockIn",
      data = { job = businessName },
      jobPerms = {
        {
          job = businessName,
          reqOffDuty = true,
        }
      },
    },
    {
      icon = "clipboard",
      text = "Clock Out",
      event = "Businesses:Client:ClockOut",
      data = { job = businessName },
      jobPerms = {
        {
          job = businessName,
          reqDuty = true,
        }
      },
    },
  }
end

AddEventHandler("Businesses:Client:Startup", function()
  exports['ox_target']:TargetingZonesAddBox("digitalden-clockinoff", "chess-clock", vector3(384.17, -830.31, 29.3), 1.2, 0.8, {
    heading = 0,
    --debugPoly=true,
    minZ = 28.7,
    maxZ = 30.3
  }, GetBusinessClockInMenu("digitalden"), 3.0, true)

  exports['ox_target']:TargetingZonesAddBox("securoserv-clockinoff", "chess-clock", vector3(19.99, -119.98, 56.22), 2, 1.0, {
    heading = 340,
    --debugPoly=true,
    minZ = 55.22,
    maxZ = 57.42
  }, GetBusinessClockInMenu("securoserv"), 3.0, true)

  exports['ox_target']:TargetingZonesAddBox("ferrari_pawn-clockinoff", "chess-clock", vector3(167.95, -1314.62, 29.36), 1.0, 2, {
    heading = 334,
    --debugPoly=true,
    minZ = 28.76,
    maxZ = 30.56
  }, {
    {
      icon = "clipboard-check",
      text = "Clock In",
      event = "Businesses:Client:ClockIn",
      data = { job = "ferrari_pawn" },
      jobPerms = {
        {
          job = "ferrari_pawn",
          reqOffDuty = true,
        }
      },
    },
    {
      icon = "clipboard",
      text = "Clock Out",
      event = "Businesses:Client:ClockOut",
      data = { job = "ferrari_pawn" },
      jobPerms = {
        {
          job = "ferrari_pawn",
          reqDuty = true,
        }
      },
    },
    {
      icon = "tv",
      text = "Set TV Link",
      event = "Billboards:Client:SetLink",
      data = { id = "business_ferrari" },
      jobPerms = {
        {
          job = "ferrari_pawn",
          reqDuty = true,
        }
      },
    },
  }, 3.0, true)

  exports['ox_target']:TargetingZonesAddBox("sagma-clockinoff", "chess-clock", vector3(-422.48, 31.83, 46.23), 1, 1, {
    heading = 8,
    --debugPoly=true,
    minZ = 46.03,
    maxZ = 47.23
  }, GetBusinessClockInMenu("sagma"), 3.0, true)

  exports['ox_target']:TargetingZonesAddBox("sagma-clockinoff2", "chess-clock", vector3(-491.26, 31.8, 46.3), 1, 1, {
    heading = 355,
    --debugPoly=true,
    minZ = 46.1,
    maxZ = 47.1
  }, GetBusinessClockInMenu("sagma"), 3.0, true)

  exports['ox_target']:TargetingZonesAddBox("tuner-tvs", "tv", vector3(125.35, -3014.88, 7.04), 0.8, 2.0, {
    heading = 0,
    --debugPoly=true,
    minZ = 6.64,
    maxZ = 7.64,
  }, {
    {
      icon = "tv",
      text = "Set TV Link",
      event = "Billboards:Client:SetLink",
      data = { id = "business_tuner" },
      jobPerms = {
        {
          job = "tuna",
          reqDuty = true,
        }
      },
    },
  }, 3.0, true)
end)

AddEventHandler("Businesses:Client:ClockIn", function(_, data)
  if data and data.job then
    exports['jobs']:JobsDutyOn(data.job)
  end
end)

AddEventHandler("Businesses:Client:ClockOut", function(_, data)
  if data and data.job then
    exports['jobs']:JobsDutyOff(data.job)
  end
end)