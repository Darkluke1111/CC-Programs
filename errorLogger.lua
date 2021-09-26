
function connectNetwork()
  for _,v in pairs(peripheral.getNames()) do
    if peripheral.getType(v) == "modem" then
      rednet.open(v)
      write("Listening on " .. v)
      rednet.broadcast(os.getComputerID() .. " is online :D", "welcome")
    end
  end
end

function listen()

 while true do
   id, msg, prot = rednet.receive()
   write(msg)
 end
end

connectNetwork()
listen()
