local zonedLocations = {}
local keyedLocations = {}
local hasEntered = nil
local triggerRange = 1.0
local fadeTime = 150
local CAM
local waitTime = 2500
local waitedSince = 0
local multicamIndex = 0
local multicamTime = 10000
local multicamLastSwitch = 0

local function halp(textEntry, label)
    label = label or "this location"
    BeginTextCommandDisplayHelp(textEntry)
    AddTextComponentSubstringPlayerName(label)
    EndTextCommandDisplayHelp(0, false, false, 0)
end

local function getCam()
    if not CAM or not DoesCamExist(CAM) then
        CAM = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    end
    return CAM
end

local function faded(funcref, ...)
    DoScreenFadeOut(fadeTime)
    while IsScreenFadingOut() do
        SetUseHiDof()
        HideHudAndRadarThisFrame()
        Citizen.Wait(0)
    end
    if funcref then
        pcall(funcref, ...)
    end
    DoScreenFadeIn(fadeTime)
    while IsScreenFadingIn() do
        SetUseHiDof()
        HideHudAndRadarThisFrame()
        Citizen.Wait(0)
    end
    HideHudAndRadarThisFrame()
end

local function setCamProperties(cam, camProps, pointCoords)
    if type(camProps) == "table" then
        SetFocusPosAndVel(camProps.coords.x, camProps.coords.y, camProps.coords.z, 0.0, 0.0, 0.0)
        SetCamCoord(cam, camProps.coords.x, camProps.coords.y, camProps.coords.z)
        SetCamRot(cam, camProps.rot.x, camProps.rot.y, camProps.rot.z, 2)
    else
        SetFocusPosAndVel(camProps.x, camProps.y, camProps.z, 0.0, 0.0, 0.0)
        SetCamCoord(cam, camProps.x, camProps.y, camProps.z)
        PointCamAtCoord(cam, pointCoords.x, pointCoords.y, pointCoords.z)
    end
end

local function startCam(location)
    local cam = getCam()
    setCamProperties(cam, location.cam, location.inside)
    RenderScriptCams(true, false, 0, true, false)
    return cam
end

local function endCam()
    RenderScriptCams(false, false, 0, false, false)
    if DoesCamExist(CAM) then
        DestroyCam(CAM, true)
    end
end

local function maybeTrigger(event)
    if not event then return end
    if type(event) == "table" then
        TriggerEvent(table.unpack(event))
        TriggerServerEvent(table.unpack(event))
    else
        TriggerEvent(event)
        TriggerServerEvent(event)
    end
end

local function enterLocation(location)
    hasEntered = location
    multicamIndex = 0
    multicamLastSwitch = GetGameTimer()
    local cam = startCam(location)
    maybeTrigger(location.enterEvent)
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, true)
    SetEntityCoordsNoOffset(ped, location.inside.x, location.inside.y, location.inside.z, false, false, true)
    if location.dof then
        SetCamUseShallowDofMode(cam, true)
        SetCamNearDof(cam, location.dof[1] or 0.5)
        SetCamFarDof(cam, location.dof[2] or 1.3)
        SetCamDofStrength(cam, 1.0)
        SetUseHiDof()
    end
    if location.blur then
        TriggerScreenblurFadeIn(0)
    end
end

local function exitLocation(where, funcref)
    if not hasEntered then return end
    ClearFocus()
    maybeTrigger(hasEntered.exitEvent)
    endCam()
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, false)
    where = where or hasEntered.door
    SetEntityCoordsNoOffset(ped, where.x, where.y, where.z, false, false, true)
    SetEntityHeading(ped, where.w)
    if hasEntered.nightvision and GetUsingnightvision() then
        SetNightvision(false)
    end
    if hasEntered.blur then
        TriggerScreenblurFadeOut(0)
    end
    waitedSince = GetGameTimer() + 1000
    if funcref then
        local ok, err = pcall(funcref)
        if not ok then
            print("ERROR running post-exit function: " .. err)
        end
    end
    hasEntered = nil
end

local function disableConflictingControls()
    for i=0, 31 do
        DisableAllControlActions(i)
    end
    for _, control in ipairs({51, 245, 249}) do
        EnableControlAction(0, control, true)
    end
end

local function debugMarker(location, range, full, current)
    if LocalPlayer.state.devmode then
        local r, g, b, a = 255, 255, 255, 100
        if full and current then
            r = math.floor(255 - ((255*current)/full))
            g = math.floor( (255*current) / full)
            b = 0
        end
        ---@diagnostic disable-next-line:param-type-mismatch Passing 0 as the texture disables the texturing.
        DrawMarker(28, location.x, location.y, location.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, range, range, range, r or 0, g or 255, b or 255, a or 111, false, false, 0, false, 0, 0, false)
    end
end

local function stateCheck(location)
    if not location.state then return true end
    if LocalPlayer.state.devmode then return true end

    for key, value in pairs(location.state) do
        if type(value) == "table" then
            local any = false
            for _, subvalue in ipairs(value) do
                if LocalPlayer.state[key] == subvalue then
                    any = true
                end
            end
            if not any then
                return false
            end
        elseif LocalPlayer.state[key] ~= value then
            return false
        end
    end

    return true
end

local function outside()
    local playerPed = PlayerPedId()

    if IsPedInAnyVehicle(playerPed, true) then return end
    if IsEntityDead(playerPed) then return end

    local coords = GetEntityCoords(playerPed)
    local zone = GetNameOfZone(coords.x, coords.y, coords.z)
    if zonedLocations[zone] then
        local inRange = false
        for _, location in ipairs(zonedLocations[zone]) do
            if stateCheck(location) then
                local range = location.range or triggerRange
                local distance = #( coords - location.door.xyz)
                if distance <= range then
                    inRange = true
                    local now = GetGameTimer()
                    debugMarker(location.door, range, (location.wait or waitTime), now - waitedSince)
                    if waitedSince ~= 0 and waitedSince <= now - (location.wait or waitTime) then
                        halp('ENTERENTERHELP', location.label)
                        if IsControlJustReleased(0, 51) then
                            waitedSince = GetGameTimer() + 1000
                            faded(enterLocation, location)
                        end
                    end
                    break
                else
                    debugMarker(location.door, range)
                end
            end
        end
        if inRange then
            if waitedSince == 0 then
                waitedSince = GetGameTimer()
            end
        else
            waitedSince = 0
        end
    elseif waitedSince ~= 0 then
        waitedSince = 0
    end
end

local function switchMulticam()
    if not hasEntered then return end
    local cam = getCam()
    local idx = multicamIndex + 1
    if hasEntered.multicam and idx <= #hasEntered.multicam then
        multicamIndex = idx
        setCamProperties(cam, hasEntered.multicam[multicamIndex], hasEntered.inside)
    else
        multicamIndex = 0
        setCamProperties(cam, hasEntered.cam, hasEntered.inside)
    end

end

local function inside()
    if not hasEntered then return end

    disableConflictingControls()
    HideHudAndRadarThisFrame()
    if hasEntered.dof then
        SetUseHiDof()
    end
    if hasEntered.nightvision then
        local hour = GetClockHours()
        if hour > 22 or hour < 6 then
            if not GetUsingnightvision() then
                SetNightvision(true)
            end
        elseif GetUsingnightvision() then
            SetNightvision(false)
        end
    end
    if hasEntered.multicam then
        local now = GetGameTimer()
        if now >= multicamLastSwitch + multicamTime then
            faded(switchMulticam)
            multicamLastSwitch = now
        end
    end
    if not hasEntered?.suppressExit then
        ---@diagnostic disable-next-line:need-check-nil,undefined-field Trust me, bro, I have it all mapped out.
        if waitedSince <= GetGameTimer() - (hasEntered?.wait or waitTime) then
            halp('ENTEREXITHELP', hasEntered.label)
            if IsControlJustReleased(0, 51) then
                faded(exitLocation)
            end
        end
    end
end

local function getRelativeLocation(location, heading, distance)
    location = location or vector3(0,0,0)
    local rotation = vector3(0,0,heading or 0)
    distance = distance or 10.0

    local tZ = math.rad(rotation.z)
    local tX = math.rad(rotation.x)

    local absX = math.abs(math.cos(tX))

    local rx = location.x + (-math.sin(tZ) * absX) * distance
    local ry = location.y + (math.cos(tZ) * absX) * distance
    local rz = location.z + (math.sin(tX)) * distance

    return vector3(rx,ry,rz)
end

local function validCamLocation(cam)
    if not cam then return false end
    if type(cam) == "vector3" then return true end
    if type(cam) == "table" then
        return type(cam.coords) == "vector3" and type(cam.rot) == "vector3"
    end
    return false
end

local function processLocations(locations, resource)
    for idx, location in ipairs(locations) do
        location.origin = resource or GetCurrentResourceName()
        if type(location.door) == "vector4" then
            if type(location.inside) ~= "vector3" then
                location.inside = getRelativeLocation(location.door.xyz, location.door.w, -3.0) + vector3(0,0,-2.5)
            end
            if not validCamLocation(location.cam) then
                location.cam = getRelativeLocation(location.door.xyz, location.door.w, 10.0) + vector3(0, 0, 10)
            end
            local zone = GetNameOfZone(location.door.x, location.door.y, location.door.z)
            if not zonedLocations[zone] then
                zonedLocations[zone] = {}
            end
            location.zone = zone
            table.insert(zonedLocations[zone], location)

            if location.key then
                if not keyedLocations[resource] then
                    keyedLocations[resource] = {}
                end
                keyedLocations[resource][location.key] = location
                print( ("Added keyed location %s %s"):format(resource, location.key))
            end

        else
            print( ("Discarded a malformed location %i from %s"):format(idx, resource) )
        end
    end
end

Citizen.CreateThread(function()
    AddTextEntry('ENTERENTERHELP', "Press ~INPUT_CONTEXT~ to enter ~a~")
    AddTextEntry('ENTEREXITHELP', "Press ~INPUT_CONTEXT~ to exit ~a~")
    processLocations(LOCATIONS, GetCurrentResourceName())
    while true do
        if hasEntered then
            inside()
        else
            outside()
        end
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('enter:exit')
AddEventHandler('enter:exit', function(where, funcref)
    faded(exitLocation, where, funcref)
end)

RegisterNetEvent('enter:add-locations')
AddEventHandler('enter:add-locations', function(locations)
    processLocations(locations, GetInvokingResource())
end)

RegisterNetEvent('enter:command', function(args)
    if #args ~= 2 then
        print('You need exactly two arguments:  The resource the location is from, and the key it is registered with, in that order.')
        return
    end
    if keyedLocations and keyedLocations[args[1]] and keyedLocations[args[1]][args[2]] then
        faded(enterLocation,keyedLocations[args[1]][args[2]])
    else
        print(("%q %q is an invalid resource/key combination"):format(args[1], args[2]))
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        exitLocation()
    end
    if hasEntered and hasEntered.origin == resourceName then
        exitLocation()
    end
    keyedLocations[resourceName] = nil
    for _, locations in pairs(zonedLocations) do
        for idx, location in ipairs(locations) do
            if location.origin == resourceName then
                table.remove(locations, idx)
            end
        end
    end
end)
