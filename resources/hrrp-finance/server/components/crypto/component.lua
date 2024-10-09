_cryptoCoins = {}

AddEventHandler("Crypto:Shared:DependencyUpdate", RetrieveCryptoComponents)
function RetrieveCryptoComponents()
  Fetch = exports["hrrp-base"]:FetchComponent("Fetch")
  Utils = exports["hrrp-base"]:FetchComponent("Utils")
  Execute = exports["hrrp-base"]:FetchComponent("Execute")

  Middleware = exports["hrrp-base"]:FetchComponent("Middleware")
  Callbacks = exports["hrrp-base"]:FetchComponent("Callbacks")
  Chat = exports["hrrp-base"]:FetchComponent("Chat")
  Logger = exports["hrrp-base"]:FetchComponent("Logger")
  Generator = exports["hrrp-base"]:FetchComponent("Generator")
  Phone = exports["hrrp-base"]:FetchComponent("Phone")
  Crypto = exports["hrrp-base"]:FetchComponent("Crypto")
  Banking = exports["hrrp-base"]:FetchComponent("Banking")
  Billing = exports["hrrp-base"]:FetchComponent("Billing")
  Loans = exports["hrrp-base"]:FetchComponent("Loans")
  Wallet = exports["hrrp-base"]:FetchComponent("Wallet")
  Tasks = exports["hrrp-base"]:FetchComponent("Tasks")
  Jobs = exports["hrrp-base"]:FetchComponent("Jobs")
  Vehicles = exports["hrrp-base"]:FetchComponent("Vehicles")
  Inventory = exports["hrrp-base"]:FetchComponent("Inventory")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports["hrrp-base"]:RequestDependencies("Crypto", {
    "Fetch",
    "Utils",
    "Execute",
    "Chat",

    "Middleware",
    "Callbacks",
    "Logger",
    "Generator",
    "Phone",
    "Wallet",
    "Banking",
    "Billing",
    "Loans",
    "Crypto",
    "Jobs",
    "Tasks",
    "Vehicles",
    "Inventory",
  }, function(error)
    if #error > 0 then
      exports["hrrp-base"]:FetchComponent("Logger"):Critical("Crypto", "Failed To Load All Dependencies")
      return
    end
    RetrieveCryptoComponents()

    RemoveEventHandler(setupEvent)
  end)
end)

_CRYPTO = {
  Coin = {
    Create = function(self, name, acronym, price, buyable, sellable)
      while Crypto == nil do
        Citizen.Wait(1)
      end

      if not Crypto.Coin:Get(acronym) then
        table.insert(_cryptoCoins, {
          Name = name,
          Short = acronym,
          Price = price,
          Buyable = buyable,
          Sellable = sellable,
        })
      else
        for k, v in ipairs(_cryptoCoins) do
          if v.Short == acronym then
            _cryptoCoins[k] = {
              Name = name,
              Short = acronym,
              Price = price,
              Buyable = buyable,
              Sellable = sellable,
            }
            return
          end
        end
      end
    end,
    Get = function(self, acronym)
      for k, v in ipairs(_cryptoCoins) do
        if v.Short == acronym then
          return v
        end
      end

      return nil
    end,
    GetAll = function(self)
      return _cryptoCoins
    end,
  },
  Has = function(self, source, coin, amt)
    local plyr = exports['hrrp-base']:FetchSource(source)
    if plyr ~= nil then
      local char = plyr:GetData("Character")
      if char ~= nil then
        local crypto = char:GetData("Crypto") or {}
        return crypto[coin] ~= nil and crypto[coin] >= amt
      else
        return false
      end
    else
      return false
    end
  end,
  Exchange = {
    IsListed = function(self, coin)
      for k, v in ipairs(_cryptoCoins) do
        if v.Short == coin then
          return true
        end
      end
      return false
    end,
    Buy = function(self, coin, target, amount)
      if Crypto.Exchange:IsListed(coin) then
        local plyr = exports['hrrp-base']:FetchSID(target)
        if plyr ~= nil then
          local char = plyr:GetData("Character")
          if char ~= nil then
            local acc = Banking.Accounts:GetPersonal(char:GetData("SID"))
            local coinData = Crypto.Coin:Get(coin)
            if acc.Balance >= (coinData.Price * amount) then
              if
                  Banking.Balance:Withdraw(acc.Account, (coinData.Price * amount), {
                    type = "withdraw",
                    title = "Crypto Purchase",
                    description = string.format("Bought %s $%s", amount, coin),
                    transactionAccount = false,
                    data = {
                      character = char:GetData("SID"),
                    },
                  })
              then
                Phone.Notification:Add(
                  char:GetData("Source"),
                  "Crypto Purchase",
                  string.format("You Bought %s $%s", amount, coin),
                  os.time() * 1000,
                  6000,
                  "crypto",
                  {}
                )
                return Crypto.Exchange:Add(coin, char:GetData("CryptoWallet"), amount)
              else
                return false
              end
            else
              Phone.Notification:Add(
                char:GetData("Source"),
                "Crypto Purchase",
                "Insufficient Funds",
                os.time() * 1000,
                6000,
                "crypto",
                {}
              )
              return false
            end
          else
            return false
          end
        else
          return false
        end
      else
        return false
      end
    end,
    Sell = function(self, coin, target, amount)
      if Crypto.Exchange:IsListed(coin) then
        local plyr = exports['hrrp-base']:FetchSID(target)
        if plyr ~= nil then
          local char = plyr:GetData("Character")
          if char ~= nil then
            local acc = Banking.Accounts:GetPersonal(char:GetData("SID"))
            local coinData = Crypto.Coin:Get(coin)

            if coinData.Sellable then
              if Crypto.Exchange:Remove(coin, char:GetData("CryptoWallet"), amount, true) then
                return Banking.Balance:Deposit(acc.Account, (coinData.Sellable * amount), {
                  type = "deposit",
                  title = "Crypto Sale",
                  description = string.format("Sold %s $%s", amount, coin),
                  transactionAccount = false,
                  data = {
                    character = char:GetData("SID"),
                  },
                })
              else
                return false
              end
            else
              return false
            end
          else
            return false
          end
        else
          return false
        end
      else
        return false
      end
    end,
    Add = function(self, coin, target, amount, skipAlert)
      local plyr = Fetch:CharacterData("CryptoWallet", target)
      if plyr == nil then
        local char = plyr:GetData("Character")
        local crypto = char:GetData("Crypto") or {}
        if crypto[coin] == nil then
          crypto[coin] = 0
        end

        crypto[coin] = crypto[coin] + amount
        char:SetData("Crypto", crypto)

        if not skipAlert then
          Phone.Notification:Add(
            char:GetData("Source"),
            "Received Crypto",
            string.format("You Received %s $%s", amount, coin),
            os.time(),
            6000,
            "crypto",
            {}
          )
        end

        return true
      else
        local fetchUser = MySQL.single.await(
          "SELECT `CryptoWallet`, `Crypto` FROM characters WHERE CryptoWallet = @CryptoWallet", {
            ["@CryptoWallet"] = target,
          })
        if not fetchUser then
          return false
        end

        local Crypto = json.decode(fetchUser.Crypto)
        if not Crypto then
          Crypto = {}
        end
        Crypto[coin] = (Crypto[coin] or 0) + amount

        local affectedRows = MySQL.update.await(
          "UPDATE characters SET Crypto = @Crypto WHERE CryptoWallet = @CryptoWallet", {
            ["@Crypto"] = json.encode(Crypto),
            ["@CryptoWallet"] = target,
          }
        )

        return affectedRows > 0
      end
    end,
    Remove = function(self, coin, target, amount, skipAlert)
      local p = promise.new()
      local plyr = Fetch:CharacterData("CryptoWallet", target)
      if plyr ~= nil then
        local char = plyr:GetData("Character")
        local crypto = char:GetData("Crypto") or {}

        if crypto[coin] == nil then
          crypto[coin] = 0
        end

        if crypto[coin] >= amount then
          crypto[coin] = crypto[coin] - amount
          char:SetData("Crypto", crypto)

          if not skipAlert then
            Phone.Notification:Add(
              char:GetData("Source"),
              "Crypto Purchase",
              string.format("You Paid %s $%s", amount, coin),
              os.time(),
              6000,
              "crypto",
              {}
            )
          end

          p:resolve(true)
        else
          p:resolve(false)
        end
      else
        local fetchUser = MySQL.single.await(
          "SELECT `CryptoWallet`, `Crypto` FROM characters WHERE CryptoWallet = @CryptoWallet", {
            ["@CryptoWallet"] = target,
          })
        if not fetchUser then
          return false
        end

        local Crypto = json.decode(fetchUser.Crypto)
        if not Crypto then
          Crypto = {}
        end

        if Crypto[coin] >= amount then
          Crypto[coin] = Crypto[coin] - amount

          local affectedRows = MySQL.update.await(
            "UPDATE characters SET Crypto = @Crypto WHERE CryptoWallet = @CryptoWallet", {
              ["@Crypto"] = json.encode(Crypto),
              ["@CryptoWallet"] = target,
            }
          )

          return affectedRows > 0
        else
          return false
        end
      end
    end,
    Transfer = function(self, coin, sender, target, amount)
      local plyr = exports['hrrp-base']:FetchSID(sender)
      if plyr then
        local char = plyr:GetData("Character")
        if char then
          if char:GetData("CryptoWallet") ~= target then
            local plyr2 = Fetch:CharacterData("CryptoWallet", target)

            if plyr2 or DoesCryptoWalletExist(target) then
              if Crypto.Exchange:Remove(coin, char:GetData("CryptoWallet"), math.abs(amount), true) then
                Phone.Notification:Add(
                  plyr:GetData("Source"),
                  "Crypto Transfer",
                  string.format("You Sent %s $%s", amount, coin),
                  os.time() * 1000,
                  6000,
                  "crypto",
                  {}
                )

                if Crypto.Exchange:Add(coin, target, math.abs(amount), true) then
                  if plyr2 then
                    Phone.Notification:Add(
                      plyr2:GetData("Source"),
                      "Crypto Transfer",
                      string.format("You Received %s $%s", amount, coin),
                      os.time() * 1000,
                      6000,
                      "crypto",
                      {}
                    )
                  end

                  return true
                end
              end
            end
          end
        end
      end
      return false
    end,
  },
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
  exports["hrrp-base"]:RegisterComponent("Crypto", _CRYPTO)
end)
