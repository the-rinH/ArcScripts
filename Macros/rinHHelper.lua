--[[
    helper things

    my macros will depend on this, put this in your macros folder PLEASE.

    guess what you can use the functions here to make your own macro
]]

-- Linear Interpolation
function lerp(v1, v2, percent)
    return v1 + (v2 - v1) * percent
end

-- Linear Interpolation with easings
--[[
    i skipped some of them because they look close to each other, plus im lazy
]]
_EASINGS = {"s", "si", "so", "b", "ci", "co", "cio", "qi", "qo", "qio", "circin", "circout", "circinout", "backin", "backout", "backinout"} -- let me chuck a table into dropdownMenu pleas
function lerpEasing(v1, v2, percent, easing)
    local easingLower = string.lower(easing)
    local easedPercent = percent

    --[[
    --Linear (s)
    if easingLower == "s" or easingLower == "l" or easingLower == "linear" then
        -- do nothing lmao
    else
        ]]
    -- Sine In (si)
    if easingLower == "si" or easingLower == "sinein" then
        easedPercent = 1 - math.cos((percent * math.pi) / 2)

    -- Sine Out (so)
    elseif easingLower == "so" or easingLower == "sineout" then
        easedPercent = 1 - math.sin((percent * math.pi) / 2)
    
    -- b
    elseif easingLower == "b" or easingLower == "sineinout" then
        easedPercent = -(math.cos(math.pi * percent) - 1) / 2

    -- cubic in
    elseif easingLower == "ci" or easingLower == "cubicin" then
        easedPercent = percent ^ 3

    -- cubic out
    elseif easingLower == "co" or easingLower == "cubicout" then
        easedPercent = 1 - (1-percent) ^ 3

    -- cubic in out
    elseif easingLower == "cio" or easingLower == "cubicinout" then
        if percent < 0.5 then
            easedPercent = 4 * percent ^ 3
        else
            easedPercent = 1 - ((-2 * percent + 2) ^ 3) / 2
        end

    -- quint in
    elseif easingLower == "qi" or easingLower == "quintin" then
        easedPercent = percent ^ 5

    -- quint out
    elseif easingLower == "qo" or easingLower == "quintout" then
        easedPercent = 1 - (1-percent) ^ 5

    -- quint in out
    elseif easingLower == "qio" or easingLower == "quintinout" then
        if percent < 0.5 then
            easedPercent = 16 * percent ^ 5
        else
            easedPercent = 1 - ((-2 * percent + 2) ^ 5) / 2
        end

    -- circ In
    elseif easingLower == "circin" or easingLower == "circularin" then
        easedPercent = 1 - math.sqrt(1 - percent ^ 2)

    -- circ Out
    elseif easingLower == "circout" or easingLower == "circularout" then
        easedPercent = math.sqrt(1 - (1 - percent) ^ 2)

    -- circ in out
    elseif easingLower == "circinout" or easingLower == "circularinout" then
        if percent < 0.5 then
            easedPercent = (1 - math.sqrt(1 - (2 * percent) ^ 2)) / 2
        else
            easedPercent = (math.sqrt(1 - (-2 * percent + 2) ^ 2) + 1) / 2
        end
    
    -- back in
    elseif easingLower == "bi" or easingLower == "backin" then
        local c1 = 1.70158
        local c3 = c1 + 1
        easedPercent = (c3 * percent ^ 3) - (c1 * percent ^ 2)
    
    -- back out
    elseif easingLower == "bo" or easingLower == "backout" then
        local c1 = 1.70158
        local c3 = c1 + 1
        easedPercent = (1 + c3 * (percent - 1) ^ 3) + (c1 * (percent - 1) ^ 2)
    
    -- back inout (untested lol)
    elseif easingLower == "bio" or easingLower == "backinout" then
        local c1 = 1.70158
        local c2 = c1 * 1.525
        if percent < 0.5 then
            easedPercent = ((2 * percent) ^ 2 * ((c2 + 1) * 2 * percent - c2)) / 2
        else
            easedPercent = ((2 * percent - 2) ^ 2 * ((c2 + 1) * (percent * 2 - 2) + c2) + 2) / 2
        end
    end

    return lerp(v1, v2, easedPercent)
end