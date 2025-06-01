local utils = require "utils"

local background
local shader
local font

local w, h = 800, 800
local mouseX = 0
local mouseY = 0
local time = 0

function love.load()
    love.window.setTitle("Shader - Blob")
    love.window.setMode(w, h)
    font = love.graphics.newFont(24)

    shader = love.graphics.newShader("blob.glsl")
    background = love.graphics.newCanvas()
end

function love.update(dt)
    mouseX, mouseY = love.mouse.getPosition()
    time = time + dt
end

function love.draw()
    love.graphics.clear(0, 0, 0, 0)
    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.setColor(1, 1, 1, 1)

    local ux, uy = mouseX / w, mouseY / h
    utils.withShader(shader, function()
        shader:send("u_mouse", { ux, uy })
        shader:send("u_time", time)
        love.graphics.draw(background, 0, 0)
    end)

    love.graphics.setBlendMode("alpha", "alphamultiply")
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(font)
    love.graphics.printf("X: " .. string.format("%.2f", ux), 0, h / 2 - 48, w, "center")
    love.graphics.printf("Y: " .. string.format("%.2f", uy), 0, h / 2 - 24, w, "center")
end
