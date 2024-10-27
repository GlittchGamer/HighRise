AddEventHandler("Confirm:Shared:DependencyUpdate", RetrieveInfoOverlayComponents)
function RetrieveInfoOverlayComponents()
  InfoOverlay = exports['core']:FetchComponent("InfoOverlay")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies("InfoOverlay", {
    "InfoOverlay",
  }, function(error)
    if #error > 0 then
      return
    end
    RetrieveInfoOverlayComponents()

    RemoveEventHandler(setupEvent)
  end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
  exports['core']:RegisterComponent("InfoOverlay", INFOOVERLAY)
end)

-- RegisterNetEvent("Confirm:Client:Test", function()
-- 	Confirm:Show(
-- 		"Test Input",
-- 		{
-- 			yes = "Confirm:Test:Yes",
-- 			no = "Confirm:Test:No",
-- 		},
-- 		"This is a test confirm dialog, neat",
-- 		{
-- 			test = "penis",
-- 		}
-- 	)
-- end)

local _isOpen = false

INFOOVERLAY = {
  Show = function(self, title, description)
    _isOpen = true

    SendNUIMessage({
      action = "SHOW_INFO_OVERLAY",
      data = {
        info = {
          label = title,
          description = description,
        },
      },
    })
  end,
  Close = function(self)
    _isOpen = false

    SendNUIMessage({
      action = "CLOSE_INFO_OVERLAY",
    })
  end,
  IsOpen = function(self)
    return _isOpen
  end
}
