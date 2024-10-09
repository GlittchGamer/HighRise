RegisterNUICallback("Banking:GetData", function(data, cb)
  exports["hrrp-base"]:CallbacksServer('Banking:GetAccounts', {}, function(accounts, pendingBills)
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
  exports["hrrp-base"]:CallbacksServer('Banking:DoAccountAction', data, function(success)
    if success then
      exports["hrrp-base"]:CallbacksServer('Banking:GetAccounts', {}, function(accounts, transactions, pendingBills)
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
  exports["hrrp-base"]:CallbacksServer('Billing:AcceptBill', data, function(success)
    cb(success)
  end)
end)

RegisterNUICallback("Banking:DismissBill", function(data, cb)
  exports["hrrp-base"]:CallbacksServer('Billing:DismissBill', data, function(success)
    cb(success)
  end)
end)

RegisterNUICallback("Banking:Bill", function(data, cb)
  exports["hrrp-base"]:CallbacksServer('Billing:CreateBill', data, function(success)
    cb(success)
  end)
end)

AddEventHandler("Phone:Nui:Bank:AcceptBill", function(data)
  exports["hrrp-base"]:CallbacksServer('Billing:AcceptBill', {
    bill = data.bill,
    notify = true
  })
end)

AddEventHandler("Phone:Nui:Bank:DenyBill", function(data)
  exports["hrrp-base"]:CallbacksServer('Billing:DismissBill', data)
end)
