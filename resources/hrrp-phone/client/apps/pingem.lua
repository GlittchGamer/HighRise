RegisterNUICallback("PingEm:Send", function(data, cb)
  exports["hrrp-base"]:CallbacksServer("Phone:PingEm:SendPing", data, cb)
end)

local _pingId = 1
AddEventHandler("Phone:Client:PingEm:AcceptPing", function(data)
  local id = string.format("pingem-%s", _pingId)
  _pingId = _pingId + 1

  local blip = exports['hrrp-blips']:Add(id, "Ping'Em", data.location, 280, 50, 1.1)
  SetBlipFlashes(blip, true)
  exports["hrrp-base"]:CallbacksServer("Phone:PingEm:GetFeedback", {
    result = true,
    source = data.source,
  })

  Citizen.CreateThread(function()
    Citizen.Wait(30000)
    exports['hrrp-blips']:Remove(id)
  end)
end)

AddEventHandler("Phone:Client:PingEm:RejectPing", function(data)
  exports["hrrp-base"]:CallbacksServer("Phone:PingEm:GetFeedback", {
    result = false,
    source = data.source,
  })
end)
