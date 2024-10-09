local PD_NPC_DATA = {
  ["Police-MRPD-ClockOn"] = {
    first_name = 'Ben',
    last_name = 'Carmine',
    Tag = '👮',
    description = 'Hey bud! What can I do for you?',
  }
}

function RegisterPoliceNPC()
  exports['hrrp-pedinteraction']:Add("Police-MRPD-ClockOn", GetHashKey("s_m_y_garbage"), vector3(450.013, -979.385, 29.678), 99.654624938965, 25.0, {
    {
      icon = "person",
      text = "Interact",
      event = "Police:NPC:Duty",
      data = { NPC_NAME = 'Police-MRPD-ClockOn' }
    },
  }, nil, 'WORLD_HUMAN_CLIPBOARD', {
    jobPerms = {
      {
        job = "police",
        reqDuty = false
      },
    },
  })
end

-- if LocalPlayer.state.onDuty == "police" and not LocalPlayer.state.isDead and LocalPlayer.state._inInvPoly ~= nil then
--   return
-- end

local function GenerateNPCDialogue()
  return {
    {
      text = "Ready to get 10-41?",
      event = "Police:Client:OnDuty",
      isEnabled = LocalPlayer.state.onDuty == "police" == false
    },
    {
      text = "Going 10-42 already? Part Timer.",
      event = "Police:Client:OffDuty",
      isEnabled = LocalPlayer.state.onDuty == "police" == true
    },
  }
end

RegisterNetEvent('Police:NPC:Duty', function(entity, data)
  local Options = {}
  local NPCData = PD_NPC_DATA[data.NPC_NAME]
  for k, v in ipairs(GenerateNPCDialogue()) do
    if v.isEnabled then
      table.insert(Options, {
        label = v.text,
        data = { close = true, event = v.event }
      })
    end
  end

  table.insert(Options, {
    label = 'See you later',
    data = { close = true }
  })


  NPCData['buttons'] = Options

  NPCDialog.Open(entity.entity, NPCData)
end)
