args = {...}

os.loadAPI("CC-Programs/util.lua")
os.loadAPI("CC-Programs/loggingLib.lua")
local log = loggingLib
local util = util

function main()
    local system, managed = connectToPeripherals()
end

function connectToPeripherals()
    local system = util.connectToPeripheralTypeAll("appliedenergistics2:interface")
    log.debug("Connected to " .. #system .. " Interfaces")
    local managed = util.connectToPeripheralType("enderstorage:ender_chest")
    if managed then
        log.debug("Connected to an ender chest")
    else
        log.error("No ender chest connected!")
    end
    return system, managed
end

function listenNetwork()
    local senderID, msg = rednet.receive("InvAccess", 10)
    log.debug("Received a message from " .. senderID)
end

main()
