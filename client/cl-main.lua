ESX = exports["es_extended"]:getSharedObject()

PlayerData = {}
local peds, combatPeds = {}, {}

Dominac = {
    JobStarted = false,
    JobLocation = Config.JobLocation,
    JobDeliver = Config.JobDeliver,
    HasTasks = false,
    NPCSpawned = false,
    VehicleSpawned = false,
    JobDelivered = false,
    
    -- Cooldown:
    Cooldown = 0,
    Cooldowndown = false
}

Citizen.CreateThread(function()
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(100)
    end
    
    PlayerData = ESX.GetPlayerData()
end)

SpawnPed = function(model, coords, heading, cb)
    local hash = GetHashKey(model)

    local start = GetGameTimer()
    RequestModel(hash)
    while not HasModelLoaded(hash) and GetGameTimer() - start < 30000 do 
        Wait(0); 
    end

    if not HasModelLoaded(hash) then
        print('No Model ' .. model)
        return
    end

    local ped = CreatePed(5, hash, coords.x, coords.y, coords.z, heading, true, true)

    start = GetGameTimer()
    while not DoesEntityExist(ped) and GetGameTimer() - start < 30000 do 
        Wait(0); 
    end

    if not DoesEntityExist(ped) then
        print('No Entity ' .. ped)
        return
    end

    SetEntityAsMissionEntity(ped, true, true)
    SetModelAsNoLongerNeeded(hash)

    if cb then
        cb(ped)
    end
end

exports.ox_target:addModel(Config.PedModel, {
    {
        label = 'Start job',
        icon = 'fa-solid fa-flask',
        onSelect = function()
            if Dominac.Cooldown > 0 then
                if Dominac.JobStarted then
                    lib.notify({
                        title = 'Dominic',
                        description = 'Du har allerede et job aktivt!',
                        type = 'inform'
                    })
                else
                    lib.notify({
                        title = 'Dominic',
                        description = 'Jeg har ingen jobs til dig lige nu!',
                        type = 'inform'
                    })
                end
            else
                ESX.TriggerServerCallback('fisk_dominic:startjob', function(data)
                    if data == 'kontant' then
                        lib.notify({
                            title = 'Dominic',
                            description = 'Du mangler kontanter, du skal bruge 175.000!',
                            type = 'error'
                        })
                    elseif data == 'needmoney' then
                        lib.notify({
                            title = 'Dominic',
                            description = 'Du mangler flere kontanter, du skal bruge 175.000!',
                            type = 'error'
                        })
                    elseif data == 'startjob' then
                        lib.notify({
                            title = 'Dominic',
                            description = 'Du har startet jobbet, tag hen til GPS\'en!',
                            type = 'success'
                        })
                        Dominac.Cooldown = Config.Cooldown * 1000
                        Dominac.JobStarted = true
                        Dominac.Cooldowndown = true
                        Dominac.HasTasks = true
                        TriggerEvent('fisk_dominac:cooldown')
                        TriggerEvent('fisk_dominic:startjob')
                    else
                        lib.notify({
                            title = 'Dominic',
                            description = 'Der skete en fejl!',
                            type = 'error'
                        })
                    end
                end)
            end
        end,
        distance = 1.4
    }
})

SpawnVehicle = function(model, coords, heading, cb)
    RequestModel(model)
    while not HasModelLoaded(model) do 
        Wait(0); 
    end
  
    local veh = CreateVehicle(model, coords.x, coords.y, coords.z, true, true)
    while not DoesEntityExist(veh) do 
        Wait(0); 
    end
  
    SetEntityAsMissionEntity(veh, true, true)
    SetEntityHeading(veh, heading)
    SetVehicleOnGroundProperly(veh)
      
    while not NetworkHasControlOfEntity(veh) do 
        NetworkRequestControlOfEntity(veh); 
        Wait(0); 
    end

    while not NetworkGetEntityIsNetworked(veh) do 
        NetworkRegisterEntityAsNetworked(veh); 
        Wait(0); 
    end

    Wait(500)
    SetModelAsNoLongerNeeded(model)

    if cb then
        cb(veh)
    end
end

AgroNPCs = function()
    local playerPed = PlayerPedId()

    for i=1, #peds, 1 do
        local ped = peds[i]

        if not IsEntityDead(ped) and not combatPeds[ped] == true then
            if HasEntityClearLosToEntityInFront(ped, playerPed) or HasEntityClearLosToEntity(ped, playerPed, 17) or hasPedsAgro then
                TaskCombatPed(ped, playerPed, 0, 16)
                combatPeds[ped] = true
            end
        end
    end
end


RegisterNetEvent('fisk_dominic:startjob', function()
    local blip = AddBlipForCoord(Dominac.JobLocation.x, Dominac.JobLocation.y, Dominac.JobLocation.z)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 67)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName("Vogn Lokation")
    EndTextCommandSetBlipName(blip)
    SetBlipRoute(blip, true)

    while Dominac.HasTasks do
        Citizen.Wait(0)

        local player = GetPlayerPed(-1)
        local playerCoords = GetEntityCoords(player)

        local distance = GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, Dominac.JobLocation.x, Dominac.JobLocation.y, Dominac.JobLocation.z, false)
        local DominacSpawnLoc = { x = Dominac.JobLocation.x, y = Dominac.JobLocation.y, z = Dominac.JobLocation.z}
        if distance <= 100 then
            local vehiclespawnedbur
            while not Dominac.VehicleSpawned do
                SpawnVehicle('burrito', DominacSpawnLoc, Dominac.JobLocation.h, function(spawnVehicle)
                    vehiclespawnedbur = spawnVehicle
                
                    local netID = NetworkGetNetworkIdFromEntity(vehiclespawnedbur)
                    exports['t1ger_keys']:SetVehicleLocked(vehiclespawnedbur, 0)
                    Dominac.VehicleSpawned = true
                end)
            end

            while not Dominac.NPCSpawned do
                for i = 1, #Config.Peds, 1 do
                    local pedSpawn = Config.Peds[i]
                    local pedSpawnLocation = vector3(pedSpawn.location.x, pedSpawn.location.y, pedSpawn.location.z - 0.50)
            
                    SpawnPed(pedSpawn.type, pedSpawnLocation, pedSpawn.heading, function(ped)
                        SetPedRelationshipGroupHash(ped, GetHashKey("KOS"))
                        SetPedFleeAttributes(ped, 0, 0)
                        SetPedCombatAttributes(ped, 46, 1)
                        SetPedCombatMovement(ped, 3)
                        SetPedCombatRange(ped, 2)
                        GiveWeaponToPed(ped, GetHashKey(pedSpawn.weapon), 1, false, true)
            
                        table.insert(peds, ped)
                    end)
                end
                Dominac.NPCSpawned = true
            end
            if Dominac.VehicleSpawned then
                AgroNPCs()
            end
            if distance <= 1 then
                RemoveBlip(blip)
                TriggerEvent('fisk_dominic:jobdeliver', vehiclespawnedbur)
                Dominac.HasTasks = false
            end
        end
    end
end)

RegisterNetEvent('fisk_dominic:jobdeliver', function(vehicle)
    local blip = AddBlipForCoord(Dominac.JobDeliver.x, Dominac.JobDeliver.y, Dominac.JobDeliver.z)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 67)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName("Leverings Lokation")
    EndTextCommandSetBlipName(blip)
    SetBlipRoute(blip, true)
    lib.notify({
        title = 'Dominic',
        description = 'Tag hen til drop-off lokationen!',
        type = 'inform'
    })
    local targetadded
    
    while not Dominac.JobDelivered do
        Citizen.Wait(0)

        local player = GetPlayerPed(-1)
        local playerCoords = GetEntityCoords(player)

        local distance = GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, Dominac.JobDeliver.x, Dominac.JobDeliver.y, Dominac.JobDeliver.z, true)

        if distance <= 2 then
            RemoveBlip(blip)
            Dominac.JobDelivered = true
            local entitytodelete = GetVehiclePedIsIn(
                player, 
                false
            )        
            DeleteEntity(entitytodelete)
            lib.notify({
                title = 'Dominic',
                description = 'Du har aflevered køretøjet!',
                type = 'inform'
            })
            TriggerServerEvent('fisk_dominic:rewardjob')
        end
    end
end)

RegisterNetEvent('fisk_dominac:cooldown')
AddEventHandler('fisk_dominac:cooldown', function()
    while Dominac.Cooldowndown do
        Citizen.Wait(1000)
        if Dominac.Cooldown == 0 then
            Dominac.Cooldowndown = false
            return
        else
            Dominac.Cooldown = Dominac.Cooldown - 1000
        end
    end
end)