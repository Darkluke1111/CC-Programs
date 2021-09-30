args = {...}

os.loadAPI("CC-Programs/loggingLib.lua")
log = loggingLib

os.loadAPI("CC-Programs/util.lua")

local m
local e

function main()
  m = util.connectToPeripheralType("monitor")
  e = util.connectToPeripheralType("mekanism:induction_port")

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