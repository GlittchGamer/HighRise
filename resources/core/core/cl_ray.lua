COMPONENTS.ShapeTest = {
  _protected = true,
  _name = 'base',
  Ray = {
    EntityHit = function(self, startCoords, endCoords)
      local rayHandle = StartShapeTestRay(startCoords.x, startCoords.y, startCoords.z, endCoords.x, endCoords.y, endCoords.z, -1, PlayerPedId(), 0)
      local rayHandle, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)
      if hit then
        return entityHit
      else
        return false
      end
    end
  }
}

local function exportHandler(exportName, func)
  AddEventHandler(('__cfx_export_%s_%s'):format(GetCurrentResourceName(), exportName), function(setCB)
    setCB(function(...)
      return func(COMPONENTS.ShapeTest, ...)
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

for k, v in pairs(COMPONENTS.ShapeTest) do
  if type(v) == "function" then
    exportHandler("ShapeTest" .. k, v)
  elseif type(v) == "table" then
    createExportForObject(v, "ShapeTest" .. k)
  end
end
