COMPONENTS.Core = {
  Shutdown = function(self, reason)
    COMPONENTS.Logger:Critical("Core", "Shutting Down Core, Reason: " .. reason, {
      console = true,
      file = true,
    })

    Citizen.Wait(1000) -- Need wait period so logging can finish
    os.exit()
  end,
  DropAll = function(self)
    for k, v in pairs(COMPONENTS.Players) do
      if v ~= nil then
        DropPlayer(
          v:GetData("Source"),
          "⛔ Server Restarting ⛔ Due to a pending restart, you've been dropped from the server. Please ❗❗❗RESTART FIVEM❗❗❗ and reconnect in a few minutes."
        )
      end
    end
  end,
}

AddEventHandler("Core:Server:ForceAllSave", function()
  COMPONENTS.Queue.Utils:CloseAndDrop()
  COMPONENTS.Core.DropAll()
  TriggerEvent("Core:Server:ForceSave")
end)

AddEventHandler("txAdmin:events:scheduledRestart", function(eventData)
  if eventData.secondsRemaining <= 60 then
    COMPONENTS.Queue.Utils:CloseAndDrop()
    COMPONENTS.Core.DropAll()
    TriggerEvent("Core:Server:ForceSave")
  elseif not GlobalState["RestartLockdown"] and eventData.secondsRemaining <= (60 * 30) then
    GlobalState["RestartLockdown"] = true
  end

  -- COMPONENTS.Chat.Send.System:Broadcast( -- TX Admin Sends them
  -- 	string.format("Server Restart In %s Minutes", math.floor(eventData.secondsRemaining / 60))
  -- )
end)

AddEventHandler("Core:Server:StartupReady", function()
  Citizen.CreateThread(function()
    while not exports or exports[GetCurrentResourceName()] == nil do
      Citizen.Wait(1)
    end


    TriggerEvent("Proxy:Shared:RegisterReady")
    for k, v in pairs(COMPONENTS) do
      TriggerEvent("Proxy:Shared:ExtendReady", k)
    end

    Citizen.Wait(1000)

    COMPONENTS.Proxy.ExportsReady = true
    TriggerEvent("Proxy:Shared:ExportsReady")

    SetupAPIHandler()

    TriggerEvent("Core:Shared:Ready")
    return
  end)
end)

Citizen.CreateThread(function()
  while true do
    GlobalState["OS:Time"] = os.time()
    Citizen.Wait(1000)
  end
end)

AddEventHandler("Database:Server:Ready", function()
  COMPONENTS.Proxy.DatabaseReady = true
  TriggerEvent("Core:Shared:Ready")
end)

RegisterNetEvent("Core:Server:ResourceStopped", function(resource)
  local src = source
  if resource == "hrrp-pwnzor" then
    COMPONENTS.Punishment.Ban:Source(src, -1, "Pwnzor Resource Stopped", "Pwnzor")
  end
end)

local function exportHandler(exportName, func)
  AddEventHandler(('__cfx_export_%s_%s'):format(GetCurrentResourceName(), exportName), function(setCB)
    setCB(function(...)
      return func(COMPONENTS.Core, ...)
    end)
  end)
end

local function createExportForObject(object, name)
  name = name or ""
  for k, v in pairs(object) do
    if type(v) == "function" then
      exportHandler(name .. k, v)
    elseif type(v) == "table" then
      createExportForObject(v, name .. k)
    end
  end
end

for k, v in pairs(COMPONENTS.Core) do
  if type(v) == "function" then
    exportHandler("Core" .. k, v)
  elseif type(v) == "table" then
    createExportForObject(v, "Core" .. k)
  end
end
