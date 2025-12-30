local adore = {}

Adore = {}
Adore.lib = {}

Adore.searchPath = "sprites"
Adore.sprites = {}
Adore.drawables = {}
Adore.updateables = {}
Adore.mouseDetectors = {}
Adore.needsSort = true

Adore.lib.ui = require("lib/ui")


Adore.camera = require("lib/camera")
Adore.lib.object = require("lib/object")

function Vector2(x,y)
    y = y or nil
    if y == nil then return {x=x,y=x} end
    return {x=x,y=y}
end

function adore:load()
    Adore:registerSprites()
    Adore.lib.ui:load()

    Adore:printTree()
end
local dTimer = 0
function adore:update(dt)
    dTimer = dTimer + dt
    Adore.lib.ui:update(dt)

    Adore:hoverDetection()

    --Adore.camera.x = math.sin(dTimer) * 40
    --Adore.camera.y = math.cos(dTimer) * 40
    --Adore.camera.zoom = 1 + math.sin(dTimer) / 10
    --Adore.camera.rot = Adore.camera.rot + dt * 5
    for _,i in ipairs(Adore.updateables) do
        if i.script.update ~= nil then
            i.script:update(dt)
        end
    end

    for _, root in ipairs(Adore:getRoots()) do
        root:updateGlobalTransform()
    end
end

function adore:draw()
    if Adore.needsSort then
        table.sort(Adore.drawables, function(a, b)
            if a.layer ~= b.layer then
                return a.layer < b.layer
            end
            return #a.id > #b.id
        end)
        Adore.needsSort = false
    end

    love.graphics.push()

    love.graphics.translate(
        love.graphics.getWidth() / 2,
        love.graphics.getHeight() / 2
    )

    love.graphics.scale(Adore.camera.zoom)

    love.graphics.rotate(math.rad(Adore.camera.rot))

    love.graphics.translate(
        -Adore.camera.x - love.graphics.getWidth() / 2,
        -Adore.camera.y - love.graphics.getHeight() / 2
    )


    for _, i in ipairs(Adore.drawables) do
        local _, _, w, h = i.quad:getViewport()
        local orX, orY = w / 2, h / 2

        if i.origin then
            if i.origin.x then orX = i.origin.x end
            if i.origin.y then orY = i.origin.y end
        end

        love.graphics.draw(
            i.drawable,
            i.quad,
            i.globalPos.x,
            i.globalPos.y,
            i.rot or 0,
            i.scale.x or 1,
            i.scale.y or 1,
            orX,
            orY
        )
    end

    love.graphics.pop()

    Adore.lib.ui:draw()
end


function Adore:getRoots()
    local roots = {}
    for _, obj in ipairs(self.drawables) do
        if obj.parent == nil then
            table.insert(roots, obj)
        end
    end
    return roots
end

function Adore.randfRange(min, max)
    return min + math.random() * (max - min)
end

function Adore:printNode(node, depth)
    depth = depth or 0
    local indent = string.rep("  ", depth)

    print(indent .. "- " .. node.id)

    for _, child in ipairs(node.children) do
        Adore:printNode(child, depth + 1)
    end
end

function Adore:printTree()
    for _, root in ipairs(Adore:getRoots()) do
        Adore:printNode(root)
    end
end

function Adore:registerSprites()
    Adore.sprites = {}

    local function scanDir(dir)
        local items = love.filesystem.getDirectoryItems(dir)

        for _, item in ipairs(items) do
            local fullPath = dir .. "/" .. item
            local info = love.filesystem.getInfo(fullPath)

            if info then
                if info.type == "directory" then
                    scanDir(fullPath)

                elseif info.type == "file" and Adore.stringEndsWith(item, ".png") then
                    table.insert(Adore.sprites, {
                        path = fullPath,         
                        img  = love.graphics.newImage(fullPath)
                    })
                end
            end
        end
    end

    -- start at root sprites folder
    scanDir("sprites")
end


function Adore.stringEndsWith(str, suffix)
    return string.sub(str, -string.len(suffix)) == suffix
end

function Adore:findSprite(sprite)
    for _, img in ipairs(Adore.sprites) do
        if img.path:match(sprite.."$") then
            return img.img
        end
    end
    for _, img in ipairs(Adore.sprites) do
        if img.path:match("missing.png$") then
            return img.img
        end
    end
    return nil
end

local hovering = {}
function Adore:hoverDetection()
    hovering = {}
    for _,i in pairs(Adore.mouseDetectors) do
        local sx, sy = love.mouse.getPosition()
        local Mx, My = Adore:screenToWorld(sx, sy)

        local _, _, w, h = i.quad:getViewport()
        local hw = (w * i.scale.x) / 2
        local hh = (h * i.scale.y) / 2

        local left   = i.globalPos.x - hw
        local right  = i.globalPos.x + hw
        local top    = i.globalPos.y - hh
        local bottom = i.globalPos.y + hh

        if Mx > left and Mx < right and My > top and My < bottom then
            table.insert(hovering, i)
        end


    end

    function compare(a, b)
        return a.layer > b.layer
    end

    table.sort(hovering, compare)
end

function Adore:screenToWorld(sx, sy)
    local x, y = sx, sy

    x = x - love.graphics.getWidth() / 2
    y = y - love.graphics.getHeight() / 2

    local r = -math.rad(Adore.camera.rot)
    local cosr = math.cos(r)
    local sinr = math.sin(r)
    x, y = x * cosr - y * sinr, x * sinr + y * cosr

    x = x / Adore.camera.zoom
    y = y / Adore.camera.zoom

    x = x + Adore.camera.x + love.graphics.getWidth() / 2
    y = y + Adore.camera.y + love.graphics.getHeight() / 2

    return x, y
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


local screenDim = Vector2(800, 600)
local oldResize = love.resize
love.resize = function(screenX, screenY)
    
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

    if screenDim ~= nil then
        local diff = Vector2(screenX - screenDim.x, screenY - screenDim.y)

        Adore.camera.x = Adore.camera.x - diff.x / 2
        Adore.camera.y = Adore.camera.y - diff.y / 2

        screenDim = Vector2(screenX, screenY)
    end
    
    if oldResize then oldResize(w, h) end
end

return adore