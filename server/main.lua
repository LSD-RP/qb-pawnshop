local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent("qb-pawnshop:server:sellPawnItems", function(itemName, itemAmount, itemPrice)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local totalPrice = (tonumber(itemAmount) * itemPrice)

    if Player.Functions.RemoveItem(itemName, tonumber(itemAmount)) then
        if Config.BankMoney then
            Player.Functions.AddMoney("bank", totalPrice)
        else
            Player.Functions.AddMoney("cash", totalPrice)
        end

        TriggerClientEvent("QBCore:Notify", src, Lang:t('success.sold', {value = tonumber(itemAmount), value2 = QBCore.Shared.Items[itemName].label, value3 = totalPrice}), 'success')
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[itemName], 'remove')
    else
        TriggerClientEvent("QBCore:Notify", src, Lang:t('error.no_items'), "error")
    end
end)

RegisterNetEvent("qb-pawnshop:server:meltItemRemove", function(itemName, itemAmount,item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local meltTime = 0

    if Player.Functions.RemoveItem(itemName, itemAmount) then
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[itemName], 'remove')
        
        meltTime = (tonumber(itemAmount) * item.time)
        TriggerClientEvent('qb-pawnshop:client:startMelting', src,item, tonumber(itemAmount), (meltTime* 60000/1000))
        TriggerEvent("qb-log:server:CreateLog", "moneysafes", "Pawn Melting", "red", "**"..GetPlayerName(src) .. "** began melting "..itemAmount.. " " .. itemName)
        local itemReward = nil
        local rewardAmount = 0
        for k,v in pairs(Config.MeltingItems) do
            if v.item == itemName then
                itemReward = v.rewards
                break
            end
        end
        exports.oxmysql:execute('INSERT INTO smelting (citizenid, items, amount, reward, time) VALUES (?, ?, ?, ?, ?)', {
            Player.PlayerData.citizenid,
            itemName,
            tonumber(itemAmount),
            json.encode(itemReward),
            os.time()
        })

        TriggerClientEvent("QBCore:Notify", src, Lang:t('info.melt_wait', {value = meltTime}), "primary")
    else
        TriggerClientEvent("QBCore:Notify", src, Lang:t('error.no_items'), "error")
    end
end)


RegisterNetEvent("qb-pawnshop:server:pickupMelted", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local meltedAmount = 0
    local items = exports.oxmysql:executeSync('SELECT * FROM smelting WHERE citizenid LIKE @citizenid', {['@citizenid'] = Player.PlayerData.citizenid})
    if items[1] ~= nil then
        local i = 1
        while items[i] ~= nil do
            local meltitem = items[i].items
            local meltAmount = items[i].amount
            local reward = json.decode(items[i].reward)
            local time = items[i].time
            local timeNeeded = 0
            for k,v in pairs(Config.MeltingItems) do
                if v.item == meltitem then
                    timeNeeded = tonumber(os.date(v.meltTime * meltAmount))
                    reward = v.rewards
                    break
                end
            end
            local timeElapsed = os.time() - time
            print(timeElapsed)
            if timeElapsed > timeNeeded * 60 then
                for k,v in pairs(reward) do
                    Player.Functions.AddItem(v.item, v.amount * meltAmount)
                    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[v.item], 'add')
                    TriggerClientEvent('QBCore:Notify', src, 'You received '..(v.amount * meltAmount).. ' x '..QBCore.Shared.Items[v.item].label, 'success')
                    TriggerEvent("qb-log:server:CreateLog", "moneysafes", "Pawn Melting", "green", "**"..GetPlayerName(src) .. "** claimed "..(v.amount * meltAmount).." " .. v.item)
                end
                exports.oxmysql:execute('DELETE FROM smelting WHERE time LIKE @time', {['@time'] = time})
            else
                -- need more time to melt
                TriggerClientEvent('QBCore:Notify', src, 'We need more time to finish melting your ' .. QBCore.Shared.Items[meltitem].label)
            end

            i = i + 1
        end
    else
        -- no items melting
        TriggerClientEvent('QBCore:Notify', src, 'You do not have any items being melted')
    end
    -- for k,v in pairs(item.items) do
    --     meltedAmount = v.amount
    --     for l,m in pairs(v.item.reward) do
    --         Player.Functions.AddItem(m.item, (meltedAmount * m.amount))
    --         TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[m.item], 'add')
    --         TriggerClientEvent('QBCore:Notify', src, 'You received '..(meltedAmount * m.amount).. ' x '..QBCore.Shared.Items[m.item].label, 'success')
    --         TriggerEvent("qb-log:server:CreateLog", "moneysafes", "Pawn Melting", "green", "**"..GetPlayerName(src) .. "** claimed "..(m.amount * meltedAmount).." " .. m.item)

    --     end
    -- end
    TriggerClientEvent('qb-pawnshop:client:resetPickup', src)
end)

QBCore.Functions.CreateCallback('qb-pawnshop:server:getInv', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local inventory = Player.PlayerData.items

    return cb(inventory)
end)