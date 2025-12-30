local ui = {}

Adore.ui = {}
Adore.ui.anchors = {}
Adore.ui.objects = {}
Adore.ui.types = {}
Adore.ui.fonts = {}

Adore.ui.uiScale = 4

function ui:load()
    screenX = love.graphics.getWidth()
    screenY = love.graphics.getHeight()

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
end

function ui:update(dt)
    ui:hoverDetection()
end

function ui:draw()
    for _, i in pairs(Adore.ui.objects) do
        local x, y, w, h = i.quad:getViewport()
        if i.type == "text" then 
            w = i.drawable:getWidth() 
            h = i.drawable:getHeight() 
        end

        local anchor = Adore.ui.anchors[i.anchor]
        local offset = i.offset or Vector2(0,0)
        if offset.x == 0 and offset.y == 0 then
            if i.anchor == "m" then
                offset = Vector2(w/2,h/2)
            elseif i.anchor == "t" then
                offset = Vector2(w/2,0)
            elseif i.anchor == "tr" then
                offset = Vector2(w,0)
            elseif i.anchor == "r" then
                offset = Vector2(w,h/2)
            elseif i.anchor == "br" then
                offset = Vector2(w,h)
            elseif i.anchor == "b" then
                offset = Vector2(w/2,h)
            elseif i.anchor == "bl" then
                offset = Vector2(0,h)
            elseif i.anchor == "l" then
                offset = Vector2(0,h/2)
            end
        end

        i.anchorOffset = offset
        local sx, sy = 4, 4
        if i.type == "text" then
            sx, sy = 1, 1
        end

        love.graphics.draw(i.drawable, anchor.x, anchor.y, 0, sx, sy, offset.x, offset.y)

    end
end


function Adore.ui:registerUiType(quad, drawable, id)
    Adore.ui.types[id] = {quad=quad, drawable=drawable}
end


function Adore.ui:addPanel(id, anchor, offset, uiType, layer, scriptPath)
    p = basicUiPiece(id, anchor, offset, uiType, layer, scriptPath)
    p.type = "panel"

    return p
end

function Adore.ui:addFont(id, filePath)
    font = love.graphics.newFont(filePath, 64)

    Adore.ui.fonts[id] = font
end

function Adore.ui:addButton(id, anchor, offset, uiType, layer, scriptPath)
    b = basicUiPiece(id, anchor, offset, uiType, layer, scriptPath)
    b.type = "button"
    b.hover = false

    return b
end

function Adore.ui:addText(id, anchor, offset, layer, font)
    local newType = {
        quad = love.graphics.newQuad(0,0,0,0,0,0),
        drawable = love.graphics.newText(font, "")
    }


    t = basicUiPiece(id, anchor, offset, newType, layer, nil)
    t.type = "text"
    
    return t
end


function basicUiPiece(id, anchor, offset, uiType, layer, scriptPath)
    local scriptPath = scriptPath or nil
    
    local basic = {
        type = "basic",
        anchor = anchor,
        offset = offset,
        quad = uiType.quad,
        drawable = uiType.drawable,
        layer = layer,
        anchorOffset = Vector2(0),
        script = nil
    }

    function basic:hoverable(value)
        if value == true then
            self.hover = false
        else
            self.hover = nil
        end
    end

    Adore.ui.objects[id] = basic



    if scriptPath ~= nil then
        local ScriptClass = require(scriptPath)
        if ScriptClass ~= nil then
            local scriptInstance = ScriptClass.new(Adore.ui.objects[id])

            Adore.ui.objects[id].script = scriptInstance
            table.insert(Adore.updateables, Adore.ui.objects[id])

            if scriptInstance.load ~= nil then
                scriptInstance:load()
            end
        end
    end
    return basic
end

local hovering = {}
function ui:hoverDetection()
    hovering = {}
    for _,i in pairs(Adore.ui.objects) do
        if i.hover ~= nil then
            local Mx, My = love.mouse.getPosition()
            local x, y, w, h = i.quad:getViewport()

            local anchor = Adore.ui.anchors[i.anchor]

            local right = anchor.x + ((w - i.anchorOffset.x) * Adore.ui.uiScale)
            local left = anchor.x - ((i.anchorOffset.x) * Adore.ui.uiScale)
            local bottom = anchor.y + ((h - i.anchorOffset.y) * Adore.ui.uiScale)
            local top = anchor.y - ((i.anchorOffset.y) * Adore.ui.uiScale)

            if Mx > left and Mx < right and
                My < bottom and My > top  then
                table.insert(hovering, i)

            end
        end

    end

    function compare(a, b)
        return a.layer > b.layer
    end

    table.sort(hovering, compare)
end

local oldMousePressed = love.mousepressed
local oldMouseReleased = love.mousereleased

function love.mousepressed(x, y, button, istouch, presses)
    if oldMousePressed then
        oldMousePressed(x, y, button, istouch, presses)
    end

    if hovering[1] ~= nil then 
        if hovering[1].script ~= nil then
            if hovering[1].script.mousePressed ~= nil then
                hovering[1].script:mousePressed() 
            end
        end
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    if oldMouseReleased then
        oldMouseReleased(x, y, button, istouch, presses)
    end

    if hovering[1] ~= nil then
        if hovering[1].script ~= nil then
            if hovering[1].script.mouseReleased ~= nil then
                hovering[1].script:mouseReleased()
            end
        end
    end
end



return ui