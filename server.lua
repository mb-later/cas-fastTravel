RegisterServerEvent("getPlayersInCoords",function()
    GetPlayersInCoords(source)
end)

GetPlayersInCoords = function(src)
    ClearAllCount()
    local players = {}
    for _, player in ipairs(GetPlayers()) do
        for key,value in pairs(CAS.Cards) do
            if #(GetEntityCoords(GetPlayerPed(player)) - value.targetCoords) < 200 then
                value.playerCountInArea = value.playerCountInArea + 1
                print("added some ")
            end
        end
    end
    TriggerClientEvent("updatePlayersCount",src, CAS.Cards)
end




ClearAllCount = function() 
    for i,j in pairs(CAS.Cards) do
        j.playerCountInArea = 0
    end
end