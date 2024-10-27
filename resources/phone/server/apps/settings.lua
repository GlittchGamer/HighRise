AddEventHandler("Phone:Server:RegisterCallbacks", function()
  exports['core']:CallbacksRegisterServer("Phone:Settings:Update", function(source, data, cb)
    local src = source
    local char = exports['core']:FetchSource(src):GetData("Character")
    local settings = char:GetData("PhoneSettings")
    settings[data.type] = data.val
    char:SetData("PhoneSettings", settings)
  end)
end)
