
os.loadAPI("CC-Programs/util.lua")
os.loadAPI("CC-Programs/loggingLib.lua")
os.loadAPI("CC-Programs/chatControlLib.lua")
local cc =  chatControlLib
local log = loggingLib
local util = util


local me = peripheral.find("meBridge")

function handler(user, command, params)
    items = me.listItems()

    for _,item in pairs(items) do
        if item.name == params[2] then
            return "You have " .. item.amount .. " of " .. item.displayName
        end
    end
end

cc.listenForMessage(handler)