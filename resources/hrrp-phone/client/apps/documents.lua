RegisterNUICallback("EditDocument", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("Phone:Documents:Edit", data, cb)
end)

RegisterNUICallback("DeleteDocument", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("Phone:Documents:Delete", data.id, cb)
end)

RegisterNUICallback("CreateDocument", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("Phone:Documents:Create", data, cb)
end)

RegisterNUICallback("ShareDocument", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("Phone:Documents:Share", data, cb)
end)

RegisterNUICallback("SignDocument", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("Phone:Documents:Sign", data, cb)
end)