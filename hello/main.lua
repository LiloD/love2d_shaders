local utils = require "utils"

local background
local shader

local w, h = 600, 600

function love.load()
    love.window.setTitle("Shader - Hello GLSL")
    love.window.setMode(w, h)

    shader = love.graphics.newShader("hello.glsl")
    background = love.graphics.newCanvas()
end

function love.draw()
    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.setColor(1, 1, 1, 1)
    utils.withShader(shader, function()
        love.graphics.draw(background)
    end)
end
