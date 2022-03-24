print("^1[AUTHEUR]^7 Tigeurs#5614")

ESX = nil
local StartJob = false

Citizen.CreateThread(function()

    TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)

    while ESX == nil do
        Citizen.Wait(10)
    end

    while ESX.GetPlayerData().job2 == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()

    InitMarkerJob()
    InitBlips()
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
    ESX.PlayerData.job2 = job2
    InitMarkerJob()
end)

function InitMarkerJob()
    StartJob = true
    Citizen.CreateThread(function()
        while StartJob do
            local InZone = false
            local playerPos = GetEntityCoords(PlayerPedId())
            for i = 1, #Gang do
                local v = Gang[i]
                if ESX.PlayerData.job2.name == v.JobGangName then
                    for _,gradeGarage in pairs(v.Garage.GradeJobAcces) do
                        if ESX.PlayerData.job2.grade_name == gradeGarage then
                            local dst1 = GetDistanceBetweenCoords(playerPos, v.Garage.PosSpawner, true)
                            if dst1 < 20.0 then
                                InZone = true
                                DrawMarker(6, v.Garage.PosSpawner.x, v.Garage.PosSpawner.y, v.Garage.PosSpawner.z, 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 1.0, 1.0, 1.0, v.Couleurs.R, v.Couleurs.G, v.Couleurs.B, 200)
                                if dst1 < 2.0 then
                                    Visual.Subtitle(("Appuyez sur [~r~E~s~] pour ouvrir le garage : %s"):format(v.GangName))
                                    if IsControlJustReleased(1, 38) then
                                        FreezeEntityPosition(PlayerPedId(), true)
                                        openGarageMenu(v)
                                    end
                                end
                            end
                        end
                        if ESX.PlayerData.job2.grade_name == gradeGarage then
                            local dst2 = GetDistanceBetweenCoords(playerPos, v.Garage.PosDeleter, true)
                            if dst2 < 20.0 then
                                InZone = true
                                DrawMarker(6, v.Garage.PosDeleter.x, v.Garage.PosDeleter.y, v.Garage.PosDeleter.z, 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 1.0, 1.0, 1.0, v.Couleurs.R, v.Couleurs.G, v.Couleurs.B, 200)
                                if dst2 < 2.0 then
                                    Visual.Subtitle(("Appuyez sur [~r~E~s~] pour ranger le véhicule : %s"):format(v.GangName))
                                    if IsControlJustReleased(1, 38) then
                                        for _,v in pairs(v.Garage.Vehicule) do
                                            local Vehicule = ESX.Game.GetClosestVehicle({x = playerPos.x, y = playerPos.y, z = playerPos.z})
                                            local HashVehicule = GetEntityModel(Vehicule)
                                            if HashVehicule == v.hash then
                                                DeleteEntity(Vehicule)
                                                v.stock = v.stock + 1
                                                ESX.ShowNotification(("Vous venez de ranger une : %s ~s~, il y en n'a ~r~%s ~s~ maintenant !"):format(v.name, v.stock))
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    for _,gradeBoss in pairs(v.BossAction.GradeJobAcces) do
                        if ESX.PlayerData.job2.grade_name == gradeBoss then
                            local dst3 = GetDistanceBetweenCoords(playerPos, v.BossAction.PosBoss, true)
                            if dst3 < 20.0 then
                                InZone = true
                                DrawMarker(6, v.BossAction.PosBoss.x, v.BossAction.PosBoss.y, v.BossAction.PosBoss.z, 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 1.0, 1.0, 1.0, v.Couleurs.R, v.Couleurs.G, v.Couleurs.B, 200)
                                if dst3 < 2.0 then
                                    Visual.Subtitle(("Appuyez sur [~r~E~s~] pour gérer : %s"):format(v.GangName))
                                    if IsControlJustReleased(1, 38) then
                                        FreezeEntityPosition(PlayerPedId(), true)
                                        menuGangBoss(v)
                                    end
                                end
                            end
                        end
                    end
                    for _,gradeCoffre in pairs(v.Coffre.GradeJobAcces) do
                        if ESX.PlayerData.job2.grade_name == gradeCoffre then
                            local dst4 = GetDistanceBetweenCoords(playerPos, v.Coffre.PosCoffre, true)
                            if dst4 < 20.0 then
                                InZone = true
                                DrawMarker(6, v.Coffre.PosCoffre.x, v.Coffre.PosCoffre.y, v.Coffre.PosCoffre.z, 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 1.0, 1.0, 1.0, v.Couleurs.R, v.Couleurs.G, v.Couleurs.B, 200)
                                if dst4 < 2.0 then
                                    Visual.Subtitle(("Appuyez sur [~r~E~s~] pour ouvrir le coffre : %s"):format(v.GangName))
                                    if IsControlJustReleased(1, 38) then
                                        FreezeEntityPosition(PlayerPedId(), true)
                                        openCoffreMenu(v)
                                    end
                                end
                            end
                        end
                    end
                    for _,gradeVestiaire in pairs(v.Vestiaire.GradeJobAcces) do
                        if ESX.PlayerData.job2.grade_name == gradeVestiaire then
                            local dst5 = GetDistanceBetweenCoords(playerPos, v.Vestiaire.PosVestiaire, true)
                            if dst5 < 20.0 then
                                InZone = true
                                DrawMarker(6, v.Vestiaire.PosVestiaire.x, v.Vestiaire.PosVestiaire.y, v.Vestiaire.PosVestiaire.z, 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 1.0, 1.0, 1.0, v.Couleurs.R, v.Couleurs.G, v.Couleurs.B, 200)
                                if dst5 < 2.0 then
                                    Visual.Subtitle(("Appuyez sur [~r~E~s~] pour ouvrir le vestiaire : %s"):format(v.GangName))
                                    if IsControlJustReleased(1, 38) then
                                        FreezeEntityPosition(PlayerPedId(), true)
                                        openVestiaireMenu(v)
                                    end
                                end
                            end
                        end
                    end
                end
            end
            if not InZone then
                Wait(500)
            else
                Wait(1)
            end
        end
    end)
    for _,v in pairs(Gang) do
        print("^1[ESX GANG]^7 "..v.JobGangName.." Chargé avec succès !")
    end
end

-- function InitBlips()
--     for i = 1, #Gang do
--     if ESX.PlayerData.job2 == Gang[i].JobGangName then
--     for i = 1, #BlipsGang.Blip, 1 do
--         local CreateBlip = AddBlipForCoord(BlipsGang.Blip[i].pos)

--         SetBlipSprite(CreateBlip, BlipsGang.Blip[i].id)
--         SetBlipScale(CreateBlip, BlipsGang.Blip[i].scale)
--         SetBlipDisplay(CreateBlip, BlipsGang.Blip[i].display)
--         SetBlipColour (CreateBlip, BlipsGang.Blip[i].color)
--         SetBlipAsShortRange(CreateBlip, true)

--         BeginTextCommandSetBlipName("STRING")
--         AddTextComponentString(BlipsGang.Blip[i].name)
--         EndTextCommandSetBlipName(CreateBlip)
--     end
-- end
-- end
-- end

function InitBlips()
    for i = 1, #Gang do
        local v = Gang[i]
        if ESX.PlayerData.job2.name == Gang[i].JobGangName then
        
            local CreateBlipvestiaire = AddBlipForCoord(v.Vestiaire.PosVestiaire.x, v.Vestiaire.PosVestiaire.y, v.Vestiaire.PosVestiaire.z)

            SetBlipSprite(CreateBlipvestiaire, 366)
            SetBlipScale(CreateBlipvestiaire, 0.8)
            SetBlipDisplay(CreateBlipvestiaire, 4)
            SetBlipColour (CreateBlipvestiaire, v.CouleursBlips)
            SetBlipAsShortRange(CreateBlipvestiaire, true)

            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("[".. v.JobGangName .. "]  Vestiaire")
            EndTextCommandSetBlipName(CreateBlipvestiaire)


           local CreateBlipCoffre = AddBlipForCoord(v.Coffre.PosCoffre.x, v.Coffre.PosCoffre.y, v.Coffre.PosCoffre.z)

            SetBlipSprite(CreateBlipCoffre, 408)
            SetBlipScale(CreateBlipCoffre, 0.8)
            SetBlipDisplay(CreateBlipCoffre, 4)
            SetBlipColour (CreateBlipCoffre, v.CouleursBlips)
            SetBlipAsShortRange(CreateBlipCoffre, true)

            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("[".. v.JobGangName .. "] Coffre")
            EndTextCommandSetBlipName(CreateBlipCoffre)


           local CreateBlipGarage = AddBlipForCoord(v.Garage.PosSpawner.x, v.Garage.PosSpawner.y, v.Garage.PosSpawner.z)

            SetBlipSprite(CreateBlipGarage, 326)
            SetBlipScale(CreateBlipGarage, 0.8)
            SetBlipDisplay(CreateBlipGarage, 4)
            SetBlipColour (CreateBlipGarage, v.CouleursBlips)
            SetBlipAsShortRange(CreateBlipGarage, true)

            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("[".. v.JobGangName .. "] Garage (Sortie)")
            EndTextCommandSetBlipName(CreateBlipGarage)


           local CreateBlipGarageRanger = AddBlipForCoord(v.Garage.PosDeleter.x, v.Garage.PosDeleter.y, v.Garage.PosDeleter.z)

            SetBlipSprite(CreateBlipGarageRanger, 290)
            SetBlipScale(CreateBlipGarageRanger, 0.8)
            SetBlipDisplay(CreateBlipGarageRanger, 4)
            SetBlipColour (CreateBlipGarageRanger, v.CouleursBlips)
            SetBlipAsShortRange(CreateBlipGarageRanger, true)

            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("[".. v.JobGangName .. "] Garage (Ranger)")
            EndTextCommandSetBlipName(CreateBlipGarageRanger)

            local CreateBlipBoss = AddBlipForCoord(v.BossAction.PosBoss.x, v.BossAction.PosBoss.y, v.BossAction.PosBoss.z)

            SetBlipSprite(CreateBlipBoss, 439)
            SetBlipScale(CreateBlipBoss, 0.8)
            SetBlipDisplay(CreateBlipBoss, 4)
            SetBlipColour (CreateBlipBoss, v.CouleursBlips)
            SetBlipAsShortRange(CreateBlipBoss, true)

            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("[".. v.JobGangName .. "] Action Boos")
            EndTextCommandSetBlipName(CreateBlipBoss)
            
        end
    end
end

function TextInfo(TextEntry, ExampleText, MaxStringLenght, isValueInt)

    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        blockinput = false
        if isValueInt then
            local isNumber = tonumber(result)
            if isNumber then return result else return nil end
        end

        return result
    else
        Citizen.Wait(500)
        blockinput = false
        return nil
    end
end


RegisterCommand("pos", function(source, args, raw)
    local ped = GetPlayerPed(PlayerId())
    local coords = GetEntityCoords(ped, false)
    local heading = GetEntityHeading(ped)
    Citizen.Trace(tostring("X: " .. coords.x .. " Y: " .. coords.y .. " Z: " .. coords.z .. " HEADING: " .. heading))
end, false)