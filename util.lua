function yield()
  os.queueEvent("fakeEvent");
  os.pullEvent();
end
