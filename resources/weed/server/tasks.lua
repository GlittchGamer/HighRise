local _run = false


AddEventHandler("Core:Server:ForceSave", function()
  local docs = {}
  for k, v in pairs(_plants) do
    if v and v.plant then
      table.insert(docs, v.plant)
    end
  end
  if #docs > 0 then
    exports['core']:LoggerInfo("Weed", string.format("Saving ^2%s^7 Plants", #docs))

    MySQL.Sync.execute("DELETE FROM weed")

    for _, doc in ipairs(docs) do
      MySQL.Sync.execute(
      "INSERT INTO weed (isMale, location, growth, output, material, planted, water) VALUES (@isMale, @location, @growth, @output, @material, @planted, @water)",
        {
          ['@isMale'] = doc.isMale,
          ['@location'] = json.encode(doc.location),
          ['@growth'] = doc.growth,
          ['@output'] = doc.output,
          ['@material'] = doc.material,
          ['@planted'] = doc.planted,
          ['@water'] = doc.water,
        })
    end
  end
end)



function RegisterTasks()
  if _run then return end
  _run = true

  Citizen.CreateThread(function()
    while true do
      Citizen.Wait((1000 * 60) * 10)
      local docs = {}
      for k, v in pairs(_plants) do
        if v and v.plant then
          table.insert(docs, v.plant)
        end
      end
      if #docs > 0 then
        exports['core']:LoggerInfo("Weed", string.format("Saving ^2%s^7 Plants", #docs))

        MySQL.Sync.execute("DELETE FROM weed")

        for _, doc in ipairs(docs) do
          MySQL.Sync.execute(
          "INSERT INTO weed (isMale, location, growth, output, material, planted, water) VALUES (@isMale, @location, @growth, @output, @material, @planted, @water)",
            {
              ['@isMale'] = doc.isMale,
              ['@location'] = json.encode(doc.location),
              ['@growth'] = doc.growth,
              ['@output'] = doc.output,
              ['@material'] = doc.material,
              ['@planted'] = doc.planted,
              ['@water'] = doc.water,
            })
        end
      end
    end
  end)


  Citizen.CreateThread(function()
    while true do
      Citizen.Wait((1000 * 60) * 10)
      exports['core']:LoggerTrace("Weed", "Growing Plants")
      local updatingStuff = {}

      for k, v in pairs(_plants) do
        if (os.time() - v.plant.planted) >= Config.Lifetime then
          exports['core']:LoggerTrace("Weed", "Deleting Weed Plant Because Some Dumb Cunt Didn't Harvest It")
          Weed.Planting:Delete(k)
        else
          if v.plant.growth < 100 then
            local mat = Materials[v.plant.material]
            if mat ~= nil then
              local gt = GroundTypes[mat.groundType]
              if gt ~= nil then
                local phosphorus = gt.phosphorus
                if v.plant.fertilizer ~= nil and v.plant.fertilizer.type == "phosphorus" then
                  phosphorus = phosphorus + v.plant.fertilizer.value
                end
                v.plant.growth = v.plant.growth + (1 + phosphorus)
                if v.stage ~= getStageByPct(v.plant.growth) then
                  local res = Weed.Planting:Set(k, true, true)
                  if res then
                    table.insert(updatingStuff, res)
                  end
                end
              else
                Weed.Planting:Delete(k)
              end
            else
              Weed.Planting:Delete(k)
            end
          end
        end
      end

      if #updatingStuff > 0 then
        TriggerLatentClientEvent("Weed:Client:Objects:UpdateMany", -1, 30000, updatingStuff)
      end
    end
  end)

  Citizen.CreateThread(function()
    while true do
      Citizen.Wait((1000 * 60) * 20)
      exports['core']:LoggerTrace("Weed", "Increasing Plant Outputs")
      for k, v in pairs(_plants) do
        if v.plant.growth < 100 then
          local mat = Materials[v.plant.material]
          if mat ~= nil then
            local gt = GroundTypes[mat.groundType]
            if gt ~= nil then
              local nitrogen = gt.nitrogen
              if v.plant.fertilizer ~= nil and v.plant.fertilizer.type == "nitrogen" then
                nitrogen = nitrogen + v.plant.fertilizer.value
              end
              v.plant.output = (v.plant.output or 0) + (1 * (1 + nitrogen))
            end
          end
        end
      end
    end
  end)

  Citizen.CreateThread(function()
    while true do
      Citizen.Wait((1000 * 60) * 10)
      exports['core']:LoggerTrace("Weed", "Degrading Water")
      for k, v in pairs(_plants) do
        if v.plant.water > -25 then
          local mat = Materials[v.plant.material]
          if mat ~= nil then
            local gt = GroundTypes[mat.groundType]
            if gt ~= nil then
              local potassium = gt.potassium
              if v.plant.fertilizer ~= nil and v.plant.fertilizer.type == "potassium" then
                potassium = potassium + v.plant.fertilizer.value
              end

              v.plant.water = v.plant.water - ((1.0 * (1.0 + (1.0 - potassium))) - gt.water)
            else
              Weed.Planting:Delete(k)
            end
          else
            Weed.Planting:Delete(k)
          end
        else
          exports['core']:LoggerTrace("Weed", "Deleting Weed Plant Because Some Dumb Cunt Didn't Water It")
          Weed.Planting:Delete(k)
        end
      end
    end
  end)

  Citizen.CreateThread(function()
    while true do
      Citizen.Wait((1000 * 60) * 1)
      exports['core']:LoggerTrace("Weed", "Ticking Down Fertilizer")
      for k, v in pairs(_plants) do
        if v.plant.fertilizer ~= nil then
          if v.plant.fertilizer.time > 0 then
            v.plant.fertilizer.time = v.plant.fertilizer.time - 1
          else
            v.plant.fertilizer = nil
          end
        end
      end
    end
  end)
end
