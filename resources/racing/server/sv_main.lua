local startupThread = nil
startupThread = AddEventHandler('Core:Shared:Ready', function()
  Races.Tracks = {} --! Prevenative on dupes until we fix, later.
  RegisterCallbacks()
  RegisterMiddleware()
  LoadTracks()
  -- Additional startup logic can be added here
  RemoveEventHandler(startupThread)
end)
