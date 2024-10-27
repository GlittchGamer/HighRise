function RegisterJobCallbacks()
  exports['core']:CallbacksRegisterServer('Jobs:OnDuty', function(source, jobId, cb)
    cb(exports['jobs']:JobsDutyOn(source, jobId))
  end)

  exports['core']:CallbacksRegisterServer('Jobs:OffDuty', function(source, jobId, cb)
    cb(exports['jobs']:JobsDutyOff(source, jobId))
  end)
end
