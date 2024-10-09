COMPONENTS.Spawn = COMPONENTS.Spawn or {
  _required = { 'InitCamera', 'Init' },
  _name = 'base',
}

COMPONENTS.Spawn.SpawnPoint = {
  x = -1044.84,
  y = -2749.85,
  z = 21.36,
  h = 0
}

function COMPONENTS.Spawn.InitCamera(self)
  return
end

function COMPONENTS.Spawn.Init(self)
  DoScreenFadeOut(500)
  SetEntityCoords(PlayerPedId(), self.SpawnPoint.x, self.SpawnPoint.y, self.SpawnPoint.z)
  SetEntityHeading(PlayerPedId(), self.SpawnPoint.h)
  ShutdownLoadingScreen()

  DoScreenFadeIn(500)

  while not IsScreenFadingIn() do
    Citizen.Wait(10)
  end
end

AddEventHandler('playerSpawned', function()
  COMPONENTS.Spawn:Init()
end)

AddEventHandler('onClientMapStart', function()
  COMPONENTS.Spawn:InitCamera()
  exports['spawnmanager']:spawnPlayer()
  Citizen.Wait(2500)
  exports['spawnmanager']:setAutoSpawn(false)
end)

local function exportHandler(exportName, func)
  AddEventHandler(('__cfx_export_%s_%s'):format(GetCurrentResourceName(), exportName), function(setCB)
    setCB(function(...)
      return func(COMPONENTS.Spawn, ...)
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

for k, v in pairs(COMPONENTS.Spawn) do
  if type(v) == "function" then
    exportHandler("Spawn" .. k, v)
  elseif type(v) == "table" then
    createExportForObject(v, "Spawn" .. k)
  end
end
