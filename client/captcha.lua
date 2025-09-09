local charset = {}
for c = 48, 57 do table.insert(charset, string.char(c)) end -- 0-9
for c = 65, 90 do table.insert(charset, string.char(c)) end -- A-Z
for c = 97, 122 do table.insert(charset, string.char(c)) end -- a-z

function GenerateCaptcha(length)
    local res = {}
    math.randomseed(GetGameTimer())
    for i = 1, length do
        res[i] = charset[math.random(1, #charset)]
    end
    return table.concat(res)
end
exports('GenerateCaptcha', GenerateCaptcha)
