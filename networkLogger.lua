-- Simple Program that prints messages received by the network
-- Taks a cmd line parameter to specify minimal priority for messages to be printed

args = {...}

os.loadAPI("CC-Programs/util.lua")
os.loadAPI("CC-Programs/loggingLib.lua")
log = loggingLib

function main()
  loggingPrio = 20
  if args[1] then
    loggingPrio = tonumber(args[1])
  end

  log.setMinLoggingPrio(loggingPrio)
  log.logNetwork()
end

-- loggs messages received by the network (blocking)
function logNetwork()
  while true do
    local senderID, msg = rednet.receive("Logging", 10)
    if config.minLoggingPrio <= config.levels[loggingLevel].prio then
      util.writeC("[" .. msg.type .. "] ", config.levels[msg.type].color)
      util.writeC("(" .. senderID .. ") " .. msg .. "\n", colors.white)
    end
  end
end

main()
