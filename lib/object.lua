local object = {}

local adore = Adore

function object:new(quad, fileName, newPos, id, layer, scriptPath)
    scriptPath = scriptPath or nil

    local obj = {
        quad = quad,
        drawable = adore:findSprite(fileName),
        globalPos = Vector2(newPos.x, newPos.y),
        localPos  = Vector2(newPos.x, newPos.y),
        rot = 0,
        scale = Vector2(4),
        id = id,
        layer = layer,
        script = nil,
        tags = {},
        parent = nil,
        children = {}
    }

    setmetatable(obj, self)
    self.__index = self

    if scriptPath ~= nil then
        local ScriptClass = require(scriptPath)
        if ScriptClass ~= nil then
            local scriptInstance = ScriptClass.new(obj)

            obj.script = scriptInstance
            table.insert(adore.updateables, obj)

            if scriptInstance.load ~= nil then
                scriptInstance:load()
            end
        end
    end


    table.insert(adore.drawables, obj)
    adore.needsSort = true

    return obj
end

function object:addTag(tag)
    table.insert(self.tags, tag)
end

function object:hasTag(tag)
    for _,i in ipairs(self.tags) do
        if i == tag then
            return true
        end
    end
    return false
end

function object:setMouseDetectable(state)
    if state == true then
        Adore.mouseDetectors[self.id] = self
    else
        Adore.mouseDetectors[self.id] = nil
    end
end


function object:addChild(obj)
    table.insert(self.children, obj)
    obj.parent = self
end

function object:getChildren()
    return self.children
end

function object:findChild(childToFind)
    for _,i in ipairs(self.children) do
        if i.id == childToFind then return i end
    end
    return nil
end

function object:getChildCount()
    return #self.children
end

function object:setGlobalPosition(newPos)
    if self.parent then
        self.parent:updateGlobalTransform()
        self.localPos.x = newPos.x - self.parent.globalPos.x
        self.localPos.y = newPos.y - self.parent.globalPos.y
    else
        self.localPos.x = newPos.x
        self.localPos.y = newPos.y
    end
end

function object:updateGlobalTransform()
    if self.parent then
        self.globalPos.x = self.parent.globalPos.x + self.localPos.x
        self.globalPos.y = self.parent.globalPos.y + self.localPos.y
    else
        self.globalPos.x = self.localPos.x
        self.globalPos.y = self.localPos.y
    end

    for _, child in ipairs(self.children) do
        child:updateGlobalTransform()
    end
end





return object
