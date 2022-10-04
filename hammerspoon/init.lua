-- Move window to the top/left
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Y", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x - 10
  f.y = f.y - 10
  win:setFrame(f)
end)

-- Move window to the top
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "K", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.y = f.y - 10
  win:setFrame(f)
end)

-- Move window to the top/right
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "U", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x + 10
  f.y = f.y - 10
  win:setFrame(f)
end)

-- Move window to the left
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "H", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x - 10
  win:setFrame(f)
end)

-- Move window to the right
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "L", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x + 10
  win:setFrame(f)
end)

-- Move window to the bottom/left
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "B", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x - 10
  f.y = f.y + 10
  win:setFrame(f)
end)

-- Move window to the bottom
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "J", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.y = f.y + 10
  win:setFrame(f)
end)

-- Move window to the bottom/right
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "N", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x + 10
  f.y = f.y + 10
  win:setFrame(f)
end)

-- Reload Hammerspoon config
hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

-- Caffeine replacement
hs.loadSpoon("Caffeine")
spoon.Caffeine:start()

-- Move windows
hs.loadSpoon("WindowHalfsAndThirds")
spoon.WindowHalfsAndThirds:bindHotkeys(spoon.WindowHalfsAndThirds.defaultHotkeys)

-- Send all Finder windows to front when calling finder
function applicationWatcher(appName, eventType, appObject)
  if (eventType == hs.application.watcher.activated) then
    if (appName == "Finder") then
      -- Bring all Finder windows forward when one gets activated
      appObject:selectMenuItem({"Window", "Bring All to Front"})
    end
  end
end
appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()

-- Mute when not connected to home Wifi
wifiWatcher = nil
homeSSID = "freedonuts"
lastSSID = hs.wifi.currentNetwork()

function ssidChangedCallback()
  newSSID = hs.wifi.currentNetwork()

  if newSSID == homeSSID and lastSSID ~= homeSSID then
    -- We just joined our home WiFi network
    hs.audiodevice.defaultOutputDevice():setVolume(25)
  elseif newSSID ~= homeSSID and lastSSID == homeSSID then
    -- We just departed our home WiFi network
    hs.audiodevice.defaultOutputDevice():setVolume(0)
  end

  lastSSID = newSSID
end

wifiWatcher = hs.wifi.watcher.new(ssidChangedCallback)
wifiWatcher:start()

-- Defeat paste blocking
hs.hotkey.bind({"cmd", "alt"}, "V", function() hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end)

-- Display Spotify current track
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "S", function()
    hs.spotify.displayCurrentTrack()
end)

-- Highlight mouse
mouseCircle = nil
mouseCircleTimer = nil

function mouseHighlight()
  -- Delete an existing highlight if it exists
  if mouseCircle then
    mouseCircle:delete()
    if mouseCircleTimer then
      mouseCircleTimer:stop()
    end
  end
  -- Get the current co-ordinates of the mouse pointer
  mousepoint = hs.mouse.getAbsolutePosition()
  -- Prepare a big red circle around the mouse pointer
  mouseCircle = hs.drawing.circle(hs.geometry.rect(mousepoint.x-40, mousepoint.y-40, 80, 80))
  mouseCircle:setStrokeColor({["red"]=1,["blue"]=0,["green"]=0,["alpha"]=1})
  mouseCircle:setFill(false)
  mouseCircle:setStrokeWidth(5)
  mouseCircle:show()

  -- Set a timer to delete the circle after 3 seconds
  mouseCircleTimer = hs.timer.doAfter(3, function() mouseCircle:delete() end)
end
hs.hotkey.bind({"cmd","alt","shift"}, "D", mouseHighlight)

hs.urlevent.bind("someAlert", function(eventName, params)
                   hs.alert.show("Received someAlert")
end)
