RegisterNUICallback("Govt:PurchaseService", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("Phone:Govt:PurchaseService", data, cb)
end)