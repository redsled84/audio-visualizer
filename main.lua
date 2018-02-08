luafft = require "luafft"
local soundData = love.sound.newSoundData("atb.mp3")
local updateSpectrum = false

function devide(list, factor)
  for i, v in ipairs(list) do list[i] = list[i] * factor end
end

-- amount of frequencies from fft
local size = 1024
local audioSize = soundData:getSampleCount()
local frequency = soundData:getSampleRate()
local length = size / frequency

local audioSource = love.audio.newSource("atb.mp3")
audioSource:play()

local windowWidth = love.graphics.getWidth()
local windowHeight = love.graphics.getHeight()
local spectrum, temp
local maxTime = .02
local timer = maxTime
function love.update(dt)
  local audioPos = audioSource:tell("samples")

  local list = {}

  for i = audioPos, audioPos + size - 1 do
    temp = i
    if i + 2048 > audioSize then i = audioSize / 2 end

    list[#list+1] = complex.new(soundData:getSample(i * 2), 0)
  end


  timer = timer - dt
  if timer < 0 then
    spectrum = luafft.fft(list, false)
    devide(spectrum, 10)
    timer = maxTime
  end
end

function love.draw()
    if not spectrum then return end
    local barWidth = 14
    for i = 1, #spectrum / barWidth do
      love.graphics.rectangle("fill", i * (barWidth-1), windowHeight,
        (barWidth-1), -1 * (spectrum[i]:abs() * 0.3)) -- bars
      love.graphics.print("@ " .. math.floor((i) / length) .. "Hz "
        .. math.floor(spectrum[i]:abs() * 0.3), windowWidth - 90, (12 * i)) -- frequencies
      love.graphics.print(temp, 0, 0) -- current position
    end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end