function RegisterEvents()
    Citizen.CreateThread(function()
        exports["hrrp-base"]:CallbacksServer('Pwnzor:GetEvents', {}, function(e)
            for k, v in ipairs(e) do
                AddEventHandler(v, function()
                    exports["hrrp-base"]:CallbacksServer('Pwnzor:Trigger', {
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