
Pos = {
    x = 0,
    y = 0
}

function Pos:new(x,y)
    local p = {}
    if x and y then
        p.x = x
        p.y = y
    end
    self.__index = self
    setmetatable(p,Pos)
    return p
end

function Pos:__add(other)
    return Pos:new(self.x + other.x, self.y + other.y)
end

function Pos:__sub(other)
    return Pos:new(self.x - other.x, self.y - other.y)
end

function Pos:__unm()
    return Pos:new(-self.x, -self.y)
end