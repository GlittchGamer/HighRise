RegisterNUICallback("EditDocument", function(data, cb)
	exports['core']:CallbacksServer("Phone:Documents:Edit", data, cb)
end)

RegisterNUICallback("DeleteDocument", function(data, cb)
	exports['core']:CallbacksServer("Phone:Documents:Delete", data.id, cb)
end)

RegisterNUICallback("CreateDocument", function(data, cb)
	exports['core']:CallbacksServer("Phone:Documents:Create", data, cb)
end)

RegisterNUICallback("ShareDocument", function(data, cb)
	exports['core']:CallbacksServer("Phone:Documents:Share", data, cb)
end)

RegisterNUICallback("SignDocument", function(data, cb)
	exports['core']:CallbacksServer("Phone:Documents:Sign", data, cb)
end)