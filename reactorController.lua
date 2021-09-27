args = {...}

os.loadAPI("CC-Programs/loggingLib.lua")
log = loggingLib

os.loadAPI("CC-Programs/util.lua")

config = {
  targetmB = 0
}

function main()
  log.openNetwork()
  readConfig()
  r = wrapReactor()
  controlReactor(r)
end

function readConfig()
  if args[1] then
    config.targetmB = tonumber(args[1])
    log.logInfo("Target mB is set to " .. config.targetmB)
  else
    log.logInfo("Target mB is set to default of " .. config.targetmB)
  end
end

function wrapReactor()
  for _,v in pairs(peripheral.getNames()) do
    if peripheral.getType(v) == "BigReactors-Reactor" then
      log.logInfo("Wrapping Reactor at " ..  v)
      return peripheral.wrap(v)
    end
  end
  logError(msg)
end

function controlReactor(r)
  logInfo("Start controlling...")
  while true do
    util.yield()
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

main()
