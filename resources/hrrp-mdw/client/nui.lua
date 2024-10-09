RegisterNUICallback("Search", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("MDT:Search:" .. data.type, data, cb)
end)

RegisterNUICallback("InputSearch", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("MDT:InputSearch:" .. data.type, data, cb)
end)

RegisterNUICallback("InputSearchSID", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("MDT:InputSearchSID", data, cb)
end)

RegisterNUICallback("View", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("MDT:View:" .. data.type, data.id, cb)
end)

RegisterNUICallback("Create", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("MDT:Create:" .. data.type, data, cb)
end)

RegisterNUICallback("Update", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("MDT:Update:" .. data.type, data, cb)
end)

RegisterNUICallback("Delete", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("MDT:Delete:" .. data.type, data, cb)
end)

RegisterNUICallback("SentencePlayer", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("MDT:SentencePlayer", data, cb)
end)

RegisterNUICallback("IssueWarrant", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("MDT:IssueWarrant", data, cb)
end)

RegisterNUICallback("ManageEmployment", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("MDT:ManageEmployment", data, cb)
end)

RegisterNUICallback("HireEmployee", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("MDT:Hire", data, cb)
end)

RegisterNUICallback("FireEmployee", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("MDT:Fire", data, cb)
end)

RegisterNUICallback("SuspendEmployee", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("MDT:Suspend", data, cb)
end)

RegisterNUICallback("UnsuspendEmployee", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("MDT:Unsuspend", data, cb)
end)

RegisterNUICallback("CheckCallsign", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("MDT:CheckCallsign", data, cb)
end)

RegisterNUICallback("RosterView", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("MDT:RosterView", data, cb)
end)

RegisterNUICallback("RosterSelect", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("MDT:RosterSelect", data, cb)
end)

RegisterNUICallback("GetProperties", function(data, cb)
	local properties = Properties:GetProperties()

	local data = {}
	if properties then
		for k,v in pairs(properties) do
			table.insert(data, v)
		end
	end

	cb(data)
end)

RegisterNUICallback("FindProperty", function(data, cb)
	local prop = Properties:Get(data)
	if prop ~= nil then
		ClearGpsPlayerWaypoint()
		SetNewWaypoint(prop.location.front.x, prop.location.front.y)
        cb(true)
	else
		cb(false)
	end
end)

RegisterNUICallback("EvidenceLocker", function(data, cb)
	cb(true)
	exports["hrrp-base"]:CallbacksServer("MDT:OpenEvidenceLocker", data)
end)

RegisterNUICallback("PrintBadge", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("MDT:PrintBadge", data, cb)
end)

RegisterNUICallback("RevokeSuspension", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("MDT:RevokeLicenseSuspension", data, cb)
end)

RegisterNUICallback("ClearRecord", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("MDT:ClearCriminalRecord", data, cb)
end)

RegisterNUICallback("RemovePoints", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("MDT:RemoveLicensePoints", data, cb)
end)

RegisterNUICallback("OverturnSentence", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("MDT:OverturnSentence", data, cb)
end)

RegisterNUICallback("ViewVehicleFleet", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("MDT:ViewVehicleFleet", data, cb)
end)

RegisterNUICallback("SetAssignedDrivers", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("MDT:SetAssignedDrivers", data, cb)
end)

RegisterNUICallback("TrackFleetVehicle", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("MDT:TrackFleetVehicle", data, function(data)
		if data then
			DeleteWaypoint()
			SetNewWaypoint(data.x, data.y)
			cb(true)
		else
			cb(false)
		end
	end)
end)

RegisterNUICallback("GetHomeData", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("MDT:GetHomeData", data, cb)
end)

RegisterNUICallback("GetLibraryDocuments", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("MDT:GetLibraryDocuments", data, cb)
end)

RegisterNUICallback("AddLibraryDocument", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("MDT:AddLibraryDocument", data, cb)
end)

RegisterNUICallback("RemoveLibraryDocument", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("MDT:RemoveLibraryDocument", data, cb)
end)

RegisterNUICallback("DOCGetPrisoners", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("MDT:DOCGetPrisoners", data, cb)
end)

RegisterNUICallback("DOCReduceSentence", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("MDT:DOCReduceSentence", data, cb)
end)

RegisterNUICallback("DOCRequestVisitation", function(data, cb)
	exports["hrrp-base"]:CallbacksServer("MDT:DOCRequestVisitation", data, cb)
end)