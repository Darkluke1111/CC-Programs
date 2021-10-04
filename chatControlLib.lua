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
            chat.sendMessageToPlayer("Received your message!", user, "Your buddy")
        end
    end
end

listenForMessage()