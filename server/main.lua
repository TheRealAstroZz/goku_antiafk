-- ========= Helpers =========
local function getIdByType(src, t)
    -- Nutzt die Lua-API GetPlayerIdentifiers; alternativ: GetPlayerIdentifierByType auf neueren Builds. :contentReference[oaicite:5]{index=5}
    for _, id in ipairs(GetPlayerIdentifiers(src)) do
        if id:sub(1, #t+1) == (t .. ":") then
            return id:sub(#t + 2)
        end
    end
    return nil
end

local function boolIcon(b) return b and "✅" or "❌" end

-- ========= Moderner Webhook-Sender =========
local function sendDiscordLogModern(opts)
    -- opts: { title, desc, color, fields, username, avatar, thread_name }
    local url = Config.Webhook
    if not url or url == "" then
        print("^3[goku_antiafk]^7 Kein Discord-Webhook in Config.Webhook gesetzt — Logging deaktiviert.")
        return
    end

    local username = opts.username or "ForsakenWorld • Anti-AFK"
    local avatar   = opts.avatar   or (Config.WebhookAvatar or "")
    local logo     = Config.WebhookLogo or avatar

    local embed = {
        author = { name = "ForsakenWorld Anti-AFK", icon_url = logo },
        title  = opts.title or "Anti-AFK Event",
        description = opts.desc or "",
        color  = opts.color or 0xF1C40F,
        thumbnail = logo ~= "" and { url = logo } or nil,
        fields = opts.fields or {},
        footer = { text = "Anti-AFK System by Goku | .astrozz", icon_url = logo },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%S.000Z")
    }

    local payload = {
        username   = username,
        avatar_url = avatar,
        embeds     = { embed },
    }

    -- Optional: Thread-Unterstützung (Forum/Media Channels) :contentReference[oaicite:6]{index=6}
    if (Config.WebhookThreadName or "") ~= "" then
        payload.thread_name = Config.WebhookThreadName
    elseif opts.thread_name then
        payload.thread_name = opts.thread_name
    end

    PerformHttpRequest(url, function(status, body, headers)
        if status < 200 or status >= 300 then
            print(("[goku_antiafk] Webhook Fehler (%s): %s"):format(status, body or ""))
        end
        -- Hinweis: Discord Webhooks sind geratelimited (z.B. 5/2s/Webhook, ~30/min/Channel). :contentReference[oaicite:7]{index=7}
    end, "POST", json.encode(payload), { ["Content-Type"] = "application/json" })
end

-- ========= Permissions / Exempt =========
local function IsExempt(src)
    for _, ace in ipairs(Config.ExemptPermissions or {}) do
        if IsPlayerAceAllowed(src, ace) then
            return true
        end
    end
    return false
end

RegisterNetEvent('goku_antiafk:checkExempt', function()
    local src = source
    TriggerClientEvent('goku_antiafk:setExempt', src, IsExempt(src))
end)

-- ========= KICK (Timeout) =========
RegisterNetEvent('goku_antiafk:kickMe', function(msg)
    local src = source
    if not IsExempt(src) then
        local name    = GetPlayerName(src) or ("Player "..tostring(src))
        local license = getIdByType(src, "license")
        local discord = getIdByType(src, "discord")
        local steam   = getIdByType(src, "steam")
        local ping    = GetPlayerPing(src) or 0
        local ip      = (Config.LogIP and GetPlayerEndpoint and GetPlayerEndpoint(src)) or nil  -- vorsichtig nutzen

        local fields
        if Config.WebhookCompact then
            fields = {
                { name = "License", value = license and ("`"..license.."`") or "`n/a`", inline = true },
                { name = "Discord", value = discord and ("<@"..discord.."> (`"..discord.."`)") or "`n/a`", inline = true },
                { name = "Steam",   value = steam and ("`"..steam.."`") or "`n/a`", inline = true },
            }
        else
            fields = {
                { name = "Spieler", value = ("%s (`%d`)"):format(name, src), inline = true },
                { name = "Ping",    value = tostring(ping).." ms", inline = true },
                { name = "Exempt",  value = boolIcon(false), inline = true },
                { name = "License", value = license and ("`"..license.."`") or "`n/a`", inline = true },
                { name = "Discord", value = discord and ("<@"..discord.."> (`"..discord.."`)") or "`n/a`", inline = true },
                { name = "Steam",   value = steam and ("`"..steam.."`") or "`n/a`", inline = true },
                ip and { name = "IP", value = "`"..ip.."`", inline = false } or nil
            }
        end

        sendDiscordLogModern({
            title = ("⛔ AFK Kick — Player %d"):format(src),  -- Spieler-ID im Titel
            desc  = ("**%s** wurde wegen Inaktivität gekickt.\n> %s"):format(name, msg or (Config.KickMessage or "AFK too long.")),
            color = Config.EmbedColorKick or 0xE74C3C,
            fields = fields
        })

        DropPlayer(src, msg or Config.KickMessage or "AFK too long.")
    end
end)

-- ========= SOLVED =========
RegisterNetEvent('goku_antiafk:solved', function()
    local src = source
    local name    = GetPlayerName(src) or ("Player "..tostring(src))
    local license = getIdByType(src, "license")
    local discord = getIdByType(src, "discord")
    local steam   = getIdByType(src, "steam")
    local ping    = GetPlayerPing(src) or 0

    local fields
    if Config.WebhookCompact then
        fields = {
            { name = "License", value = license and ("`"..license.."`") or "`n/a`", inline = true },
            { name = "Discord", value = discord and ("<@"..discord.."> (`"..discord.."`)") or "`n/a`", inline = true },
            { name = "Steam",   value = steam and ("`"..steam.."`") or "`n/a`", inline = true },
        }
    else
        fields = {
            { name = "Spieler", value = ("%s (`%d`)"):format(name, src), inline = true },
            { name = "Ping",    value = tostring(ping).." ms", inline = true },
            { name = "Exempt",  value = boolIcon(IsExempt(src)), inline = true },
            { name = "License", value = license and ("`"..license.."`") or "`n/a`", inline = true },
            { name = "Discord", value = discord and ("<@"..discord.."> (`"..discord.."`)") or "`n/a`", inline = true },
            { name = "Steam",   value = steam and ("`"..steam.."`") or "`n/a`", inline = true }
        }
    end

    sendDiscordLogModern({
        title  = ("✅ Captcha solved — Player %d"):format(src),  -- Spieler-ID im Titel
        desc   = "Spieler hat das Anti-AFK-Captcha **erfolgreich gelöst**.",
        color  = Config.EmbedColorSolved or 0x2ECC71,
        fields = fields
    })
end)

-- ========= Debug =========
if Config.Debug then
    RegisterCommand('antiAFK_open', function(src)
        TriggerClientEvent('goku_antiafk:open', src)
    end, true)
end
