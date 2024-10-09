_casinoConfig = {}

_casinoConfigLoaded = false

AddEventHandler("Casino:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Fetch = exports["hrrp-base"]:FetchComponent("Fetch")
  Utils = exports["hrrp-base"]:FetchComponent("Utils")
  Execute = exports["hrrp-base"]:FetchComponent("Execute")

  Middleware = exports["hrrp-base"]:FetchComponent("Middleware")
  Callbacks = exports["hrrp-base"]:FetchComponent("Callbacks")
  Chat = exports["hrrp-base"]:FetchComponent("Chat")
  Logger = exports["hrrp-base"]:FetchComponent("Logger")
  Generator = exports["hrrp-base"]:FetchComponent("Generator")
  Phone = exports["hrrp-base"]:FetchComponent("Phone")
  Jobs = exports["hrrp-base"]:FetchComponent("Jobs")
  Vehicles = exports["hrrp-base"]:FetchComponent("Vehicles")
  Inventory = exports["hrrp-base"]:FetchComponent("Inventory")
  Wallet = exports["hrrp-base"]:FetchComponent("Wallet")
  Crafting = exports["hrrp-base"]:FetchComponent("Crafting")
  Banking = exports["hrrp-base"]:FetchComponent("Banking")
  Casino = exports["hrrp-base"]:FetchComponent("Casino")
  Loot = exports["hrrp-base"]:FetchComponent("Loot")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports["hrrp-base"]:RequestDependencies("Casino", {
    "Fetch",
    "Utils",
    "Execute",
    "Chat",

    "Middleware",
    "Callbacks",
    "Logger",
    "Generator",
    "Phone",
    "Jobs",
    "Vehicles",
    "Inventory",
    "Wallet",
    "Crafting",
    "Banking",
    "Casino",
    "Loot",
  }, function(error)
    if #error > 0 then
      exports["hrrp-base"]:FetchComponent("Logger"):Critical("Casino", "Failed To Load All Dependencies")
      return
    end
    RetrieveComponents()

    TriggerEvent("Casino:Server:Startup")

    GlobalState["CasinoOpen"] = not GlobalState.IsProduction


    -- Middleware:Add("Characters:Spawning", function(source)
    -- 	TriggerClientEvent("Businesses:Client:CreatePoly", source, _pickups)
    -- end, 2)

    exports['hrrp-base']:CallbacksRegisterServer("Casino:OpenClose", function(source, data, cb)
      if Player(source).state.onDuty == "casino" and data.state ~= GlobalState["CasinoOpen"] then
        GlobalState["CasinoOpen"] = data.state

        if GlobalState["CasinoOpen"] then
          exports['hrrp-base']:ExecuteClient(source, "Notification", "Success", "Casino Opened")
        else
          exports['hrrp-base']:ExecuteClient(source, "Notification", "Error", "Casino Closed")
        end
      else
        exports['hrrp-base']:ExecuteClient(source, "Notification", "Error", "Error Opening/Closing Casino")
      end
    end)

    exports['hrrp-base']:CallbacksRegisterServer("Casino:BuyChips", function(source, amount, cb)
      local char = exports['hrrp-base']:FetchSource(source):GetData("Character")
      if char and amount and amount > 0 then
        local amount = math.floor(amount)
        if Wallet:Modify(source, -amount) then
          local total = Casino.Chips:Modify(source, amount)
          if total then
            SendCasinoPhoneNotification(source, string.format("Purchased $%s in Chips", formatNumberToCurrency(amount)),
              string.format("You now have a chip balance of $%s", formatNumberToCurrency(total)))

            return cb(true)
          end
        end
      end

      cb(false)
    end)

    exports['hrrp-base']:CallbacksRegisterServer("Casino:SellChips", function(source, amount, cb)
      local char = exports['hrrp-base']:FetchSource(source):GetData("Character")
      if char and amount and amount > 0 then
        local amount = math.floor(amount)
        local chipTotal = Casino.Chips:Modify(source, -amount)
        if chipTotal then
          if Wallet:Modify(source, amount) then
            SendCasinoPhoneNotification(source, string.format("Cashed Out $%s of Chips", formatNumberToCurrency(amount)),
              string.format("You now have a chip balance of $%s", formatNumberToCurrency(chipTotal)))

            return cb(true)
          end
        end
      end

      cb(false)
    end)

    exports['hrrp-base']:CallbacksRegisterServer("Casino:PurchaseVIP", function(source, amount, cb)
      local char = exports['hrrp-base']:FetchSource(source):GetData("Character")
      if char then
        if Wallet:Modify(source, -10000) then
          Inventory:AddItem(char:GetData("SID"), "diamond_vip", 1, {}, 1)
          GiveCasinoFuckingMoney(source, "VIP Card", 10000)
        else
          exports['hrrp-base']:ExecuteClient(source, "Notification", "Error", "Not Enough Cash")
        end
      end

      cb(true)
    end)

    exports['hrrp-base']:CallbacksRegisterServer("Casino:GetBigWins", function(source, data, cb)
      if Player(source).state.onDuty == "casino" then
        local query = "SELECT * FROM casino_bigwins"

        local results = MySQL.query.await(query, {})

        if results and #results > 0 then
          cb(results)
        else
          cb(false)
        end
      else
        cb(false)
      end
    end)


    Chat:RegisterCommand("chips", function(source, args, rawCommand)
      local chipTotal = Casino.Chips:Get(source)

      SendCasinoPhoneNotification(source, "Current Chip Balance",
        string.format("Your current balance is $%s", formatNumberToCurrency(chipTotal)))
    end, {
      help = "Show Casino Chip Balance",
    })

    RunConfigStartup()

    RemoveEventHandler(setupEvent)
  end)
end)

local _configStartup = false
function RunConfigStartup()
  if not _configStartup then
    _configStartup = true

    local query = "SELECT * FROM casino_config"

    local results = MySQL.query.await(query, {})

    if results and #results > 0 then
      for _, v in ipairs(results) do
        local decodedData = json.decode(v.data)
        _casinoConfig[v.key] = decodedData
      end
    end

    _casinoConfigLoaded = true
  end
end

_CASINO = {
  Chips = {
    Get = function(self, source)
      local char = exports['hrrp-base']:FetchSource(source):GetData("Character")
      if char then
        return char:GetData("CasinoChips") or 0
      end
      return 0
    end,
    Has = function(self, source, amount)
      local char = exports['hrrp-base']:FetchSource(source):GetData("Character")
      if char and amount > 0 then
        local currentChips = char:GetData("CasinoChips") or 0
        if currentChips >= amount then
          return true
        end
      end
      return false
    end,
    Modify = function(self, source, amount)
      local char = exports['hrrp-base']:FetchSource(source):GetData("Character")
      if char then
        local currentChips = char:GetData("CasinoChips") or 0
        local newChipBalance = math.floor(currentChips + amount)
        if newChipBalance >= 0 then
          char:SetData("CasinoChips", newChipBalance)
          return newChipBalance
        end
      end
      return false
    end,
  },
  Config = {
    Set = function(self, key, data)
      local query = [[
				INSERT INTO casino_config (`key`, `data`)
				VALUES (@key, @data)
				ON DUPLICATE KEY UPDATE
				`data` = @data
			]]

      local params = {
        ['@key'] = key,
        ['@data'] = json.encode(data)
      }

      local affectedRows = MySQL.insert.await(query, params)

      if affectedRows > 0 then
        _casinoConfig[key] = data
        _casinoConfigLoaded = true
        return true
      else
        _casinoConfigLoaded = true
        return false
      end
    end,

    Get = function(self, key)
      return _casinoConfig[key]
    end
  }
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
  exports["hrrp-base"]:RegisterComponent("Casino", _CASINO)
end)

function SendCasinoWonChipsPhoneNotification(source, amount)
  local chipTotal = Casino.Chips:Get(source)
  SendCasinoPhoneNotification(source, string.format("You Won $%s in Chips!", formatNumberToCurrency(amount)),
    string.format("Your balance is now $%s", formatNumberToCurrency(chipTotal)))
end

function SendCasinoSpentChipsPhoneNotification(source, amount)
  local chipTotal = Casino.Chips:Get(source)
  SendCasinoPhoneNotification(source, string.format("You Paid $%s in Chips!", formatNumberToCurrency(amount)),
    string.format("Your balance is now $%s", formatNumberToCurrency(chipTotal)))
end

function SendCasinoPhoneNotification(source, title, description, time)
  Phone.Notification:Add(source, title, description, os.time() * 1000, time or 7500, {
    color = "#18191e",
    label = "Casino",
    icon = "cards",
  }, {}, nil)
end

function GiveCasinoFuckingMoney(source, game, amount)
  local charInfo = "Unknown"

  local plyr = exports['hrrp-base']:FetchSource(source)
  if plyr then
    local char = plyr:GetData("Character")
    if char then
      charInfo = string.format("%s %s [%s]", char:GetData("First"), char:GetData("Last"), char:GetData("SID"))
    end
  end

  local f = Banking.Accounts:GetOrganization("casino-bets")
  Banking.Balance:Deposit(f.Account, amount, {
    type = "deposit",
    title = game,
    description = string.format("%s Profit From %s", game, charInfo),
    data = {},
  }, true)
end
