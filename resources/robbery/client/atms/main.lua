ATMRobbery = {
  CreatedEntities = {},
  DrillScenes = {},
  DrillAnimations = {
    { 'intro',                   'bag_intro',                'intro_drill_bit' },
    { 'drill_straight_start',    'bag_drill_straight_start', 'drill_straight_start_drill_bit' },
    { 'drill_straight_end_idle', 'bag_drill_straight_idle',  'drill_straight_idle_drill_bit' },
    { 'drill_straight_fail',     'bag_drill_straight_fail',  'drill_straight_fail_drill_bit' },
    { 'drill_straight_end',      'bag_drill_straight_end',   'drill_straight_end_drill_bit' },
    { 'exit',                    'bag_exit',                 'exit_drill_bit' },
  }
}

AddEventHandler("Robbery:Client:Setup", function()
  exports['core']:CallbacksRegisterClient('Robbery:ATM:StartRobbing', function(data, callback)
    local Target = exports.ox_target:TargetingGetEntityPlayerIsLookingAt()

    if not Target then
      callback(false)
      return
    end
    if IsATMModel(Target.entity) then
      if not data.Cooldown then
        exports['core']:CallbacksServer('Robbery:ATM:CanRobATM', Target.entity, function(cb)
          if cb then
            exports['core']:CallbacksServer('Robbery:ATM:SetATMRobbed', Target.entity, function(cb) end)
            local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(Target.entity), true)

            if distance < 2.0 then
              StartDrilling(Target.entity, {})
              callback(true)
            else
              callback(false)
            end
          else
            callback(false)
            exports['hud']:NotificationError('This ATM has already been robbed.', 2500)
          end
        end)
      else
        exports['hud']:NotificationError('You cannot rob an ATM right now.', 2500)
        callback(false)
      end
    else
      callback(false)
    end
  end)
end)

local ATMModels = {
  [506770882] = true,
  [-870868698] = true,
  [-1364697528] = true,
  [-1126237515] = true
}

function IsATMModel(entity)
  local model = GetEntityModel(entity)

  if ATMModels[model] then
    return true
  end

  return false
end

RequestAnim = function(animDict)
  while not HasAnimDictLoaded(animDict) do
    RequestAnimDict(animDict)
    Wait(10)
  end
end

RequestModelFunc = function(model)
  while not HasModelLoaded(model) do
    Wait(50)
    RequestModel(model)
  end
end

reqControlOfEntity = function(entity)
  NetworkRequestControlOfEntity(entity)
  local timer = GetGameTimer()
  while not NetworkHasControlOfEntity(entity) and GetGameTimer() - timer < 800 do
    Citizen.Wait(0)
  end
end

StartDrilling = function(entity, itemData)
  local pedCo = GetEntityCoords(ped)

  TaskTurnPedToFaceEntity(PlayerPedId(), entity, -1)
  Wait(1000)

  LocalPlayer.state.emotesDisabled = true

  local animDict = 'anim_heist@hs3f@ig9_vault_drill@laser_drill@'
  RequestAnim(animDict)

  local bagModel = `hei_p_m_bag_var22_arm_s`
  local laserDrillModel = `ch_prop_laserdrill_01a`
  RequestModelFunc(bagModel)
  RequestModelFunc(laserDrillModel)

  while not RequestScriptAudioBank("DLC_HEIST3/CASINO_HEIST_FINALE_GENERAL_01", false) do
    RequestScriptAudioBank("DLC_HEIST3/CASINO_HEIST_FINALE_GENERAL_01", false)
    Wait(100)
  end

  while not HasNamedPtfxAssetLoaded('scr_ornate_heist') do
    RequestNamedPtfxAsset('scr_ornate_heist')
    Wait(50)
  end

  local bag = CreateObject(bagModel, pedCo.x, pedCo.y, pedCo.z, true, false, false)
  local laserDrill = CreateObject(laserDrillModel, pedCo.x, pedCo.y, pedCo.z, true, false, false)
  SetEntityAsMissionEntity(bag, true, true)
  SetEntityAsMissionEntity(laserDrill, true, true)
  table.insert(ATMRobbery.CreatedEntities, bag)
  table.insert(ATMRobbery.CreatedEntities, laserDrill)

  reqControlOfEntity(bag)
  reqControlOfEntity(laserDrill)

  local animpos = GetEntityCoords(entity)
  local animrot = GetEntityRotation(entity)

  for i = 1, #ATMRobbery.DrillAnimations do
    ATMRobbery.DrillScenes[i] = NetworkCreateSynchronisedScene(animpos.x, animpos.y, animpos.z + 1.2, animrot.x, animrot.y, animrot.z, 2, true, false, 1065353216,
      0, 1.3)
    NetworkAddPedToSynchronisedScene(PlayerPedId(), ATMRobbery.DrillScenes[i], animDict, ATMRobbery.DrillAnimations[i][1], 4.0, -4.0, 1033, 0, 1000.0, 0)
    NetworkAddEntityToSynchronisedScene(bag, ATMRobbery.DrillScenes[i], animDict, ATMRobbery.DrillAnimations[i][2], 1.0, -1.0, 1148846080)
    NetworkAddEntityToSynchronisedScene(laserDrill, ATMRobbery.DrillScenes[i], animDict, ATMRobbery.DrillAnimations[i][3], 1.0, -1.0, 1148846080)
  end

  NetworkStartSynchronisedScene(ATMRobbery.DrillScenes[1])
  Wait(GetAnimDuration(animDict, 'intro') * 1000)

  NetworkStartSynchronisedScene(ATMRobbery.DrillScenes[2])
  Wait(GetAnimDuration(animDict, 'drill_straight_start') * 1000)

  NetworkStartSynchronisedScene(ATMRobbery.DrillScenes[3])

  UseParticleFxAsset('scr_ornate_heist')
  local blowPtfx = StartParticleFxLoopedOnEntity('scr_heist_ornate_thermal_burn', laserDrill, 0.0, 0.40, -0.01, 0.0, 0.0, 0.0, 1.0, false, false, false)

  local coords = GetEntityCoords(PlayerPedId())

  -- if math.random(100) >= 75 then
  --     SetTimeout(8000, function()
  --         Sounds.Play:Location(coords, 20.0, "house_alarm.ogg", 0.05)
  --         TriggerServerEvent("ATMTheft:AlertPolice", NetworkGetNetworkIdFromEntity(entity), "An ATM is being tampered with!")
  --     end)
  -- end

  Drilling.Type = 'VAULT_LASER'
  Drilling.Start(function(status)
    if status then
      StopParticleFxLooped(blowPtfx, false)
      NetworkStartSynchronisedScene(ATMRobbery.DrillScenes[5])
      Wait(GetAnimDuration(animDict, 'drill_straight_end') * 1000)

      NetworkStartSynchronisedScene(ATMRobbery.DrillScenes[6])
      Wait(GetAnimDuration(animDict, 'exit') * 1000)

      ClearPedTasks(PlayerPedId())

      reqControlOfEntity(bag)
      SetEntityAsMissionEntity(bag, true, true)
      DeleteObject(bag)

      reqControlOfEntity(laserDrill)
      SetEntityAsMissionEntity(laserDrill, true, true)
      DeleteObject(laserDrill)

      exports['core']:CallbacksServer('Robbery:ATM:GetReward', {}, function(HRRP) end)
    else
      StopParticleFxLooped(blowPtfx, false)

      NetworkStartSynchronisedScene(ATMRobbery.DrillScenes[4])
      Wait(GetAnimDuration(animDict, 'drill_straight_fail') * 1000 - 1500)

      ClearPedTasks(PlayerPedId())

      reqControlOfEntity(bag)
      SetEntityAsMissionEntity(bag, true, true)
      DeleteObject(bag)

      reqControlOfEntity(laserDrill)
      SetEntityAsMissionEntity(laserDrill, true, true)
      DeleteObject(laserDrill)

      -- if math.random(1, 3) == 3 then
      --     TriggerServerEvent('ATMTheft:RemoveItem', itemData)
      -- end
    end

    LocalPlayer.state.emotesDisabled = false
  end)

  ATMRobbery.CreatedEntities = {}
end
