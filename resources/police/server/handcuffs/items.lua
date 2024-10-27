function HandcuffItems()
	Inventory.Items:RegisterUse("pdhandcuffs", "Handcuffs", function(source, item)
		exports['core']:CallbacksClient(source, "Handcuffs:VehCheck", {}, function(inVeh)
			if not inVeh then
				Handcuffs:ToggleCuffs(source)
			end
		end)
	end)

	Inventory.Items:RegisterUse("handcuffs", "Handcuffs", function(source, item)
		exports['core']:CallbacksClient(source, "Handcuffs:VehCheck", {}, function(inVeh)
			if not inVeh then
				Handcuffs:ToggleCuffs(source)
			end
		end)
	end)

	Inventory.Items:RegisterUse("fluffyhandcuffs", "Handcuffs", function(source, item)
		exports['core']:CallbacksClient(source, "Handcuffs:VehCheck", {}, function(inVeh)
			if not inVeh then
				Handcuffs:ToggleCuffs(source)
			end
		end)
	end)
end