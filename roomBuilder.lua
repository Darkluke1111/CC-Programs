args = {...}

os.loadAPI("CC-Programs/tt.lua")
os.loadAPI("CC-Programs/loggingLib.lua")
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
    turtle.digDown()
    turtle.placeDown()
  end
end

function placeFloor(length, width)
  placeBlockLine(tt.NORTH,length)
  for i = 1, width - 1 do
    tt.move(tt.EAST,true)
    if i%2 == 0 then
      placeBlockLine(tt.NORTH,length)
    else
      placeBlockLine(tt.SOUTH,length)
    end
  end
end

function placeWall(dir,length, height)
  placeBlockLine(dir,length)
  for i = 1,height-1 do
    tt.move(tt.UP,true)
    dir = - dir
    placeBlockLine(dir,length)
  end
end

function placeRectWall(length, width, height)
  placeBlockLine(tt.NORTH,length)
  placeBlockLine(tt.EAST,length)
  placeBlockLine(tt.SOUTH,length)
  placeBlockLine(tt.WEST,length)

  for i = 1,height-1 do
    tt.move(tt.UP,true)
    placeBlockLine(tt.NORTH,length)
    placeBlockLine(tt.EAST,length)
    placeBlockLine(tt.SOUTH,length)
    placeBlockLine(tt.WEST,length)
  end
end

function placeRoom(length, width, height)
  startPos = tt.tts.pos
  placeFloor(length,height)
  tt.pathFindTo(startPos + tt.UP)
  placeRectWall(length, width, height - 2)
  tt.pathFindTo(startPos + (tt.UP * (height - 1)))
  placeFloor(length,height)
end


