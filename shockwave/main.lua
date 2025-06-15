local utils = require "utils"

local w, h
local canvas, image
local shockwave_shader
local debugInfo

local mouseX, mouseY = 0, 0
local time = 0
local mousePressed = false

function love.load()
    image = love.graphics.newImage("image.jpeg")
    w = image:getWidth()
    h = image:getHeight()
    love.window.setTitle "love shader - shockwave"
    love.window.setMode(w, h)
    canvas = love.graphics.newCanvas(w, h)
    shockwave_shader = love.graphics.newShader "shockwave.glsl"

    debugInfo = utils.debugInfo()

    utils.withCanvas(canvas, function()
        love.graphics.setColor(1, 1, 1);
        love.graphics.draw(image, 0, 0)
    end)
end

function love.mousepressed(x, y, button)
    if button == 1 then
        time = 0
        mouseX = x
        mouseY = y
        mousePressed = true
    end
end

function love.update(dt)
    if mousePressed then
        time = time + dt
    end

    debugInfo.update({
        mouseX = mouseX,
        mouseY = mouseY,
        time = time,
    })
end

function love.draw()
    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.setColor(1, 1, 1, 1)

    utils.withShader(shockwave_shader, function()
        shockwave_shader:send("u_aspect", { 1, w / h })
        shockwave_shader:send("u_mouse_pos", { mouseX / w, mouseY / h })
        shockwave_shader:send("u_time", time)
        love.graphics.draw(canvas, 0, 0)
    end)

    debugInfo.draw()
end
