local RSGCore = exports['rsg-core']:GetCoreObject()
local HeadbagList = {}

RegisterNetEvent("headbag1:addHeadbagS", function(cPlayer)
    HeadbagList[cPlayer] = true
    TriggerClientEvent("headbag1:addHeadbag", cPlayer)
end)

RegisterNetEvent("headbag1:removeHeadbagS", function(cPlayer)
    HeadbagList[cPlayer] = false
    TriggerClientEvent("headbag1:removeHeadBag", cPlayer)
end)

RegisterNetEvent('headbag1:damageHeadbag', function(item)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local uses = Player.PlayerData.items[item.slot].info.uses
    if (uses-1) <= 0 then
        TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[item.name], "remove", 1)
        Player.Functions.RemoveItem(item.name, 1, item.slot)
    else
        Player.PlayerData.items[item.slot].info.uses = Player.PlayerData.items[item.slot].info.uses - 1
        Player.Functions.SetInventory(Player.PlayerData.items)
    end
end)

RSGCore.Functions.CreateCallback("headbag1:isHeadbagOn", function(source, cb, pid)
    local isOn = false
    if HeadbagList[pid] then
        isOn = HeadbagList[pid]
    end
    cb(isOn)
end)

RSGCore.Functions.CreateUseableItem("baghead", function(source, item)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if Player.Functions.GetItemByName("baghead") ~= nil then
        TriggerClientEvent("headbag1:enableHeadbag", src, item)
    end
end)

RegisterCommand("removebag", function(source, _)
    TriggerClientEvent("headbag1:removeHeadbagCmd", source)
end, false)