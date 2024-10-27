local _sharePromise = nil

AddEventHandler("Wardrobe:Shared:DependencyUpdate", RetrieveWardrobeComponents)
function RetrieveWardrobeComponents()
  Callbacks = exports['core']:FetchComponent("Callbacks")
  Notification = exports['core']:FetchComponent("Notification")
  Utils = exports['core']:FetchComponent("Utils")
  ListMenu = exports['core']:FetchComponent("ListMenu")
  Input = exports['core']:FetchComponent("Input")
  Confirm = exports['core']:FetchComponent("Confirm")
  Sounds = exports['core']:FetchComponent("Sounds")
  Wardrobe = exports['core']:FetchComponent("Wardrobe")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies("ListMenu", {
    "Callbacks",
    "Notification",
    "Utils",
    "ListMenu",
    "Input",
    "Confirm",
    "Sounds",
    "Wardrobe",
  }, function(error)
    if #error > 0 then
      return
    end
    RetrieveWardrobeComponents()

    exports['core']:CallbacksRegisterClient("Wardrobe:Sharing:Begin", function(data, cb)
      if _sharePromise == nil then
        _sharePromise = promise.new()
        Confirm:Show(
          'Confirm Outfit Sharing',
          {
            no = 'Wardrobe:Sharing:Deny',
            yes = 'Wardrobe:Sharing:Confirm',
          },
          string.format(
            [[
							Please confirm that you would like to recieve the outfit below.<br>
							Outfit Name: %s<br>
						]],
            data.label
          ),
          {},
          'Refuse',
          'Accept'
        )

        cb(Citizen.Await(_sharePromise))
      else
        cb(false)
      end
    end)



    RemoveEventHandler(setupEvent)
  end)
end)

AddEventHandler('Wardrobe:Sharing:Confirm', function(data)
  if _sharePromise ~= nil then
    _sharePromise:resolve(true)
    _sharePromise = nil
  end
end)

AddEventHandler('Wardrobe:Sharing:Deny', function(data)
  if _sharePromise ~= nil then
    _sharePromise:resolve(false)
    _sharePromise = nil
  end
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
  exports['core']:RegisterComponent("Wardrobe", WARDROBE)
end)

AddEventHandler("Wardrobe:Client:SaveNew", function(data)
  Input:Show("Outfit Name", "Outfit Name", {
    {
      id = "name",
      type = "text",
      options = {
        inputProps = {
          maxLength = 24,
        },
      },
    },
  }, "Wardrobe:Client:DoSave", data)
end)

AddEventHandler("Wardrobe:Client:Rename", function(data)
  Input:Show("Outfit Name", "Outfit Name", {
    {
      id = "name",
      type = "text",
      options = {
        inputProps = {
          maxLength = 24,
        },
      },
    },
  }, "Wardrobe:Client:DoRename", data.index)
end)

AddEventHandler("Wardrobe:Client:SaveExisting", function(data)
  exports['core']:CallbacksServer("Wardrobe:SaveExisting", data.index, function(state)
    if state then
      exports['hud']:NotificationSuccess("Outfit Saved")
      Wardrobe:Show()
    else
      exports['hud']:NotificationError("Unable to Save Outfit")
    end
  end)
end)

AddEventHandler("Wardrobe:Client:DoSave", function(values, data)
  exports['core']:CallbacksServer("Wardrobe:Save", {
    index = data,
    name = values.name,
  }, function(state)
    if state then
      exports['hud']:NotificationSuccess("Outfit Saved")
      Wardrobe:Show()
    else
      exports['hud']:NotificationError("Unable to Save Outfit")
    end
  end)
end)

AddEventHandler("Wardrobe:Client:Delete", function(data)
  Confirm:Show(string.format("Delete %s?", data.label), {
    yes = "Wardrobe:Client:Delete:Yes",
    no = "Wardrobe:Client:Delete:No",
  }, "", data.index)
end)

AddEventHandler("Wardrobe:Client:Delete:Yes", function(data)
  exports['core']:CallbacksServer("Wardrobe:Delete", data, function(s)
    if s then
      exports['hud']:NotificationSuccess("Outfit Deleted")
      Wardrobe:Show()
    end
  end)
end)

AddEventHandler("Wardrobe:Client:Equip", function(data)
  exports['core']:CallbacksServer("Wardrobe:Equip", data.index, function(state)
    if state then
      Sounds.Play:One("outfit_change.ogg", 0.3)
      exports['hud']:NotificationSuccess("Outfit Equipped")
    else
      exports['hud']:NotificationError("Unable to Equip Outfit")
    end
  end)
end)

AddEventHandler("Wardrobe:Client:DoRename", function(values, data)
  exports['core']:CallbacksServer("Wardrobe:Rename", {
    index = data,
    name = values.name,
  }, function(state)
    if state then
      exports['hud']:NotificationSuccess("Outfit Renamed")
      Wardrobe:Show()
    else
      exports['hud']:NotificationError("Unable to Rename Outfit")
    end
  end)
end)

AddEventHandler("Wardrobe:Client:Share", function(data)
  exports['core']:CallbacksServer("Wardrobe:Share", data.index, function(state)
    if not state then
      exports['hud']:NotificationError("Unable to Share Outfit")
    end
  end)
end)

RegisterNetEvent("Wardrobe:Client:MoveUp", function(data)
  exports['core']:CallbacksServer("Wardrobe:MoveUp", data, function(state)
    if state then
      Wardrobe:Show()
    else
      exports['hud']:NotificationError("Unable to Change Order")
    end
  end)
end)

RegisterNetEvent("Wardrobe:Client:MoveDown", function(data)
  exports['core']:CallbacksServer("Wardrobe:MoveDown", data, function(state)
    if state then
      Wardrobe:Show()
    else
      exports['hud']:NotificationError("Unable to Change Order")
    end
  end)
end)

RegisterNetEvent("Wardrobe:Client:ShowBitch", function(eventRoutine)
  Wardrobe:Show()
end)

WARDROBE = {
  Show = function(self)
    exports['core']:CallbacksServer("Wardrobe:GetAll", {}, function(data)
      local items = {}
      for k, v in pairs(data) do
        if v.label ~= nil then
          local actions = {
            {
              icon = "floppy-disk",
              event = "Wardrobe:Client:SaveExisting",
            },
            {
              icon = "shirt",
              event = "Wardrobe:Client:Equip",
            },
            {
              icon = "share",
              event = "Wardrobe:Client:Share",
            },
            {
              icon = "signature",
              event = "Wardrobe:Client:Rename",
            },
            {
              icon = "x",
              event = "Wardrobe:Client:Delete",
            }
          }

          if (k == #data) then
            table.insert(actions, 1, { icon = "arrow-up", event = "Wardrobe:Client:MoveUp" })
          elseif (k == 1) then
            table.insert(actions, 1, { icon = "arrow-down", event = "Wardrobe:Client:MoveDown" })
          else
            table.insert(actions, 1, { icon = "arrow-up", event = "Wardrobe:Client:MoveUp" })
            table.insert(actions, 2, { icon = "arrow-down", event = "Wardrobe:Client:MoveDown" })
          end

          table.insert(items, {
            label = v.label,
            description = string.format("Outfit #%s", k),
            actions = actions,
            data = {
              index = k,
              label = v.label,
            },
          })
        end
      end

      table.insert(items, {
        label = "Save New Outfit",
        event = "Wardrobe:Client:SaveNew",
      })

      ListMenu:Show({
        main = {
          label = "Wardrobe",
          items = items,
        },
      })
    end)
  end,
  Close = function(self)
    SetNuiFocus(false, false)
    SendNUIMessage({
      type = "CLOSE_LIST_MENU",
    })
  end,
}
