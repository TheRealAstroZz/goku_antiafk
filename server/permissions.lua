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
    local allowed = IsExempt(src)
    TriggerClientEvent('goku_antiafk:setExempt', src, allowed)
end)

return { IsExempt = IsExempt }
