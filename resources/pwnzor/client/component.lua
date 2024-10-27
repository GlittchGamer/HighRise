AddEventHandler('Proxy:Shared:RegisterReady', function()
  exports['core']:RegisterComponent('Pwnzor', PWNZOR)
end)

PWNZOR = PWNZOR or {}
