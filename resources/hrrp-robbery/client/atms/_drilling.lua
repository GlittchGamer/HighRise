-- Thanks to meta-hub for scaleform and minigame base. I made a few edits and added a few things.
Scaleforms = {}
-- Load scaleforms
Scaleforms.LoadMovie = function(name)
  local scaleform = RequestScaleformMovie(name)
  while not HasScaleformMovieLoaded(scaleform) do Wait(0); end
  return scaleform
end

Scaleforms.LoadInteractive = function(name)
  local scaleform = RequestScaleformMovieInteractive(name)
  while not HasScaleformMovieLoaded(scaleform) do Wait(0); end
  return scaleform
end

Scaleforms.UnloadMovie = function(scaleform)
  SetScaleformMovieAsNoLongerNeeded(scaleform)
end
-- Text & labels
Scaleforms.LoadAdditionalText = function(gxt, count)
  for i = 0, count, 1 do
    if not HasThisAdditionalTextLoaded(gxt, i) then
      ClearAdditionalText(i, true)
      RequestAdditionalText(gxt, i)
      while not HasThisAdditionalTextLoaded(gxt, i) do Wait(0); end
    end
  end
end

Scaleforms.SetLabels = function(scaleform, labels)
  BeginScaleformMovieMethod(scaleform, "SET_LABELS")
  for i = 1, #labels, 1 do
    local txt = labels[i]
    BeginTextCommandScaleformString(txt)
    EndTextCommandScaleformString()
  end
  EndScaleformMovieMethod()
end
-- Push method vals wrappers
Scaleforms.PopMulti = function(scaleform, method, ...)
  BeginScaleformMovieMethod(scaleform, method)
  for _, v in pairs({ ... }) do
    local trueType = Scaleforms.TrueType(v)
    if trueType == "string" then
      ScaleformMovieMethodAddParamTextureNameString(v)
    elseif trueType == "boolean" then
      ScaleformMovieMethodAddParamBool(v)
    elseif trueType == "int" then
      ScaleformMovieMethodAddParamInt(v)
    elseif trueType == "float" then
      ScaleformMovieMethodAddParamFloat(v)
    end
  end
  EndScaleformMovieMethod()
end

Scaleforms.PopFloat = function(scaleform, method, val)
  BeginScaleformMovieMethod(scaleform, method)
  ScaleformMovieMethodAddParamFloat(val)
  EndScaleformMovieMethod()
end

Scaleforms.PopInt = function(scaleform, method, val)
  BeginScaleformMovieMethod(scaleform, method)
  ScaleformMovieMethodAddParamInt(val)
  EndScaleformMovieMethod()
end

Scaleforms.PopBool = function(scaleform, method, val)
  BeginScaleformMovieMethod(scaleform, method)
  ScaleformMovieMethodAddParamBool(val)
  EndScaleformMovieMethod()
end

-- Push no args
Scaleforms.PopRet = function(scaleform, method)
  BeginScaleformMovieMethod(scaleform, method)
  return EndScaleformMovieMethodReturnValue()
end

Scaleforms.PopVoid = function(scaleform, method)
  BeginScaleformMovieMethod(scaleform, method)
  EndScaleformMovieMethod()
end
-- Get return
Scaleforms.RetBool = function(ret)
  return IsScaleformMovieMethodReturnValueReady(ret)
end

Scaleforms.RetInt = function(ret)
  return GetScaleformMovieMethodReturnValueInt(ret)
end
-- Util functions
Scaleforms.TrueType = function(val)
  if type(val) ~= "number" then return type(val); end
  local s = tostring(val)
  if string.find(s, '.') then
    return "float"
  else
    return "int"
  end
end

Drilling = {}

Drilling.DisabledControls = { 30, 31, 32, 33, 34, 35 }
Drilling.Start = function(callback)
  if not Drilling.Active then
    Drilling.Active = true
    Drilling.Init()
    Drilling.Update(callback)
  end
end


Drilling.Init = function()
  if Drilling.Scaleform then
    Scaleforms.UnloadMovie(Drilling.Scaleform)
  end
  Drilling.Scaleform = Scaleforms.LoadMovie(Drilling.Type)
  if Drilling.Type == 'VAULT_LASER' then
    extra = "SET_LASER_WIDTH"
  else
    extra = "SET_SPEED"
  end

  Drilling.DrillSpeed = 0.0
  Drilling.DrillPos   = 0.0
  Drilling.DrillTemp  = 0.0
  Drilling.HoleDepth  = 0.0

  Scaleforms.PopVoid(Drilling.Scaleform, "REVEAL")
  Scaleforms.PopFloat(Drilling.Scaleform, extra, 0.0)
  Scaleforms.PopFloat(Drilling.Scaleform, "SET_DRILL_POSITION", 0.0)
  Scaleforms.PopFloat(Drilling.Scaleform, "SET_TEMPERATURE", 0.0)
  Scaleforms.PopFloat(Drilling.Scaleform, "SET_HOLE_DEPTH", 0.0)
  Scaleforms.PopInt(Drilling.Scaleform, "SET_NUM_DISCS", 6)
end


Drilling.Update = function(callback)
  while Drilling.Active do
    Drilling.Draw()
    Drilling.DisableControls()
    Drilling.HandleControls()
    Drilling.HandleInstructions()
    Wait(0)
  end
  callback(Drilling.Result)
end


Drilling.Draw = function()
  DrawScaleformMovieFullscreen(Drilling.Scaleform, 255, 255, 255, 255, 255)
end


Drilling.HandleInstructions = function()
  CreateThread(function()
    while Drilling.Active do
      Wait(0)
      AddTextEntry('DrillingMessage',
        "~INPUT_MOVE_UP_ONLY~ Move up ~INPUT_MOVE_DOWN_ONLY~ Move down\n~INPUT_MOVE_LEFT_ONLY~ Move left ~INPUT_MOVE_RIGHT_ONLY~ Move Right\n~INPUT_CELLPHONE_CANCEL~ End")
      BeginTextCommandDisplayHelp('DrillingMessage')
      EndTextCommandDisplayHelp(0, false, true, -1)
      if IsControlJustPressed(0, 194) then
        if Drilling.Active then
          Drilling.Result = false
          Drilling.Active = false
        end
      end
    end
  end)
end


Drilling.HandleControls = function()
  local last_pos = Drilling.DrillPos
  if IsControlJustPressed(0, 232) then
    Drilling.DrillPos = math.min(1.0, Drilling.DrillPos + 0.01)
    Scaleforms.PopVoid(Drilling.Scaleform, "burstOutSparks")
  elseif IsControlPressed(0, 235) then
    Drilling.DrillPos = math.min(1.0, Drilling.DrillPos + (0.1 * GetFrameTime() / (math.max(0.1, Drilling.DrillTemp) * 10)))
  elseif IsControlJustPressed(0, 233) then
    Drilling.DrillPos = math.max(0.0, Drilling.DrillPos - 0.01)
  elseif IsControlPressed(0, 234) then
    Drilling.DrillPos = math.max(0.0, Drilling.DrillPos - (0.1 * GetFrameTime()))
  end
  local last_speed = Drilling.DrillSpeed
  if IsControlJustPressed(0, 235) then
    Drilling.DrillSpeed = math.min(1.0, Drilling.DrillSpeed + 0.05)
  elseif IsControlPressed(0, 235) then
    Drilling.DrillSpeed = math.min(1.0, Drilling.DrillSpeed + (0.5 * GetFrameTime()))
  elseif IsControlJustPressed(0, 234) then
    Drilling.DrillSpeed = math.max(0.0, Drilling.DrillSpeed - 0.05)
  elseif IsControlPressed(0, 234) then
    Drilling.DrillSpeed = math.max(0.0, Drilling.DrillSpeed - (0.5 * GetFrameTime()))
  end
  local last_temp = Drilling.DrillTemp
  if last_pos < Drilling.DrillPos then
    if Drilling.DrillSpeed > 0.4 then
      Drilling.DrillTemp = math.min(1.0, Drilling.DrillTemp + ((0.05 * GetFrameTime()) * (Drilling.DrillSpeed * 10)))
      Scaleforms.PopFloat(Drilling.Scaleform, "SET_DRILL_POSITION", Drilling.DrillPos)
    else
      if Drilling.DrillPos < 0.1 or Drilling.DrillPos < Drilling.HoleDepth then
        Scaleforms.PopFloat(Drilling.Scaleform, "SET_DRILL_POSITION", Drilling.DrillPos)
      else
        Drilling.DrillPos = last_pos
        Drilling.DrillTemp = math.min(1.0, Drilling.DrillTemp + (0.01 * GetFrameTime()))
      end
    end
  else
    if Drilling.DrillPos < Drilling.HoleDepth then
      Drilling.DrillTemp = math.max(0.0, Drilling.DrillTemp - ((0.05 * GetFrameTime()) * math.max(0.005, (Drilling.DrillSpeed * 10) / 2)))
    end
    if Drilling.DrillPos ~= Drilling.HoleDepth then
      Scaleforms.PopFloat(Drilling.Scaleform, "SET_DRILL_POSITION", Drilling.DrillPos)
    end
  end
  if last_speed ~= Drilling.DrillSpeed then
    Scaleforms.PopFloat(Drilling.Scaleform, extra, Drilling.DrillSpeed)
  end
  if last_temp ~= Drilling.DrillTemp then
    Scaleforms.PopFloat(Drilling.Scaleform, "SET_TEMPERATURE", Drilling.DrillTemp)
  end
  if Drilling.DrillTemp >= 1.0 then
    Drilling.Result = false
    Drilling.Active = false
    Scaleforms.PopVoid(Drilling.Scaleform, "RESET")
  elseif Drilling.DrillPos >= 1.0 then
    Drilling.Result = true
    Drilling.Active = false
    Scaleforms.PopVoid(Drilling.Scaleform, "RESET")
  end
  Drilling.HoleDepth = (Drilling.DrillPos > Drilling.HoleDepth and Drilling.DrillPos or Drilling.HoleDepth)
end

Drilling.DisableControls = function()
  for _, control in ipairs(Drilling.DisabledControls) do
    DisableControlAction(0, control, true)
  end
end

Drilling.EnableControls = function()
  for _, control in ipairs(Drilling.DisabledControls) do
    DisableControlAction(0, control, true)
  end
end
