args = {...}

os.loadAPI("CC-Programs/util.lua")
os.loadAPI("CC-Programs/loggingLib.lua")
local log = loggingLib
local util = util

local protocol =  "InvAccess"

local system, managed
local cache

function main()
    system, managed = connectToPeripherals()
    recalcCache()
    listenNetwork()
end

function connectToPeripherals()
    local system = util.connectToPeripheralTypeAll("appliedenergistics2:interface")
    -- local system = util.connectToPeripheralTypeAll("minecraft:chest")
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
    for _, v in pairs(system) do
        for i = 1, v.size() do
            table.insert(items, v.getItemDetail(i))
        end
    end
    return items
end

function recalcCache()
    local tmp = {}
    for _, v in pairs(system) do
        for i = 1, v.size() do
            local item = v.getItemDetail(i)
            if item then
                local entry = {
                    item = item,
                    inv = v,
                    slot = i
                }
                table.insert(tmp, entry)
            end
        end
    end

    cache = tmp
    log.debug("New cached Items: " .. textutils.serialize(util.mapTo(cache, "item")))
end

function makeAvailable(itemName, amount)
    for _, entry in pairs(cache) do
        if entry.item.name == itemName then
            log.debug("Pulling from " .. entry.inv.name .. " to " .. managed.name)
            local moved = entry.inv.pushItems(managed.name, entry.slot, amount)
            log.debug("Moved items: " .. moved)
            return
        end
    end
end

function emptyManagedInventory()
    for i = 1, managed.size() do
        managed.pushItems(system[1].name, i)
    end
end

function listenNetwork()
    log.debug("Starting Listening for requests...")
    while true do
        local senderID, msg = rednet.receive(protocol, 10)
        log.debug("Received a message from " .. senderID .. ":")
        log.debug(textutils.serialize(msg))

        emptyManagedInventory()
        for _, request in pairs(msg) do
            makeAvailable(request.item, request.amount)
        end
        rednet.send(senderID, 0, protocol)
    end
end

main()
