local startupThread = nil
startupThread = AddEventHandler('Core:Shared:Ready', function()
  RegisterCreatorKeybinds()
  -- Additional startup logic can be added here
  RemoveEventHandler(startupThread)
end)
