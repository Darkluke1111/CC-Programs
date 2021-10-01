
-- Concurrency --
function yield()
  os.queueEvent("fakeEvent");
  os.pullEvent();
end


-- Table Operations -- 

function contains(arr, elem)
  for _,v in pairs(arr) do
    if v == elem then return true end
  end
  return false
end

function map(arr,f)
  local newArr = {}
  for k,v in pairs(arr) do
    newArr[k] = f(v)
  end
  return newArr
end

function mapTo(arr, childname)
  return map(
    arr, 
    function(e) return e[childname] end
  )
end

-- arr has to be an array style table!
function filter(arr,filter)
  local newArr = {}
  for _,v in ipairs(arr) do
    if filter(v) then 
      table.insert(newArr,v)
    end
  end
  return newArr
end

-- Text Utils --

function writeC(text, color)
  local old = term.getTextColor()
  term.setTextColor(color)
  write(text)
  term.setTextColor(old)
end

-- Peripheral Utils --

function connectToPeripheralType(type)
  for _,v in pairs(peripheral.getNames()) do
    if peripheral.getType(v) ==  type then
      local p = peripheral.wrap(v)
      p.name = v
      return p
    end
  end
end

function connectToPeripheralTypeAll(type)
  local ps = {}
  for _,v in pairs(peripheral.getNames()) do
    if peripheral.getType(v) ==  type then
      local p = peripheral.wrap(v)
      p.name = v
      table.insert(ps,p)
    end
  end
  return ps
end
