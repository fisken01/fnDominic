ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterServerCallback('fisk_dominic:startjob', function(source, cb, cooldown)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        if xPlayer.getInventoryItem('money') ~= nil then
            if xPlayer.getInventoryItem('money').count >= Config.Price then
                xPlayer.removeInventoryItem('money', Config.Price)
                cb("startjob")
            else
                cb("needmoney")
            end
        else
            cb("kontant")
         end
    end
end)

RegisterServerEvent('fisk_dominic:rewardjob', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local itemtoget = math.random(1, 4)
    local item = 'water'
    if itemtoget == 1 then
        item = Config.Rewards[1]
    elseif itemtoget == 2 then
        item = Config.Rewards[2]
    elseif itemtoget == 3 then
        item = Config.Rewards[3]
    elseif itemtoget == 4 then
        item = Config.Rewards[4]
    end
    xPlayer.addInventoryItem(item, math.random(400, 700))
end)