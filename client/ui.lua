-- Helper to open/close from server if needed
RegisterNetEvent('goku_antiafk:open', function()
    -- client/main handles duplicates
    local minutes = Config.AfkWarningThreshold + 1.0
    -- force open by pushing lastActive far enough in the past
    TriggerEvent('chat:addMessage', {args={'^3ANTI-AFK^7', 'Opening captcha (debug).'}})
end)
