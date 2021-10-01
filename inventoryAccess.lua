args = {...}

os.loadAPI("CC-Programs/util.lua")
os.loadAPI("CC-Programs/loggingLib.lua")
local log = loggingLib
local util = util

local system, managed

function main()
    system, managed = connectToPeripherals()
    log.debug(textutils.serialize(getAvailableItems(system)))
    makeAvailable("minecraft:cobblestone", 1)
end

function connectToPeripherals()
    local system = util.connectToPeripheralTypeAll("appliedenergistics2:interface")
    log.debug("Connected to " .. #system .. " Interfaces")
    local managed = util.connectToPeripheralType("enderstorage:ender_chest")
    if managed then
        log.debug("Connected to an ender chest at " .. managed.name)
    else
        log.error("No ender chest connected!")
    end
    return system, managed
end

function getAvailableItems()
    local items = {}
    for _,v in pairs(system) do
        for i = 1,v.size() do
            table.insert(items,v.wrap.getItemDetail(i))
        end
    end
    return items
end

function makeAvailable(itemName, amount)
    for _,v in pairs(system) do
        for i = 1,v.size() do
            local item = v.getItemDetail(i)
            if item.name == itemName then
                v.pullItem(managed.name,i,amount)
            end
        end
    end
end

function listenNetwork()
    local senderID, msg = rednet.receive("InvAccess", 10)
    log.debug("Received a message from " .. senderID)
end

main()
