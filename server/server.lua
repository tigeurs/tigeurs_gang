ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Citizen.CreateThread(function()
    for _,v in pairs(Gang) do
        print("^1[ESX GANG]^7 "..v.GangName.." Chargé avec succès !")
    end
end)

ESX.RegisterServerCallback("esx_gang:argent", function(source, cb, Society)
    TriggerEvent('esx_addonaccount:getSharedAccount', Society, function(account)
        cb(account.money)
    end)
end)

ESX.RegisterServerCallback("esx_gang:PlayerInventaire", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	cb(xPlayer.inventory)
end)

ESX.RegisterServerCallback("esx_gang:PlayerWeapon", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    cb(xPlayer.loadout)
end)

ESX.RegisterServerCallback("esx_gang:GangStockItem", function(source, cb, Society)
	TriggerEvent("esx_addoninventory:getSharedInventory", Society, function(inventory)
		cb(inventory.items)
	end)
end)

ESX.RegisterServerCallback("esx_gang:GangStockWeapon", function(source, cb, Society)
    TriggerEvent("esx_datastore:getSharedDataStore", Society, function(weapons)
        cb(weapons.get("weapons"))
    end)
end)

ESX.RegisterServerCallback("esx_gang:PlayerFouilleInventaire", function(source, cb, target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)

    TriggerClientEvent("esx:showNotification", xTarget.source, "On n'est entrain de te fouiller !")

    if xTarget then
        local data = {
            inventory = xTarget.getInventory(),
            accounts = xTarget.getAccounts(),
            weapon = xTarget.getLoadout(),
        }

        cb(data)
    end
end)

RegisterNetEvent("esx_gang:deposerargent")
AddEventHandler("esx_gang:deposerargent", function(gangSelected, value)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local playerPos = GetEntityCoords(GetPlayerPed(src))
    local coffreBoss = gangSelected.BossAction.PosBoss
    local distancePlayerBoss = #(playerPos-coffreBoss)

    if distancePlayerBoss <= 10 then
        if gangSelected.JobGangName == xPlayer.getJob2().name then
            if xPlayer.getAccount(gangSelected.BossAction.ArgentType).money >= value then
                TriggerEvent('esx_addonaccount:getSharedAccount', gangSelected.BossAction.SocietyAction, function(account)
                    xPlayer.removeAccountMoney(gangSelected.BossAction.ArgentType, value)
                    account.addMoney(value)
                    TriggerClientEvent('esx:showAdvancedNotification', src, ("GANG : %s"):format(gangSelected.GangName:upper()), "Information", ("Tu viens de déposer ~r~%s ~s~$ dans le coffre : ~b~%s ~s~!"):format(value, gangSelected.GangName), "CHAR_LESTER", 3)
                    sendToDiscord(GetPlayerName(source).. ' ['..src..']  vient de retirer de l\'argent d\'un coffre de crew\n\nCrew : '.. gangSelected.JobGangName.. '\nQuantité : '..value ..'$** ',109310)
                end)
            else
                TriggerClientEvent('esx:showAdvancedNotification', src, ("GANG : %s"):format(gangSelected.GangName:upper()), "Information", "Le montant d'argent sale que tu as saisie n'est pas bon !", "CHAR_LESTER", 3)
            end
        end
    end
end)

RegisterNetEvent("esx_gang:retirerargent")
AddEventHandler("esx_gang:retirerargent", function(gangSelected, value)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local playerPos = GetEntityCoords(GetPlayerPed(src))
    local coffreBoss = gangSelected.BossAction.PosBoss
    local distancePlayerBoss = #(playerPos-coffreBoss)
    
    if distancePlayerBoss <= 10 then
        if gangSelected.JobGangName == xPlayer.getJob2().name then
            TriggerEvent('esx_addonaccount:getSharedAccount', gangSelected.BossAction.SocietyAction, function(account)
                if account.money >= value then
                    account.removeMoney(value)
                    xPlayer.addAccountMoney(gangSelected.BossAction.ArgentType, value)
                    TriggerClientEvent('esx:showAdvancedNotification', src, ("GANG : %s"):format(gangSelected.GangName:upper()), "Information", ("Tu viens de retirer ~r~%s ~s~$ du coffre : ~b~%s ~s~!"):format(value, gangSelected.GangName), "CHAR_LESTER", 3)
                    sendToDiscord(GetPlayerName(source).. ' ['..src..']  vient de retirer de l\'argent d\'un coffre de crew\n\nCrew : '.. gangSelected.JobGangName.. '\nQuantité : '..value ..'$** ',16646401)
                    
                else
                    TriggerClientEvent('esx:showAdvancedNotification', src, ("GANG : %s"):format(gangSelected.GangName:upper()), "Information", "Le montant d'argent sale que tu as saisie n'est pas bon !", "CHAR_LESTER", 3)
                end
            end)
        end
    end
end)

RegisterNetEvent("esx_gang:DeposerObjet")
AddEventHandler("esx_gang:DeposerObjet", function(gangSelected, itemSelected, value)
    local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
    local playerPos = GetEntityCoords(GetPlayerPed(src))
    local coffrePos = gangSelected.Coffre.PosCoffre
    local distancePlayerCoffre = #(playerPos-coffrePos)

    if distancePlayerCoffre <= 10 then
        if gangSelected.JobGangName == xPlayer.getJob2().name then
            TriggerEvent("esx_addoninventory:getSharedInventory", gangSelected.Coffre.SocietyCoffre, function(inventory)

                if xPlayer.getInventoryItem(itemSelected).count >= value and value > 0 then
                    xPlayer.removeInventoryItem(itemSelected, value)
                    inventory.addItem(itemSelected, value)
                    print(value)
                    TriggerClientEvent('esx:showAdvancedNotification', src, ("GANG : %s"):format(gangSelected.GangName:upper()), "Information", ("Tu viens de poser ~b~%s ~s~x ~r~%s ~s~dans le stock !"):format(xPlayer.getInventoryItem(itemSelected).label, value), "CHAR_LESTER", 3)
                    sendToDiscord(GetPlayerName(src).. ' ['..src..'] vient d\'ajouter un item dans un coffre de crew\n\nCrew : '.. gangSelected.JobGangName.. '\nItem : '.. itemSelected ..'\nQuantité : '.. value ,109310)
                else
                    TriggerClientEvent('esx:showAdvancedNotification', src, ("GANG : %s"):format(gangSelected.GangName:upper()), "Information", "Quantité Invalide !", "CHAR_LESTER", 3)
                end
            end)
        end
    end
end)


RegisterNetEvent("esx_gang:deposerarmes")
AddEventHandler("esx_gang:deposerarmes", function(gangSelected, weaponName, weaponAmmo)
    local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
    local playerPos = GetEntityCoords(GetPlayerPed(src))
    local coffrePos = gangSelected.Coffre.PosCoffre
    local distancePlayerCoffre = #(playerPos-coffrePos)

    if distancePlayerCoffre <= 10 then
        if xPlayer.hasWeapon(weaponName) then
            TriggerEvent("esx_datastore:getSharedDataStore", gangSelected.Coffre.SocietyCoffre, function(store)
                local weapons = store.get("weapons") or {}
                weaponName = string.upper(weaponName)

                table.insert(weapons, {
                name = weaponName,
                ammo = weaponAmmo
                })

                xPlayer.removeWeapon(weaponName)
                store.set("weapons", weapons)

                TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, ("GANG : %s"):format(gangSelected.GangName:upper()), "Information", ("Tu viens de déposer ~b~%s ~s~avec ~r~%s ~s~balle(s) !"):format(ESX.GetWeaponLabel(weaponName), weaponAmmo), "CHAR_LESTER", 3)
                sendToDiscord(GetPlayerName(source).. ' ['..src..'] vient d\'ajouter une arme dans un coffre de crew\n\nCrew : '.. gangSelected.JobGangName.. '\nArme : '.. ESX.GetWeaponLabel(weaponName) ..'\nBalles : '.. weaponAmmo  ,109310)
                
            end)
        else
            TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, ("GANG : %s"):format(gangSelected.GangName:upper()), "Information", "Tu ne possèdes pas cette arme sur toi !", "CHAR_LESTER", 3)
        end
    end
end)

RegisterNetEvent("esx_gang:prendrearmes")
AddEventHandler("esx_gang:prendrearmes", function(gangSelected, weaponName, weaponAmmo)
    local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
    local playerPos = GetEntityCoords(GetPlayerPed(src))
    local coffrePos = gangSelected.Coffre.PosCoffre
    local distancePlayerCoffre = #(playerPos-coffrePos)

    if distancePlayerCoffre <= 10 then
        if not xPlayer.hasWeapon(weaponName) then
            TriggerEvent("esx_datastore:getSharedDataStore", gangSelected.Coffre.SocietyCoffre, function(store)
                local weapons = store.get("weapons") or {}
                weaponName = string.upper(weaponName)
                --local weaponName = ESX.GetWeaponLabel() 

                for i = 1, #weapons, 1 do
                    if weapons[i].name == weaponName and weapons[i].ammo == weaponAmmo then
                        table.remove(weapons, i)

                        store.set("weapons", weapons)
                        xPlayer.addWeapon(weaponName, weaponAmmo)

                        TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, ("GANG : %s"):format(gangSelected.GangName:upper()), "Information", ("Tu viens de récupérer ~b~%s ~s~avec ~r~%s ~s~balle(s) !"):format(ESX.GetWeaponLabel(weaponName), weaponAmmo), "CHAR_LESTER", 3)
                        sendToDiscord(GetPlayerName(source).. ' ['..src..'] vient de retirer une arme dans un coffre de crew\n\nCrew : '.. gangSelected.JobGangName.. '\nArme : '.. ESX.GetWeaponLabel(weaponName) ..'\nBalles : '.. weaponAmmo ,16646401)
                        sendToDiscordLog(GetPlayerName(source).. ' ['..src..'] vient de retirer une arme dans un coffre de crew\n\nCrew : '.. gangSelected.JobGangName.. '\nArme : '.. ESX.GetWeaponLabel(weaponName) ..'\nBalles : '.. weaponAmmo ,16646401,"test")
                        break
                    end
                end
            end)
        else
            TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, ("GANG : %s"):format(gangSelected.GangName:upper()), "Information", "Tu possèdes déjà cette arme sur toi !", "CHAR_LESTER", 3)
        end
    end
end)

RegisterServerEvent("esx_gang:PrendreObjet")
AddEventHandler("esx_gang:PrendreObjet", function(gangSelected, itemSelected, value)
    local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
    local playerPos = GetEntityCoords(GetPlayerPed(src))
    local coffrePos = gangSelected.Coffre.PosCoffre
    local distancePlayerCoffre = #(playerPos-coffrePos)

    if distancePlayerCoffre <= 10 then
        if xPlayer.getJob2().name == gangSelected.JobGangName then
            TriggerEvent("esx_addoninventory:getSharedInventory", gangSelected.Coffre.SocietyCoffre, function(inventory)
                local item = inventory.getItem(itemSelected)

                if item.count >= value then
                    
                    inventory.removeItem(itemSelected, value)
                    xPlayer.addInventoryItem(itemSelected, value)
                    TriggerClientEvent('esx:showAdvancedNotification', src, ("GANG : %s"):format(gangSelected.GangName:upper()), "Information", ("Tu viens de récupérer ~b~%s x ~r~%s ~s~dans le stock !"):format(xPlayer.getInventoryItem(itemSelected).label, value), "CHAR_LESTER", 3)
                    sendToDiscord(GetPlayerName(src).. ' ['..src..'] vient de retirer un item dans un coffre de crew\n\nCrew : '.. gangSelected.JobGangName.. '\nItem : '.. itemSelected ..'\nQuantité : '.. value,16646401)
                else
                    TriggerClientEvent('esx:showAdvancedNotification', src, ("GANG : %s"):format(gangSelected.GangName:upper()), "Information", "Quantité Invalide !", "CHAR_LESTER", 3)
                end
            end)
        end
    end
end)

RegisterNetEvent("esx_gang:PlayerSelected")
AddEventHandler("esx_gang:PlayerSelected", function(xTarget, itemType, itemName, value)
    local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local xTarget = ESX.GetPlayerFromId(xTarget)
    local playerPos = GetEntityCoords(GetPlayerPed(src))
    local playerPos2 = GetEntityCoords(GetPlayerPed(xTarget))
    local distancePlayers = #(playerPos-playerPos2)

    if distancePlayers <= 10 then
        if itemType == "item_standard" then
            if xTarget.getInventoryItem(itemName).count >= value then
                xTarget.removeInventoryItem(itemName, value)
                xPlayer.addInventoryItem(itemName, value)
                xPlayer.showNotification(("Tu viens de voler : ~r~%s ~s~x ~r~%s ~s~à ~b~%s ~s~!"):format(itemName, value, xTarget.getName()))
                xTarget.showNotification(("~b~%s ~s~ viens de te voler : ~r~%s ~s~x ~r~%s"):format(xPlayer.getName(), itemName, value))
            else
                xPlayer.showNotification("Quantité Invalide")
            end
        elseif itemType == "item_account" then
            if xTarget.getAccount(itemName).money >= value then
                xTarget.removeAccountMoney(itemName, value)
                xPlayer.addAccountMoney(itemName, value)

                xPlayer.showNotification(("Tu viens de voler : ~r~%s ~s~$ à ~b~%s ~s~!"):format(value, xTarget.getName()))
                xTarget.showNotification(("~b~%s ~s~viens de te voler : ~r~%s ~s~$"):format(xPlayer.getName(), value))
            else
                xPlayer.showNotification("Quantité Invalide")
            end
        elseif itemType == "item_weapon" then
            if not xPlayer.hasWeapon(itemName) then
                xTarget.removeWeapon(itemName)
                xPlayer.addWeapon(itemName, value)

                xPlayer.showNotification(("Tu viens de voler un(e) : ~r~%s ~s~ avec ~g~%s à ~b~%s ~s~!"):format(ESX.GetWeaponLabel(weaponName), value, xTarget.getName()))
                xTarget.showNotification(("On viens de te voler un(e) : ~r~%s ~s~ avec ~g~%s à ~b~%s ~s~!"):format(ESX.GetWeaponLabel(weaponName), value, xPlayer.getName()))
            else
                xPlayer.showNotification("Tu possède déjà cette arme sur toi !")
            end
        end
    end
end)




function sendToDiscord (message,color)
    local DiscordWebHook = 'https://discord.com/api/webhooks/905554122567196694/ryKq9Wj_T8RrSHeJm06l68Ddf2etoW5JlwvFO_zNgI8QGGhsbUpdRxLWFRkN3WbFTzoe'
    local date = os.date("%x %X %p", os.time())
  local embeds = {{
            ["color"] = color,
            ["author"] = {
            ["name"] = "Alynia",
            ["icon_url"] = "https://media.discordapp.net/attachments/841733728321667072/884833086150438962/logo_alynia.png",
            ["url"] = "https://discord.gg/alyniarp",
        },
           ["title"] = message,
           ["footer"] = {
           ["text"] = " © AlyniaRP • "..date,
           ["icon_url"] = "https://media.discordapp.net/attachments/841733728321667072/884833086150438962/logo_alynia.png",
        },
    }}
  
  
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({embeds = embeds}), { ['Content-Type'] = 'application/json' })
    --export['screenshot-basic']:requestScreenshotUpload("https://discord.com/api/webhooks/900827272720818217/7vHISRZdapx5uO9pS93YrAxiyHXU8LAyIIry7bmbacRSE3NMBCk8WgeKf1CUSfEZeo5F", "files[]")
end



local WebHook = {
    ["test"] = "https://discord.com/api/webhooks/900827272720818217/7vHISRZdapx5uO9pS93YrAxiyHXU8LAyIIry7bmbacRSE3NMBCk8WgeKf1CUSfEZeo5F",
    ["test2"] = {i = "https://discord.com/api/webhooks/900827043279831090/U5J61ObJsKGJn34uj98l2Al9NGnuXDj4jQgL1OqRtv07bcFrRVtS-qLER1NW6WaWcpAJ"},
}

function sendToDiscordLog (message,type)
    local date = os.date("%x %X %p", os.time())
    local WebHook = ""

    if WebHook[type] then 
        WebHook = WebHook[type].i
    else
        WebHook = type
    end
    
  local embeds = {
      {
        ["title"] = message,
        ["type"]  = "rich",
        ["color"] = 1478454,
        ["footer"] = {
            ["text"] = "Log envoyée à "..date,
        },
      }
  }
  
    PerformHttpRequest(WebHook, function(err, text, headers) end, 'POST', json.encode({username = "",embeds = embeds, avatar_url = img, tts = false}), { ['Content-Type'] = 'application/json' })
end
  
  

  