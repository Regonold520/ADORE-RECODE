local adore = require("lib/adore")

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    adore:load()
end

function love.update(dt)
    adore:update(dt)
end

function love.draw()
    adore:draw()
end