os.loadAPI("CC-Programs/util.lua")
local util = util

local chat = peripheral.find("chatBox")

local whitelist = {
    "Darkluke1111"
}

function listenForMessage(callback)
    while true do
        _, user, msg = os.pullEvent("chat")

        if util.contains(whitelist, user) then
            command  = split(msg, " ")
            response = callback(user, command[1], command)
            chat.sendMessageToPlayer(response,user,"InvManager")
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