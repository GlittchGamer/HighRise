RegisterNUICallback("UpdateSetting", function(data, cb)
	cb("OK")
	_settings[data.type] = data.val
	exports['core']:CallbacksServer("Laptop:Settings:Update", data)
end)