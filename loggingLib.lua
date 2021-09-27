
config = {
  levels = {
    Debug = {
      color = colors.blue
    },
    Info = {
      color = colors.green
    },
    Warning = {
      color = colors.yellow
    },
    Error = {
      color = colors.red
    },
  }
}

function openNetwork()
  for _,v in pairs(peripheral.getNames()) do
    if peripheral.getType(v) == "modem" then
      rednet.open(v)
    end
  end
end

local function log(loggingLevel, msg)
  writeC("[" .. loggingLevel .. "] ", config.levels[loggingLevel].color)
  writeC(msg .. "\n", colors.white)
  rednet.broadcast({type = loggingLevel, msg = msg}, "Logging")
end

function debug(msg)
  log("Debug", msg)
end

function info(msg)
  log("Info", msg)
end

function warning(msg)
  log("Warning", msg)
end

function error(msg)
  log("Error", msg)
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
    log(msg.type, "(" .. senderID .. ") " .. msg.msg)
  end
end
