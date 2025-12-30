local bredBG = {}
bredBG.__index = bredBG

function bredBG.new(object)
    local self = setmetatable({}, bredBG)

    self.object = object
    self.dTimer = 0

    return self
end

function bredBG:load()
end


function bredBG:update(dt)
    self.dTimer = self.dTimer + dt
    local obj = self.object

    --No squashing for this one :( just boring linear scaling
    obj.scale.x = 5 + math.cos(self.dTimer) / 3
    obj.scale.y = 5 + math.cos(self.dTimer) / 3

end

return bredBG
