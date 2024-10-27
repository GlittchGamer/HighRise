local _stores = {}

COMPONENTS.DataStore = {
  _name = "base",
  CreateStore = function(self, owner, key, data)
    data = data or {}
    _stores[owner] = _stores[owner] or {}
    _stores[owner][key] = data

    local ownerDataStore = _stores[owner][key]

    return {
      Owner = owner,
      Key = key,
      SetData = function(self, var, data)
        ownerDataStore[var] = data

        if self.Key == "Character" and IsDuplicityVersion() then
          TriggerClientEvent("Characters:Client:SetData", ownerDataStore["Source"], var, data)

          -- exports['characters']:updateCachedValue(ownerDataStore["SID"], var, data)
        end
      end,
      GetData = function(self, var)
        local data = _stores[self.Owner][self.Key]
        if var and var ~= "" then
          return data[var]
        else
          return data
        end
      end,
      DeleteStore = function(self)
        COMPONENTS.DataStore:DeleteStore(self.Owner, self.Key)
      end,
    }
  end,
  DeleteStore = function(self, owner, key)
    _stores[owner][key] = nil
    collectgarbage()
  end,
}

exports("DataStoreCreate", function(owner, key, data)
  return COMPONENTS.DataStore:CreateStore(owner, key, data)
end)

exports("DataStoreDelete", function(owner, key)
  return COMPONENTS.DataStore:DeleteStore(owner, key)
end)
