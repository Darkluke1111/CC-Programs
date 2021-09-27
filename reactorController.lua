args = {...}

config = {
  targetmB = 0
}

function main()
  readConfig()
  r = wrapReactor()
  controlReactor(r)
end

function readConfig()
  if args[1] then
    config.targetmB = tonumber(args[1])
    logInfo("Target mB is set to " .. config.targetmB)
  else
    logInfo("Target mB is set to default of " .. config.targetmB)
  end
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

function controlReactor(r)
  logInfo("Start controlling...")
  while true do
    yield()
    os.sleep(1)
    mBt = r.getHotFluidProducedLastTick()
    logInfo("mB/t: " .. mBt)
    if mBt > config.targetmB then
      adjustFuelRods(r,"up")
    else
      adjustFuelRods(r,"down")
    end
  end
end

function adjustFuelRods(r,direction)
  local maxLevel = -1
  local maxIndex = -1
  local minLevel = 101
  local minIndex = -1
  for index,level in pairs(r.getControlRodsLevels()) do
    if level > maxLevel then
      maxLevel = level
      maxIndex = index
    end
    if level < minLevel then
      minLevel = level
      minIndex = index
    end
  end
  if(direction == "up") then
    r.setControlRodLevel(minIndex, minLevel + 1)
  else
    r.setControlRodLevel(maxIndex, maxLevel - 1)
  end
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

function yield()
  os.queueEvent("fakeEvent");
  os.pullEvent();
end

main()
