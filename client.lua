playersLoaded = false

Citizen.CreateThread(function()
    for key,value in pairs(CAS.PedCoords) do
        if value.ped == nil then
            local pedHash = GetHashKey(value.pedHash) 
            RequestModel(pedHash)
            while not HasModelLoaded(pedHash) do
                Wait(100)
            end
            value.ped = CreatePed(pedHash, value.coords.x, value.coords.y, value.coords.z-1, value.coords.w, false, false)
            SetPedOutfitPreset(value.ped, true, false)
			Citizen.InvokeNative(0x283978A15512B2FE, value.ped, true)
            SetEntityCoords(PlayerPedId(), value.coords.x, value.coords.y, value.coords.z)
            FreezeEntityPosition(value.ped, true)
            SetEntityInvincible(value.ped, true)
            SetBlockingOfNonTemporaryEvents(value.ped, true)
        end
    end
    while true do
        local sleep = 750
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        for key,value in pairs(CAS.PedCoords) do
            local distance = #(coords - vector3(value.coords.x, value.coords.y, value.coords.z+0.90))
            if distance < 3 then
                sleep = 0
                if IsControlJustReleased(0, "INPUT_MELEE_GRAPPLE_CHOKE") then
                    print("okey ya")
                    DisplayUI()
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

AddEventHandler('onResourceStop', function (resourceName)
    print('The resource ' .. resourceName .. ' has been stopped on the client.')
    for key,value in pairs(CAS.PedCoords) do
        if DoesEntityExist(value.ped) then
            DeleteEntity(value.ped)
        end
    end
  end)
  


RegisterNUICallback("nuiFetch",function(data,cb)
    if not data then return end
    print(data.key)
    SendNUIMessage({
        action = "force",
    })
    SetNuiFocus(false,false)
    DoScreenFadeOut(500)
    Wait(600)
    SetEntityCoords(PlayerPedId(), CAS.Cards[data.key].targetCoords.x,CAS.Cards[data.key].targetCoords.y,CAS.Cards[data.key].targetCoords.z)
    Wait(1000)
    DoScreenFadeIn(1000)
end)


RegisterNetEvent("updatePlayersCount",function(array)
    CAS.Cards = array
    playersLoaded = true
end)
DisplayUI = function()
    TriggerServerEvent("getPlayersInCoords")
    while playersLoaded == false do
        Wait(100)
    end
    print("working")
    SendNUIMessage({
        action = "show",
        config = CAS.Cards
    })
    playersLoaded = false
    SetNuiFocus(true,true)
end

