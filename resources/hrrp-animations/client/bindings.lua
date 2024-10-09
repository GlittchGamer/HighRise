ANIMATIONS.EmoteBinds = {
  Update = function(self, newBinds)
    exports["hrrp-base"]:CallbacksServer('Animations:UpdateEmoteBinds', newBinds, function(success, data)
      if success then
        emoteBinds = data
        exports['hrrp-hud']:NotificationSuccess('Successfully Updated and Saved Keybinds', 5000)
      end
    end)
  end,
  Use = function(self, bindId)
    local bindEmote = emoteBinds[tostring(bindId)]
    if bindEmote and type(bindEmote) == 'string' then
      exports["hrrp-animations"]:EmotesPlay(bindEmote, true)
    end
  end
}

RegisterNetEvent('Animations:Client:OpenEmoteBinds', function()
  local bindInputs = {}
  for bindNum = 1, 5 do
    table.insert(bindInputs, {
      id = 'bind-' .. bindNum,
      type = "text",
      options = {
        inputProps = {
          maxLength = 64,
        },
        label = string.format('Emote Bind #%s - Currently Assigned to %s', bindNum, exports['hrrp-keybinds']:GetKey('emote_bind_' .. bindNum)),
        defaultValue = emoteBinds[tostring(bindNum)] or '',
      },
    })
  end

  Input:Show(
    "Emote Binds",
    "Input Label",
    bindInputs,
    "Animations:Client:SaveEmoteBinds",
    {}
  )
end)

AddEventHandler('Animations:Client:SaveEmoteBinds', function(values)
  local updatedBinds = {}

  for bindNum = 1, 5 do
    local newValue = values['bind-' .. bindNum]
    if newValue then
      updatedBinds[tostring(bindNum)] = newValue
    end
  end

  Animations.EmoteBinds:Update(updatedBinds)
end)
