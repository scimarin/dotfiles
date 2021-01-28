local module = {}

---------------------------------------------
-- helper functions -------------------------
---------------------------------------------
function getSpeakers()
  if device then return device end

  local devices = hs.audiodevice.allOutputDevices()
  device = nil

  for ix = 1, #devices do
    device = devices[ix]
    if string.find(device:name(), "Speakers") then
      break
    end
  end

  return device
end

function decreaseVolume()
  local speakers = getSpeakers()
  local volume = speakers:volume()
  speakers:setOutputVolume(math.max(0, volume - 5))
end

function increaseVolume()
  local speakers = getSpeakers()
  local volume = speakers:volume()
  speakers:setOutputVolume(math.min(100, volume + 5))
end

function decreaseBrightness()
  local brightness = hs.brightness.get()
  hs.brightness.set(math.max(0, brightness - 5))
end

function increaseBrightness()
  local brightness = hs.brightness.get()
  hs.brightness.set(math.min(100, brightness + 5))
end

---------------------------------------------
-- module -----------------------------------
---------------------------------------------
module.start = function()
  hs.hotkey.bind({"cmd"}, "space", function()
    local wf = hs.window.filter
    local filter = wf.new(false):setAppFilter('Terminal')
    local windows = filter:getWindows()
    local count = 0
    for _ in pairs(windows) do count = count + 1 end
  end)


  hs.hotkey.bind({"cmd"},  "p", function()
    if not hs.spotify.isRunning() then
      hs.application.open("Spotify")
    end

    if hs.spotify.isPlaying() then
      hs.spotify.pause()
    else
      hs.spotify.play()
      hs.spotify.displayCurrentTrack()
    end

  end)

  hs.hotkey.bind({"cmd"}, "i", nil, decreaseBrightness, decreaseBrightness)
  hs.hotkey.bind({"cmd"}, "o", nil, increaseBrightness, increaseBrightness)

  hs.hotkey.bind({"cmd"}, ",", nil, decreaseVolume, decreaseVolume)
  hs.hotkey.bind({"cmd"}, ".", nil, increaseVolume, increaseVolume)


  hs.hotkey.bind({"cmd"}, "m", function()
    local app = hs.application.get("Spotify")
    if app == nil then return end

    if app:isFrontmost() then
      app:hide()
    else
      app:activate()
    end
  end)
end

---------------------------------------------
-- module -----------------------------------
---------------------------------------------
module.stop = function()
end

return module
