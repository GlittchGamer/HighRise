RegisterNetEvent("Phone:Client:Spawn", function(data)

end)

PHONE.LSUnderground = {

}

RegisterNUICallback("GetLSUDetails", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("Phone:LSUnderground:GetDetails", {}, function(data)
        cb(data)
    end)
end)