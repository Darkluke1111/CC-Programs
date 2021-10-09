os.loadAPI("CC-Programs/chatControlLib.lua")
local cc = chatControlLib

os.loadAPI("CC-Programs/util.lua")
local util = util

os.loadAPI("CC-Programs/loggingLib.lua")
local log = loggingLib

local me = peripheral.find("meBridge")
local ar = peripheral.find("arController")

local craftingGoals = {
    {
        name = "minecraft:stick",
        count = 64
    }
}

function autocrafter()
    while true do
        for _,v in pairs(craftingGoals) do
            recraft(v)
        end
        sleep(10)
    end
end

function recraft(craftingGoal)
    -- check whether item is craftable
    local craftable =  false
    local meItem
    for _,item in pairs(me.listCraftableItems()) do
        if item.name == craftingGoal.name then
            craftable = true
            meItem = item
        end
    end
    if craftable == false then return end

    -- check whether the item is already being crafted
    if me.isItemCrafting(meItem) then return end

    -- check how many items are already there
    local craftAmount = craftingGoal.count
    for _,item in pairs(me.listItems()) do
        if item.name == craftingGoal.name then
            craftAmount = craftAmount - item.amount
        end
    end

    if craftAmount <= 0 then return end

    meItem.count = craftAmount
    --log.debug(textutils.serialize(meItem))
    me.craftItem(meItem)
    log.info("Crafting " .. craftAmount .. " of ".. craftingGoal.name)
end

autocrafter()
