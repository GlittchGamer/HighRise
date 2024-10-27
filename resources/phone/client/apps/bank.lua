RegisterNUICallback("Banking:GetData", function(data, cb)
  exports['core']:CallbacksServer('Banking:GetAccounts', {}, function(accounts, pendingBills)
    cb({
      accounts = accounts,
      transactions = {}, -- TODO: Look into this
      pendingBills = pendingBills or {},
    })
  end)
end)

-- Transfer

RegisterNUICallback("Banking:Transfer", function(data, cb)
  data.action = 'TRANSFER'
  exports['core']:CallbacksServer('Banking:DoAccountAction', data, function(success)
    if success then
      exports['core']:CallbacksServer('Banking:GetAccounts', {}, function(accounts, transactions, pendingBills)
        Phone.Data:Set('bankLoans', {
          accounts = accounts,
          transactions = transactions,
          pendingBills = pendingBills or {},
        })
        cb(true)
      end)
    else
      cb(false)
    end
  end)
end)

-- Bills

RegisterNUICallback("Banking:AcceptBill", function(data, cb)
  exports['core']:CallbacksServer('Billing:AcceptBill', data, function(success)
    cb(success)
  end)
end)

RegisterNUICallback("Banking:DismissBill", function(data, cb)
  exports['core']:CallbacksServer('Billing:DismissBill', data, function(success)
    cb(success)
  end)
end)

RegisterNUICallback("Banking:Bill", function(data, cb)
  exports['core']:CallbacksServer('Billing:CreateBill', data, function(success)
    cb(success)
  end)
end)

AddEventHandler("Phone:Nui:Bank:AcceptBill", function(data)
  exports['core']:CallbacksServer('Billing:AcceptBill', {
    bill = data.bill,
    notify = true
  })
end)

AddEventHandler("Phone:Nui:Bank:DenyBill", function(data)
  exports['core']:CallbacksServer('Billing:DismissBill', data)
end)
