Races = {
  Tracks = {},
  RaceID = 0,
  ActiveRaces = {}
}

function LoadTracks()
  local results = MySQL.query.await('SELECT * FROM `racing_tracks`')
  for _, track in ipairs(results) do
    track.Checkpoints = json.decode(track.Checkpoints)
    track.Fastest = track.Fastest ~= nil and json.decode(track.Fastest) or {}
    track.History = track.History ~= nil and json.decode(track.History) or {}
    table.insert(Races.Tracks, track)
  end
end
