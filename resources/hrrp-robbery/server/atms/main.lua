local _ATM_COOLDOWNS = {}
local _ROBBED_ATMS = {}

AddEventHandler("Robbery:Server:Setup", function()
	exports['hrrp-base']:CallbacksRegisterServer("Robbery:ATM:CanRobATM", function(source, data, cb)
		if data and _ROBBED_ATMS[data] == nil then
			cb(true)
		else
			cb(false)
		end
	end)

	exports['hrrp-base']:CallbacksRegisterServer('Robbery:ATM:SetATMRobbed', function(src, state, cb)
		exports["hrrp-base"]:LoggerInfo('ATM Robbery', state .. ' ATM entity is on cooldown.')

		_ROBBED_ATMS[state] = true
		
		BeginEntityCooldown(src, state)
	end)

	Inventory.Items:RegisterUse('drill', 'RandomItems', function(source, ItemData)
		local Player = exports['hrrp-base']:FetchSource(source)
		local Char = Player:GetData('Character')
	
		exports["hrrp-base"]:CallbacksClient(source, 'Robbery:ATM:StartRobbing', {
			atm = 139778,
			item = ItemData,
			Cooldown = _ATM_COOLDOWNS[Char:GetData('SID')]
		}, function(state)
			if not _ATM_COOLDOWNS[Char:GetData('SID')] and state then
				_ATM_COOLDOWNS[Char:GetData('SID')] = true
				exports["hrrp-base"]:LoggerInfo('ATM Robbery', Char:GetData('First') .. ' ' .. Char:GetData('Last') .. ' is on ATM Cooldown.')
	
				BeginATMCooldown(source)
			end
		end)
	end)

	BeginATMCooldown = function(source)
		Wait(10 * 60000)
		
		local Player = exports['hrrp-base']:FetchSource(source)
		local Char = Player:GetData('Character')

		exports["hrrp-base"]:LoggerInfo('ATM Robbery', Char:GetData('First') .. ' ' .. Char:GetData('Last') .. ' got off ATM Cooldown.')

		_ATM_COOLDOWNS[Char:GetData('SID')] = false
	end

	BeginEntityCooldown = function(source, _Entity)
		Wait(20 * 60000)
		exports["hrrp-base"]:LoggerInfo('ATM Robbery', _Entity .. ' ATM entity is off cooldown.')

		_ROBBED_ATMS[_Entity] = false
	end

	exports['hrrp-base']:CallbacksRegisterServer('Robbery:ATM:GetReward', function(source, data, cb)
		local Player = exports['hrrp-base']:FetchSource(source)
		local Char = Player:GetData('Character')

		Inventory:AddItem(Char:GetData("SID"), "moneyroll", math.random(1, 100), {}, 1)

		if math.random() <= 0.2 then
			Inventory:AddItem(Char:GetData("SID"), "moneyband", math.random(1, 10), {}, 1)
		end		
	end)
end)