local utils = require "utils"

local background
local shader
local time = 0

local w, h = 600, 600

function love.load()
    love.window.setTitle("Shader - Plot Lines")
    love.window.setMode(w, h)

    shader = love.graphics.newShader("plot.glsl")
    background = love.graphics.newCanvas()
end

function love.update(dt)
    time = time + dt
end

function love.draw()
    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.setColor(1, 1, 1, 1)
    utils.withShader(shader, function()
        shader:send("u_time", time)
        love.graphics.draw(background)
    end)
end
