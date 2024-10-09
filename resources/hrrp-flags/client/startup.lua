local setupEvent = nil

setupEvent = AddEventHandler("Core:Shared:Ready", function()
  --If we need to execute any bullshit here
  RemoveEventHandler(setupEvent)
end)
