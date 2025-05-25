local utils = require "utils"
local shaderCode = require "shaderCode"

local background
local shader

local w, h = 400, 400
local slider = 0
local diff = 0
local keyTable = {}
local u_time = 0
local mouseX = 0
local mouseY = 0

function love.load()
    love.window.setTitle("Shader - Hello World")
    love.window.setMode(800, 600)

    shader = love.graphics.newShader(shaderCode.rect_sdf)
    background = love.graphics.newCanvas(w, h)
end

function love.keypressed(key)
    keyTable[key] = 1
end

function love.keyreleased(key)
    keyTable[key] = 0
end

function love.update(dt)
    u_time = u_time + dt
    diff = 0
    if keyTable["up"] == 1 then
        diff = 0.005
    elseif keyTable["down"] == 1 then
        diff = -0.005
    end
    slider = slider + diff
    if slider > 1.0 then
        slider = 1.0
    elseif slider < 0.0 then
        slider = 0.0
    end

    mouseX, mouseY = love.mouse.getPosition()
end

function love.draw()
    love.graphics.clear(0, 0, 0, 0)
    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.setColor(1, 1, 1, 1)

    utils.withShader(shader, function()
        shader:send("u_mouse_pos", { mouseX / w, mouseY / h })
        love.graphics.draw(background, 0, 0)
    end)
end
