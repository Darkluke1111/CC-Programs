

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
  write("[Error]" .. msg .. "\n")
end

function logInfo(msg)
  write("[Info]" .. msg .. "\n")
end
