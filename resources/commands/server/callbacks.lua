function RegisterCallbacks()
  exports['core']:CallbacksRegisterServer('Commands:ValidateAdmin', function(source, data, cb)
    local player = exports['core']:FetchComponent('Fetch'):Source(source)
    if player.Permissions:IsAdmin() then
      return cb(true)
    else
      exports['core']:FetchComponent('Logger'):Log('Commands', string.format('%s attempted to use an admin command but failed Admin Validation.', {
        console = true,
        file = true,
        database = true,
        discord = {
          embed = true,
          type = 'error'
        }
      }, player:GetData('Identifier')))
    end
  end)
end
