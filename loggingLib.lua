-- Configuration Table
config = {
  minLoggingPrio = 0,
  levels = {
    Debug = {
      color = colors.blue,
      prio = 0
    },
    Info = {
      color = colors.green,
      prio = 10
    },
    Warning = {
      color = colors.yellow,
      prio = 20
    },
    Error = {
      color = colors.red,
      prio = 30
    },
  }
}

-- Write text to the terminal in a color
local function writeC(text, color)
  local old = term.getTextColor()
  term.setTextColor(color)
  write(text)
  term.setTextColor(old)
end

-- local function taht handles logging to the terminal
local function log(loggingLevel, msg)
  if config.minLoggingPrio <= config.levels[loggingLevel].prio then
    writeC("[" .. loggingLevel .. "] ", config.levels[loggingLevel].color)
    writeC(msg .. "\n", colors.white)
    rednet.broadcast({type = loggingLevel, msg = msg}, "Logging")
  end
end

-- Sets the minimal priority for messages to be logged by this logger
function setMinLoggingPrio(prio)
  config.minLoggingPrio = prio
end

-- opens available networks for sending log messages
function openNetwork()
  for _,v in pairs(peripheral.getNames()) do
    if peripheral.getType(v) == "modem" then
      rednet.open(v)
    end
  end
end

-- Debug level logging
function debug(msg)
  log("Debug", msg)
end

-- Info level logging
function info(msg)
  log("Info", msg)
end

-- Warning level logging
function warning(msg)
  log("Warning", msg)
end

-- Error level logging
function error(msg)
  log("Error", msg)
end

-- loggs messages received by the network (blocking)
function logNetwork()
  while true do
    local senderID, msg = rednet.receive("Logging", 10)
    log(msg.type, "(" .. senderID .. ") " .. msg.msg)
  end
end
