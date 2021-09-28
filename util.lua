function yield()
  os.queueEvent("fakeEvent");
  os.pullEvent();
end

function contains(arr, elem)
  for _,v in pairs(arr) do
    if v == elem then return true end
  end
  return false
end
