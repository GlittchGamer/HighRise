function RegisterMiddleware()
  Middleware:Add("Characters:Creating", function(source, cData)
    return {
      {
        Jailed = {
          Released = true,
          Jailed = false,
          Time = nil,
          Duration = nil
        },
        ICU = {
          Released = true
        }
      },
    }
  end)

  Middleware:Add("Characters:Spawning", function(source)
    local _src = source
    local player = exports['core']:FetchSource(_src)
    local currentTime = os.time() * 1000
    if player ~= nil then
      local char = player:GetData("Character")
      if char ~= nil then
        local jailed = char:GetData("Jailed")
        if
            (jailed and jailed.Jailed and jailed.Jailed.Time ~= nil and jailed.Jailed.Duration ~= nil)
            and (os.time() >= jailed.Time + (jailed.Duration * 60))
        then
          char:SetData("Jailed", {})
        end
      end
    end
  end, 2)

  local function CheckJailed(source)
    local player = exports['core']:FetchSource(source)
    if player ~= nil then
      local char = player:GetData("Character")
      if char ~= nil then
        local jailed = char:GetData("Jailed") or false
        if
            (jailed and jailed.Jailed and jailed.Jailed.Time ~= nil and jailed.Jailed.Duration ~= nil)
            and (os.time() >= jailed.Time + (jailed.Duration * 60))
        then
          char:SetData("Jailed", {})
        end
      end
    end
  end

  Middleware:Add("Characters:Logout", CheckJailed, 1)
  Middleware:Add("playerDropped", CheckJailed, 1)
end
