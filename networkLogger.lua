args = {...}


os.loadAPI("CC-Programs/loggingLib.lua")
log = loggingLib

main()


function main()
  loggingPrio = 20
  if args[1] then
    loggingPrio = args[1]
  end

  log.setMinLoggingPrio(loggingPrio)
  log.openNetwork()
  log.logNetwork()
end
