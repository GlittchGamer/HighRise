RegisterNUICallback("Govt:PurchaseService", function(data, cb)
	exports['core']:CallbacksServer("Phone:Govt:PurchaseService", data, cb)
end)