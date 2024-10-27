RegisterNUICallback("CreateAdvert", function(data, cb)
	cb("OK")
	exports['core']:CallbacksServer("Phone:Adverts:Create", data)
end)

RegisterNUICallback("UpdateAdvert", function(data, cb)
	cb("OK")
	exports['core']:CallbacksServer("Phone:Adverts:Update", data)
end)

RegisterNUICallback("DeleteAdvert", function(data, cb)
	cb("OK")
	exports['core']:CallbacksServer("Phone:Adverts:Delete")
end)
