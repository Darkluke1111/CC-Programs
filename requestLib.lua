

os.loadAPI("CC-Programs/util.lua")
os.loadAPI("CC-Programs/loggingLib.lua")
local log = loggingLib
local util = util

local protocol =  "InvAccess"


function requestItem(name, amount)
    local request = {}
    request[1] = {
        item = name,
        amount =  amount
    }
    rednet.broadcast(request,protocol)
end

function requestItems(items)

    e