os.loadAPI("CC-Programs/util.lua")
os.loadAPI("CC-Programs/loggingLib.lua")
log = loggingLib


-- All coordinates and directions are realtive to the turtles starting postion.
-- Turtles ALWAYS start at 0,0,0 looking north (1,0,0)

UP = vector.new(0,1,0)
DOWN = vector.new(0,-1,0)
NORTH = vector.new(1,0,0)
SOUTH = vector.new(-1,0,0)
EAST = vector.new(0,0,1)
WEST = vector.new(0,0,-1)
ZERO = vector.new(0,0,0)

-- State of the turtle
tts = {
  -- look direction
  dir = vector.new(1,0,0),
  -- position
  pos = vector.new(0,0,0),
  visited = { ZERO },
  digged = {},
  -- positions of currently placed chunkloaders
  loadedChunks = {}
}

-- Config
-- The turtle should be supplied with those items in the those slots for some
-- functions to work properly
ttc = {
  reservedSlots = {
    chunkLoaderSlot = 1,
    enderChestSlot = 2,
    torchSlot = 3
  }
}

local function setPos(newPos)
  tts.pos = newPos
end

local function movePos(direction)
  setPos(tts.pos + direction)
end

directions = {NORTH,EAST,UP,SOUTH,WEST,DOWN}

-- moves the trutle in the specified direction (Possibly turning it in the process)
-- digging: Optional, if true makes the turtle dig out block in the way
function move(direction, digging)
  -- s: Was the move successfull
  local s = false 
  if direction == UP then
    s = up(digging)
  elseif direction == DOWN then
    s = down(digging)
  else
    turn(direction)
    s = forward(digging)
  end
  return s
end

-- digs a tunnel in the specified direction with the specified length
-- up: if true digs out all blocks above the turtle
-- down: if true digs out all blocks below the turtle
function digTunnel(direction,length,up,down)

  local callback = function()
    if up then digUp() end
    if down then digDown() end
  end

  callback()
  for i= 1,length do
    if move(direction,true) then 
      callback() 
    end
    if inventoryIsFull() then
      emptyInventoy()
    end
  end
end

-- Similar to move(...)
function forward(digging)
  local success = false
  if not digging then
    success = turtle.forward()
  else
    while not success do
      dig()
      success = turtle.forward()
    end
  end
  if success then
    movePos(tts.dir)
    return true
  else
    return false
  end
end

-- Similar to move(...)
function up(digging)
  local success = false
  if not digging then
    success = turtle.up()
  else
    while not success do
      digUp()
      success = turtle.up()
    end
  end
  if success then
    movePos(UP)
    return true
  else
    return false
  end
end

-- Similar to move(...)
function down(digging)
  local success = false
  if not digging then
    success = turtle.down()
  else
    while not success do
      digDown()
      success = turtle.down()
    end
  end
  if success then
    movePos(DOWN)
    return true
  else
    return false
  end
end

-- wrapper for dig
function dig()
  turtle.dig()
end

-- wrapper for dig
function digUp()
  turtle.digUp()
end

-- wrapper for dig
function digDown()
  turtle.digDown()
end

-- wrapper for turn
function turnRight()
  turtle.turnRight()
  tts.dir = tts.dir:cross(UP)
end

-- wrapper for turn
function turnLeft()
  turtle.turnLeft()
  tts.dir = tts.dir:cross(DOWN)
end

-- turn to the specified direction
function turn(direction)
  direction = stripY(direction)
  if     direction:cross(UP)   == tts.dir then
    turnLeft()
  elseif direction:cross(DOWN) == tts.dir then
    turnRight()
  elseif (direction + tts.dir):length()   == 0       then
    turnRight()
    turnRight()
  end
end

-- remove y component of a vector
function stripY(v)
  return vector.new(v.x,0,v.z)
end

-- prints the state of the turtle to the terminal
function printState()
  write(textutils.serialize(tts))
end

-- turtle tries to reach the specified position.
-- digging (Optional) if set to true the turtle will mine blocks in its way
-- callback (Optional) executed after every successfull move
function pathFindTo(pos, digging, callback)
  visited = {}
  while tts.pos ~= pos do
    table.insert(visited, tts.pos)
    _moves = {unpack(directions)}
    function comp(x,y)
      return (pos - tts.pos - x):length() < (pos - tts.pos - y):length()
    end
    table.sort(_moves, comp)
    for _,m in pairs(_moves) do
      if not util.contains(visited,tts.pos + m) then
        if move(m, digging) then 
          if callback then callback() end
          break 
        end
      end
    end
  end
end

-- The turtle will mine out a cube with the specified size
-- TODO: Does probably not work with negative sizes yet?
function mineCube(x,y,z)
  startPos = tts.pos
  endPos = tts.pos + vector.new(x,y,z)
  while tts.pos.y < endPos.y-2 do
    move(UP,true,digUp)
  end
  for j = 1,y/3 do
    levelPos = tts.pos
    for i = 1,z do
      if i % 2 == 1 then
        digTunnel(NORTH,x-1,true,true)
      else
        digTunnel(SOUTH,x-1,true,true)
      end
      if i ~= z then
        digTunnel(EAST,1,true,true)
      end
    end
    pathFindTo(levelPos)
    turn(NORTH)
    if j ~= y/3 then
      move(DOWN,true)
      move(DOWN,true)
      move(DOWN,true)
    end
  end
  pathFindTo(startPos,true)
  turn(NORTH)
end

-- Reset starting position/direction to current position/direction (for testing)
function reset()
  tts = {
    dir = vector.new(1,0,0),
    pos = vector.new(0,0,0)
  }
end

-- Select the inventoryslot containing an item with the specified name
function selectItem(name)
  for i = 1,16 do
    local item = turtle.getItemDetail(i)
    if item and item.name == name then
      turtle.select(i)
      return i
    end
  end
  return nil
end

-- Epties all slots except reserved slots into an enderchest
-- Digs out the block beneath the turtle to make room for the chest
function emptyInventoy()
  digDown()
  turtle.select(ttc.reservedSlots.enderChestSlot)
  success = turtle.placeDown()
  if not success then
    log.error("Unable to place Chest")
    return false
  end
  for i = 1,16 do
    if not util.contains(ttc.reservedSlots,i) then
      turtle.select(i)
      turtle.dropDown()
    end
  end
  turtle.select(ttc.reservedSlots.enderChestSlot)
  digDown()
  return true
end

-- Tests whether all not reserved slots are full
function inventoryIsFull()
  for i = 1,16 do
    if (not util.contains(ttc.reservedSlots,i)) and (turtle.getItemCount(i) == 0) then
      return false
    end
  end
  return true
end

-- Places a chunkloader to load the 9 chunks around. Remembers its position.
-- Digs out the block beneath the turtle to make room for the chunkloader
function loadChunk()
  turtle.select(ttc.reservedSlots.chunkLoaderSlot)
  digDown()
  success = turtle.placeDown()
  if not success then
    log.error("Unable to load Chunk")
    return false
  end
  table.insert(tts.loadedChunks,tts.pos + DOWN)
end

-- Removes the oldest remembered chunkloader. The turtle will return to its original position
-- after removing the chunkloader
function unloadOldestChunk(digging)
  currentPos = tts.pos
  currentDir = tts.dir
  loader = table.remove(tts.loadedChunks,1)
  pathFindTo(loader + UP,digging)
  turtle.select(ttc.reservedSlots.chunkLoaderSlot)
  if not turtle.compareDown() then
    sendError("Unable to unload Chunk")
    return false
  end
  digDown()
  pathFindTo(currentPos,digging)
  turn(currentDir)
  return true
end

-- mines n chunks (with 21 height) into the direction the turtle faces
function mineTheWorld(n)
  log.openNetwork()
  loadChunk()
  for i = 1,n do
    mineCube(16,21,16)
    pathFindTo(tts.pos + vector.new(16,0,0), true)
    emptyInventoy()
    loadChunk()
    unloadOldestChunk()
  end
  unloadOldestChunk()
  emptyInventoy()
end
