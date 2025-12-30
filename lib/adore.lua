local adore = {}

Adore = {}
Adore.lib = {}

Adore.searchPath = "sprites"
Adore.sprites = {}
Adore.drawables = {}
Adore.updateables = {}
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

    local bred = Adore.lib.object:new(love.graphics.newQuad(0,0,32,32,32,32), "bread1.png",Vector2(love.graphics.getWidth()/2,love.graphics.getHeight()/2), "bred", 0)
    local bred2 = Adore.lib.object:new(love.graphics.newQuad(0,0,32,32,32,32), "bread2.png",Vector2(100,0), "bred2", 1, "scripts/bred2")
    local bred3 = Adore.lib.object:new(love.graphics.newQuad(0,0,32,32,32,32), "bread3.png",Vector2(0,100), "bred3", 2, "scripts/bred")

    bred:addChild(bred2)
    bred2:addChild(bred3)

    Adore:printTree()
end
local dTimer = 0
function adore:update(dt)
    dTimer = dTimer + dt
    Adore.lib.ui:update(dt)

    Adore.camera.x = math.sin(dTimer) * 40
    Adore.camera.y = math.cos(dTimer) * 40
    Adore.camera.zoom = 1 + math.sin(dTimer) / 10
    Adore.camera.rot = Adore.camera.rot + dt * 5

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
    local items = love.filesystem.getDirectoryItems("sprites")

    

    local dirs = {}

    for _, item in ipairs(items) do
        local fullPath = "sprites/" .. item

        if love.filesystem.getInfo(fullPath, "directory") then
            table.insert(dirs, fullPath)
        end
    end

    for _, dir in ipairs(dirs) do
        for i, img in ipairs(love.filesystem.getDirectoryItems(dir)) do
            if Adore.stringEndsWith(img, ".png") then
                table.insert(Adore.sprites, {
                    path = img,
                    img = love.graphics.newImage(dir .. "/" .. img)
                })
            end
        end
    end
end

function Adore.stringEndsWith(str, suffix)
    return string.sub(str, -string.len(suffix)) == suffix
end

function Adore:findSprite(sprite)
    for _, img in ipairs(Adore.sprites) do
        if img.path == sprite then
            return img.img
        elseif _ == #Adore.sprites then
            return Adore:findSprite("missing.png")
        end
    end
end

return adore