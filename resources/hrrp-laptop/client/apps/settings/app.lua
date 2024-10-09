RegisterNUICallback("UpdateSetting", function(data, cb)
	cb("OK")
	_settings[data.type] = data.val
	exports["hrrp-base"]:CallbacksServer("Laptop:Settings:Update", data)
end)