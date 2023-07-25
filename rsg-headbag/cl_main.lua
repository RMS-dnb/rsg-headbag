local RSGCore = exports['rsg-core']:GetCoreObject()
local object = nil

local function GetClosestPlayer()
    local players = GetActivePlayers()
    local closestPlayer = -1
    local closestDistance = -1
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    for _, player in ipairs(players) do
        if player ~= PlayerId() then
            local targetPed = GetPlayerPed(player)
            local targetCoords = GetEntityCoords(targetPed)
            local distance = GetDistanceBetweenCoords(playerCoords, targetCoords, true)

            if closestDistance == -1 or distance < closestDistance then
                closestPlayer = player
                closestDistance = distance
            end
        end
    end

    return closestPlayer, closestDistance
end

RegisterNetEvent("headbag1:addHeadbag", function()
    local closestPlayer, closestDistance = GetClosestPlayer()

    if closestPlayer ~= -1 and closestDistance <= 2.0 then
        local playerPed = GetPlayerPed(closestPlayer)
        object = CreateObject(GetHashKey("p_cs_seanmask01x"), 0, 0, 0, true, true, true)
        local closestPlayerPed = GetPlayerPed(closestPlayer)
        local boneIndex = GetPedBoneIndex(closestPlayerPed, 0x796e)
        ped = PlayerPedId()

        -- Adjust the X, Y, and Z offsets below to move the bag backward and to the left
        local offsetX, offsetY, offsetZ = -0.0, -0.02, -0.0

        AttachEntityToEntity(object, ped, GetPedBoneIndex(ped, 21030), offsetX, offsetY, offsetZ, 0.0, -270.0, 0.6, true, true, false, true, 1, true)
        SetEntityCompletelyDisableCollision(object, false, true)

        SendNUIMessage({
            action = "open"
        })
    else
        RSGCore.Functions.Notify("No player nearby", "error")
    end
end)



RegisterNetEvent("headbag1:removeHeadBag", function()
    local closestPlayer, closestDistance = GetClosestPlayer()

    if closestPlayer ~= -1 and closestDistance <= 2.0 then
        local playerPed = GetPlayerPed(closestPlayer)

        -- Check if the 'object' variable is valid and remove the prop
        if object and DoesEntityExist(object) then
            DeleteEntity(object)
            object = nil -- Reset the 'object' variable
        end

        SendNUIMessage({
            action = "remove"
        })
    else
        RSGCore.Functions.Notify("No player nearby", "error")
    end
end)

local isUsingHeadbag = false
RegisterNetEvent("headbag1:enableHeadbag", function(item)
    local closestPlayer, closestDistance = GetClosestPlayer()

    if closestPlayer ~= -1 and closestDistance <= 2.0 then
        if not isUsingHeadbag then
            isUsingHeadbag = true
            local playerId = GetPlayerServerId(closestPlayer)
            RSGCore.Functions.TriggerCallback("headbag1:isHeadbagOn", function(isOn)
                if isOn then
                    TriggerServerEvent("headbag1:removeHeadbagS", playerId)
                    SetTimeout(3000, function()
                        isUsingHeadbag = false
                    end)
                else
                    TriggerServerEvent("headbag1:damageHeadbag", item)
                    TriggerServerEvent("headbag1:addHeadbagS", playerId)
                    SetTimeout(3000, function()
                        isUsingHeadbag = false
                    end)
                end
            end, playerId)
        else
            RSGCore.Functions.Notify("Please wait before you try again", "error")
        end
    else
        RSGCore.Functions.Notify("No player nearby", "error")
    end
end)

RegisterNetEvent("headbag1:removeHeadbagCmd", function()
    local closestPlayer, closestDistance = GetClosestPlayer()

    if closestPlayer ~= -1 and closestDistance <= 2.0 then
        local playerId = GetPlayerServerId(closestPlayer)
        RSGCore.Functions.TriggerCallback("headbag1:isHeadbagOn", function(isOn)
            if isOn then
                TriggerServerEvent("headbag1:removeHeadbagS", playerId)
            else
                RSGCore.Functions.Notify("Person doesn't have a headbag on their head", "error")
            end
        end, playerId)
    else
        RSGCore.Functions.Notify("No player nearby", "error")
    end
end)



-- Rest of the script...

