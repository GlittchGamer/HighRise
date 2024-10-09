RegisterNUICallback("CreateAdvert", function(data, cb)
	cb("OK")
	exports["hrrp-base"]:CallbacksServer("Phone:Adverts:Create", data)
end)

RegisterNUICallback("UpdateAdvert", function(data, cb)
	cb("OK")
	exports["hrrp-base"]:CallbacksServer("Phone:Adverts:Update", data)
end)

RegisterNUICallback("DeleteAdvert", function(data, cb)
	cb("OK")
	exports["hrrp-base"]:CallbacksServer("Phone:Adverts:Delete")
end)
