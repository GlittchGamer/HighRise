function RegisterJobCallbacks()
  exports['hrrp-base']:CallbacksRegisterServer('Jobs:OnDuty', function(source, jobId, cb)
    cb(exports['hrrp-jobs']:JobsDutyOn(source, jobId))
  end)

  exports['hrrp-base']:CallbacksRegisterServer('Jobs:OffDuty', function(source, jobId, cb)
    cb(exports['hrrp-jobs']:JobsDutyOff(source, jobId))
  end)
end
