os.loadAPI("CC-Programs/loggingLib.lua")
local log = loggingLib

local m = peripheral.find("monitor")

local height, width = m.getSize()
local bgc = colors.black
local fgc = colors.red

m.setTextScale(0.5)

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

function drawButton(xMin, yMin, xMax, yMax, text, color)
    if not color then
        color = fgc
    end
    if not text or text == "" then
        log.debug("No text provided!")
        drawRect(xMin, yMin, xMax, yMax, color)
    end

    local bw = xMax - xMin
    if #text > bw then
        local newLength = bw - 3 > 0 and bw - 3 or 0
        text = string.sub(text, 1, newLength)
        while #text < bw do
            text = text .. "."
        end
    end

    local tw = #text
    log.debug("Textlength: " .. tw)
    local yMid = math.floor((yMin + yMax) / 2)
    local xTextStart = math.floor(xMin + tw/2)

    m.setBackgroundColor(color)
    for i = yMin, yMax do
        local j = xMin
        while j <= xMax do
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
