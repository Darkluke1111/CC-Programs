args = {...}

os.loadAPI("loggingLib.lua")
log = loggingLib

os.loadAPI("util.lua")

local m
local e

function main()
  m = util.connectToPeripheralType("monitor")
  e = util.connectToPeripheralType("energy_storage")

  term.redirect(m)
  width, height = term.getSize()

  while true do
    max = e.getEnergyCapacity()
    cur = e.getEnergy()

    res = cur / max * height

    paintutils.drawFilledBox(1,1,width,res)
  end
end

main()