function RegisterGamesCallbacks()
	exports["hrrp-base"]:CallbacksRegisterClient("Robbery:Games:Progress", DoProgress)
	exports["hrrp-base"]:CallbacksRegisterClient("Robbery:Games:Lockpick", Lockpick)
	exports["hrrp-base"]:CallbacksRegisterClient("Robbery:Games:Thermite", Thermite)
	exports["hrrp-base"]:CallbacksRegisterClient("Robbery:Games:Laptop", Laptop)
	exports["hrrp-base"]:CallbacksRegisterClient("Robbery:Games:Captcha", Captcha)
	exports["hrrp-base"]:CallbacksRegisterClient("Robbery:Games:Tracking", Tracking)
	exports["hrrp-base"]:CallbacksRegisterClient("Robbery:Games:Aim", Aim)
	exports["hrrp-base"]:CallbacksRegisterClient("Robbery:Games:AimHack", AimHack)
	exports["hrrp-base"]:CallbacksRegisterClient("Robbery:Games:Hack", Hack)
	exports["hrrp-base"]:CallbacksRegisterClient("Robbery:Games:Drill", Drill)
	exports["hrrp-base"]:CallbacksRegisterClient("Robbery:Games:SafeCrack", SafeCrack)
end

function DoProgress(data, cb)
	Progress:Progress({
		name = "robbery_action",
		duration = math.random(45, 60) * 1000,
		label = data.config.label or "Doing A Thing",
		useWhileDead = false,
		canCancel = true,
		ignoreModifier = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = data.config.anim,
	}, function(cancelled)
		cb(not cancelled, data.data)
	end)
end

function Lockpick(data, cb)
	DoLockpick(data.data, data.config, function(isSuccess, d)
		cb(isSuccess, d)
	end)
end

function Thermite(data, cb)
	_memPass = 1
	ThermiteShit({
		x = data.location.coords.x,
		y = data.location.coords.y,
		z = data.location.coords.z,
		h = data.location.heading,
	}, data, cb)
end

function Laptop(data, cb)
	LaptopShit(
		{
			x = data.location.coords.x,
			y = data.location.coords.y,
			z = data.location.coords.z,
			h = data.location.heading,
		},
		data,
		function(isSuccess, data)
			cb(isSuccess, data)
		end
	)
end

function Captcha(data, cb)
	CaptchaShit(
		{
			x = data.location.coords.x,
			y = data.location.coords.y,
			z = data.location.coords.z,
			h = data.location.heading,
		},
		data,
		function(isSuccess, data)
			cb(isSuccess, data)
		end
	)
end

function Tracking(data, cb)
	TrackingGameShit(data, function(isSuccess, data)
		cb(isSuccess, data)
	end)
end

function Aim(data, cb)
	BombShit(
		{
			x = data.location.coords.x,
			y = data.location.coords.y,
			z = data.location.coords.z,
			h = data.location.heading,
		},
		data,
		function(isSuccess)
			if isSuccess then
				exports["hrrp-base"]:CallbacksServer("Robbery:DoBombFx", {
					x = data.location.coords.x,
					y = data.location.coords.y,
					z = data.location.coords.z,
					h = data.location.heading,
				}, function() end)
			end

			cb(isSuccess)
		end
	)
end

function AimHack(data, cb)
	AimHackShit(data, function(isSuccess)
		cb(isSuccess, data)
	end)
end

function Hack(data, cb)
	HackShit(data, function(isSuccess, data)
		cb(isSuccess, data)
	end)
end

function Drill(data, cb)
	DoDrill(data, function(isSuccess, data)
		cb(isSuccess, data)
	end)
end

function SafeCrack(data, cb)
	_memPass = 1
	DoMemory(data.passes, data.config, data.data, function(isSuccess, extra)
		cb(isSuccess, extra)
	end)
end
