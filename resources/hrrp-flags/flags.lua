Flags = {}

local curVehicleFlag = 1
local function prevVehicleFlag()
  curVehicleFlag = curVehicleFlag * 2
  return curVehicleFlag / 2
end

Flags["VehicleFlags"] = {
  isCarShopVehicle = prevVehicleFlag(),
}

local curPedFlag = 1
local function prevPedFlag()
  curPedFlag = curPedFlag * 2
  return curPedFlag / 2
end

Flags["PedFlags"] = { --! No more than 28, exceeds int limit
  isNPC = prevPedFlag()
}

Flags["ObjectFlags"] = {}
