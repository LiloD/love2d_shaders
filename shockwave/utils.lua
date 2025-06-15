local M = {}

M.withCanvas = function(canvas, fn)
    love.graphics.setCanvas(canvas)
    fn()
    love.graphics.setCanvas()
end

M.withShader = function(shader, fn)
    love.graphics.setShader(shader)
    fn()
    love.graphics.setShader()
end

M.clamp = function(n, min, max)
    return math.min(math.max(min, n), max)
end

M.debugInfo = function()
    local _o = {}
    local _t = {}
    local _canvas = love.graphics.newCanvas()
    local _font = love.graphics.newFont(24)
    local h = _font:getHeight()

    _o.update = function(t)
        for key, value in pairs(t) do
            _t[key] = value
        end
    end

    _o.draw = function()
        M.withCanvas(_canvas, function()
            love.graphics.setBlendMode("alpha", "alphamultiply")
            love.graphics.clear()
            love.graphics.setFont(_font)
            local i = 0
            for key, value in pairs(_t) do
                local t = type(value)
                local display
                if t == "number" then
                    display = string.format("%.2f", value)
                else
                    display = tostring(value)
                end

                love.graphics.printf(key .. ": " .. display, 10, 10 + h * i, _canvas:getWidth())
                i = i + 1
            end
        end)

        love.graphics.setBlendMode("alpha", "premultiplied")
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(_canvas, 0, 0)
    end

    return _o
end

return M
