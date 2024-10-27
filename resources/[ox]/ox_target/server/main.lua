local startupEvent = nil
startupEvent = AddEventHandler("Core:Shared:Ready", function()
  RemoveEventHandler(startupEvent)
end)


lib.versionCheck('overextended/ox_target')

if not lib.checkDependency('ox_lib', '3.21.0', true) then return end

---@type table<number, EntityInterface>
local entityStates = {}

---@param netId number
RegisterNetEvent('ox_target:setEntityHasOptions', function(netId)
  local entity = Entity(NetworkGetEntityFromNetworkId(netId))
  entity.state.hasTargetOptions = true
  entityStates[netId] = entity
end)

---@param netId number
---@param door number
RegisterNetEvent('ox_target:toggleEntityDoor', function(netId, door)
  local entity = NetworkGetEntityFromNetworkId(netId)
  if not DoesEntityExist(entity) then return end

  local owner = NetworkGetEntityOwner(entity)
  TriggerClientEvent('ox_target:toggleEntityDoor', owner, netId, door)
end)

CreateThread(function()
  local arr = {}
  local num = 0

  while true do
    Wait(10000)

    for netId, entity in pairs(entityStates) do
      if not DoesEntityExist(entity.__data) or not entity.state.hasTargetOptions then
        entityStates[netId] = nil
        num += 1

        arr[num] = netId
      end
    end

    if num > 0 then
      TriggerClientEvent('ox_target:removeEntity', -1, arr)
      table.wipe(arr)

      num = 0
    end
  end
end)

function formatNumberToCurrency(number)
  local i, j, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')
  int = int:reverse():gsub("(%d%d%d)", "%1,")
  return minus .. int:reverse():gsub("^,", "") .. fraction
end

RegisterNetEvent("Ped:Server:SendCash") -- Needs Testing
AddEventHandler("Ped:Server:SendCash", function(amount, targetServerId)
  local source = source
  local char = exports['core']:FetchSource(source)
  local targetChar = exports['core']:FetchSID(targetServerId):GetData("Character")

  if char ~= nil and targetChar ~= nil then
    local playerCoords = GetEntityCoords(GetPlayerPed(source))
    local targetCoords = GetEntityCoords(GetPlayerPed(targetChar:GetData("Source")))

    if #(playerCoords - targetCoords) <= 5.0 then
      local amount = math.tointeger(amount)
      if amount and amount > 0 then
        if exports['finance']:WalletModify(source, -amount, true) then
          if exports['finance']:WalletModify(targetChar:GetData("Source"), amount, true) then
            exports['core']:ExecuteClient(source, "Notification", "Success", "You Gave $" .. formatNumberToCurrency(amount) .. " in Cash")
            exports['core']:ExecuteClient(targetChar:GetData("Source"), "Notification", "Success",
              "You Just Received $" .. formatNumberToCurrency(amount) .. " in Cash")
          else
            exports['core']:ExecuteClient(source, "Notification", "Error", "Transaction Failed")
          end
        else
          exports['core']:ExecuteClient(source, "Notification", "Error", "Not Enough Cash")
        end
      else
        exports['core']:ExecuteClient(source, "Notification", "Error", "Invalid Amount")
      end
    else
      exports['core']:ExecuteClient(source, "Notification", "Error", "Target Not Nearby")
    end
  else
    exports['core']:ExecuteClient(source, "Notification", "Error", "Character Data Not Found")
  end
end) -- Needs Testing
