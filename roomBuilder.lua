args = {...}

os.loadAPI("tt.lua")
os.loadAPI("loggingLib.lua")
log = loggingLib

coonfig = {
  size = vector.new()
}

function parseArgs()
  config.size = vector.new(tonumber(args[1]), tonumber(args[2]), tonumber(args[3]))
end

function placeBlockLine(dir,length)
  turtle.placeDown()
  for i = 1,length-1 do
    tt.move(dir,true)
    turtle.placeDown()
  end
end


function buildRoom()

end

