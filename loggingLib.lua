os.loadAPI("CC-Programs/util.lua")

-- Configuration Table
config = {
  logFileName = "log.txt",
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

local function init()
  logFileHandle = fs.open(config.logFileName, fs.exists(config.logFileName) and "a" or "w")
  openNetwork()
end

-- local function taht handles logging to the terminal
local function log(loggingLevel, msg)
  if config.minLoggingPrio <= config.levels[loggingLevel].prio then
    -- write to terminal
    util.writeC("[" .. loggingLevel .. "] ", config.levels[loggingLevel].color)
    util.writeC(msg .. "\n", colors.white)
    -- write to network
    rednet.broadcast({type = loggingLevel, msg = msg}, "Logging")
    -- write to logFile
    logFileHandle.writeLine("[" .. loggingLevel .. "] " .. msg)
    logFileHandle.flush()
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

init()
