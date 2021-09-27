
function main()
  r = wrapReactor()
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
  writeC("[Error] ", colors.yellow)
  writeC(msg .. "\n", colors.white)
end

function writeC(text, color)
  local old = term.getTextColor()
  term.setTextColor(color)
  write(text)
  term.setTextColor(old)
end

main()
