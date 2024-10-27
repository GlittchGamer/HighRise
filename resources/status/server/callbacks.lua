function RegisterCallbacks()
  exports['core']:CallbacksRegisterServer('Status:Get', function(source, data, cb)
    local player = exports['core']:FetchSource(source)
    local char = player:GetData('Character')
    if char ~= nil then
      local status = char:GetData('Status')
      if status == nil then
        status = {}
      end
      if status[data.name] ~= nil then
        cb(status[data.name])
      else
        status[data.name] = data.max
        char:SetData('Status', status)
        cb(data.max)
      end
    else
      cb(data.max)
    end
  end)
end
