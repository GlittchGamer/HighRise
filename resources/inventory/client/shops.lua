Shops = {}
showingMarker = false
_isLoggedIn = false

local npcData = {
  ['General Store'] = { first_name = 'Ranjesh', last_name = 'Gupta', description = 'You can get all of your general products from me...' },
  ['Liquor Store'] = { first_name = 'Vincent', last_name = 'Spirits', description = 'Indulge in Every Pour, Crafted for Your Pleasure.' },
  ['Ammunation'] = { first_name = 'Micheal', last_name = 'Anderson', description = 'Grab all your legal firearm equipment from here.' },
  ['Hardware Store'] = { first_name = 'James', last_name = 'Wrinklethorpe', description = 'Grab all of your utilities here.' },
  ['Medical Supplies'] = { first_name = 'Jim', last_name = 'Long', description = 'Need a bandage ?' },
  ['Pharmacy'] = { first_name = 'Betty', last_name = 'Bandage', description = 'Need a bandage ?' },
  ['Hunting Supplies'] = { first_name = 'Elena', last_name = 'Blackwood', description = 'Gear up for the wilderness: Your one-stop shop for hunters' },
  ['Fishing Supplies'] = { first_name = 'Caleb', last_name = 'Rivers', description = 'Reel in the adventure, your premier destination for angling essentials' },
  ['Food Wholesaler'] = { first_name = 'Natalie', last_name = 'Archer', description = 'Delivering quality provisions to fuel your culinary creations, straight wholesale' },
  ['Smoke On The Water'] = { first_name = 'Jackson', last_name = 'Greenleaf', description = 'Curating premium strains: your destination for elevated cannabis experiences, legally.' },
  ['Digital Den'] = { first_name = 'Alexandra', last_name = 'Techsmith', description = 'Your tech guru: providing cutting-edge gadgets and personalized solutions.' },
  ['Goldpan'] = { first_name = 'Jasper', last_name = 'Goldrush', description = 'Seeking fortune in streams, one shimmering speck at a time.' },
}

function setupStores(shops)
  for k, v in pairs(shops) do
    if v.coords ~= nil then
      if string.find(v.name, 'Vending') or string.find(v.name, 'Machine') or v.name == 'DOJ Shop' then
        interactEvent = 'Shop:Client:OpenShop'
      else
        interactEvent = 'Shop:Client:NPC'
      end

      local menu = {
        icon = "sack-dollar",
        text = v.name or "Shop",
        event = interactEvent,
        data = {
          id = v.id,
          name = v.name
        }
      }

      if v.restriction ~= nil then
        if v.restriction.job ~= nil then
          menu.jobPerms = {
            {
              job = v.restriction.job.id,
              workplace = v.restriction.job.workplace,
              grade = v.restriction.job.grade,
              permissionKey = v.restriction.job.permissionKey,
              reqDuty = true,
            }
          }
        end
      end

      exports['pedinteraction']:Add(
        "shop-" .. v.id,
        GetHashKey(v.npc),
        vector3(v.coords.x, v.coords.y, v.coords.z),
        v.coords.h,
        25.0,
        {
          menu,
        },
        v.icon or "shop"
      )
      if v.blip then
        exports['blips']:Add(
          "inventory_shop_" .. v.id,
          v.name,
          vector3(v.coords.x, v.coords.y, v.coords.z),
          v.blip.sprite,
          v.blip.color,
          v.blip.scale
        )
      end
    end
  end
end

AddEventHandler("Shop:Client:OpenShop", function(obj, data)
  Inventory.Shop:Open(data)
end)

AddEventHandler("Shop:Client:OpenShopNPC", function(data)
  Inventory.Shop:Open(data.id)
end)

AddEventHandler('Shop:Client:NPC', function(data, param)
  if npcData[param.name] == nil then return end
  -- if npcData[param.name] == nil then exports['core']:LoggerError("Inventory", param.name .. ' does not exist on NPC dialog') return end
  NPCDialog.Open(data.entity, {
    first_name = npcData[param.name].first_name,
    last_name = npcData[param.name].last_name,
    Tag = param.name,
    description = npcData[param.name].description,
    buttons = {
      {
        label = 'Open Shop',
        data = {
          close = true,
          event = 'Shop:Client:OpenShopNPC',
          params = {
            id = param.id
          }
        }
      },
      {
        label = 'See you later !',
        data = { close = true }
      }
    }
  })
end)
