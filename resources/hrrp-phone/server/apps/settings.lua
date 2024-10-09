AddEventHandler("Phone:Server:RegisterCallbacks", function()
  exports['hrrp-base']:CallbacksRegisterServer("Phone:Settings:Update", function(source, data, cb)
    local src = source
    local char = exports['hrrp-base']:FetchSource(src):GetData("Character")
    local settings = char:GetData("PhoneSettings")
    settings[data.type] = data.val
    char:SetData("PhoneSettings", settings)
  end)
end)
