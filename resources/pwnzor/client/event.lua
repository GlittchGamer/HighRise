function RegisterEvents()
    Citizen.CreateThread(function()
        exports['core']:CallbacksServer('Pwnzor:GetEvents', {}, function(e)
            for k, v in ipairs(e) do
                AddEventHandler(v, function()
                    exports['core']:CallbacksServer('Pwnzor:Trigger', {
                        check = v,
                        match = v,
                    }, function(s)
                        CancelEvent()
                        return
                    end)
                end)
            end
        end)
    end)
end