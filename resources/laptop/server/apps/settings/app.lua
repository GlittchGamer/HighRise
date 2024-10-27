AddEventHandler("Laptop:Server:RegisterCallbacks", function()
  exports['core']:CallbacksRegisterServer("Laptop:Settings:Update", function(source, data, cb)
    local char = exports['core']:FetchSource(source):GetData("Character")
    if char then
      local settings = char:GetData("LaptopSettings")
      settings[data.type] = data.val
      char:SetData("LaptopSettings", settings)
    end
  end)
end)
