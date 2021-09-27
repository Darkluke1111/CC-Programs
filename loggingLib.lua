
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

function setMinLoggingPrio(prio)
  config.minLoggingPrio = prio
end

function openNetwork()
  for _,v in pairs(peripheral.getNames()) do
    if peripheral.getType(v) == "modem" then
      rednet.open(v)
    end
  end
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

function logNetwork()
  while true do
    local senderID, msg = rednet.receive("Logging", 10)
    log(msg.type, "(" .. senderID .. ") " .. msg.msg)
  end
end

local function writeC(text, color)
  local old = term.getTextColor()
  term.setTextColor(color)
  write(text)
  term.setTextColor(old)
end

local function log(loggingLevel, msg)
  if config.minLoggingPrio <= config.levels[loggingLevel].prio then
    writeC("[" .. loggingLevel .. "] ", config.levels[loggingLevel].color)
    writeC(msg .. "\n", colors.white)
    rednet.broadcast({type = loggingLevel, msg = msg}, "Logging")
  end
end
