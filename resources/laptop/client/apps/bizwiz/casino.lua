RegisterNUICallback("CasinoGetBigWins", function(data, cb)
	exports['core']:CallbacksServer("Casino:GetBigWins", {}, function(penis)
        if penis then
            cb(penis)
        else
            cb(false)
        end
    end)
end)