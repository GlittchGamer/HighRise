local TemplateData = {
  model = "",
  customization = {
    face = {
      face1 = {
        index = 0,
        texture = 0,
        mix = 50.0,
      },
      face2 = {
        index = 0,
        texture = 0,
        mix = 50.0,
      },
      face3 = {
        index = 0,
        texture = 0,
        mix = 100.0,
      },
      features = {
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
      },
    },
    eyeColor = 0,
    overlay = {
      blemish = {
        id = 0,
        index = 0,
        opacity = 100.0,
        disabled = true,
      },
      facialhair = {
        id = 1,
        index = 0,
        opacity = 100.0,
        disabled = true,
      },
      eyebrows = {
        id = 2,
        index = 0,
        opacity = 100.0,
        disabled = true,
      },
      ageing = {
        id = 3,
        index = 0,
        opacity = 100.0,
        disabled = true,
      },
      makeup = {
        id = 4,
        index = 0,
        opacity = 100.0,
        disabled = true,
      },
      blush = {
        id = 5,
        index = 0,
        opacity = 100.0,
        disabled = true,
      },
      complexion = {
        id = 6,
        index = 0,
        opacity = 100.0,
        disabled = true,
      },
      sundamage = {
        id = 7,
        index = 0,
        opacity = 100.0,
        disabled = true,
      },
      lipstick = {
        id = 8,
        index = 0,
        opacity = 100.0,
        disabled = true,
      },
      freckles = {
        id = 9,
        index = 0,
        opacity = 100.0,
        disabled = true,
      },
      chesthair = {
        id = 10,
        index = 0,
        opacity = 100.0,
        disabled = true,
      },
      bodyblemish = {
        id = 11,
        index = 0,
        opacity = 100.0,
        disabled = true,
      },
      addbodyblemish = {
        id = 12,
        index = 0,
        opacity = 100.0,
        disabled = true,
      },
    },
    colors = {
      hair = {
        color1 = {
          index = 0,
          rgb = "rgb(0, 0, 0)",
        },
        color2 = {
          index = 0,
          rgb = "rgb(0, 0, 0)",
        },
      },
      facialhair = {
        color1 = {
          index = 0,
          rgb = "rgb(0, 0, 0)",
        },
        color2 = {
          index = 0,
          rgb = "rgb(0, 0, 0)",
        },
      },
      eyebrows = {
        color1 = {
          index = 0,
          rgb = "rgb(0, 0, 0)",
        },
        color2 = {
          index = 0,
          rgb = "rgb(0, 0, 0)",
        },
      },
      chesthair = {
        color1 = {
          index = 0,
          rgb = "rgb(0, 0, 0)",
        },
        color2 = {
          index = 0,
          rgb = "rgb(0, 0, 0)",
        },
      },
    },
    components = {
      face = {
        componentId = 0,
        drawableId = 0,
        textureId = 0,
        paletteId = 0,
      },
      mask = {
        componentId = 1,
        drawableId = 0,
        textureId = 0,
        paletteId = 0,
      },
      hair = {
        componentId = 2,
        drawableId = 0,
        textureId = 0,
        paletteId = 0,
      },
      torso = {
        componentId = 3,
        drawableId = 0,
        textureId = 0,
        paletteId = 0,
      },
      leg = {
        componentId = 4,
        drawableId = 0,
        textureId = 0,
        paletteId = 0,
      },
      bag = {
        componentId = 5,
        drawableId = 0,
        textureId = 0,
        paletteId = 0,
      },
      shoes = {
        componentId = 6,
        drawableId = 0,
        textureId = 0,
        paletteId = 0,
      },
      accessory = {
        componentId = 7,
        drawableId = 0,
        textureId = 0,
        paletteId = 0,
      },
      undershirt = {
        componentId = 8,
        drawableId = 0,
        textureId = 0,
        paletteId = 0,
      },
      kevlar = {
        componentId = 9,
        drawableId = 0,
        textureId = 0,
        paletteId = 0,
      },
      badge = {
        componentId = 10,
        drawableId = 0,
        textureId = 0,
        paletteId = 0,
      },
      torso2 = {
        componentId = 11,
        drawableId = 0,
        textureId = 0,
        paletteId = 0,
      },
    },
    props = {
      hat = {
        componentId = 0,
        drawableId = 0,
        textureId = 0,
        disabled = true,
      },
      glass = {
        componentId = 1,
        drawableId = 0,
        textureId = 0,
        disabled = true,
      },
      ear = {
        componentId = 2,
        drawableId = 0,
        textureId = 0,
        disabled = true,
      },
      watch = {
        componentId = 6,
        drawableId = 0,
        textureId = 0,
        disabled = true,
      },
      bracelet = {
        componentId = 7,
        drawableId = 0,
        textureId = 0,
        disabled = true,
      },
    },
    tattoos = {},
  },
}

GlobalState["Ped:Pricing"] = {
  CREATOR = 0,
  BARBER = 100,
  SHOP = 100,
  TATTOO = 100,
  SURGERY = 10000,
}

AddEventHandler("Ped:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Fetch = exports['core']:FetchComponent("Fetch")
  Callbacks = exports['core']:FetchComponent("Callbacks")

  Locations = exports['core']:FetchComponent("Locations")
  Routing = exports['core']:FetchComponent("Routing")
  Logger = exports['core']:FetchComponent("Logger")
  Ped = exports['core']:FetchComponent("Ped")
  Inventory = exports['core']:FetchComponent("Inventory")
  Chat = exports['core']:FetchComponent("Chat")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies("Ped", {
    "Fetch",
    "Callbacks",

    "Locations",
    "Routing",
    "Logger",
    "Ped",
    "Inventory",
    "Chat",
  }, function(error)
    if #error > 0 then
      return
    end -- Do something to handle if not all dependencies loaded
    RetrieveComponents()
    RegisterCallbacks()
    RegisterItemUses()

    GlobalState["GangChains"] = _gangChains
    GlobalState["ClothingStoreHidden"] = _hideFromStore

    Chat:RegisterCommand("m0", function(source, args, rawCommand)
      local plyr = exports['core']:FetchSource(source)
      if plyr ~= nil then
        local char = plyr:GetData("Character")
        if char ~= nil then
          local ped = char:GetData("Ped")
          if ped.customization.components.mask.drawableId ~= 0 then
            TriggerClientEvent("Ped:Client:MaskAnim", source)
            Citizen.Wait(300)
            Ped.Mask:Unequip(source)
          end
        end
      end
    end, {
      help = "Remove Mask",
    })

    Chat:RegisterCommand("h0", function(source, args, rawCommand)
      local plyr = exports['core']:FetchSource(source)
      if plyr ~= nil then
        local char = plyr:GetData("Character")
        if char ~= nil then
          local ped = char:GetData("Ped")
          if not ped.customization.props.hat.disabled then
            TriggerClientEvent("Ped:Client:HatGlassAnim", source)
            Citizen.Wait(300)
            Ped.Hat:Unequip(source)
          end
        end
      end
    end, {
      help = "Remove Hat",
    })

    Chat:RegisterCommand("h1", function(source, args, rawCommand)
      local plyr = exports['core']:FetchSource(source)
      if plyr ~= nil then
        local char = plyr:GetData("Character")
        if char ~= nil then
          local ped = char:GetData("Ped")
          if not ped.customization.props.hat.disabled then
            TriggerClientEvent("Ped:Client:HatGlassAnim", source)
            Citizen.Wait(300)
            TriggerClientEvent("Ped:Client:Hat", source)
          end
        end
      end
    end, {
      help = "Re-equip Hat If You Had One",
    })

    Chat:RegisterCommand("g1", function(source, args, rawCommand)
      local plyr = exports['core']:FetchSource(source)
      if plyr ~= nil then
        local char = plyr:GetData("Character")
        if char ~= nil then
          local ped = char:GetData("Ped")
          if not ped.customization.props.glass.disabled then
            TriggerClientEvent("Ped:Client:HatGlassAnim", source)
            Citizen.Wait(300)
            TriggerClientEvent("Ped:Client:Glasses", source)
          end
        end
      end
    end, {
      help = "Re-equip Glasses If You Had One",
    })

    Chat:RegisterCommand("g0", function(source, args, rawCommand)
      local plyr = exports['core']:FetchSource(source)
      if plyr ~= nil then
        local char = plyr:GetData("Character")
        if char ~= nil then
          TriggerClientEvent("Ped:Client:RemoveGlasses", source)
        end
      end
    end, {
      help = "Remove Glasses",
    })

    RemoveEventHandler(setupEvent)
  end)
end)

PED = {
  Save = function(self, char, ped)
    if ped?.customization?.face?.features and type(ped.customization.face.features) == "table" then
      for k, v in pairs(ped.customization.face.features) do
        ped.customization.face.features[tostring(k)] = v
      end
    end

    local savePedQuery = MySQL.query.await([[
      INSERT INTO `peds` (`char`, `ped`) VALUES (?, ?)
      ON DUPLICATE KEY UPDATE `ped` = VALUES(`ped`)
    ]], { char:GetData("ID"), json.encode(ped) })

    if not savePedQuery then
      return false
    end

    char:SetData("Ped", ped)
    return true
  end,
  ApplyOutfit = function(self, source, outfit)
    local plyr = exports['core']:FetchSource(source)
    if plyr ~= nil then
      local char = plyr:GetData("Character")
      if char ~= nil then
        local ped = char:GetData("Ped")
        ped.customization.components = outfit.data.components or ped.customization.components
        ped.customization.props = outfit.data.props or ped.customization.props
        ped.customization.colors = outfit.data.colors or ped.customization.colors
        ped.customization.overlay = outfit.data.overlay or ped.customization.overlay
        Ped:Save(char, ped)
      end
    end
  end,
  Mask = {
    Equip = function(self, source, data)
      local plyr = exports['core']:FetchSource(source)
      if plyr ~= nil then
        local char = plyr:GetData("Character")
        if char ~= nil then
          local ped = char:GetData("Ped")
          ped.customization.components.mask = data
          Ped:Save(char, ped)
        end
      end
    end,
    Unequip = function(self, source)
      local plyr = exports['core']:FetchSource(source)
      if plyr ~= nil then
        local char = plyr:GetData("Character")
        if char ~= nil then
          local ped = char:GetData("Ped")

          local itemId = Inventory.Items:GetWithStaticMetadata(
            "mask",
            "drawableId",
            "textureId",
            char:GetData("Gender"),
            ped.customization.components.mask
          ) or "mask"

          local md = { mask = ped.customization.components.mask }
          if itemId ~= "mask" then
            md = {}
          end

          if Inventory:AddItem(char:GetData("SID"), itemId, 1, md, 1) then
            ped.customization.components.mask = {
              componentId = 1,
              drawableId = 0,
              textureId = 0,
              paletteId = 0,
            }
            Ped:Save(char, ped)
          end
        end
      end
    end,
    UnequipNoItem = function(self, source)
      local plyr = exports['core']:FetchSource(source)
      if plyr ~= nil then
        local char = plyr:GetData("Character")
        if char ~= nil then
          local ped = char:GetData("Ped")
          if ped.customization.components.mask.drawableId ~= 0 then
            TriggerClientEvent("Ped:Client:MaskAnim", source)
            ped.customization.components.mask = {
              componentId = 1,
              drawableId = 0,
              textureId = 0,
              paletteId = 0,
            }
            Ped:Save(char, ped)
          end
        end
      end
    end,
  },
  Hat = {
    Equip = function(self, source, data)
      local plyr = exports['core']:FetchSource(source)
      if plyr ~= nil then
        local char = plyr:GetData("Character")
        if char ~= nil then
          local ped = char:GetData("Ped")
          ped.customization.props.hat = data
          Ped:Save(char, ped)
        end
      end
    end,
    Unequip = function(self, source)
      local plyr = exports['core']:FetchSource(source)
      if plyr ~= nil then
        local char = plyr:GetData("Character")
        if char ~= nil then
          local ped = char:GetData("Ped")

          local itemId = Inventory.Items:GetWithStaticMetadata(
            "hat",
            "drawableId",
            "textureId",
            char:GetData("Gender"),
            ped.customization.props.hat
          ) or "hat"

          local md = { hat = ped.customization.props.hat }
          if itemId ~= "hat" then
            md = {}
          end

          if Inventory:AddItem(char:GetData("SID"), itemId, 1, md, 1) then
            ped.customization.props.hat = {
              componentId = 0,
              drawableId = 0,
              textureId = 0,
              disabled = true,
            }
            Ped:Save(char, ped)
          end
        end
      end
    end,
  },
  Necklace = {
    Equip = function(self, source, data)
      local plyr = exports['core']:FetchSource(source)
      if plyr ~= nil then
        local char = plyr:GetData("Character")
        if char ~= nil then
          local ped = char:GetData("Ped")
          ped.customization.components.accessory = data
          Ped:Save(char, ped)
        end
      end
    end,
    Unequip = function(self, source)
      local plyr = exports['core']:FetchSource(source)
      if plyr ~= nil then
        local char = plyr:GetData("Character")
        if char ~= nil then
          local ped = char:GetData("Ped")
          local itemId = Inventory.Items:GetWithStaticMetadata(
            "accessory",
            "drawableId",
            "textureId",
            char:GetData("Gender"),
            ped.customization.components.accessory
          ) or "accessory"

          if itemId ~= "accessory" then
            if Inventory:AddItem(char:GetData("SID"), itemId, 1, {}, 1) then
              ped.customization.components.accessory = {
                componentId = 7,
                drawableId = 0,
                textureId = 0,
                paletteId = 0,
              }
              Ped:Save(char, ped)
            end
          end
        end
      end
    end,
    UnequipNoItem = function(self, source)
      local plyr = exports['core']:FetchSource(source)
      if plyr ~= nil then
        local char = plyr:GetData("Character")
        if char ~= nil then
          local ped = char:GetData("Ped")
          if ped.customization.components.mask.drawableId ~= 0 then
            TriggerClientEvent("Ped:Client:MaskAnim", source)
            ped.customization.components.mask = {
              componentId = 1,
              drawableId = 0,
              textureId = 0,
              paletteId = 0,
            }
            Ped:Save(char, ped)
          end
        end
      end
    end,
  },
}
AddEventHandler("Proxy:Shared:RegisterReady", function()
  exports['core']:RegisterComponent("Ped", PED)
end)

function deepcopy(orig)
  local orig_type = type(orig)
  local copy
  if orig_type == "table" then
    copy = {}
    for orig_key, orig_value in next, orig, nil do
      copy[deepcopy(orig_key)] = deepcopy(orig_value)
    end
    setmetatable(copy, deepcopy(getmetatable(orig)))
  else -- number, string, boolean, etc
    copy = orig
  end
  return copy
end

function RegisterCallbacks()
  exports['core']:CallbacksRegisterServer("Ped:CheckPed", function(source, data, cb)
    local player = exports['core']:FetchSource(source)
    local char = player:GetData("Character")

    local myPed = MySQL.single.await([[
      SELECT * FROM `peds` WHERE `char` = ?
    ]], { char:GetData("ID") })

    if not myPed then
      local tmp = deepcopy(TemplateData)

      if char:GetData("Gender") == 0 then
        tmp.model = "mp_m_freemode_01"
      else
        tmp.model = "mp_f_freemode_01"
      end

      char:SetData("Ped", tmp)
      return cb({
        existed = false,
        ped = tmp,
      })
    end

    local ped = json.decode(myPed.ped)

    if next(ped) == nil then --! This should never be nil, but just in case we will force them to recreate.
      local tmp = deepcopy(TemplateData)

      if char:GetData("Gender") == 0 then
        tmp.model = "mp_m_freemode_01"
      else
        tmp.model = "mp_f_freemode_01"
      end

      char:SetData("Ped", tmp)
      return cb({
        existed = false,
        ped = tmp,
      })
    end

    if ped.model == "" then
      if char:GetData("Gender") == 0 then
        ped.model = "mp_m_freemode_01"
      else
        ped.model = "mp_f_freemode_01"
      end
    end

    char:SetData("Ped", ped)
    cb({
      existed = true,
      ped = ped,
    })
  end)

  exports['core']:CallbacksRegisterServer("Ped:MakePayment", function(source, data, cb)
    local char = exports['core']:FetchSource(source):GetData("Character")
    local pricing = GlobalState["Ped:Pricing"][data.type]
    if pricing == 0 or char:GetData("Cash") >= pricing then
      char:SetData("Cash", char:GetData("Cash") - pricing)
      cb(true, pricing)
    else
      cb(false)
    end
  end)

  exports['core']:CallbacksRegisterServer("Ped:SavePed", function(source, data, cb)
    local player = exports['core']:FetchComponent("Fetch"):Source(source)
    local char = player:GetData("Character")
    cb(Ped:Save(char, data.ped))
  end)

  exports['core']:CallbacksRegisterServer("Ped:RemoveMask", function(source, data, cb)
    local plyr = exports['core']:FetchSource(source)
    if plyr ~= nil then
      local char = plyr:GetData("Character")
      if char ~= nil then
        local ped = char:GetData("Ped")
        if ped.customization.components.mask.drawableId ~= 0 then
          TriggerClientEvent("Ped:Client:MaskAnim", source)
          Citizen.Wait(500)
          Ped.Mask:Unequip(source)
        end
      end
    end
  end)

  exports['core']:CallbacksRegisterServer("Ped:RemoveHat", function(source, data, cb)
    local plyr = exports['core']:FetchSource(source)
    if plyr ~= nil then
      local char = plyr:GetData("Character")
      if char ~= nil then
        local ped = char:GetData("Ped")
        if not ped.customization.props.hat.disabled then
          TriggerClientEvent("Ped:Client:HatGlassAnim", source)
          Citizen.Wait(500)
          Ped.Hat:Unequip(source)
        end
      end
    end
  end)

  exports['core']:CallbacksRegisterServer("Ped:RemoveAccessory", function(source, data, cb)
    local plyr = exports['core']:FetchSource(source)
    if plyr ~= nil then
      local char = plyr:GetData("Character")
      if char ~= nil then
        local ped = char:GetData("Ped")
        if ped.customization.components.accessory.drawableId ~= 0 then
          TriggerClientEvent("Ped:Client:HatGlassAnim", source)
          Citizen.Wait(500)
          Ped.Necklace:Unequip(source)
        end
      end
    end
  end)
end
