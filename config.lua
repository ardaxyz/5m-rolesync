Config = {}

Config.Discord = {
    ["bot_token"] = "Bot-Token", -- Token of a Bot from the Guild
    ["guild_id"] = "Guild-ID", -- Your Discord Guild ID
},

Config.DiscordRollen = { -- Set Your Group for a Role ID
    ["IC-GROUP"] = { -- Group Name
        "DISCORD-ID", -- Discord-ID
    },
    -- you can add here more

    -- ["admin"] = { -- Group Name
    --     "00000000000000000", -- Discord-ID
    -- },
}

function Notify(src, type, title, msg, time) -- you can change your notify here
    TriggerClientEvent("esx:showNotification", src, message)
end