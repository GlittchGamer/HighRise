_WALLET = {
  Get = function(self, source)
    local char = exports['core']:FetchSource(source):GetData("Character")
    if char then
      return char:GetData("Cash") or 0
    end
    return 0
  end,
  Has = function(self, source, amount)
    local char = exports['core']:FetchSource(source):GetData("Character")
    if char and amount > 0 then
      local currentCash = char:GetData("Cash") or 0
      if currentCash >= amount then
        return true
      end
    end
    return false
  end,
  Modify = function(self, source, amount, skipNotify)
    local char = exports['core']:FetchSource(source):GetData("Character")
    if char then
      local currentCash = char:GetData("Cash") or 0
      local newCashBalance = math.floor(currentCash + amount)
      if newCashBalance >= 0 then
        char:SetData("Cash", newCashBalance)

        if not skipNotify then
          if amount < 0 then
            exports['core']:ExecuteClient(
              source,
              "Notification",
              "Info",
              string.format("You Paid $%s In Cash", formatNumberToCurrency(math.floor(math.abs(amount))))
            )
          else
            exports['core']:ExecuteClient(
              source,
              "Notification",
              "Success",
              string.format("You Received $%s In Cash", formatNumberToCurrency(math.floor(amount)))
            )
          end
        end
        return newCashBalance
      end
    end
    return false
  end,
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
  exports['core']:RegisterComponent("Wallet", _WALLET)
end)

local function exportHandler(exportName, func)
  AddEventHandler(('__cfx_export_%s_%s'):format(GetCurrentResourceName(), exportName), function(setCB)
    setCB(function(...)
      return func(_WALLET, ...)
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

for k, v in pairs(_WALLET) do
  if type(v) == "function" then
    exportHandler("Wallet" .. k, v)
  elseif type(v) == "table" then
    createExportForObject(v, "Wallet" .. k)
  end
end
