local ui = {}

Adore.ui = {}
Adore.ui.anchors = {}
Adore.ui.objects = {}
Adore.ui.types = {}

function ui:load()
    screenX = love.graphics.getWidth()
    screenY = love.graphics.getHeight()

    Adore.ui:registerUiType(love.graphics.newQuad(0,0,32,32,32,32),Adore:findSprite("breadpanel.png"), "test")
    Adore.ui:registerUiType(love.graphics.newQuad(0,0,59,16,59,16),Adore:findSprite("breadpanel2.png"), "test2")
    
    Adore.ui.anchors = {
        m = Vector2(screenX / 2, screenY / 2),
        tl = Vector2(0, 0),
        t = Vector2(screenX / 2, 0),
        tr = Vector2(screenX, 0),
        r = Vector2(screenX, screenY / 2),
        br = Vector2(screenX, screenY),
        b = Vector2(screenX / 2, screenY),
        bl = Vector2(0, screenY),
        l = Vector2(0, screenY / 2)
    }

    Adore.ui:addPanel("testPanel", Adore.ui.anchors.tl, Vector2(0,0), Adore.ui.types.test, 1)

end

function ui:update(dt)
end

function ui:draw()
    for _, i in pairs(Adore.ui.objects) do
        local x, y, w, h = i.quad:getViewport()
        local offset = i.offset or Vector2(0,0)
        
        if offset.x == 0 and offset.y == 0 then
            if i.anchor == Adore.ui.anchors.m then
                offset = Vector2(w/2,w/2)
            elseif i.anchor == Adore.ui.anchors.t then
                offset = Vector2(w/2,0)
            elseif i.anchor == Adore.ui.anchors.tr then
                offset = Vector2(w,0)
            elseif i.anchor == Adore.ui.anchors.r then
                offset = Vector2(w,w/2)
            elseif i.anchor == Adore.ui.anchors.br then
                offset = Vector2(w,h)
            elseif i.anchor == Adore.ui.anchors.b then
                offset = Vector2(w/2,h)
            elseif i.anchor == Adore.ui.anchors.bl then
                offset = Vector2(0,h)
            elseif i.anchor == Adore.ui.anchors.l then
                offset = Vector2(0,h/2)
            end
        end

        love.graphics.draw(i.drawable, i.anchor.x, i.anchor.y, 0, 4, 4, offset.x, offset.y)
    end
end

function Adore.ui:registerUiType(quad, drawable, id)
    Adore.ui.types[id] = {quad=quad, drawable=drawable}
end


function Adore.ui:addPanel(id, anchor, offset, uiType, layer)
    Adore.ui.objects[id] = {
        type = "panel",
        anchor = anchor,
        offset = offset,
        quad = uiType.quad,
        drawable = uiType.drawable,
        layer = layer
    }
end


return ui