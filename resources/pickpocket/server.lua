AddEventHandler("Picker:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Inventory = exports['core']:FetchComponent("Inventory")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies("Picker", {
    "Inventory",
  }, function(error)
    if #error > 0 then
      exports['core']:LoggerCritical("Picker", "Failed To Load All Dependencies")
      return
    end
    RetrieveComponents()
    RemoveEventHandler(setupEvent)
  end)
end)

local lootTable = {
  { item = "sandwich",      probability = 0.4 },
  { item = "soda",          probability = 0.3 },
  { item = "water",         probability = 0.2 },
  { item = "burger",        probability = 0.1 },
  { item = "chocolate_bar", probability = 0.5 },
  { item = "donut",         probability = 0.2 },
  { item = "energy_pepe",   probability = 0.2 }
}

local function getRandomLootItem()
  local randomValue = math.random()
  local cumulativeProbability = 0

  for _, loot in ipairs(lootTable) do
    cumulativeProbability = cumulativeProbability + loot.probability
    if randomValue <= cumulativeProbability then
      return loot.item
    end
  end

  -- Fallback in case of rounding errors
  return lootTable[#lootTable].item
end

function formatNumberToCurrency(number)
  local i, j, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')
  int = int:reverse():gsub("(%d%d%d)", "%1,")
  return minus .. int:reverse():gsub("^,", "") .. fraction
end

-- Event that handles giving an item when pickpocketing
RegisterNetEvent('Ped:Server:GiveItemPick:SkinnyCunt')
AddEventHandler('Ped:Server:GiveItemPick:SkinnyCunt', function()
  local src = source
  local amount = math.random(100, 200)
  local Player = exports['core']:FetchSource(src)
  local Char = Player:GetData('Character')
  exports['finance']:WalletModify(Char:GetData("Source"), amount, true)
  exports['core']:ExecuteClient(Char:GetData("Source"), "Notification", "Success",
    "Please just leave me alone, You managed to take $" .. formatNumberToCurrency(amount) .. " in Cash")
end)

RegisterNetEvent('Ped:Server:GiveItemPick:FatCunt') -- not working... wtf
AddEventHandler('Ped:Server:GiveItemPick:FatCunt', function()
  local src = source
  local Player = exports['core']:FetchSource(src)
  local Char = Player:GetData('Character')

  -- Select a random item from the loot table
  local randomItem = getRandomLootItem()

  -- Give the item to the player

  Inventory:AddItem(Char:GetData("SID"), randomItem, math.random(1, 2), {}, 1)

  exports['core']:ExecuteClient(Char:GetData("Source"), "Notification", "Success", "Whyyyyy Thats my lunch, You managed to take a " .. randomItem)
end)
