os.loadAPI("CC-Programs/util.lua")
local util = util

local chat = peripheral.find("chatBox")

local whitelist = {
    "Darkluke1111"
}

function listenForMessage()
    while true do
        _, user, msg = os.pullEvent("chat")

        if util.contains(whitelist, user) then
            command  = split(msg)
            os.queueEvent("command", user, command[1], command)
        end
    end
end

function split(s, delimiter)
    local result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end