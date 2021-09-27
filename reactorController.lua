

function wrapReactor()
  for _,v in pairs(peripheral.getNames()) do
    if peripheral.getType(v) == "BigReactors-Reactor" then
      return peripheral.wrap(v)
    end
  end
  reportError(msg)
end

function reportError(msg)
  write(msg .. \n)
end
