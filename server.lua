local DiscordRoles, DiscordAPI, gruppe = {}, nil, "user"

CreateThread(function()
    Wait(2000)
    PerformHttpRequest('https://discord.com/api/guilds/' .. Config.Discord["guild_id"], function(status, response)
        if not status == 200 then
            local data = json.decode(response)
            print(">> Verbindung erfolgreich! Guild: " .. data.name .. "^0")
        end
    end, 'GET', '', {['Authorization'] = "Bot " .. Config.Discord["bot_token"]})
end)

function DiscordAPI:Get(id)
    for i = 0, GetNumPlayerIdentifiers(id) - 1 do
        local identifier = GetPlayerIdentifier(id, i)
        if string.find(identifier, "discord:") then
            return string.gsub(identifier, "discord:", "")
        end
    end
end

function DiscordAPI:Roles(id, cb)
    PerformHttpRequest('https://discord.com/api/guilds/' .. Config.Discord["guild_id"] .. '/members/' .. id, function(status, response)
        if status == 200 then
            local data = json.decode(response)
            print("[^4ROLESYNC^7] Rollen erfolgreich geladen: " .. #(data.roles or {}) .. " Rollen")
            cb(data.roles or {})
        else
            print("[^4ROLESYNC^7] ^1Fehler beim Laden der Rollen: " .. status .. "^0")
            cb({})
        end
    end, 'GET', '', {['Authorization'] = "Bot " .. Config.Discord["bot_token"]})
end

function setGroup(xPlayer)
    for groupName, roleIds in pairs(Config.DiscordRollen) do
        for _, playerRole in pairs(DiscordRoles[xPlayer.source] or {}) do
            for _, roleId in pairs(roleIds) do
                if playerRole == roleId then
                    gruppe = groupName
                    goto abc
                end
            end
        end
    end
    ::abc::
    
    if xPlayer.group ~= gruppe then
        Notify(xPlayer.source, "success", "Gruppe", "Deine Gruppe wurde auf " .. gruppe .. " gesetzt.", 5000)
        xPlayer.setGroup(gruppe)
    end
end

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(playerId, xPlayer)
    local id = DiscordAPI:Get(xPlayer.source)
    if id then
        DiscordAPI:Roles(id, function(roles)
            DiscordRoles[xPlayer.source] = roles
            Wait(1000)
            setGroup(xPlayer)
        end)
    else
        print("^3Keine Discord ID gefunden für: " .. xPlayer.getName() .. "^0")
    end
end)