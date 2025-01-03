AddEventHandler("Handcuffs:Shared:DependencyUpdate", HandcuffsComponents)
function HandcuffsComponents()
  Fetch = exports['core']:FetchComponent("Fetch")
  Middleware = exports['core']:FetchComponent("Middleware")
  Callbacks = exports['core']:FetchComponent("Callbacks")
  Logger = exports['core']:FetchComponent("Logger")
  Sounds = exports['core']:FetchComponent("Sounds")
  Handcuffs = exports['core']:FetchComponent("Handcuffs")
  Inventory = exports['core']:FetchComponent("Inventory")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies("Handcuffs", {
    "Middleware",
    "Callbacks",
    "Logger",
    "Fetch",
    "Sounds",
    "Handcuffs",
    "Inventory",
  }, function(error)
    if #error > 0 then
      return
    end -- Do something to handle if not all dependencies loaded
    HandcuffsComponents()
    HandcuffItems()

    exports['core']:MiddlewareAdd("Characters:Logout", function(source)
      local playerState = Player(source).state
      playerState.isCuffed = false
      playerState.isHardCuffed = false
    end, 2)

    RemoveEventHandler(setupEvent)
  end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
  exports['core']:RegisterComponent("Handcuffs", _HANDCUFFS)
end)

function DoCuff(source, target, isHardCuffed, isForced)
  TriggerClientEvent("Handcuffs:Client:CuffingAnim", source)
  exports['core']:CallbacksClient(target, "Handcuffs:DoCuff", {
    cuffer = source,
    isHardCuffed = isHardCuffed,
    forced = isForced,
  }, function(result)
    if result == -1 then
      exports['core']:ExecuteClient(source, "Notification", "Error", "Unable To Cuff Player")
    else
      local playerState = Player(target).state
      local ped = GetPlayerPed(target)
      if result then
        ClearPedTasksImmediately(GetPlayerPed(target))
        ClearPedTasksImmediately(GetPlayerPed(source))

        exports['core']:ExecuteClient(source, "Notification", "Error", "Suspect Broke Out Of The Cuffs")
        Sounds.Play:Distance(target, 10, "handcuff_break.ogg", 0.35)
        --Sounds.Play:One(target, "handcuff_break.ogg", 0.35)
        playerState.isCuffed = false
        playerState.isHardCuffed = false
        SetPedConfigFlag(ped, 120, false)
        SetPedConfigFlag(ped, 121, false)
      else
        exports['core']:ExecuteClient(source, "Notification", "Success", "You Cuffed A Player")
        Sounds.Play:Distance(target, 10, "handcuff_on.ogg", 0.55)
        Citizen.CreateThread(function()
          Citizen.Wait(1050)
          Sounds.Play:Distance(target, 10, "handcuff_on.ogg", 0.55)
        end)
        SetPedConfigFlag(ped, 120, true)
        SetPedConfigFlag(ped, 121, isHardCuffed)
        playerState.isCuffed = true
        playerState.isHardCuffed = isHardCuffed
        --FreezeEntityPosition(ped, false)
        TriggerClientEvent("Handcuffs:Client:CuffThread", target)
      end
    end
  end)
end

RegisterNetEvent("Handcuffs:Server:HardCuff", function(target)
  local src = source

  local mPos = GetEntityCoords(GetPlayerPed(src))
  local tPos = GetEntityCoords(GetPlayerPed(target))

  if #(vector3(mPos.x, mPos.y, mPos.z) - vector3(tPos.x, tPos.y, tPos.z)) <= 1.5 then
    if Inventory.Items:HasAnyItems(src, Config.CuffItems) then
      if
          not Player(target).state.isCuffed
          or (Player(target).state.isCuffed and not Player(target).state.isHardCuffed)
      then
        Handcuffs:HardCuffTarget(src, target, false)
      else
        exports['core']:ExecuteClient(source, "Notification", "Error", "Target Already Hard Cuffed")
      end
    end
  else
    exports['core']:ExecuteClient(source, "Notification", "Error", "Target Too Far")
  end
end)

RegisterNetEvent("Handcuffs:Server:SoftCuff", function(target)
  local src = source

  local mPos = GetEntityCoords(GetPlayerPed(src))
  local tPos = GetEntityCoords(GetPlayerPed(target))

  if #(vector3(mPos.x, mPos.y, mPos.z) - vector3(tPos.x, tPos.y, tPos.z)) <= 1.5 then
    if Inventory.Items:HasAnyItems(src, Config.CuffItems) then
      local pState = Player(target).state
      if not pState.isCuffed or (pState.isCuffed and pState.isHardCuffed) then
        Handcuffs:SoftCuffTarget(src, target, false)
      end
    else
      --missing items
    end
  else
    --target too far
  end
end)

RegisterNetEvent("Handcuffs:Server:Uncuff", function(target)
  local src = source

  local mPos = GetEntityCoords(GetPlayerPed(src))
  local tPos = GetEntityCoords(GetPlayerPed(target))

  if #(vector3(mPos.x, mPos.y, mPos.z) - vector3(tPos.x, tPos.y, tPos.z)) <= 1.5 then
    if Inventory.Items:HasAnyItems(src, Config.CuffItems) then
      if Player(target).state.isCuffed then
        Handcuffs:UncuffTarget(src, target)
      end
    end
  else
    --target too far
  end
end)

_HANDCUFFS = {
  ToggleCuffs = function(self, source)
    exports['core']:CallbacksClient(source, "HUD:GetTargetInfront", {}, function(target)
      if target ~= nil then
        if not Player(target).state.isCuffed then
          DoCuff(source, target, false, false)
        else
          Handcuffs:UncuffTarget(source, target)
        end
      else
        exports['core']:ExecuteClient(source, "Notification", "Error", "Nobody To Cuff")
      end
    end)
  end,
  SoftCuff = function(self, source)
    exports['core']:CallbacksClient(source, "HUD:GetTargetInfront", {}, function(target)
      if target ~= nil then
        if not Player(target).state.isCuffed then
          DoCuff(source, target, false, false)
        else
          exports['core']:ExecuteClient(source, "Notification", "Error", "Player Already Cuffed")
        end
      else
        exports['core']:ExecuteClient(source, "Notification", "Error", "Nobody To Cuff")
      end
    end)
  end,
  SoftCuffTarget = function(self, source, target, forced)
    local myPos = GetEntityCoords(GetPlayerPed(source))
    local pos = GetEntityCoords(GetPlayerPed(target))
    if #(vector3(myPos.x, myPos.y, myPos.z) - vector3(pos.x, pos.y, pos.z)) <= 1.5 then
      DoCuff(source, target, false, forced)
      return
    end
    exports['core']:ExecuteClient(source, "Notification", "Error", "Nobody Around To Cuff")
  end,
  HardCuff = function(self, source)
    exports['core']:CallbacksClient(source, "HUD:GetTargetInfront", {}, function(target)
      if target ~= nil then
        if not Player(target).state.isCuffed then
          DoCuff(source, target, true, false)
        else
          exports['core']:ExecuteClient(source, "Notification", "Error", "Player Already Cuffed")
        end
      else
        exports['core']:ExecuteClient(source, "Notification", "Error", "Nobody To Cuff")
      end
    end)
  end,
  HardCuffTarget = function(self, source, target, forced)
    local myPos = GetEntityCoords(GetPlayerPed(source))
    local pos = GetEntityCoords(GetPlayerPed(target))
    if #(vector3(myPos.x, myPos.y, myPos.z) - vector3(pos.x, pos.y, pos.z)) <= 1.5 then
      DoCuff(source, target, true, forced)
      return
    end
    exports['core']:ExecuteClient(source, "Notification", "Error", "Nobody Around To Cuff")
  end,
  Uncuff = function(self, source)
    exports['core']:CallbacksClient(source, "HUD:GetTargetInfront", {}, function(target)
      if target ~= nil then
        if Player(target).state.isCuffed then
          Handcuffs:UncuffTarget(source, target)
        else
          exports['core']:ExecuteClient(source, "Notification", "Error", "Player Is Not Cuffed")
        end
      else
        exports['core']:ExecuteClient(source, "Notification", "Error", "Nobody To Cuff")
      end
    end)
  end,
  UncuffTarget = function(self, source, target)
    exports['core']:CallbacksClient(target, "Handcuffs:VehCheck", {}, function(inVeh)
      if not inVeh then
        if source ~= -1 then
          TriggerClientEvent("Handcuffs:Client:UncuffingAnim", source)
          Citizen.Wait(2200)
        end
        Sounds.Play:Distance(target, 10, "handcuff_remove.ogg", 0.15)
        local playerState = Player(target).state
        local ped = GetPlayerPed(target)
        FreezeEntityPosition(ped, false)
        playerState.isCuffed = false
        playerState.isHardCuffed = false
        SetPedConfigFlag(ped, 120, false)
        SetPedConfigFlag(ped, 121, false)
      else
        exports['core']:ExecuteClient(source, "Notification", "Error", "Unable To Uncuff Player")
      end
    end)
  end,
}
