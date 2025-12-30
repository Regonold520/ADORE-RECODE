local uiTest = {}
uiTest.__index = uiTest

function uiTest.new(object)
    local self = setmetatable({}, uiTest)

    self.object = object
    self.dTimer = 0

    return self
end


function uiTest:mousePressed()
    print("am i hath work?")
end

return uiTest
