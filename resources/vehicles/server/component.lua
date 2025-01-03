ACTIVE_OWNED_VEHICLES = {} -- Vehicles that need synced to the DB
ACTIVE_OWNED_VEHICLES_SPAWNERS = {}

VEHICLES_PENDING_PROPERTIES = {}

LICENSE_PLATE_DATA = {}

_savedVehiclePropertiesClusterfuck = {}

AddEventHandler('Vehicles:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
  Callbacks = exports['core']:FetchComponent('Callbacks')
  Execute = exports['core']:FetchComponent('Execute')
  Fetch = exports['core']:FetchComponent('Fetch')
  Locations = exports['core']:FetchComponent('Locations')
  Chat = exports['core']:FetchComponent('Chat')
  Wallet = exports['core']:FetchComponent('Wallet')
  Fetch = exports['core']:FetchComponent('Fetch')
  Utils = exports['core']:FetchComponent('Utils')
  Logger = exports['core']:FetchComponent('Logger')
  Middleware = exports['core']:FetchComponent('Middleware')
  DataStore = exports['core']:FetchComponent('DataStore')
  Jobs = exports['core']:FetchComponent('Jobs')
  Inventory = exports['core']:FetchComponent('Inventory')
  Sequence = exports['core']:FetchComponent('Sequence')
  Generator = exports['core']:FetchComponent('Generator')
  Vehicles = exports['core']:FetchComponent('Vehicles')
  Phone = exports['core']:FetchComponent('Phone')
  Tow = exports['core']:FetchComponent('Tow')
  Properties = exports['core']:FetchComponent('Properties')
  Banking = exports['core']:FetchComponent('Banking')
  RegisterChatCommands()
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports['core']:RequestDependencies('Vehicles', {
    'Callbacks',
    'Fetch',
    'Execute',
    'Locations',
    'Chat',
    'Wallet',
    'Fetch',
    'Utils',
    'Logger',
    'Middleware',
    'DataStore',
    'Jobs',
    'Inventory',
    'Sequence',
    'Generator',
    'Vehicles',
    'Phone',
    'Tow',
    'Properties',
    'Banking',
  }, function(error)
    if #error > 0 then
      return
    end -- Do something to handle if not all dependencies loaded
    RetrieveComponents()
    RegisterCallbacks()
    RegisterMiddleware()
    RegisterItemUses()
    RegisterPersonalPlateCallbacks()
    Startup()

    RemoveEventHandler(setupEvent)
  end)
end)

function RegisterMiddleware()
  Middleware:Add('Characters:Spawning', function(source)
    local charId = exports['core']:FetchSource(source):GetData('Character'):GetData('ID')
    if VEHICLE_KEYS[charId] == nil then
      VEHICLE_KEYS[charId] = {}
    end
    TriggerClientEvent('Vehicles:Client:UpdateKeys', source, VEHICLE_KEYS[charId])
  end, 5)

  Middleware:Add('playerDropped', function(source)
    local sourceSpawnVehicles = ACTIVE_OWNED_VEHICLES_SPAWNERS[source]
    if sourceSpawnVehicles and #sourceSpawnVehicles > 0 then
      for k, v in ipairs(sourceSpawnVehicles) do
        Vehicles.Owned:ForceSave(v)
      end

      ACTIVE_OWNED_VEHICLES_SPAWNERS[source] = nil
    end
  end)
end

-- If the vehicle doesn't have it's properties saved, they are sent to the server
RegisterNetEvent('Vehicles:Server:PlayerSetProperties', function(veh, properties)
  if veh and DoesEntityExist(veh) and VEHICLES_PENDING_PROPERTIES[veh] and type(properties) == 'table' then
    local vState = Entity(veh).state
    if vState and vState.VIN then
      local vData = Vehicles.Owned:GetActive(vState.VIN)
      if vData then
        vData:SetData('Properties', properties)
        vData:SetData('FirstSpawn', false)
        VEHICLES_PENDING_PROPERTIES[veh] = nil
        SaveVehicle(vState.VIN)
      elseif vState.PleaseDoNotFuckingDelete then
        _savedVehiclePropertiesClusterfuck[vState.VIN] = properties
        VEHICLES_PENDING_PROPERTIES[veh] = nil
      end
    end
  end
end)

local tempVehicleStoreShit = { '_id', 'VIN', 'EntityId', 'LastSave', 'Flags', 'Strikes' }

function SaveVehicle(VIN)
  local veh = Vehicles.Owned:GetActive(VIN)
  if veh then
    local vehEnt = veh:GetData('EntityId')
    local vehState = Entity(vehEnt).state

    -- Gather vehicle data
    local dirtLevel = GetVehicleDirtLevel(vehEnt)
    local fuel = vehState.Fuel
    local damage = vehState.Damage or {}
    local damagedParts = vehState.DamagedParts or {}
    local properties = vehState.Properties or {}
    local mileage = vehState.Mileage
    local polish = vehState.Polish or {}
    local harness = vehState.Harness
    local nitrous = vehState.Nitrous
    local neonsDisabled = vehState.neonsDisabled
    local lastSave = os.time() * 1000

    local Query = [[
    UPDATE vehicles
    SET DirtLevel = @DirtLevel, Fuel = @Fuel, Damage = @Damage, DamagedParts = @DamagedParts, Properties = @Properties,
        Mileage = @Mileage, Polish = @Polish, Harness = @Harness, Nitrous = @Nitrous,
        NeonsDisabled = @NeonsDisabled, LastSave = @LastSave
    WHERE VIN = @VIN]]

    local Values = {
      ['@DirtLevel'] = dirtLevel,
      ['@Fuel'] = fuel,
      ['@Damage'] = json.encode(damage),
      ['@DamagedParts'] = json.encode(damagedParts),
      ['@Properties'] = json.encode(properties),
      ['@Mileage'] = mileage,
      ['@Polish'] = json.encode(polish),
      ['@Harness'] = harness or 0,
      ['@Nitrous'] = nitrous or 0,
      ['@NeonsDisabled'] = neonsDisabled or false,
      ['@LastSave'] = lastSave,
      ['@VIN'] = VIN
    }

    local affectedRows = MySQL.update.await(Query, Values)

    if affectedRows > 0 then
      return true
    else
      return false
    end
  else
    return false
  end
end

--[[
    ? Owner Types:
    0 = Characters
    1 = Job Fleets


    ? Storage Types:
    0 - Impound
    1 - Garage
    2 - Property

    ? Vehicle Types:
    0 - Regular Car/Truck
    1 - Boat
    2 - Aircraft
]]

VEHICLE = {
  RandomModel = {
    DClass = function()
      return _models.D[math.random(#_models.D)]
    end,
    CCLass = function()
      return _models.C[math.random(#_models.C)]
    end,
    BClass = function()
      return _models.B[math.random(#_models.B)]
    end,
    AClass = function()
      return _models.A[math.random(#_models.A)]
    end,
    SClass = function()
      return `taxi`
    end,
    XClass = function()
      return `taxi`
    end,
  },
  RandomName = function(self)
    return _vehNamesAll[math.random(#_vehNamesAll)]
  end,
  RandomNameByMake = function(self, make)
    local models = _vehNames[make]
    if models then
      return models[math.random(#models)]
    end
  end,
  Garages = {
    GetAll = function(self)
      local garages = {}
      for k, v in pairs(_vehicleStorage) do
        garages[k] = {
          label = v.name,
          location = v.coords,
        }
      end
      garages['impound'] = {
        label = _vehicleImpound.name,
        location = _vehicleImpound.coords,
      }
      return garages
    end,
    Get = function(self, id)
      return _vehicleStorage[id]
    end,
    Impound = function(self)
      return _vehicleImpound
    end,
  },
  Owned = {
    AddToCharacter = function(self, charSID, vehicleHash, vehicleType, infoData, cb, properties, defaultStorage, suppliedVIN)
      print(charSID, vehicleHash, vehicleType, infoData, cb, properties, defaultStorage, suppliedVIN)
      Vehicles.Owned:Add({
        Type = 0,
        Id = charSID
      }, vehicleHash, vehicleType, infoData, cb, properties, defaultStorage, suppliedVIN)
    end,

    AddToFleet = function(self, jobId, jobWorkplace, vehicleLevel, vehicleHash, vehicleType, infoData, cb, properties,
                          qual)
      if not properties then
        properties = {}
      end

      local defaultStorage = false
      if type(vehicleType) ~= 'number' or vehicleType < 0 or vehicleType > 2 then
        vehicleType = 0
      end

      -- Get the fleet HQ to store vehicles in by default
      for storageId, storageData in pairs(_vehicleStorage) do
        if storageData.fleet then
          for k, v in pairs(storageData.fleet) do
            if storageData.vehType == vehicleType and v.JobId == jobId and v.HQ then
              defaultStorage = {
                Type = 1,
                Id = storageId,
              }

              break
            end
          end
        end
      end

      Vehicles.Owned:Add({
        Type = 1,
        Id = jobId,
        Workplace = jobWorkplace and jobWorkplace or false,
        Level = (type(vehicleLevel) == 'number') and vehicleLevel or 0,
        Qualification = qual,
      }, vehicleHash, vehicleType, infoData, cb, properties, defaultStorage)
    end,

    -- !!! Should not be used externally
    Add = function(self, ownerData, vehicleHash, vehicleType, infoData, cb, properties, defaultStorageData, suppliedVIN)
      if type(vehicleType) ~= 'number' or vehicleType < 0 or vehicleType > 2 then
        vehicleType = 0
      end

      if ownerData and ownerData.Type and ownerData.Id and type(vehicleHash) == 'number' and type(infoData) == 'table' then
        -- Determining Default Storage Data
        local storageData = false
        if type(defaultStorageData) == 'table' and defaultStorageData.Type and defaultStorageData.Id then
          storageData = defaultStorageData
        else
          storageData = GetVehicleTypeDefaultStorage(vehicleType)
        end

        local plate = false
        if vehicleType == 0 then
          plate = Vehicles.Identification.Plate:Generate()
        end

        local VIN = suppliedVIN
        if not VIN then
          VIN = Vehicles.Identification.VIN:GenerateOwned()
        end

        local doc = {
          Type = vehicleType,
          Vehicle = vehicleHash,
          VIN = VIN,
          RegisteredPlate = plate,
          FakePlate = false,
          Fuel = math.random(90, 100),
          Owner = ownerData,
          Storage = storageData,
          Make = infoData.make or 'Unknown',
          Model = infoData.model or 'Unknown',
          Class = infoData.class or 'Unknown',
          Value = infoData.value or 0,
          FirstSpawn = true,
          Properties = properties or {},
          RegistrationDate = os.time(),
          Mileage = 0,
          DirtLevel = 0.0,
        }

        local query = [[
              INSERT INTO vehicles (Type, Vehicle, VIN, RegisteredPlate, FakePlate, Fuel, Owner, Storage, Make, Model, Class, Value, FirstSpawn, Properties, RegistrationDate, Mileage, DirtLevel)
              VALUES (@Type, @Vehicle, @VIN, @RegisteredPlate, @FakePlate, @Fuel, @Owner, @Storage, @Make, @Model, @Class, @Value, @FirstSpawn, @Properties, @RegistrationDate, @Mileage, @DirtLevel)
          ]]

        local insertId = MySQL.insert.await(query, {
          ['@Type'] = doc.Type,
          ['@Vehicle'] = doc.Vehicle,
          ['@VIN'] = doc.VIN,
          ['@RegisteredPlate'] = doc.RegisteredPlate,
          ['@FakePlate'] = doc.FakePlate,
          ['@Fuel'] = doc.Fuel,
          ['@Owner'] = json.encode(doc.Owner),
          ['@Storage'] = json.encode(doc.Storage),
          ['@Make'] = doc.Make,
          ['@Model'] = doc.Model,
          ['@Class'] = doc.Class,
          ['@Value'] = doc.Value,
          ['@FirstSpawn'] = doc.FirstSpawn,
          ['@Properties'] = json.encode(doc.Properties),
          ['@RegistrationDate'] = doc.RegistrationDate,
          ['@Mileage'] = doc.Mileage,
          ['@DirtLevel'] = doc.DirtLevel
        })

        if insertId > 0 then
          cb(true, doc)
        else
          cb(false)
        end
      else
        cb(false)
      end
    end,

    GetActive = function(self, VIN)
      if ACTIVE_OWNED_VEHICLES[VIN] then
        return ACTIVE_OWNED_VEHICLES[VIN]
      end
      return false
    end,

    GetVIN = function(self, VIN, cb)
      local query = string.format("SELECT * FROM vehicles WHERE VIN = '%s'", VIN)
      -- local result = MySQL.Sync.fetchAll(query)
      local result = MySQL.single.await(query, {})

      if result then
        result.Owner = json.decode(result.Owner)
        result.Storage = json.decode(result.Storage)
        result.Properties = json.decode(result.Properties)
        result.Damage = json.decode(result.Damage)
        result.DamagedParts = json.decode(result.DamagedParts)
        result.Polish = json.decode(result.Polish)
        result.Flags = json.decode(result.Flags)
        result.Strikes = json.decode(result.Strikes)
        cb(result)
      else
        cb(false)
      end
    end,
    GetAll = function(self, vehType, ownerType, ownerId, cb, storageType, storageId, ignoreSpawned, checkFleetOwner)
      local sqlQuery = "SELECT * FROM vehicles WHERE 1=1"
      local params = {}
      if ownerType and ownerId then
        sqlQuery = sqlQuery .. " AND JSON_EXTRACT(Owner, '$.Type') = ? AND JSON_EXTRACT(Owner, '$.Id') = ?"
        table.insert(params, ownerType)
        table.insert(params, ownerId)
      end


      if checkFleetOwner and checkFleetOwner.Id then
        sqlQuery = sqlQuery ..
            " AND JSON_EXTRACT(Owner, '$.Type') = 1 AND JSON_EXTRACT(Owner, '$.Id') = ? AND (JSON_EXTRACT(Owner, '$.Workplace') IN (?, 'false') OR JSON_EXTRACT(Owner, '$.Workplace') IN (false, 'false')) AND JSON_EXTRACT(Owner, '$.Level') <= ?"
        table.insert(params, checkFleetOwner.Id)
        table.insert(params, checkFleetOwner.Workplace)
        table.insert(params, checkFleetOwner.Level or 0)
      end

      if storageType and storageId then
        sqlQuery = sqlQuery .. " AND JSON_EXTRACT(Storage, '$.Type') = ? AND JSON_EXTRACT(Storage, '$.Id') = ?"
        table.insert(params, storageType)
        table.insert(params, storageId)
      end

      if type(vehType) == 'number' then
        sqlQuery = sqlQuery .. " AND `Type` = ?"
        table.insert(params, vehType)
      end

      local fetchAllVehicles = MySQL.query.await(sqlQuery, params)

      if not fetchAllVehicles or #fetchAllVehicles == 0 then
        return false
      end
      local vehicles = {}
      for _, v in ipairs(fetchAllVehicles) do
        v.Owner = json.decode(v.Owner)
        v.Storage = json.decode(v.Storage)
        if not ignoreSpawned or (ignoreSpawned and not Vehicles.Owned:GetActive(v.VIN)) then
          v.Spawned = Vehicles.Owned:GetActive(v.VIN)
          if v.Storage and v.Storage.Type == 2 then
            local prop = Properties:Get(v.Storage.Id)
            if prop and prop.id and prop.label then
              v.PropertyStorage = prop
            end
          end
          table.insert(vehicles, v)
        end
      end
      cb(vehicles)
    end,
    GetAllActive = function(self)
      return ACTIVE_OWNED_VEHICLES
    end,

    Spawn = function(self, source, VIN, coords, heading, cb)
      Vehicles.Owned:GetVIN(VIN, function(vehicle)
        if vehicle and not Vehicles.Owned:GetActive(VIN) then
          local spawnedVehicle = CreateAutomobile(vehicle.Vehicle, coords, (heading and heading + 0.0 or 0.0))
          if spawnedVehicle then
            -- Set State
            local vehState = Entity(spawnedVehicle).state

            vehState.ServerEntity = spawnedVehicle
            vehState.Owned = true
            vehState.Owner = vehicle.Owner
            vehState.PlayerDriven = true
            vehState.VIN = vehicle.VIN
            vehState.RegisteredPlate = vehicle.RegisteredPlate
            vehState.Fuel = vehicle.Fuel
            vehState.Locked = true
            SetVehicleDoorsLocked(spawnedVehicle, 2)

            vehState.GroupKeys = false
            if vehicle.Owner then
              if vehicle.Owner.Id == 'police' then
                vehState.GroupKeys = 'police'
              elseif vehicle.Owner.Id == 'ems' then
                vehState.GroupKeys = 'ems'
              end
            end

            vehState.Make = vehicle.Make
            vehState.Model = vehicle.Model
            vehState.Class = vehicle.Class
            vehState.Value = vehicle.Value

            vehState.Damage = vehicle.Damage
            vehState.DamagedParts = vehicle.DamagedParts
            vehState.Mileage = vehicle.Mileage

            vehState.WheelFitment = vehicle.WheelFitment

            if vehicle.Polish and vehicle.Polish.Expires and vehicle.Polish.Expires > os.time() then
              vehState.Polish = vehicle.Polish
            end

            if vehicle.Harness and vehicle.Harness > 0 then
              vehState.Harness = vehicle.Harness
            end

            if vehicle.Nitrous ~= nil then
              vehState.Nitrous = vehicle.Nitrous
            end

            if vehicle.RegisteredPlate then
              if vehicle.FakePlate then
                vehState.Plate = vehicle.FakePlate
                vehState.FakePlate = vehicle.FakePlate
                SetVehicleNumberPlateText(spawnedVehicle, vehicle.FakePlate)
              else
                vehState.Plate = vehicle.RegisteredPlate
                SetVehicleNumberPlateText(spawnedVehicle, vehicle.RegisteredPlate)
              end
            else -- Its a heli or boat
              SetVehicleNumberPlateText(spawnedVehicle, '')
            end

            if vehicle.DirtLevel and type(vehicle.DirtLevel) == 'number' then
              SetVehicleDirtLevel(spawnedVehicle, vehicle.DirtLevel + 0.0)
            end

            if vehicle.NeonsDisabled then
              vehState.neonsDisabled = true
            end

            if vehicle.ForcedAudio then
              vehState.ForcedAudio = vehicle.ForcedAudio
            end

            vehState.Trailer = GetVehicleType(spawnedVehicle) == 'trailer'
            if vehicle.FirstSpawn and (not vehicle.Properties or next(vehicle.Properties) == nil) then
              VEHICLES_PENDING_PROPERTIES[spawnedVehicle] = true
              vehState.awaitingProperties = {
                needInit = true,
              }
            elseif vehicle.Properties then
              vehState.awaitingProperties = {
                needInit = false,
                properties = vehicle.Properties,
                damage = vehicle.Damage,
              }
            end

            local vehicleStore = exports['core']:DataStoreCreate('Vehicle', vehicle.VIN, vehicle)
            vehicleStore:SetData('EntityId', spawnedVehicle)
            ACTIVE_OWNED_VEHICLES[vehicle.VIN] = vehicleStore
            cb(true, vehicle, spawnedVehicle)

            if source and source > 0 then
              -- Active Owner Stuff
              if not ACTIVE_OWNED_VEHICLES_SPAWNERS[source] then
                ACTIVE_OWNED_VEHICLES_SPAWNERS[source] = {}
              end
              table.insert(ACTIVE_OWNED_VEHICLES_SPAWNERS[source], vehicle.VIN)
            end

            -- Fix?
            local inVeh = GetPedInVehicleSeat(spawnedVehicle, -1)
            if inVeh and DoesEntityExist(inVeh) then
              DeleteEntity(inVeh)
            end
          else
            cb(false)
          end
        else
          cb(false)
        end
      end)
    end,
    Store = function(self, VIN, storageType, storageId, cb)
      local vehData = Vehicles.Owned:GetActive(VIN)
      if vehData and vehData:GetData('VIN') then
        local isSeized = vehData:GetData('Seized')
        if not isSeized then
          vehData:SetData('Storage', {
            Type = storageType,
            Id = storageId,
          })
        end

        Vehicles.Owned:Delete(vehData:GetData('VIN'), function(success)
          cb(success)
        end)
      else
        cb(false)
      end
    end,

    Delete = function(self, VIN, cb, ignoredExists)
      local vehData = Vehicles.Owned:GetActive(VIN)
      if vehData and vehData:GetData('VIN') then
        local entity = vehData:GetData('EntityId')

        local ent = Entity(entity)
        if ent and ent.state then
          ent.state.Deleted = true
        end

        if entity and DoesEntityExist(entity) then
          local success = SaveVehicle(vehData:GetData('VIN'))
          if success then
            DeleteEntity(entity)
            ACTIVE_OWNED_VEHICLES[VIN] = nil
            DataStore:DeleteStore('Vehicle', VIN)
            cb(true)
          end
          cb(success)
        elseif ignoredExists then
          ACTIVE_OWNED_VEHICLES[VIN] = nil
          DataStore:DeleteStore('Vehicle', VIN)
          cb(true, true)
        end
      else
        cb(false)
      end
    end,
    ForceSave = function(self, VIN)
      local vehicleData = Vehicles.Owned:GetActive(VIN)
      if vehicleData then
        local success = SaveVehicle(VIN)
        if success then
          exports['core']:LoggerInfo('Vehicles', 'Successfully Force Saved Vehicle: ' .. VIN)
        end
      end
    end,

    Properties = {
      -- Character Storing Personal Vehicle in Property
      Store = function(self, source, VIN, propertyId, cb)
        local character = exports['core']:FetchSource(source):GetData('Character')
        local vehData = Vehicles.Owned:GetActive(VIN)
        if propertyId and character and vehData and vehData:GetData('VIN') then
          local vehOwner = vehData:GetData('Owner')
          local stateId = character:GetData('SID')
          if vehOwner.Type == 0 and stateId == vehOwner.Id then
            Vehicles.Owned:Store(VIN, 2, propertyId, cb)
          else
            cb(false)
          end
        else
          cb(false)
        end
      end,
      -- Get Vehicles Stored in Property
      Get = function(self, propertyId, ownerStateId, cb)
        if ownerStateId then
          Vehicles.Owned:GetAll(0, 0, ownerStateId, cb, 2, propertyId, true)
        else
          Vehicles.Owned:GetAll(0, false, false, cb, 2, propertyId, true)
        end
      end,
      GetCount = function(self, propertyId, ignoreVIN)
        -- Fetch all vehicles
        local query = "SELECT Storage, VIN FROM vehicles"
        local result = MySQL.Sync.fetchAll(query)

        if not result or #result == 0 then
          return false
        end

        local count = 0

        for _, row in ipairs(result) do
          local storageData = json.decode(row.Storage)

          if storageData and storageData.Type == 2 and storageData.Id == propertyId then
            if not ignoreVIN or (ignoreVIN and row.VIN ~= ignoreVIN) then
              count = count + 1
            end
          end
        end

        return count
      end,
    },



    Seize = function(self, VIN, seizeState) -- Vehicle Seizure for Loans
      local vehicleData = Vehicles.Owned:GetActive(VIN)
      if vehicleData then                   -- Vehicle is currently out
        vehicleData:SetData('Seized', seizeState)
        vehicleData:SetData('SeizedTime', seizeState and os.time() or false)
        if seizeState then
          vehicleData:SetData('Storage', {
            Type = 0,
            Id = 0,
            Fine = 0,
            TimeHold = false,
          })
        end
        local success = SaveVehicle(VIN)
        return success
      else -- Vehicle is stored, update DB directly
        local vehicle = Vehicles.Owned:GetVIN(VIN, function(vehicle)
          if vehicle and vehicle.VIN then
            local updatingStorage
            if vehicle.Storage.Type > 0 then -- Not Impounded
              updatingStorage = {
                Type = 0,
                Id = 0,
                Fine = 0,
                TimeHold = false,
              }
            end

            local query = string.format(
              "UPDATE vehicles SET Seized = %s, SeizedTime = %d, Storage = '%s' WHERE VIN = '%s'",
              seizeState and 1 or 0,
              seizeState and os.time() or 'NULL',
              json.encode(updatingStorage),
              VIN
            )

            local result = MySQL.Sync.execute(query)

            return result > 0
          else
            return false
          end
        end)

        return vehicle
      end
    end,

    Track = function(self, VIN)
      local p = promise.new()

      local active = Vehicles.Owned:GetActive(VIN)
      if active then
        local wasTracked = active:GetData("TrackedLast")
        local vehLocation = GetEntityCoords(active:GetData("EntityId"))
        if wasTracked and wasTracked.time > os.time() then
          p:resolve(wasTracked.coords)
        else
          active:SetData("TrackedLast", {
            time = os.time() + 120,
            coords = vehLocation
          })
          p:resolve(vehLocation)
        end
      else
        Vehicles.Owned:GetVIN(VIN, function(c)
          if c.Storage.Type == 0 then
            p:resolve(Vehicles.Garages:Impound().coords)
          elseif c.Storage.Type == 1 then
            p:resolve(Vehicles.Garages:Get(c.Storage.Id).coords)
          elseif c.Storage.Type == 2 then
            local prop = Properties:Get(c.Storage.Id)
            if prop?.location?.garage then
              p:resolve(vector3(prop?.location?.garage?.x, prop?.location?.garage?.y, prop?.location?.garage?.z))
            else
              p:resolve(false)
            end
          end
        end)
      end

      return Citizen.Await(p)
    end,
  },


  SpawnTemp = function(self, source, model, coords, heading, cb, vehicleInfoData, properties, preDamage, suppliedPlate,
                       suppliedVIN)
    local spawnedVehicle = CreateAutomobile(model, coords, heading)
    local vehState = Entity(spawnedVehicle).state
    local plate = suppliedPlate or Vehicles.Identification.Plate:Generate(true)
    vehState.VIN = suppliedVIN or Vehicles.Identification.VIN:GenerateLocal()
    vehState.Owned = false
    vehState.Locked = false
    vehState.PlayerDriven = true
    vehState.Fuel = math.random(50, 100)
    vehState.Plate = plate


    if vehicleInfoData then
      vehState.Make = vehicleInfoData.Make
      vehState.Model = vehicleInfoData.Model
      vehState.Class = vehicleInfoData.Class
      vehState.Value = vehicleInfoData.Value
    end

    vehState.Trailer = GetVehicleType(spawnedVehicle) == 'trailer'

    vehState.VEH_IGNITION = false

    if properties or preDamage then
      vehState.awaitingProperties = {
        needInit = false,
        properties = properties,
        damage = preDamage,
      }

      if preDamage then
        vehState.Damage = preDamage
      end
    end

    SetVehicleNumberPlateText(spawnedVehicle, plate)

    local inVeh = GetPedInVehicleSeat(spawnedVehicle, -1)
    if inVeh and DoesEntityExist(inVeh) then
      DeleteEntity(inVeh)
    end
    cb(spawnedVehicle, vehState.VIN, plate)
  end,
  Delete = function(self, vehicleId, cb)
    if DoesEntityExist(vehicleId) and GetEntityType(vehicleId) == 2 then
      local vehState = Entity(vehicleId).state
      if vehState and vehState.VIN and vehState.Owned then
        -- Its an owned vehicle, need to save
        Vehicles.Owned:Delete(vehState.VIN, function(success)
          cb(success)
        end)
      else
        vehState.Deleted = true
        DeleteEntity(vehicleId)
        cb(true)
        if _savedVehiclePropertiesClusterfuck[vehState.VIN] then
          _savedVehiclePropertiesClusterfuck[vehState.VIN] = nil
        end
      end
    else
      cb(false)
    end
  end,
  StopDespawn = function(self, vehicle)
    if DoesEntityExist(vehicle) then
      local ent = Entity(vehicle)

      if ent?.state?.VIN and not ent.state.Owned then
        VEHICLES_PENDING_PROPERTIES[vehicle] = true

        ent.state.ServerEntity = vehicle
        ent.state.PleaseDoNotFuckingDelete = true
        ent.state.awaitingProperties = {
          needInit = true,
        }
      end
    end
  end,
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
  exports['core']:RegisterComponent('Vehicles', VEHICLE)
end)

--[[
POPTYPE_UNKNOWN = 0,
POPTYPE_RANDOM_PERMANENT 1
POPTYPE_RANDOM_PARKED 2
POPTYPE_RANDOM_PATROL 3
POPTYPE_RANDOM_SCENARIO 4
POPTYPE_RANDOM_AMBIENT 5
POPTYPE_PERMANENT 6
POPTYPE_MISSION 7
POPTYPE_REPLAY 8
POPTYPE_CACHE 9
POPTYPE_TOOL 10
]]

function GenerateLocalVehicleInfo(entity)
  if not DoesEntityExist(entity) or Vehicles == nil then
    return
  end

  local entityType = GetEntityType(entity)
  local populationType = GetEntityPopulationType(entity)

  if entityType == 2 and (populationType == 2 or populationType == 3 or populationType == 5) then
    local veh = Entity(entity)
    if not veh.state.VIN then -- Has Not Yet Been Detected/Initialised
      veh.state.VIN = Vehicles.Identification.VIN:GenerateLocal()
      veh.state.Owned = false
      veh.state.Hotwired = false
      veh.state.HotwiredSuccess = false
      veh.state.PlayerDriven = false
      veh.state.Fuel = math.random(30, 100)
      veh.state.Mileage = math.random(1, 100) * 100
    end
  end
end

AddEventHandler("Vehicles:Server:GenerateVehicleInfo", GenerateLocalVehicleInfo)

-- Generate Vehicle Info on Client Request
RegisterNetEvent("Vehicles:Server:RequestGenerateVehicleInfo", function(vNet)
  local src = source
  local veh = NetworkGetEntityFromNetworkId(vNet)
  GenerateLocalVehicleInfo(veh)
end)

function ApplyOldVehicleState(veh, fuel, damage, damagedParts, mileage, engineHealth, bodyHealth, isBlownUp,
                              localProperties)
  local ent = Entity(veh)
  if ent?.state?.VIN then
    ent.state.Fuel = fuel
    ent.state.Damage = damage
    ent.state.DamagedParts = damagedParts
    ent.state.Mileage = mileage
    ent.state.BlownUp = isBlownUp
    ent.state.awaitingEngineHealth = engineHealth

    ent.state.awaitingBlownUp = isBlownUp

    if localProperties then
      ent.state.PleaseDoNotFuckingDelete = true
      ent.state.awaitingProperties = {
        needInit = false,
        properties = localProperties,
        damage = {
          Engine = engineHealth,
          Body = bodyHealth
        }
      }
    end
  end
end

RegisterNetEvent('Vehicles:Server:StopDespawn', function(vNet)
  local veh = NetworkGetEntityFromNetworkId(vNet)
  Vehicles:StopDespawn(veh)
end)

AddEventHandler('entityRemoved', function(entity)
  if GetEntityType(entity) == 2 then
    local ent = Entity(entity)
    if ent?.state?.VIN and (ent.state.Owned or ent.state.PleaseDoNotFuckingDelete) and not ent.state.Deleted then
      local isLocal = ent.state.PleaseDoNotFuckingDelete

      local vehModel = GetEntityModel(entity)
      local vehPlate = GetVehicleNumberPlateText(entity)

      local coords = GetEntityCoords(entity)
      local heading = GetEntityHeading(entity)
      local VIN = ent.state.VIN

      local fuel = ent.state.Fuel
      local damage = ent.state.Damage
      local damagedParts = ent.state.DamagedParts
      local mileage = ent.state.Mileage
      local isBlownUp = ent.state.BlownUp

      local engineHealth = GetVehicleEngineHealth(entity)
      local bodyHealth = GetVehicleBodyHealth(entity)

      exports['core']:LoggerWarn("Vehicles",
        string.format("Vehicle %s Deleted Unexpectedly - Local: %s, %s %s Engine: %s, Body: %s, Blown Up: %s",
          ent.state.VIN, isLocal, coords, heading, engineHealth, bodyHealth, isBlownUp))

      if not isLocal then
        ACTIVE_OWNED_VEHICLES[ent.state.VIN] = nil
        DataStore:DeleteStore('Vehicle', ent.state.VIN)
      end

      Citizen.Wait(1000)

      if isLocal then
        Vehicles:SpawnTemp(-1, vehModel, coords, heading, function(vehicleId)
          SetVehicleBodyHealth(vehicleId, bodyHealth + 0.0)

          ApplyOldVehicleState(vehicleId, fuel, damage, damagedParts, mileage, engineHealth, bodyHealth, isBlownUp,
            _savedVehiclePropertiesClusterfuck[VIN])
        end, false, false, false, vehPlate, VIN)
      else
        Vehicles.Owned:Spawn(-1, VIN, coords, heading, function(success, vehicleData, vehicleId)
          if success then
            SetVehicleBodyHealth(vehicleId, bodyHealth + 0.0)

            ApplyOldVehicleState(vehicleId, fuel, damage, damagedParts, mileage, engineHealth, bodyHealth, isBlownUp)
          end
        end)
      end
    end
  end
end)

AddEventHandler('explosionEvent', function(sender, ev)
  if ev and ev.f210 ~= 0 then
    local veh = NetworkGetEntityFromNetworkId(ev.f210)
    if veh and DoesEntityExist(veh) and GetEntityType(veh) == 2 then
      local vehEnt = Entity(veh)

      if vehEnt.state.VIN then
        print(sender, "Blew up Vehicle:", vehEnt.state.VIN)
        vehEnt.state.BlownUp = true
      end
    end
  end
end)

RegisterServerEvent('Vehicle:Server:InspectVIN', function(vNet)
  local src = source
  local veh = NetworkGetEntityFromNetworkId(vNet)
  if DoesEntityExist(veh) then
    local vState = Entity(veh).state
    if vState and vState.VIN then
      Chat.Send.Server:Single(src, 'Vehicle VIN: ' .. vState.VIN)
      TriggerClientEvent('Vehicles:Client:ViewVIN', src, vState.VIN)
    end
  end
end)

RegisterServerEvent('Vehicles:Server:FlipVehicle', function(netVeh, correctPitch)
  local vehicle = NetworkGetEntityFromNetworkId(netVeh)
  if vehicle and DoesEntityExist(vehicle) then
    local netOwner = NetworkGetEntityOwner(vehicle)
    if netOwner > 0 then
      TriggerClientEvent('Vehicles:Client:FlipVehicleRequest', netOwner, netVeh, correctPitch)
    end
  end
end)
