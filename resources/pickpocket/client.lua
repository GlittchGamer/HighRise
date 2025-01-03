local cooldown = false
local lootedPeds = {} -- Table to keep track of looted peds

AddEventHandler("PickPocket:Shared:DependencyUpdate", RetrieveComponents)

function RetrieveComponents()
  Progress = exports['core']:FetchComponent("Progress")
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies("PickPocket", {
    "Progress"
  }, function(error)
    if #error > 0 then
      return
    end
    RetrieveComponents()
    RemoveEventHandler(setupEvent)
  end)
end)

-- List of "fat" ped models
local fatPeds = {
  -- Male Fat Peds
  "a_m_m_fatlatin_01",
  "a_m_m_fatlatin_02",
  "a_m_m_fatblack_01",
  "a_m_m_fatwhite_01",
  "ig_chengsr",         -- Kenny Sr. (Fat)
  "ig_fatc",            -- Fat Gangster Character
  "cs_fatc",            -- Cutscene Fat Gangster Character
  "a_m_m_tourist_01",   -- Added as requested
  "a_m_m_afriamer_01",
  "a_m_y_downtown_01",
  "a_m_m_polynesian_01",

  -- Female Fat Peds
  "a_f_m_fatbla_01",
  "a_f_m_fatcult_01",
  "a_f_m_fatwhite_01",
  "a_f_m_downtown_01",

  -- Miscellaneous
  "s_m_m_gentransport"   -- Security Transport (overweight)
}

-- List of food items given when pickpocketing fat peds
local fatPedItems = {
  "crisps",
  "cpizzaslice",
  "papizzaslice",
  "frenchfries"
}

local function PlayPickpocketEmote()
  local playerPed = PlayerPedId()
  local animDict = "melee@knife@streamed_core"
  local animName = "plyr_rear_takedown_b"

  RequestAnimDict(animDict)
  while not HasAnimDictLoaded(animDict) do
    Wait(10)
  end

  TaskPlayAnim(playerPed, animDict, animName, 8.0, -8.0, 5000, 1, 0, false, false, false)
  Wait(5000)
  ClearPedTasks(playerPed)
end

local function IsFatPed(ped)
  local pedModel = GetEntityModel(ped)
  for _, model in pairs(fatPeds) do
    if pedModel == GetHashKey(model) then
      return true
    end
  end
  return false
end

-- Function to get a random item from the fatPedItems list
local function GetRandomFatPedItem()
  local randomIndex = math.random(#fatPedItems)
  return fatPedItems[randomIndex]
end

local function InteractWithPed(ped)
  -- Check if this ped has already been looted
  if lootedPeds[ped] then
    exports['hud']:NotificationError("Go away punk, you have taken everything I had!", 2500)
    return
  end

  -- Check if the ped is standing still
  if not IsPedStill(ped) then
    exports['hud']:NotificationError('This person is moving too fast to pickpocket.', 2500)
    return
  end

  -- Allow the pickpocket to proceed without freezing the ped
  Progress:Progress({
    name = "pickpocket",
    duration = 5000,
    label = "Pickpocketing...",
    useWhileDead = false,
    canCancel = true,
    controlDisables = {
      disableMovement = false,
      disableCarMovement = true,
      disableMouse = false,
      disableCombat = true,
    },
    animation = {
      animDict = "mini@repair",
      anim = "fixing_a_player",
      flags = 49,
    },
  }, function(cancelled)
    if not cancelled then
      if IsFatPed(ped) then
        -- If the ped is fat, give a random food item and show custom message
        TriggerServerEvent('Ped:Server:GiveItemPick:FatCunt')         -- Send random food item to the server
      else
        -- For non-fat peds, give random cash reward
        TriggerServerEvent('Ped:Server:GiveItemPick:SkinnyCunt')
      end

      -- Mark the ped as looted
      lootedPeds[ped] = true
      cooldown = true
      Citizen.SetTimeout(1000, function() cooldown = false end)
    else
      exports['hud']:NotificationError('Pickpocket attempt cancelled.', 2500)
    end
  end)
end

function EnumeratePeds()
  local peds = {}
  local pedHandle, ped = FindFirstPed()
  local found = true

  while found do
    if ped ~= PlayerPedId() and DoesEntityExist(ped) and not IsPedAPlayer(ped) then
      table.insert(peds, ped)
    end
    found, ped = FindNextPed(pedHandle)
  end

  EndFindPed(pedHandle)
  return peds
end

RegisterNetEvent('Pickpocket:AddTargetToPeds', function(data)
  local peds = EnumeratePeds()
  for _, ped in ipairs(peds) do
    -- Only add target interaction if the ped is human and standing still
    if IsPedHuman(ped) and IsPedStill(ped) then
      if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(ped)) < 2.0 then
        -- Check if the ped is looted before adding the target interaction
        if not lootedPeds[ped] then
          if not cooldown then
            InteractWithPed(ped)
          else
            exports['hud']:NotificationError("Maybe you should take a break", 2500)
          end
        end
      end
    end
  end
end)
