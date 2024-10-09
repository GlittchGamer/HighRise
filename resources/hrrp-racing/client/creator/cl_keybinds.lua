function RegisterCreatorKeybinds()
  exports['hrrp-keybinds']:Add("racing_creator_increase_cp", "PAGEUP", "keyboard", "Racing Creator - Increase CP Distance", function()
    if not Creator.creating then return end
    AdjustCheckpointSize(true)
  end)

  exports['hrrp-keybinds']:Add("racing_creator_decrease_cp", "PAGEDOWN", "keyboard", "Racing Creator - Decrease CP Distance", function()
    if not Creator.creating then return end
    AdjustCheckpointSize(false)
  end)

  exports['hrrp-keybinds']:Add("racing_creator_place_cp", "E", "keyboard", "Racing Creator - Place Checkpoint", function()
    if not Creator.creating then return end
    CreateCheckpoint()
  end)

  exports['hrrp-keybinds']:Add("racing_creator_delete_cp", "X", "keyboard", "Racing Creator - Delete Previous Checkpoint", function()
    if not Creator.creating then return end
    RemoveCheckpoint()
  end)
end
