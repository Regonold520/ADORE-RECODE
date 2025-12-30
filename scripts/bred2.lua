local bred = {}
bred.__index = bred

function bred.new(object)
    local self = setmetatable({}, bred)

    self.object = object
    self.dTimer = 0

    return self
end

function bred:load()
    print("im in the scene now:", self.object.id)
end

function bred:update(dt)
    self.dTimer = self.dTimer + dt
    local obj = self.object

    obj.localPos.y = math.cos(self.dTimer) * 100
end

return bred
