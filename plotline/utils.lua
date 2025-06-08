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

return M
