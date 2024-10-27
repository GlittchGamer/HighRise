AddEventHandler('Fuel:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
  Callbacks = exports['core']:FetchComponent('Callbacks')

  Utils = exports['core']:FetchComponent('Utils')
  Fetch = exports['core']:FetchComponent('Fetch')
  Logger = exports['core']:FetchComponent('Logger')
  Wallet = exports['core']:FetchComponent('Wallet')
  Banking = exports['core']:FetchComponent('Banking')
end

local threading = false
local bankAcc = nil
local depositData = {
  amount = 0,
  transactions = 0
}

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies('Fuel', {
    'Callbacks',

    'Utils',
    'Fetch',
    'Logger',
    'Wallet',
    'Banking',
  }, function(error)
    if #error > 0 then
      return
    end -- Do something to handle if not all dependencies loaded
    RetrieveComponents()
    RegisterCallbacks()

    if not threading then
      Citizen.CreateThread(function()
        while true do
          Citizen.Wait(1000 * 60 * 10)
          if bankAcc then
            if depositData.amount > 0 then
              exports['core']:LoggerTrace("Fuel", string.format("Depositing ^2$%s^7 To ^3%s^7", math.abs(depositData.amount), bankAcc))
              Banking.Balance:Deposit(bankAcc, math.abs(depositData.amount), {
                type = 'deposit',
                title = 'Fuel Services',
                description = string.format("Payment For Fuel Services For %s Vehicles", depositData.transactions),
                data = {},
              }, true)
              depositData = {
                amount = 0,
                transactions = 0
              }
            end
          end
        end
      end)
      threading = true
    end

    Citizen.Wait(2000)
    local f = Banking.Accounts:GetOrganization("dgang")
    if not f then
      print("Failed to get bank account")
      return
    end
    bankAcc = f.Account

    RemoveEventHandler(setupEvent)
  end)
end)

-- {
--   "_id": {
--     "$oid": "66c63e7d82a2074618d5f5e4"
--   },
--   "Owner": "dgang",
--   "Account": 551164,
--   "JobAccess": [
--     {
--       "Job": "dgang",
--       "Permissions": {
--         "DEPOSIT": "BANK_ACCOUNT_DEPOSIT",
--         "WITHDRAW": "BANK_ACCOUNT_WITHDRAW",
--         "BALANCE": "BANK_ACCOUNT_BALANCE",
--         "TRANSACTIONS": "BANK_ACCOUNT_TRANSACTIONS",
--         "MANAGE": "BANK_ACCOUNT_MANAGE",
--         "BILL": "BANK_ACCOUNT_BILL"
--       },
--       "Workplace": false
--     }
--   ],
--   "Type": "organization",
--   "Name": "Lua Holdings LLC",
--   "Balance": 4684
-- }

function RegisterCallbacks()
  exports['core']:CallbacksRegisterServer('Fuel:CompleteFueling', function(source, data, cb)
    local char = exports['core']:FetchSource(source):GetData('Character')
    if char and data and data.vehNet and type(data.vehClass) == 'number' and type(data.fuelAmount) == 'number' then
      local veh = NetworkGetEntityFromNetworkId(data.vehNet)
      if veh and DoesEntityExist(veh) then
        local vehState = Entity(veh)
        local totalCost = CalculateFuelCost(data.vehClass, data.fuelAmount)

        if vehState and vehState.state and totalCost and Wallet:Modify(source, -math.abs(totalCost), true) then
          -- TODO: Incorporate the shop bank accounts where possible so money
          -- is sent to those accounts instead of a static one
          depositData.amount += math.abs(totalCost)
          depositData.transactions += 1

          vehState.state.Fuel = math.min(math.ceil(vehState.state.Fuel + data.fuelAmount), 100)
          cb(true, totalCost)
          return
        end
      end
    end
    cb(false)
  end)

  exports['core']:CallbacksRegisterServer('Fuel:CompleteJerryFueling', function(source, data, cb)
    local char = exports['core']:FetchSource(source):GetData('Character')
    if char and data and data.vehNet and type(data.newAmount) == 'number' then
      local veh = NetworkGetEntityFromNetworkId(data.vehNet)
      if veh and DoesEntityExist(veh) then
        local vehState = Entity(veh)

        if vehState and vehState.state then
          vehState.state.Fuel = math.min(data.newAmount, 100)
          cb(true)
          return
        end
      end
    end
    cb(false)
  end)

  exports['core']:CallbacksRegisterServer("Fuel:FillCan", function(source, data, cb)
    local totalCost = CalculateFuelCost(0, math.floor(100 - (data.pct * 100)))
    cb(totalCost and Wallet:Modify(source, -math.abs(totalCost), true))
  end)
end
