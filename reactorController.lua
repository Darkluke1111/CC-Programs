config = {
  targetmB = 0
}

function main()

  r = wrapReactor()
end

function readConfig()
  args = {...}
  if args[1] then
    config.targetmB = args[1]
    logInfo("Target mB is set to " .. config.targetmB)
  else
    logInfo("Target mB is set to default of " .. config.targetmB)
end

function wrapReactor()
  for _,v in pairs(peripheral.getNames()) do
    if peripheral.getType(v) == "BigReactors-Reactor" then
      logInfo("Wrapping Reactor at " ..  v)
      return peripheral.wrap(v)
    end
  end
  logError(msg)
end

function logError(msg)
  writeC("[Error] ", colors.red)
  writeC(msg .. "\n", colors.white)
end

function logInfo(msg)
  writeC("[Info] ", colors.yellow)
  writeC(msg .. "\n", colors.white)
end

function writeC(text, color)
  local old = term.getTextColor()
  term.setTextColor(color)
  write(text)
  term.setTextColor(old)
end

main()
