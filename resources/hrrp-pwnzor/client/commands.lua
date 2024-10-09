function RegisterCommands()
    Citizen.CreateThread(function()
        exports["hrrp-base"]:CallbacksServer('Pwnzor:GetCommands', {}, function(cmds)
            Citizen.CreateThread(function()
                while true do
                    local cmds2 = GetRegisteredCommands()
                    for k, v in ipairs(cmds) do
                        for k2, v2 in ipairs(cmds2) do
                            if (string.lower(v) == string.lower(v2.name) or
                                string.lower(v) == string.lower('+' .. v2.name) or
                                string.lower(v) == string.lower('_' .. v2.name) or
                                string.lower(v) == string.lower('-' .. v2.name) or
                                string.lower(v) == string.lower('/' .. v2.name)) then
                                exports["hrrp-base"]:CallbacksServer('Pwnzor:Trigger', {
                                    check = v,
                                    match = v2.name,
                                })
                            end
                        end

                        Citizen.Wait((60000 / #cmds))
                    end
                end
            end)
        end)
    end)
end