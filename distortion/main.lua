local utils = require "utils"

local w, h
local canvas, image
local distortion_mag_shader, distortion_uv_shader
local debugInfo

local tightness = 2
local strength = 0.05
local t_diff = 0
local s_diff = 0

local key_map = {}

function love.load()
    image = love.graphics.newImage("undistorted.jpg")
    w = image:getWidth()
    h = image:getHeight()
    love.window.setTitle "love shader - distortion"
    love.window.setMode(w, h * 2)
    canvas = love.graphics.newCanvas(w, h)
    distortion_mag_shader = love.graphics.newShader "distortion_mag.glsl"
    distortion_uv_shader = love.graphics.newShader "distortion_uv.glsl"

    debugInfo = utils.debugInfo()

    utils.withCanvas(canvas, function()
        love.graphics.setColor(1, 1, 1);
        love.graphics.draw(image, 0, 0)
    end)
end

function love.keypressed(key)
    key_map[key] = true
end

function love.keyreleased(key)
    key_map[key] = false
end

function love.update()
    t_diff = 0
    if key_map["up"] then
        t_diff = 0.1
    elseif key_map["down"] then
        t_diff = -0.1
    end

    s_diff = 0
    if key_map["right"] then
        s_diff = 0.01
    elseif key_map["left"] then
        s_diff = -0.01
    end

    tightness = utils.clamp(tightness + t_diff, -10, 10)
    strength = utils.clamp(strength + s_diff, -10, 10)

    debugInfo.update({
        tightness = tightness,
        strength = strength,
    })
end

function love.draw()
    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.setColor(1, 1, 1, 1)

    utils.withShader(distortion_uv_shader, function()
        distortion_uv_shader:send("u_tightness", tightness)
        distortion_uv_shader:send("u_strength", strength)
        love.graphics.draw(canvas, 0, 0)
    end)
    utils.withShader(distortion_mag_shader, function()
        distortion_mag_shader:send("u_tightness", tightness)
        love.graphics.draw(canvas, 0, h)
    end)
    debugInfo.draw()
end
