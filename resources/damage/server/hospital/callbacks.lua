function HospitalCallbacks()
  Chat:RegisterCommand(
    "icu",
    function(source, args, rawCommand)
      if tonumber(args[1]) then
        local plyr = exports['core']:FetchSID(tonumber(args[1]))
        if plyr ~= nil then
          local char = plyr:GetData("Character")
          if char ~= nil then
            Hospital.ICU:Send(plyr:GetData("Source"))
            Chat.Send.System:Single(source, string.format("%s Has Been Admitted To ICU", args[1]))
          else
            Chat.Send.System:Single(source, "State ID Not Logged In")
          end
        else
          Chat.Send.System:Single(source, "State ID Not Logged In")
        end
      else
        Chat.Send.System:Single(source, "Invalid Arguments")
      end
    end,
    {
      help = "Sends Patient To ICU, Where They Will Remain Until Released By Medical Staff",
      params = {
        {
          name = "Target",
          help = "State ID of target",
        },
      },
    },
    1,
    {
      {
        Id = "ems",
      },
    }
  )
  Chat:RegisterCommand(
    "release",
    function(source, args, rawCommand)
      if tonumber(args[1]) then
        local plyr = exports['core']:FetchSID(tonumber(args[1]))
        if plyr ~= nil then
          local char = plyr:GetData("Character")
          if char ~= nil and char:GetData("ICU") ~= nil and char:GetData("ICU").Released ~= nil and not char:GetData("ICU").Released then
            Hospital.ICU:Release(plyr:GetData("Source"))
            Chat.Send.System:Single(source, string.format("%s Has Been Released From ICU", args[1]))
          else
            Chat.Send.System:Single(source, "State ID Not Logged In")
          end
        else
          Chat.Send.System:Single(source, "State ID Not Logged In")
        end
      else
        Chat.Send.System:Single(source, "Invalid Arguments")
      end
    end,
    {
      help = "Releases a patient from ICU",
      params = {
        {
          name = "Target",
          help = "State ID of target",
        },
      },
    },
    1,
    {
      {
        Id = "ems",
      },
    }
  )

  exports['core']:CallbacksRegisterServer("Hospital:Treat", function(source, data, cb)
    local char = exports['core']:FetchSource(source):GetData("Character")
    local bed = Hospital:RequestBed(source)

    local cost = 5000
    if not GlobalState["Duty:ems"] or GlobalState["Duty:ems"] == 0 then
      cost = 150
    end

    Billing:Charge(source, cost, "Medical Services", "Use of facilities at Mt Zonah Medical Center")

    local f = Banking.Accounts:GetOrganization("ems")
    Banking.Balance:Deposit(f.Account, cost / 2, {
      type = "deposit",
      title = "Medical Treatment",
      description = string.format("Medical Bill For %s %s", char:GetData("First"), char:GetData("Last")),
      data = {},
    }, true)

    f = Banking.Accounts:GetOrganization("government")
    Banking.Balance:Deposit(f.Account, cost / 2, {
      type = "deposit",
      title = "Medical Treatment",
      description = string.format("Medical Bill For %s %s", char:GetData("First"), char:GetData("Last")),
      data = {},
    }, true)

    cb(bed)
  end)

  exports['core']:CallbacksRegisterServer("Hospital:Respawn", function(source, data, cb)
    local char = exports['core']:FetchSource(source):GetData("Character")
    if os.time() >= Player(source).state.releaseTime then
      exports['pwnzor']:PwnzorPlayersTempPosIgnore(source)
      local bed = Hospital:RequestBed(source)

      local cost = 5000
      if not GlobalState["Duty:ems"] or GlobalState["Duty:ems"] == 0 then
        cost = 150
      end

      Billing:Charge(source, cost, "Medical Services", "Use of facilities at Mt Zonah Medical Center")

      local f = Banking.Accounts:GetOrganization("ems")
      Banking.Balance:Deposit(f.Account, cost / 2, {
        type = "deposit",
        title = "Medical Treatment",
        description = string.format("Medical Bill For %s %s", char:GetData("First"), char:GetData("Last")),
        data = {},
      }, true)

      f = Banking.Accounts:GetOrganization("government")
      Banking.Balance:Deposit(f.Account, cost / 2, {
        type = "deposit",
        title = "Medical Treatment",
        description = string.format("Medical Bill For %s %s", char:GetData("First"), char:GetData("Last")),
        data = {},
      }, true)

      cb(bed)
    else
      cb(nil)
    end
  end)

  exports['core']:CallbacksRegisterServer("Hospital:FindBed", function(source, data, cb)
    cb(Hospital:FindBed(source, data))
  end)

  exports['core']:CallbacksRegisterServer("Hospital:OccupyBed", function(source, data, cb)
    cb(Hospital:OccupyBed(source, data))
  end)

  exports['core']:CallbacksRegisterServer("Hospital:LeaveBed", function(source, data, cb)
    cb(Hospital:LeaveBed(source))
  end)

  exports['core']:CallbacksRegisterServer("Hospital:RetreiveItems", function(source, data, cb)
    Hospital.ICU:GetItems(source)
  end)

  exports['core']:CallbacksRegisterServer("Hospital:HiddenRevive", function(source, data, cb)
    local char = exports['core']:FetchSource(source):GetData("Character")
    local p = Player(source).state
    if p.isEscorting ~= nil then
      local t = Player(p.isEscorting).state
      if t ~= nil and t.isDead then
        if Crypto.Exchange:Remove("PLEB", char:GetData("CryptoWallet"), 20) then
          cb(true)
          local tPlyr = exports['core']:FetchSource(p.isEscorting)
          if tPlyr ~= nil then
            exports['core']:CallbacksClient(tPlyr:GetData("Source"), "Damage:Heal", true)
          else
            exports['core']:ExecuteClient(source, "Notification", "Error", "Invalid Target")
          end
        else
          cb(false)
          exports['core']:ExecuteClient(source, "Notification", "Error", "Not Enough Crypto")
        end
      end
    end
  end)

  exports['core']:CallbacksRegisterServer("Hospital:SpawnICU", function(source, data, cb)
    Routing:RoutePlayerToGlobalRoute(source)
    local char = exports['core']:FetchSource(source):GetData("Character")
    Player(source).state.ICU = false
    TriggerClientEvent("Hospital:Client:ICU:Enter", source)
    cb(true)
  end)
end
