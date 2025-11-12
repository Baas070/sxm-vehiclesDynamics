local vehicleProfiles = Config.VehicleProfiles or {}
local features = Config.Features or {}
local defaults = Config.Defaults or {}
local classLimits = Config.VehicleClassSpeedLimitsOffroad or {}
local lastTurboPressure = 0.0


local function featureEnabled(key)
    if features[key] == nil then return true end
    return features[key]
end

local function convertSpeed(speed)
    if Config.UseMph then
        return speed / 2.237
    else
        return speed / 3.6
    end
end

local function clamp(value, minValue, maxValue)
    if minValue and value < minValue then value = minValue end
    if maxValue and value > maxValue then value = maxValue end
    return value
end

local function getVehicleProfile(vehicle)
    local model = GetEntityModel(vehicle)
    local hashKey = tostring(model)
    local vehicleName = GetDisplayNameFromVehicleModel(model):lower()

    return vehicleProfiles[hashKey]
        or vehicleProfiles[vehicleName]
        or vehicleProfiles[model],
        vehicleName,
        hashKey,
        model
end

local function computeTurboPressure(profile, engineModLevel, hasTurbo)
    local base = profile.turboPressureBase or defaults.turboPressureBase or 0.9
    local perLevel = profile.turboPressurePerLevel or defaults.turboPressurePerLevel or 0.05
    local turboBonus = profile.turboPressureBonus or defaults.turboPressureTurboBonus or 0.25
    local target = base

    if engineModLevel and engineModLevel > -1 then
        target = target + perLevel * (engineModLevel + 1)
    end

    if hasTurbo then
        target = target + (profile.turboPressureAdd or turboBonus)
    end

    return clamp(target, defaults.turboPressureMin or 0.0, defaults.turboPressureMax or 2.0)
end

local function computeVehicleTargets(vehicle, profile)
    local engineModLevel = GetVehicleMod(vehicle, 11)
    local idx = engineModLevel + 1

    local speedLimit = profile.stockSpeedLimit or defaults.stockSpeedLimit or 200.0
    if engineModLevel and engineModLevel > -1 then
        if profile.speedLimits and #profile.speedLimits > 0 then
            speedLimit = profile.speedLimits[idx] or profile.speedLimits[#profile.speedLimits] or speedLimit
        end
    end

    local horsepower = profile.stockHorsepower or defaults.stockHorsepower or 150.0
    if engineModLevel and engineModLevel > -1 then
        if profile.horsepower and #profile.horsepower > 0 then
            horsepower = profile.horsepower[idx] or profile.horsepower[#profile.horsepower] or horsepower
        end
    end

    local hasTurbo = IsToggleModOn(vehicle, 18)
    if hasTurbo then
        speedLimit = speedLimit + (profile.turboBoost or 0.0)
        horsepower = horsepower + (profile.turboHorsepower or 0.0)
    end

    horsepower = math.min(horsepower, (defaults.stockHorsepower or 150.0) * (defaults.horsepowerCap or 3.0))

    local turboPressure = computeTurboPressure(profile, engineModLevel, hasTurbo)

    return {
        speedLimit = speedLimit,
        horsepower = horsepower,
        turboPressure = turboPressure,
        engineModLevel = engineModLevel,
        hasTurbo = hasTurbo,
        profile = profile
    }
end

local function setVehicleEngineOutput(vehicle, horsepower, spoolMultiplier)
    if not horsepower then return end
    spoolMultiplier = spoolMultiplier or 1.0

    local baseHorsepower = defaults.stockHorsepower or 150.0
    local capMultiplier = defaults.horsepowerCap or 3.0
    local adjustedHorsepower = horsepower * spoolMultiplier
    local maxHorsepower = baseHorsepower * capMultiplier
    adjustedHorsepower = math.min(adjustedHorsepower, maxHorsepower)

    local powerMultiplier = adjustedHorsepower / baseHorsepower
    powerMultiplier = math.min(powerMultiplier, capMultiplier)

    SetVehicleEnginePowerMultiplier(vehicle, (powerMultiplier - 1.0) * 100.0)
    SetVehicleEngineTorqueMultiplier(vehicle, powerMultiplier)
end

local function applyTurboPressure(vehicle, targetPressure)
    if not targetPressure then return end
    local currentPressure = GetVehicleTurboPressure(vehicle)
    local step = 0.05

    if currentPressure then
        local delta = targetPressure - currentPressure
        if math.abs(delta) <= step then
            currentPressure = targetPressure
        else
            currentPressure = currentPressure + (delta > 0 and step or -step)
        end
    else
        currentPressure = targetPressure
    end

    SetVehicleTurboPressure(vehicle, clamp(currentPressure, defaults.turboPressureMin or 0.0, defaults.turboPressureMax or 2.0))
end

local function computeTurboSpoolMultiplier(targets, currentPressure)
    if not targets or not targets.hasTurbo then
        return 1.0
    end

    local baseMultiplier = clamp(defaults.turboSpoolBaseMultiplier or 0.6, 0.0, 1.0)
    local pressure = currentPressure or lastTurboPressure or 0.0

    local minPressure = defaults.turboSpoolMinPressure or 0.05
    local maxPressure = defaults.turboSpoolMaxPressure or targets.turboPressure or (defaults.turboPressureMax or 2.0)

    if maxPressure <= minPressure then
        lastTurboPressure = pressure
        return 1.0
    end

    local normalized = clamp((pressure - minPressure) / (maxPressure - minPressure), 0.0, 1.0)
    local curve = defaults.turboSpoolCurve or 1.0
    if curve > 0.0 and curve ~= 1.0 then
        normalized = normalized ^ curve
    end

    local multiplier = baseMultiplier + (1.0 - baseMultiplier) * normalized
    lastTurboPressure = pressure
    return clamp(multiplier, baseMultiplier, 1.0)
end

local function GetGroundHash(entity)
    local coords = GetEntityCoords(entity)
    local handle = StartShapeTestCapsule(coords.x, coords.y, coords.z + 4.0, coords.x, coords.y, coords.z - 2.0, 1.0, 1, entity, 7)
    local _, _, _, _, groundHash = GetShapeTestResultEx(handle)
    return groundHash
end

local function TranslateGroundHash(hash)
    local data = Config.GroundHashes and Config.GroundHashes[hash]
    if data then
        return data.name, data.isOffroad
    else
        return 'Unknown Surface', nil
    end
end

local function applySpeedLimit(vehicle, speedLimit, ped)
    if not speedLimit then return end
    local finalLimit = speedLimit
    local surfaceName = 'Unknown Surface'
    local isOffroad = false

    if featureEnabled('offroadLimiter') then
        local groundHash = GetGroundHash(ped)
        surfaceName, isOffroad = TranslateGroundHash(groundHash)
        if isOffroad then
            local classId = GetVehicleClass(vehicle)
            local classLimit = classLimits[classId]
            if classLimit then
                finalLimit = math.min(finalLimit, classLimit)
            end
        end
    end

    local maxSpeedMs = convertSpeed(finalLimit)
    if featureEnabled('offroadLimiter') and isOffroad then
        local currentSpeed = GetEntitySpeed(vehicle)
        if currentSpeed > maxSpeedMs then
            local decel = Config.OffroadDeceleration or 0.05
            local newSpeed = math.max(currentSpeed - decel, maxSpeedMs)
            local vx, vy, vz = table.unpack(GetEntityVelocity(vehicle))
            local factor = currentSpeed > 0.0 and (newSpeed / currentSpeed) or 0.0
            SetEntityVelocity(vehicle, vx * factor, vy * factor, vz * factor)
        else
            SetEntityMaxSpeed(vehicle, maxSpeedMs)
        end
    else
        SetEntityMaxSpeed(vehicle, maxSpeedMs)
    end

    return finalLimit, surfaceName, isOffroad
end

local function processVehicle()
    local playerPed = PlayerPedId()
    if not IsPedInAnyVehicle(playerPed, false) then return end

    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if vehicle == 0 then return end

    local profile, vehicleName, vehicleHashStr = getVehicleProfile(vehicle)
    if not profile then return end

    local targets = computeVehicleTargets(vehicle, profile)

    if featureEnabled('speedLimiter') then
        applySpeedLimit(vehicle, targets.speedLimit, playerPed)
    else
        SetEntityMaxSpeed(vehicle, convertSpeed(9999.0))
    end

    local turboPressureActive = featureEnabled('turboPressure') and targets.hasTurbo
    local currentTurboPressure = nil

    if turboPressureActive then
        applyTurboPressure(vehicle, targets.turboPressure)
        currentTurboPressure = GetVehicleTurboPressure(vehicle) or targets.turboPressure
    end

    local horsepowerEnabled = featureEnabled('horsepower')
    local spoolMultiplier = 1.0

    if horsepowerEnabled and turboPressureActive and featureEnabled('turboSpool') then
        spoolMultiplier = computeTurboSpoolMultiplier(targets, currentTurboPressure)
    end

    if horsepowerEnabled then
        setVehicleEngineOutput(vehicle, targets.horsepower, spoolMultiplier)
    end

end

Citizen.CreateThread(function()
    while true do
        processVehicle()
        Citizen.Wait(Config.UpdateIntervalMs or 0)
    end
end)

local function CheckPlayerVehicleMods()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if vehicle == 0 then
        print('Player is not in a vehicle.')
        return
    end

    local profile, vehicleName, vehicleHashStr = getVehicleProfile(vehicle)
    if not profile then
        print(string.format("Vehicle '%s' (Hash: %s) is not configured.", vehicleName, vehicleHashStr))
        return
    end

    local targets = computeVehicleTargets(vehicle, profile)
    print('---- Vehicle Model Debug ----')
    print(string.format('Vehicle Name: %s', vehicleName))
    print(string.format('Vehicle Hash: %s', vehicleHashStr))
    print(string.format('Engine Level: %d', (targets.engineModLevel or -1) + 1))
    print(string.format('Target Speed Limit: %.2f', targets.speedLimit))
    print(string.format('Target Horsepower: %.2f', targets.horsepower))
    print(string.format('Turbo Pressure: %.2f', targets.turboPressure))
    print('---- End of Vehicle Model Debug ----')
end

RegisterCommand('debugvehicles', function()
    if Config.AllowDebugVehicleNames then
        CheckPlayerVehicleMods()
    else
        print('Debugging vehicle names is disabled.')
    end
end, false)

local debugRoadEnabled = false

RegisterCommand('debugroad', function()
    debugRoadEnabled = not debugRoadEnabled
    print('Ground Debug: ' .. (debugRoadEnabled and 'Enabled' or 'Disabled'))
end, false)

Citizen.CreateThread(function()
    while true do
        if debugRoadEnabled then
            local playerPed = PlayerPedId()
            local groundHash = GetGroundHash(playerPed)
            local surfaceName, isOffroad = TranslateGroundHash(groundHash)
            if surfaceName == 'Unknown Surface' then
                print('GROUND DEBUG: Unknown Surface (Hash: ' .. groundHash .. ')')
            else
                local message = isOffroad and 'Offroad' or 'Onroad'
                print('GROUND DEBUG: ' .. message .. ' (' .. surfaceName .. ')')
            end
        end
        Citizen.Wait(1000)
    end
end)
