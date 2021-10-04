os.loadAPI("CC-Programs/chatControlLib.lua")
local cc =  chatControlLib

os.loadAPI("CC-Programs/util.lua")
local util = util

os.loadAPI("CC-Programs/loggingLib.lua")
local log = loggingLib

local me = peripheral.find("meBridge")
local playerInv = peripheral.find("inventoryManager")

function handler(user, command, params)
    if command == "pull" then
        pullItem(params[2], tonumber(params[3]))
    end
end

function pullItem(item, count)
    me.exportItem({name = item, count = count}, "NORTH")
    playerInv.addItemToPlayer("SOUTH",count,-1,item)
end

cc.listenForMessage(handler)
