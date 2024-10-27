RegisterNetEvent('Racing:Client:CreateRace', function(pRaceData)
  Racing.RaceID = pRaceData.id
  Racing.ActiveRace = pRaceData

  AddRaceBlip(Racing.ActiveRace.trackData.Checkpoints[1])
  SetNewWaypoint(Racing.ActiveRace.trackData.Checkpoints[1].coords.x, Racing.ActiveRace.trackData.Checkpoints[1].coords.y)
end)


RegisterNetEvent('Racing:Client:StartRace', function(pRaceId)
  if Racing.RaceID ~= nil and Racing.RaceID == pRaceId then
    Cleanup()
    Racing:StartRace()
  end
end)
