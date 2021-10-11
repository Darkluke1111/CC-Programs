os.loadAPI("CC-Programs/loggingLib.lua")
local log = loggingLib

local m = peripheral.find("monitor")

local height, width = m.getSize()
local bgc = colors.black
local fgc = colors.red

local Button = {
    width = 10,
    height = 5,
    text = "Button",
    color = bgc
}

m.setTextScale(0.5)

function Button.new(width, height, text, color)
    local button = {}
    setmetatable(button,Button)
    button.width = width
    button.height = height
    button.text = text
    button.color = color
end

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
    local xMid = math.floor(pos.x + width / 2) +1
    local yMid = math.floor(pos.y + height/ 2) +1
    local xTextStart = math.floor(xMid - tw/2)

    m.setBackgroundColor(b.color)
    for i = pos.y, pos.y + height do
        local j = pos.x
        while j <= pos.x + width do
            if i == yMid and j == xTextStart then
                m.setCursorPos(j, i)
                m.write(text)
                j = j+tw
            else
                m.setCursorPos(j, i)
                m.write(" ")
                j = j+1
            end
        end
    end
end
