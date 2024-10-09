RegisterNetEvent("Phone:Client:Labor:NotifyEnd", function(time)
	Phone.Notification:Add("Labor Activity", "You finished a job", time * 1000, 6000, "labor", {}, nil)
end)

RegisterNUICallback("GetLaborDetails", function(data, cb)
	cb({
		jobs = Labor.Get:Jobs(),
		groups = Labor.Get:Groups(),
		reputations = Labor.Get:Reputations(),
	})
end)

RegisterNUICallback("CreateWorkgroup", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("Phone:Labor:CreateWorkgroup", data, cb)
end)

RegisterNUICallback("JoinWorkgroup", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("Phone:Labor:JoinWorkgroup", data, cb)
end)

RegisterNUICallback("DisbandWorkgroup", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("Phone:Labor:DisbandWorkgroup", data, cb)
end)

RegisterNUICallback("LeaveWorkgroup", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("Phone:Labor:LeaveWorkgroup", data, cb)
end)

RegisterNUICallback("StartLaborJob", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("Phone:Labor:StartLaborJob", data, cb)
end)

RegisterNUICallback("QuitLaborJob", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("Phone:Labor:QuitLaborJob", data, cb)
end)
