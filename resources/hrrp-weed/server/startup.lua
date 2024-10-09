local _started
function Startup()
  if _started then
    return
  end
  _started = true

  local results = MySQL.Sync.fetchAll('SELECT * FROM weed')
  for k, v in ipairs(results) do
    if os.time() - v.planted <= Config.Lifetime then
      _plants[v.id] = {
        plant = v,
        stage = getStageByPct(v.growth),
      }
      _plants[v.id].plant.location = json.decode(_plants[v.id].plant.location)
    end
  end
  exports['hrrp-base']:LoggerTrace("Weed", string.format("Loaded ^2%s^7 Weed Plants", #results), { console = true })

  Reputation:Create("weed", "Weed", {
    { label = "Rank 1", value = 3000 },
    { label = "Rank 2", value = 6000 },
    { label = "Rank 3", value = 12000 },
    { label = "Rank 4", value = 21000 },
    { label = "Rank 5", value = 50000 },
  }, true)
end
