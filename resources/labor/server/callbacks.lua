function RegisterCallbacks()
	exports['core']:CallbacksRegisterServer("Labor:GetJobs", function(source, data, cb)
		cb(Labor.Get:Jobs())
	end)
	exports['core']:CallbacksRegisterServer("Labor:GetGroups", function(source, data, cb)
		cb(Labor.Get:Groups())
	end)

	exports['core']:CallbacksRegisterServer("Labor:GetReputations", function(source, data, cb)
		cb(Reputation:View(source))
	end)

	exports['core']:CallbacksRegisterServer("Labor:AcceptRequest", function(source, data, cb)
		if _pendingInvites[data.source] ~= nil then
			local state = Labor.Workgroups:Join(_pendingInvites[data.source], data.source)

			if state then
				Phone.Notification:Add(
					data.source,
					"Labor Activity",
					"You Joined A Workgroup",
					os.time() * 1000,
					6000,
					"labor",
					{}
				)
			end

			_pendingInvites[data.source] = nil
			cb(state)
		else
			cb(false)
		end
	end)

	exports['core']:CallbacksRegisterServer("Labor:DeclineRequest", function(source, data, cb)
		if _pendingInvites[data.source] ~= nil then
			_pendingInvites[data.source] = nil

			Phone.Notification:Add(
				data.source,
				"Labor Activity",
				"Your Group Request Was Denied",
				os.time() * 1000,
				6000,
				"labor",
				{}
			)

			Phone.Notification:Add(
				source,
				"Labor Activity",
				"You Denied A Group Request",
				os.time() * 1000,
				6000,
				"labor",
				{}
			)

			cb(true)
		else
			cb(false)
		end
	end)
end
