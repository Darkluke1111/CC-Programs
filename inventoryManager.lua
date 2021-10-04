os.loadAPI("CC-Programs/chatControlLib.lua")
local cc =  chatControlLib

os.loadAPI("CC-Programs/util.lua")
local util = util

os.loadAPI("CC-Programs/loggingLib.lua")
local log = loggingLib

local me = peripheral.find("meBridge")
local playerInv = peripheral.find("inventoryManager")

function handler(user, command, params)
    if playerInv.getOwner() ~= user then
        return "There is no access to your Inventory!"
    end
    if command == "pull" then
        local amount = pullItem(params[2], tonumber(params[3]))
        return tostring(amount) .. " items were moved"
    elseif command == "push" then
        local amount = pushItem(params[2], tonumber(params[3]))
        return tostring(amount) .. " items were moved"
    end

    return "An unknown Error has occured!"
end

function pullItem(item, count)
    me.exportItem({name = item, count = count}, "NORTH")
    playerInv.addItemToPlayer("SOUTH",count,-1,item)
end

function pushItem(item, count)
    playerInv.removeItemFromPlayer("SOUTH", count, -1, item)
    me.importItem({name = item, count = count}, "NORTH")
end

cc.listenForMessage(handler)
