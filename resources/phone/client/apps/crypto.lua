RegisterNUICallback("GetCryptoCoins", function(data, cb)
	local p = promise.new()

	exports['core']:CallbacksServer("Crypto:GetAll", {}, function(coins)
		p:resolve(coins)
	end)

	cb(Citizen.Await(p))
end)

RegisterNUICallback("BuyCrypto", function(data, cb)
	exports['core']:CallbacksServer("Phone:Crypto:Buy", data, cb)
end)

RegisterNUICallback("SellCrypto", function(data, cb)
	exports['core']:CallbacksServer("Phone:Crypto:Sell", data, cb)
end)

RegisterNUICallback("TransferCrypto", function(data, cb)
	exports['core']:CallbacksServer("Phone:Crypto:Transfer", data, cb)
end)