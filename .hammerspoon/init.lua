-- requires
bindings  = require('bindings')

-- no animations
hs.window.animationDuration = 0.0
hs.grid.setGrid('2x2')

-- start modules
local modules = { bindings }

hs.fnutils.each(modules, function(module)
  if module then module.start() end
end)

-- stop modules on shutdown
hs.shutdownCallback = function()
  hs.fnutils.each(modules, function(module)
    if module then module.stop() end
  end)
end


-- focus on the left window
hs.hotkey.bind({"cmd"}, "h", function()
  local window = hs.window.frontmostWindow()
  window:focusWindowWest()
end)

-- focus on the right window
hs.hotkey.bind({"cmd"}, "l", function()
  local window = hs.window.frontmostWindow()
  window:focusWindowEast()
end)

-- focus on the lower window
hs.hotkey.bind({"cmd"}, "j", function()
  local window = hs.window.frontmostWindow()
  window:focusWindowSouth()
end)

-- focus on the upper window
hs.hotkey.bind({"cmd"}, "k", function()
  local window = hs.window.frontmostWindow()
  window:focusWindowNorth()
end)

windowLayout = {}

-- push window left
hs.hotkey.bind({"cmd", "shift"}, "h", function()
  local window = hs.window.frontmostWindow()

  local id = window:id()
  if windowLayout[id] == nil then
    windowLayout[id] = hs.layout.left50
  end

  local windowsToWest = window:windowsToWest()
  if #windowsToWest > 0 then
    hs.layout.apply({
        {nil, window, "Color LCD", hs.layout.left50, nil, nil},
      })
    windowLayout[id] = hs.layout.left50

    for i = 1, #windowsToWest do
      hs.layout.apply({
          {nil, windowsToWest[i], "Color LCD", hs.layout.right50, nil, nil},
        })
      windowLayout[windowsToWest[i]:id()] = hs.layout.right50
    end

  else
    if windowLayout[id] == hs.layout.left50 then
      windowLayout[id] = hs.layout.left75
    elseif windowLayout[id] == hs.layout.left75 then
      windowLayout[id] = hs.layout.left25
    elseif windowLayout[id] == hs.layout.left25 then
      windowLayout[id] = hs.layout.left50
    end

    local layout = {
      {nil, window, "Color LCD", windowLayout[id], nil, nil},
    }
    hs.layout.apply(layout)

    local windowsToEast = window:windowsToEast()
    for i = 1, #windowsToEast do
      local where = nil
      if windowLayout[id] == hs.layout.left50 then
        where = hs.layout.right50
      elseif windowLayout[id] == hs.layout.left75 then
        where = hs.layout.right25
      elseif windowLayout[id] == hs.layout.left25 then
        where = hs.layout.right75
      end

      local layout = {
        {nil, windowsToEast[i], "Color LCD", where, nil, nil},
      }
      hs.layout.apply(layout)
      windowLayout[windowsToEast[i]:id()] = where
    end
  end
end)

-- push window right
hs.hotkey.bind({"cmd", "shift"}, "l", function()
  local window = hs.window.frontmostWindow()

  local id = window:id()
  if windowLayout[id] == nil then
    windowLayout[id] = hs.layout.left50
  end

  local windowsToEast = window:windowsToEast()
  if #windowsToEast > 0 then
    hs.layout.apply({
        {nil, window, "Color LCD", hs.layout.right50, nil, nil},
      })
    windowLayout[id] = hs.layout.right50

    for i = 1, #windowsToEast do
      hs.layout.apply({
          {nil, windowsToEast[i], "Color LCD", hs.layout.left50, nil, nil},
        })
      windowLayout[windowsToEast[i]:id()] = hs.layout.left50
    end
  else
    if windowLayout[id] == hs.layout.right50 then
      windowLayout[id] = hs.layout.right75
    elseif windowLayout[id] == hs.layout.right75 then
      windowLayout[id] = hs.layout.right25
    elseif windowLayout[id] == hs.layout.right25 then
      windowLayout[id] = hs.layout.right50
    end

    local layout = {
      {nil, window, "Color LCD", windowLayout[id], nil, nil},
    }
    hs.layout.apply(layout)

    local windowsToWest = window:windowsToWest()
    for i = 1, #windowsToWest do
      local where = nil
      if windowLayout[id] == hs.layout.right50 then
        where = hs.layout.left50
      elseif windowLayout[id] == hs.layout.right75 then
        where = hs.layout.left25
      elseif windowLayout[id] == hs.layout.right25 then
        where = hs.layout.left75
      end

      local layout = {
        {nil, windowsToWest[i], "Color LCD", where, nil, nil},
      }
      hs.layout.apply(layout)
      windowLayout[windowsToWest[i]:id()] = where
    end
  end
end)

-- push window down
hs.hotkey.bind({"cmd", "shift"}, "j", function()
  local window = hs.window.frontmostWindow()

  local windowsToSouth = window:windowsToSouth()
  for i = 1, #windowsToSouth do
    hs.grid.pushWindowUp(windowsToSouth[i])
  end

  hs.grid.pushWindowDown(window)
  hs.grid.resizeWindowTaller(window)
  hs.grid.snap(window)
end)

-- push window up
hs.hotkey.bind({"cmd", "shift"}, "k", function()
  local window = hs.window.frontmostWindow()

  local windowsToNorth = window:windowsToNorth()
  for i = 1, #windowsToNorth do
    hs.grid.pushWindowDown(windowsToNorth[i])
  end

  hs.grid.pushWindowUp(window)
  hs.grid.resizeWindowTaller(window)
  hs.grid.snap(window)
end)

-- maximize window
WindowInfo = {topLeft = nil, size = nil, state = 'normal'}

function WindowInfo:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function WindowInfo:setSize(size)
  self.size = size
end

function WindowInfo:setTopLeft(place)
  self.topLeft = place
end

function WindowInfo:setState(state)
  self.state = state
end


windowCache = {}

hs.hotkey.bind({"cmd"}, "f", function()
  local window = hs.window.frontmostWindow()
  local id = window:id()

  local size = window:size()
  local topLeft = window:topLeft()

  if windowCache[id] == nil then
    local info = WindowInfo:new()
    info:setSize(size)
    info:setTopLeft(topLeft)
    windowCache[id] = info
  end

  local info = windowCache[id]

  if info.state == 'normal' then
    hs.grid.maximizeWindow(window)
    info.state = 'maximized'

    info:setSize(size)
    info:setTopLeft(topLeft)
  else
    window:setSize(info.size)
    window:setTopLeft(info.topLeft)
    hs.grid.snap(window)
    info.state = 'normal'
  end
end)
