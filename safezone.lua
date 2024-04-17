-- Define your safezones here
local safezones = {
    {x = 415.4278, y = -992.2303, z =  33.0282, radius = 70.0}, --415.4278, -992.2303, 33.0282, 120.3079
	{x = 263.1906, y = -587.1795, z = 43.2929, radius = 100.0}, -- 263.1906, -587.1795, 43.2929, 158.9196
	{x = 139.7671, y = -1098.10, z = 29.39, radius = 50.0}, --139.7671, -1098.1038, 29.3996, 203.7626
}

-- List of jobs that are allowed to use weapons in the safezone
local allowedJobs = {
    'police',
}

-- QBCore Player data
local PlayerJob = {}
local InSafeZone = false

-- Function to check if a player's job is in the allowed list
local function isJobAllowed()
    for _, allowedJob in ipairs(allowedJobs) do
        if PlayerJob.name == allowedJob then
            return true
        end
    end
    return false
end


local function isInAnySafezone(coords)
    for _, safezone in ipairs(safezones) do
        local dx = coords.x - safezone.x
        local dy = coords.y - safezone.y
        local dz = coords.z - safezone.z
        local distance = math.sqrt(dx*dx + dy*dy + dz*dz)

        if distance < safezone.radius then
            return true
        end
    end
    return false
end



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local inSafezone = isInAnySafezone(coords)

        if inSafezone and not InSafeZone then
            InSafeZone = true
            exports['okokNotify']:Alert("Terrific", "You Entered A Safezone.", 5000, 'success')
        elseif not inSafezone and InSafeZone then
            InSafeZone = false
            exports['okokNotify']:Alert("Terrific", "You Leaved A Safezone", 5000, 'error')
        end

        if InSafeZone and not isJobAllowed() then
            DisableControlAction(0, 24, true) -- disable attack
            DisableControlAction(0, 25, true) -- disable aim
            DisableControlAction(0, 47, true) -- disable weapon
            DisableControlAction(0, 58, true) -- disable weapon
            DisableControlAction(0, 263, true) -- disable melee
            DisableControlAction(0, 140, true) -- disable melee
            DisableControlAction(0, 141, true) -- disable melee
            DisableControlAction(0, 142, true) -- disable melee
            DisableControlAction(0, 143, true) -- disable melee
            DisablePlayerFiring(playerPed, true) -- disable firing
        else
            Citizen.Wait(1000) 
        end
    end
end)


RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)





