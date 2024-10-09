AddEventHandler('Proxy:Shared:RegisterReady', function()
  exports['hrrp-base']:RegisterComponent('Pwnzor', PWNZOR)
end)

PWNZOR = PWNZOR or {}
