local showing = false
local exempt = false
local lastActive = GetGameTimer()
local countdown = 0
local captchaText = nil

local RESOURCE = GetCurrentResourceName()

local function notify(msg)
    -- Minimal chat fallback. Replace with your HUD export if desired.
    TriggerEvent('chat:addMessage', {args = {'^3ANTI-AFK^7', msg}})
end

-- Ask the server if we're exempt (ACE permissions)
local function refreshExempt()
    TriggerServerEvent('goku_antiafk:checkExempt')
end

RegisterNetEvent('goku_antiafk:setExempt', function(state)
    exempt = state
end)

-- Generate a fresh captcha and open UI
local function openCaptcha()
    if showing or exempt then return end
    showing = true
    countdown = Config.KickTime
    captchaText = exports[RESOURCE]:GenerateCaptcha(Config.CaptchaLength)

    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'open',
        title = Config.Title,
        desc = Config.Description,
        button = Config.ButtonText,
        serverName = Config.ServerName,
        allowCancel = Config.AllowCancel,
        panelStyle = Config.PanelStyle,
        captchaStyle = Config.CaptchaStyle,
        colors = {
            primary = "#F13D3D",
            secondary = "#7B2222",
            background = "#0A0A0A",
            text = "#FFFFFF"
        },
        code = captchaText,
        seconds = countdown,
        resource = RESOURCE
    })

    -- countdown
    CreateThread(function()
        while showing and countdown > 0 do
            Wait(1000)
            countdown -= 1
            SendNUIMessage({ action = 'tick', seconds = countdown })
        end
        if showing and countdown <= 0 then
            -- time's up
            SetNuiFocus(false, false)
            showing = false
            TriggerServerEvent('goku_antiafk:kickMe', Config.KickMessage)
        end
    end)
end

-- Track activity
local controls = {
    30,31,32,33,34,35, -- move
    21,22,24,25,44,45, -- sprint, jump, attack, aim, cover, enter
    38, -- E
    44, -- Q
    74, -- H
    245 -- T
}

CreateThread(function()
    refreshExempt()
    while true do
        Wait(250)
        if exempt then goto continue end

        local ped = PlayerPedId()
        -- Any movement
        if IsPedOnFoot(ped) and GetEntitySpeed(ped) > 0.1 then
            lastActive = GetGameTimer()
        end
        -- Controls
        for _, key in ipairs(controls) do
            if IsControlJustPressed(0, key) then
                lastActive = GetGameTimer()
                break
            end
        end

        -- show captcha when threshold exceeded
        if not showing then
            local minutes = (GetGameTimer() - lastActive) / 60000.0
            if minutes >= Config.AfkWarningThreshold then
                openCaptcha()
            end
        end

        ::continue::
    end
end)

-- NUI callbacks
RegisterNUICallback('submit', function(data, cb)
    local input = tostring(data and data.value or '')
    local ok
    if Config.CaseSensitive then
        ok = (input == captchaText)
    else
        ok = (string.lower(input) == string.lower(captchaText))
    end

    if ok then
        showing = false
        SetNuiFocus(false, false)
        SendNUIMessage({ action = 'close' })
        lastActive = GetGameTimer()
        notify(Config.Notification.Success)
        TriggerServerEvent('goku_antiafk:solved')
    else
        notify(Config.Notification.Error)
    end
    cb({ ok = ok })
end)

RegisterNUICallback('cancel', function(_, cb)
    if Config.AllowCancel then
        showing = false
        SetNuiFocus(false, false)
        SendNUIMessage({ action = 'close' })
        notify(Config.Notification.Cancel)
    end
    cb({ ok = true })
end)

-- Debug command
if Config.Debug then
    RegisterCommand('antiAFK_test', function()
        openCaptcha()
    end)
end
