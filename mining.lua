tState = {
  relPos = vector.new(),
  relDir = vector.new(1,0,0),
  loaderPosList = {},
  markedPos = {},
  torchLocations = {}
}

tConfig = {
  reservedSlots = {1,2,3},
  torchLimit = 10
}

UP = vector.new(0,1,0)
DOWN = vector.new(0,-1,0)

function forward()
  success = turtle.forward()
  if not success then return false
  else
    tState.relPos = tState.relPos + tState.relDir
    --write(textutils.serialize(tState))
    return true
  end
end

function up()
  success = turtle.up()
  if not success then return false
  else
    tState.relPos = tState.relPos + vector.new(0,1,0)
    return true
  end
end

function down()
  success = turtle.down()
  if not success then return false
  else
    tState.relPos = tState.relPos + vector.new(0,-1,0)
    return true
  end
end

function turnRight()
  tState.relDir = tState.relDir:cross(UP)
  turtle.turnRight()
end

function turnLeft()
  tState.relDir = tState.relDir:cross(DOWN)
  turtle.turnLeft()
end

function mineTunnel(length)
  while length>0 do
   success=false
   while not success do
     turtle.dig()
     success=forward()
   end
   turtle.digDown()
   if inventoryIsFull() then
     emptyInventory()
   end
   --if not isLit() then placeTorchDown() end
   length=length-1
 end
end

function mineRect(length,width)
  while length>0 do
    mineTunnel(width)
    if length%2==0 then
      turnLeft()
    else
      turnRight()
    end
    mineTunnel(1)
    if length%2==0 then
      turnLeft()
    else
      turnRight()
    end
    length=length-1
  end
end

function mineCube(length,width,height)
  for i = 1,height-1 do
    mineUp()
  end
  for i = 1, height/2 do
    markPos("levelStart")
    mineRect(length,width)
    gotoLocation(getMarkedPos("levelStart"))
    mineDown()
    mineDown()
  end
end

function mineUp()
  while not up() do
    turtle.digUp()
  end
end

function mineDown()
  while not down() do
    turtle.digDown()
  end
end

function mineChunk()
  mineRect(16,16)
  emptyInventory()
end

function mineChunks(n,h)
  loadChunk()
  while n > 0 do
    mineCube(5,5,h)
    loadChunk()
    unloadChunk()
    n = n-1
  end
  unloadChunk()
end

function emptyInventory()
  turtle.select(2)
  turtle.placeDown()

  for i=1,16 do
    if not contains(tConfig.reservedSlots, i) then
      turtle.select(i)
      turtle.dropDown()
    end
  end
  turtle.select(2)
  turtle.digDown()
end

function loadChunk()
  turtle.select(1)
  turtle.placeDown()
  table.insert(tState.loaderPosList, tState.relPos + vector.new())
end

function unloadChunk()
  turtle.select(1)
  markPos("endPos")
  gotoLocation(table.remove(tState.loaderPosList,1))
  turtle.digDown()
  gotoLocation(getMarkedPos("endPos"))
end

function gotoLocation(vector)
  while tState.relPos ~= vector do
    while (vector - tState.relPos - tState.relDir):length() < (vector - tState.relPos):length() do
      forward()
    end
    turnRight()
  end
end

function markPos(name)
  tState.markedPos[name] = tState.relPos
end

function getMarkedPos(name)
  return tState.markedPos[name]
end

function inventoryIsFull()
  for i = 1,16 do
    if turtle.getItemCount(i) == 0 then
      return false
    end
  end
  return true
end

function placeTorchDown()
  turtle.select(3)
  if turtle.placeDown() then
    table.insert(tState.torchLocations,tState.relPos - vector.new(0,-1,0))
    if #tState.torchLocations > tConfig.torchLimit then
      table.remove(tState.torchLocations,1)
    end
    return true
  else
    return false
  end
end

function isLit()
  pos = tState.relPos
  isLit = false
  for _,v in pairs(tState.torchLocations) do
    if stripY(pos - v):length() <= 7 then return true end
  end
  return false
end

function stripY(v)
  return vector.new(v.x,0,v.y)
end

function contains(list, elem)
  for _,v in pairs(list) do
    if v == elem then return true end
  end
  return false
end

mineChunks(10,5)
