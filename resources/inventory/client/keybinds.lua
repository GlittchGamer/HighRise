function RegisterKeyBinds()
  exports['keybinds']:Add('open_hotbar', 'TAB', 'keyboard', 'Inventory - Show Hotbar', function()
    if not _startup then return end
    OpenHotBar()
  end)

  exports['keybinds']:Add('open_inventory', 'F2', 'keyboard', 'Inventory - Open Inventory', function()
    if not _startup then return end
    OpenInventory()
  end)

  function HotBarAction(key)
    exports['keybinds']:Add('hotbar_action_' .. tostring(key), key, 'keyboard', 'Inventory - Hotbar Action ' .. tostring(key), function()
      if not _startup then return end
      Inventory.Used:HotKey(key)
    end)
  end

  for i = 1, 5 do
    HotBarAction(i)
  end
end
