local bred = {}
bred.__index = bred

function bred.new(object)
    local self = setmetatable({}, bred)

    self.object = object
    self.dTimer = 0

    return self
end

function bred:load()
end

local breadCount = 0 --I mean, pretty self explanatory, its the COUNT of BREAD :)
local changeScale = 0 --The scale modifier when you click on the bread

function bred:update(dt)
    self.dTimer = self.dTimer + dt --Keep constant deltaTimer going so that the sin and cos stuff runs forever

    local obj = self.object --The object this script is attached to

    Adore.ui.objects.breadText.drawable:set("Bread: " .. tostring(breadCount)) --References and then replaces the text of the bread display text
    
    --This block of stuff just returns changeScale to 0 if modified
    if changeScale > 0 then
        changeScale = changeScale - (dt*8)
    elseif changeScale < 0 then
        changeScale = 0
    end

    --Funny squash and stretch on the bread object
    obj.scale.x = (6 - changeScale) + math.cos(self.dTimer) / 1.5
    obj.scale.y = (6 - (changeScale/2)) + math.sin(self.dTimer) / 1.5

end

function bred:mouseReleased()
    --Im not explaining these, I trust that youre smart enough :)
    changeScale = 1.5 
    breadCount = breadCount + 1
    Adore.camera.rot = Adore.randfRange(-25,25)
end

return bred
