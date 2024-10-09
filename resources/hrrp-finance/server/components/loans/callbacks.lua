function GetCharactersLoans(stateId)
  local myLoans = MySQL.query.await("SELECT * FROM loans WHERE SID = @SID", {
    ["@SID"] = stateId,
  })

  return myLoans
end

function RegisterLoanCallbacks()
  exports['hrrp-base']:CallbacksRegisterServer('Loans:GetLoans', function(source, data, cb)
    local char = exports['hrrp-base']:FetchSource(source):GetData("Character")
    if char then
      local SID = char:GetData('SID')
      local loans = GetCharactersLoans(SID)
      cb({
        loans = loans,
        creditScore = GetCharacterCreditScore(SID)
      })
    else
      cb(false)
    end
  end)

  exports['hrrp-base']:CallbacksRegisterServer('Loans:Payment', function(source, data, cb)
    local char = exports['hrrp-base']:FetchSource(source):GetData("Character")
    if char and data and data.loan then
      local SID = char:GetData('SID')
      local res = Loans:MakePayment(source, data.loan, data.paymentAhead, data.weeks)
      if res and res.success then
        cb(res, {
          loans = GetCharactersLoans(SID),
          creditScore = GetCharacterCreditScore(SID),
        })
      else
        cb(res)
      end
    else
      cb(false)
    end
  end)
end
