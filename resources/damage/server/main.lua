_damagedLimbs = {}
_dead = {}

function table.copy(t)
  local u = {}
  for k, v in pairs(t) do
    u[k] = v
  end
  return setmetatable(u, getmetatable(t))
end

AddEventHandler("Damage:Shared:DependencyUpdate", DamageComponents)
function DamageComponents()
  Fetch = exports['core']:FetchComponent("Fetch")

  Callbacks = exports['core']:FetchComponent("Callbacks")
  Logger = exports['core']:FetchComponent("Logger")
  Chat = exports['core']:FetchComponent("Chat")
  Middleware = exports['core']:FetchComponent("Middleware")
  --Damage = exports['core']:FetchComponent("Damage")
  Execute = exports['core']:FetchComponent("Execute")
  Status = exports['core']:FetchComponent("Status")
  RegisterChatCommands()
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies("Damage", {

    "Callbacks",
    "Logger",
    "Chat",
    "Middleware",
    "Fetch",
    --"Damage",
    "Execute",
    "Status",
  }, function(error)
    if #error > 0 then
      return
    end -- Do something to handle if not all dependencies loaded
    DamageComponents()
    RegisterChatCommands()

    exports['core']:MiddlewareAdd("Characters:Spawning", function(source)
      local plyr = exports['core']:FetchSource(source)
      if plyr ~= nil then
        local char = plyr:GetData("Character")
        if char ~= nil then
          if char:GetData("Damage") ~= nil then
            char:SetData("Damage", nil)
          end
          _damagedLimbs[char:GetData("SID")] = _damagedLimbs[char:GetData("SID")] or {}
        end
      end
    end, 2)

    exports['core']:MiddlewareAdd("Characters:Logout", function(source)
      SetPlayerInvincible(source, false)
      Player(source).state.isGodmode = false
    end, 2)

    exports['core']:CallbacksRegisterServer("Damage:GetLimbDamage", function(source, data, cb)
      local char = exports['core']:FetchSource(data):GetData("Character")
      if char ~= nil then
        local damage = Damage:GetLimbDamage(char:GetData("SID"))

        local menuData = {}

        for k, v in pairs(damage) do
          local descStr = ""

          local data = {}
          for k2, v2 in pairs(v) do
            if v2 > 0 then
              table.insert(data, string.format("%s %s", v2, Config.DamageTypeLabels[k2]))
            end
          end

          if #data > 0 then
            table.insert(menuData, {
              label = Config.BoneLabels[k],
              description = table.concat(data, ", "),
            })
          end
        end

        if #menuData == 0 then
          table.insert(menuData, {
            label = "No Observed Injuries",
          })
        end

        cb(menuData)
      end
    end)

    RemoveEventHandler(setupEvent)
  end)
end)

DAMAGE = {
  GetLimbDamage = function(self, sid)
    return _damagedLimbs[sid]
  end,
  ResetLimbDamage = function(self, sid)
    _damagedLimbs[sid] = {}
  end,
  Effects = {
    Painkiller = function(self, source, tier)
      exports['core']:CallbacksClient(source, "Damage:ApplyPainkiller", 225 * (tier or 1))
    end,
    Adrenaline = function(self, source, tier)
      exports['core']:CallbacksClient(source, "Damage:ApplyAdrenaline", 75 * (tier or 1))
    end,
  },
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
  exports['core']:RegisterComponent("Damage", DAMAGE)
end)

RegisterNetEvent("Damage:Server:StoreHealth", function(hp, armor)
  local src = source
  local plyr = exports['core']:FetchSource(src)
  if plyr ~= nil then
    local char = plyr:GetData("Character")
    if char ~= nil then
      char:SetData("HP", hp)
      char:SetData("Armor", armor)
    end
  end
end)

RegisterNetEvent("Damage:Server:BoneDamage", function(damageData)
  local src = source
  local plyr = exports['core']:FetchSource(src)
  if plyr ~= nil then
    local char = plyr:GetData("Character")
    if char ~= nil then
      if Config.Bones[damageData.bone] ~= "NONE" then
        if _damagedLimbs[char:GetData("SID")][Config.Bones[damageData.bone]] == nil then
          _damagedLimbs[char:GetData("SID")][Config.Bones[damageData.bone]] = {}
          for k, v in ipairs(Config.DamageTypes) do
            _damagedLimbs[char:GetData("SID")][Config.Bones[damageData.bone]][v] = 0
          end
        end
        local dmgType = Config.ClassDamageTypes[Config.WeaponClassBindings[damageData.hash]]
        if dmgType ~= nil then
          _damagedLimbs[char:GetData("SID")][Config.Bones[damageData.bone]][dmgType] += 1
        end
      end
    end
  end
end)

RegisterNetEvent("Damage:Server:Revived", function(wasMinor, wasFieldTreatment)
  local src = source
  local plyr = exports['core']:FetchSource(src)
  if plyr ~= nil then
    local char = plyr:GetData("Character")
    if char ~= nil then
      if not wasMinor and not wasFieldTreatment then
        exports['core']:LoggerTrace(
          "Damage",
          string.format(
            "%s %s (%s) Was Revived (Not Minor and Not Field Treatment)",
            char:GetData("First"),
            char:GetData("Last"),
            char:GetData("SID")
          )
        )
        Damage:ResetLimbDamage(char:GetData("SID"))
      else
        if wasMinor then
          exports['core']:LoggerTrace(
            "Damage",
            string.format(
              "%s %s (%s) Was Revived (Minor Injury)",
              char:GetData("First"),
              char:GetData("Last"),
              char:GetData("SID")
            )
          )
        else
          exports['core']:LoggerTrace(
            "Damage",
            string.format(
              "%s %s (%s) Was Revived (Field Treatment)",
              char:GetData("First"),
              char:GetData("Last"),
              char:GetData("SID")
            )
          )
        end
      end
    end
  end
end)
