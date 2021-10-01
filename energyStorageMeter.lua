args = {...}

os.loadAPI("CC-Programs/loggingLib.lua")

os.loadAPI("CC-Programs/util.lua")

local m
local e

local function main()
  m = util.connectToPeripheralType("monitor")
  e = util.connectToPeripheralType("mekanism:induction_port")

  term.redirect(m)
  local width, height = term.getSize()

  while true do
    local max = e.getEnergyCapacity()
    local cur = e.getEnergy()

    local res = cur / max * height

    paintutils.drawFilledBox(1,1,width,res)
  end
end

main()