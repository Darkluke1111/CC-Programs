os.loadAPI("CC-Programs/loggingLib.lua")
local log = loggingLib

local m = peripheral.find("monitor")

local height, width = m.getSize()
local bgc = colors.black
local fgc = colors.red

m.setTextScale(0.5)

-- ###### GUI ###### --
Gui = {
    root = nil
}

function Gui:new(root)
    local gui = {
        root = root
    }
    self.__index = self
    setmetatable(gui, Gui)
    return gui
end

function Gui:start()
    self.root:draw({x=1,y=1})

    while true do
        _, _, x, y = os.pullEvent("monitor_touch")
        self:handleTouch(x, y)
        self.root:draw({x=1,y=1})
    end
end

function Gui:handleTouch(x, y)
    log.debug("Touch at x:" .. x .. " y:" .. y)
    self.root:handleClick({x=x,y=y})
end

-- ###### Pane ###### --

Pane = {
    width = 0,
    height = 0,
    color = bgc
}

function Pane:new(width, height, color)
    local pane = {
        width = width,
        height = height,
        color = color,
        children = {}
    }
    self.__index = self
    setmetatable(pane, Pane)
    return pane
end

function Pane:draw(pos)
    for _, child in pairs(self.children) do
        local c = child.child
        local p = child.pos
        c:draw({x = pos.x + p.x, y = pos.y + p.y})
    end
end

function Pane:handleClick(pos)
    for _, child in pairs(self.children) do
        local c = child.child
        local p = child.pos
        if x >= p.x and x <= p.x + c.width and y >= p.y and y <= p.y + c.height then
            c:handleClick({x = x - p.x, y = y - p.y})
        end
    end
end

-- ###### Button ###### --

Button = Pane:new(10, 3, bgc)

function Button:new(width, height, text, color)
    local button = {
        width = width,
        height = height,
        text = text,
        color = color
    }
    self.__index = self
    setmetatable(button, Button)
    return button
end

function Button:handleClick(pos)
    log.debug("The button '" .. self.text .. "' was clicked!")
end

function Button:draw(pos)
    drawButton(self, pos)
end

-- ###### VBox ###### --

VBox = Pane:new(10, 10, colors.black)

function VBox:new(width, height, color)
    local vBox = {
        width = width,
        height = height,
        color = color,
        children = {}
    }
    self.__index = self
    setmetatable(vBox, VBox)
    return vBox
end

function VBox:addChild(pane)
    pane.width = self.width

    local nextY = 1
    for _, child in pairs(self.children) do
        local yEnd = child.pos.y + child.child.height + 1
        nextY = yEnd > nextY and yEnd or nextY
    end
    table.insert(
        self.children,
        {
            pos = {x = 2, y = nextY + 1},
            child = pane
        }
    )
end

-- ###### DrawPane ##### --

DrawPane = Pane:new()

function DrawPane:new(width, height)
    local drawPane = {
        width = width,
        height = height,
        colored = {}
    }
    self.__index = self
    setmetatable(drawPane, DrawPane)
    return drawPane
end

function DrawPane:draw(pos)
    for i = 1, self.height do
        for j = 1, self.width do
            m.setCursorPos(pos.x + j, pos.y + i)
            local color = self.colored[flatten({x=j+1,y=i+1},self.width)] or colors.black
            m.setBackgroundColor(color)
            m.write(" ")
        end
    end
end

function DrawPane:handleClick(pos)
    if self.colored[flatten(pos,self.width)] == colors.red then
        self.colored[flatten(pos,self.width)] = colors.black
    else
        self.colored[flatten(pos,self.width)] = colors.red
    end
end

-- ###### statics ##### --

function clear()
    m.setBackgroundColor(bgc)
    m.clear()
end

function drawRect(xMin, yMin, xMax, yMax, color)
    if not color then
        color = fgc
    end
    m.setBackgroundColor(color)
    for i = yMin, yMax do
        for j = xMin, xMax do
            m.setCursorPos(j, i)
            m.write(" ")
        end
    end
end

function flatten(pos,w)
    return pos.x + pos.y*w
end

function drawButton(b, pos)
    local text = b.text
    local width = b.width
    local height = b.height
    if #text > width then
        local newLength = width - 3 > 0 and width - 3 or 0
        text = string.sub(text, 1, newLength)
        while #text < width do
            text = text .. "."
        end
    end

    local tw = #text
    log.debug("Textlength: " .. tw)
    local xMid = math.floor(pos.x + width / 2) + 1
    local yMid = math.floor(pos.y + height / 2) + 1
    local xTextStart = math.floor(xMid - tw / 2)

    m.setBackgroundColor(b.color)
    for i = pos.y, pos.y + height do
        local j = pos.x
        while j <= pos.x + width do
            if i == yMid and j == xTextStart then
                m.setCursorPos(j, i)
                m.write(text)
                j = j + tw
            else
                m.setCursorPos(j, i)
                m.write(" ")
                j = j + 1
            end
        end
    end
end
