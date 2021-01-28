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
