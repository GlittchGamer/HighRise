RegisterNetEvent("Phone:Client:IRC:Notify")
AddEventHandler("Phone:Client:IRC:Notify", function(message)
	SendNUIMessage({
		type = "ADD_DATA",
		data = {
			type = "irc-" .. message.channel,
			data = message,
		},
	})
	Citizen.Wait(1e3)
	Phone.Notification:Add("New Message", "You received a message in #" .. message.channel, message.time, 6000, "irc", {
		view = "view/" .. message.channel,
	}, nil)
end)
RegisterNUICallback("GetIRCMessages", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("Phone:IRC:GetMessages", data, cb)
end)
RegisterNUICallback("SendIRCMessage", function(data, cb)
	cb("OK")
	exports["hrrp-base"]:CallbacksServer("Phone:IRC:SendMessage", data)
end)
RegisterNUICallback("JoinIRCChannel", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("Phone:IRC:JoinChannel", data, cb)
end)
RegisterNUICallback("LeaveIRCChannel", function(data, cb)
	cb("OK")
	exports["hrrp-base"]:CallbacksServer("Phone:IRC:LeaveChannel", data)
end)
