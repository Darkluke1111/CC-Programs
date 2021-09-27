


function openNetwork()
  for _,v in peripheral.getNames() do
    if peripheral.getType(v) == "modem" then
      rednet.open(v)
    end
  end
end

function logError(msg)
  writeC("[Error] ", colors.red)
  writeC(msg .. "\n", colors.white)
  rednet.broadcast({type = "Error", msg = msg}, "Logging")
end

function logInfo(msg)
  writeC("[Info] ", colors.yellow)
  writeC(msg .. "\n", colors.white)
  rednet.broadcast({type = "Info", msg = msg}, "Logging")
end

function writeC(text, color)
  local old = term.getTextColor()
  term.setTextColor(color)
  write(text)
  term.setTextColor(old)
end

function logNetwork()
  while true do
    local senderID, msg = rednet.receive("Logging", 10)
    if msg.type == "Error" then
      logError("[".. senderID .. "] " .. msg.msg)
    end
    if msg.type == "Info" then
      logInfo("[".. senderID .. "] " .. msg.msg)
    end
  end
end
