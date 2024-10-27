DecorRegister("PedFlags", 3)
DecorRegister("ObjectFlags", 3)
DecorRegister("VehicleFlags", 3)

local FLAGS = {
  Vehicles = {
    SetFlag = function(self, vehicle, flag, enabled)
      local mask = Flags["VehicleFlags"][flag]

      if mask ~= nil and DoesEntityExist(vehicle) then
        local field = DecorGetInt(vehicle, "VehicleFlags")

        -- Sync.DecorSetInt(vehicle, "VehicleFlags", enabled and field | mask or field &~ mask)
        -- NotifyChange('vehicle', vehicle, flag, enabled)
      end
    end,
    HasFlag = function(self, vehicle, flag)
      local mask = Flags["VehicleFlags"][flag]

      if mask ~= nil and DoesEntityExist(vehicle) then
        local field = DecorGetInt(vehicle, "VehicleFlags")

        return (field & mask) > 0
      end
      return false
    end,
    GetFlags = function(self, vehicle)
      local field = DecorGetInt(vehicle, "VehicleFlags")
      local flags = {}

      if field and field >= 0 then
        for flag, mask in pairs(Flags["VehicleFlags"]) do
          flags[flag] = (field & mask) > 0
        end
      end

      return flags
    end,
    SetFlags = function(self, vehicle, flags)
      local field = DecorGetInt(vehicle, "VehicleFlags")

      for flag, enabled in pairs(flags) do
        local mask = Flags["VehicleFlags"][flag]

        if (mask) then
          field = enabled and field | mask or field & ~mask
        end
      end

      -- Sync.DecorSetInt(vehicle, "VehicleFlags", field)
    end,
  },
  Peds = {
    SetFlag = function(self, ped, flag, enabled)
      local mask = Flags["PedFlags"][flag]

      if mask ~= nil and DoesEntityExist(ped) then
        local field = DecorGetInt(ped, "PedFlags")

        DecorSetInt(ped, "PedFlags", enabled and field | mask or field & ~mask)
        -- NotifyChange('ped', ped, flag, enabled)
      end
    end,
    HasFlag = function(self, ped, flag)
      local mask = Flags["PedFlags"][flag]

      if mask ~= nil and DoesEntityExist(ped) then
        local field = DecorGetInt(ped, "PedFlags")

        return (field & mask) > 0
      end
      return false
    end,
    GetFlags = function(self, ped)
      local field = DecorGetInt(ped, "PedFlags")
      local flags = {}

      if field and field >= 0 then
        for flag, mask in pairs(Flags["PedFlags"]) do
          flags[flag] = (field & mask) > 0
        end
      end

      return flags
    end,
    SetFlags = function(self, ped, flags)
      local field = DecorGetInt(ped, "PedFlags")

      for flag, enabled in pairs(flags) do
        local mask = Flags["PedFlags"][flag]

        if (mask) then
          field = enabled and field | mask or field & ~mask
        end
      end

      DecorSetInt(ped, "PedFlags", field)
    end,
  },
  Objects = {
    SetFlag = function(self, object, flag, enabled)
      local mask = Flags["ObjectFlags"][flag]

      if mask ~= nil and DoesEntityExist(object) then
        local field = DecorGetInt(object, "ObjectFlags")

        DecorSetInt(object, "ObjectFlags", enabled and field | mask or field & ~mask)
      end
    end,
    HasFlag = function(self, object, flag)
      local mask = Flags["ObjectFlags"][flag]

      if mask ~= nil and DoesEntityExist(object) then
        local field = DecorGetInt(object, "ObjectFlags")

        return (field & mask) > 0
      end
      return false
    end,
    GetFlags = function(self, object)
      local field = DecorGetInt(object, "ObjectFlags")
      local flags = {}

      if field and field >= 0 then
        for flag, mask in pairs(Flags["ObjectFlags"]) do
          flags[flag] = (field & mask) > 0
        end
      end

      return flags
    end,
    SetFlags = function(self, object, flags)
      local field = DecorGetInt(object, "ObjectFlags")

      for flag, enabled in pairs(flags) do
        local mask = Flags["ObjectFlags"][flag]

        if (mask) then
          field = enabled and field | mask or field & ~mask
        end
      end

      DecorSetInt(object, "ObjectFlags", field)
    end,
  },
}

local function exportHandler(exportName, func)
  AddEventHandler(('__cfx_export_%s_%s'):format(GetCurrentResourceName(), exportName), function(setCB)
    setCB(function(...)
      return func(FLAGS, ...)
    end)
  end)
end

local function createExportForObject(object, name)
  name = name or ""
  for k, v in pairs(object) do
    print(name, k)
    if type(v) == "function" then
      exportHandler(name .. k, v)
    elseif type(v) == "table" then
      createExportForObject(v, name .. k)
    end
  end
end

for k, v in pairs(FLAGS) do
  if type(v) == "function" then
    exportHandler(k, v)
  elseif type(v) == "table" then
    createExportForObject(v, k)
  end
end
