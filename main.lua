--Ive added some comments in this file to help u understand whats going on in here


local adore = require("lib/adore")

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setBackgroundColor(0.7254901960784313, 0.4666666666666667, 0.23529411764705882)
    adore:load()



    -- 2 Lines below create 2 "objects", bredBG and bred
    local bredBG = Adore.lib.object:new(love.graphics.newQuad(0,0,58,58,58,58), "breadBacker.png",Vector2(0), "bredBG", 0, "scripts/bredBG")
    local bred = Adore.lib.object:new(love.graphics.newQuad(0,0,32,32,32,32), "bread.png",Vector2(love.graphics.getWidth()/2,love.graphics.getHeight()/2), "bred", 1, "scripts/bred")
    

    bred:addChild(bredBG) --Sets bredBG to be a child of bred
    bred:setMouseDetectable(true) --Allows bred object to be targeted my mouse hover and click functions



    Adore.ui:addFont("pixel", "pixelFont.ttf") --Caches the "pixelFont.ttf" with the id of "pixel", can be accessed like Adore.ui.fonts.pixel
    Adore.ui:addText("breadText", "tr", Vector2(0,0), 2, Adore.ui.fonts.pixel) --Adds the ui object of a text at the top right anchor with the pixel font that we just made
end

local dTimer = 0
function love.update(dt)
    adore:update(dt)
    dTimer = dTimer + dt

    
    print(Adore.camera.rot)
    if Adore.camera.rot > 0.3 then
        Adore.camera.rot = Adore.camera.rot - (dt*25)
    elseif Adore.camera.rot < -0.3 then
        Adore.camera.rot = Adore.camera.rot + (dt*25)
    else
        Adore.camera.rot = 0
    end 
end

function love.draw()
    adore:draw()
end