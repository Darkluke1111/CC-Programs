-- Simple Program that prints messages received by the network
-- Taks a cmd line parameter to specify minimal priority for messages to be printed

args = {...}

os.loadAPI("CC-Programs/util.lua")
os.loadAPI("CC-Programs/loggingLib.lua")
log = loggingLib

function main()
  local loggingPrio = 20
  if args[1] then
    loggingPrio = tonumber(args[1])
  end

  while true do
    local senderID, msg = rednet.receive("Logging", 10)
    if msg then
      if loggingPrio <= log.config.levels[msg.type].prio then
        util.writeC("[" .. msg.type .. "] ", log.config.levels[msg.type].color)
        util.writeC("(" .. senderID .. ") " .. msg.msg .. "\n", colors.white)

        log.logFileHandle.writeLine("[" .. msg.type .. "] (" .. senderID .. ") ".. msg.msg)
        log.logFileHandle.flush()
      end
    end
  end

end

main()
