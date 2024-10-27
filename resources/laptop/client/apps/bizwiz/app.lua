RegisterNetEvent("Laptop:Client:BizWiz:Login", function(logo, links, notices)
    Laptop.Data:Set("businessLogo", logo)
    Laptop.Data:Set("businessPages", links)
    Laptop.Data:Set("businessNotices", notices)
end)

RegisterNetEvent("Laptop:Client:BizWiz:Logout", function()
    Laptop.Data:Set("businessLogo", nil)
    Laptop.Data:Set("businessPages", nil)
    Laptop.Data:Set("businessNotices", nil)
end)


-- Documents

RegisterNUICallback("BusinessDocumentSearch", function(data, cb)
	exports['core']:CallbacksServer("Laptop:BizWiz:Document:Search", data, cb)
end)

RegisterNUICallback("BusinessDocumentCreate", function(data, cb)
	exports['core']:CallbacksServer("Laptop:BizWiz:Document:Create", data, cb)
end)

RegisterNUICallback("BusinessDocumentUpdate", function(data, cb)
	exports['core']:CallbacksServer("Laptop:BizWiz:Document:Update", data, cb)
end)

RegisterNUICallback("BusinessDocumentView", function(data, cb)
	exports['core']:CallbacksServer("Laptop:BizWiz:Document:View", data.id, cb)
end)

RegisterNUICallback("BusinessDocumentDelete", function(data, cb)
	exports['core']:CallbacksServer("Laptop:BizWiz:Document:Delete", data.id, cb)
end)

-- Receipts

RegisterNUICallback("BusinessReceiptSearch", function(data, cb)
	exports['core']:CallbacksServer("Laptop:BizWiz:Receipt:Search", data, cb)
end)

RegisterNUICallback("BusinessReceiptCreate", function(data, cb)
	exports['core']:CallbacksServer("Laptop:BizWiz:Receipt:Create", data, cb)
end)

RegisterNUICallback("BusinessReceiptUpdate", function(data, cb)
	exports['core']:CallbacksServer("Laptop:BizWiz:Receipt:Update", data, cb)
end)

RegisterNUICallback("BusinessReceiptView", function(data, cb)
	exports['core']:CallbacksServer("Laptop:BizWiz:Receipt:View", data.id, cb)
end)

RegisterNUICallback("BusinessReceiptDelete", function(data, cb)
	exports['core']:CallbacksServer("Laptop:BizWiz:Receipt:Delete", data.id, cb)
end)

RegisterNUICallback("BusinessReceiptDeleteAll", function(data, cb)
	exports['core']:CallbacksServer("Laptop:BizWiz:Receipt:DeleteAll", {}, cb)
end)

-- Notices

RegisterNUICallback("CreateBusinessNotice", function(data, cb)
	exports['core']:CallbacksServer("Laptop:BizWiz:Notice:Create", data, cb)
end)

RegisterNUICallback("DeleteBusinessNotice", function(data, cb)
	exports['core']:CallbacksServer("Laptop:BizWiz:Notice:Delete", data, cb)
end)

RegisterNUICallback("BizWizEmployeeSearch", function(data, cb)
	exports['core']:CallbacksServer("Laptop:BizWiz:EmployeeSearch", data, cb)
end)

RegisterNUICallback("SetBusinessTwitter", function(data, cb)
	exports['core']:CallbacksServer("Laptop:BizWiz:SetTwitterProfile", data, cb)
end)

RegisterNUICallback("GetBusinessTwitter", function(data, cb)
	exports['core']:CallbacksServer("Laptop:BizWiz:GetTwitterProfile", data, cb)
end)

RegisterNUICallback("SendBusinessTweet", function(data, cb)
	exports['core']:CallbacksServer("Laptop:BizWiz:SendTweet", data, cb)
end)

RegisterNUICallback("ViewVehicleFleet", function(data, cb)
	exports['core']:CallbacksServer("Laptop:BizWiz:ViewVehicleFleet", data, cb)
end)

RegisterNUICallback("TrackFleetVehicle", function(data, cb)
	exports['core']:CallbacksServer("Laptop:BizWiz:TrackFleetVehicle", data, function(data)
		if data then
			DeleteWaypoint()
			SetNewWaypoint(data.x, data.y)
			cb(true)
		else
			cb(false)
		end
	end)
end)