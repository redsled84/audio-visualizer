luafft = require "luafft"
inspect = require "inspect"
local songName = "excalibur.mp3"
local soundData = love.sound.newSoundData(songName)
local updateSpectrum = false

local beach = love.graphics.newImage("cotton-candy.jpg")

function devide(list, factor)
  for i, v in ipairs(list) do list[i] = list[i] * factor end
end

-- amount of frequencies from fft
local size = 1024
local audioSize = soundData:getSampleCount()
local frequency = soundData:getSampleRate()
local length = size / frequency

love.graphics.setBackgroundColor(0,0,0)

local audioSource = love.audio.newSource(songName)
audioSource:play()

local windowWidth = love.graphics.getWidth()
local windowHeight = love.graphics.getHeight()
local spectrum, temp
local maxTime = .001
local timer = maxTime
function love.update(dt)
  local audioPos = audioSource:tell("samples")
  -- print(audioPos, audioSize)

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

function draw_spectrum(a, b)

end

function love.draw()
    -- love.graphics.setColor(255, 255, 255)
    -- love.graphics.draw(beach, 0, 0, 0, .5, .75)
    love.graphics.setColor(45, 45, 45, 220)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    local alpha = 255
    if not spectrum then return end
    local barWidth = 4
    local r2, g2, b2 = 255, 0, 14
    local r1, g1, b1 = 255, 97, 35
    local r3, g3, b3 = 20, 255, 229
    local r4, g4, b4 = 0, 246, 185
    for i = 1, (#spectrum / barWidth) - 1 do

      local sensitiviy = .55
      local barHeight = (spectrum[i]:abs() * sensitiviy)
      if barHeight > (love.graphics.getHeight()) * 9/10 then
        barHeight = (love.graphics.getHeight()) * 9/10
      end
      local barHeight2 = (spectrum[i+1]:abs() * sensitiviy)
      if barHeight2 > (love.graphics.getHeight()) * 9/10 then
        barHeight2 = (love.graphics.getHeight()) * 9/10
      end
      local n = barHeight
      if n > 255 then
        n = 255
      end

      if n < 50 then
        love.graphics.setColor(r1,g1,b1)
      elseif n < 100 then 
        love.graphics.setColor(r2,g2,b2)
      -- elseif n < 180 then
        -- love.graphics.setColor(254,237,255)
      -- elseif n < 210 then
        -- love.graphics.setColor(184,247,255)
      elseif n < 240 then
        love.graphics.setColor(r3,g3,b3)
      else
        love.graphics.setColor(r4,g4,b4)
      end


      -- love.graphics.rectangle("fill", (i-1) * (barWidth-1), windowHeight / 2 - barHeight / 2,
      --   (barWidth-1), (barHeight)) -- bars
      love.graphics.line((i-1) * (barWidth-1)+love.graphics.getWidth()/2, windowHeight / 2 - barHeight / 2, love.graphics.getWidth()/2+(i) * (barWidth-1),
       windowHeight / 2 - barHeight2 / 2)

      if n > 255 then
        n = 255
      end
      if n < 50 then
        love.graphics.setColor(r1,g1,b1, alpha)
      elseif n < 100 then 
        love.graphics.setColor(r2,g2,b2, alpha)
      -- elseif n < 180 then
        -- love.graphics.setColor(254,237,255)
      -- elseif n < 210 then
        -- love.graphics.setColor(184,247,255)
      elseif n < 240 then
        love.graphics.setColor(r3,g3,b3, alpha)
      else
        love.graphics.setColor(r4,g4,b4, alpha)
      end

      love.graphics.line((i-1) * (barWidth-1)+love.graphics.getWidth()/2, windowHeight / 2 + barHeight / 2, love.graphics.getWidth()/2+(i) * (barWidth-1),
       windowHeight / 2 + barHeight2 / 2)

      love.graphics.setColor(255,255,255)
      -- love.graphics.print("@ " .. math.floor((i) / length) .. "Hz "
        -- .. math.floor(barHeight), windowWidth - 90, (12 * i)) -- frequencies
      -- love.graphics.print(temp, 0, 0) -- current position
    end
    for i = -(#spectrum / barWidth) - 1, -1, 1 do

      local sensitiviy = .55
      local barHeight = (spectrum[math.abs(i)]:abs() * sensitiviy)
      if barHeight > (love.graphics.getHeight()) * 9/10 then
        barHeight = (love.graphics.getHeight()) * 9/10
      end
      local barHeight2 = (spectrum[math.abs(i)+1]:abs() * sensitiviy)
      if barHeight2 > (love.graphics.getHeight()) * 9/10 then
        barHeight2 = (love.graphics.getHeight()) * 9/10
      end
      local n = barHeight
      if n > 255 then
        n = 255
      end
      if n < 50 then
        love.graphics.setColor(r1,g1,b1)
      elseif n < 100 then 
        love.graphics.setColor(r2,g2,b2)
      -- elseif n < 180 then
        -- love.graphics.setColor(254,237,255)
      -- elseif n < 210 then
        -- love.graphics.setColor(184,247,255)
      elseif n < 240 then
        love.graphics.setColor(r3,g3,b3)
      else
        love.graphics.setColor(r4,g4,b4)
      end


      -- love.graphics.rectangle("fill", (i-1) * (barWidth-1), windowHeight / 2 - barHeight / 2,
      --   (barWidth-1), (barHeight)) -- bars
      love.graphics.line((i) * (barWidth-1) + windowWidth/2, windowHeight / 2 - barHeight / 2, (i-1) * (barWidth-1) + windowWidth/2,
       windowHeight / 2 - barHeight2 / 2)

      if n > 255 then
        n = 255
      end
      if n < 50 then
        love.graphics.setColor(r1,g1,b1, alpha)
      elseif n < 100 then 
        love.graphics.setColor(r2,g2,b2, alpha)
      -- elseif n < 180 then
        -- love.graphics.setColor(254,237,255)
      -- elseif n < 210 then
        -- love.graphics.setColor(184,247,255)
      elseif n < 240 then
        love.graphics.setColor(r3,g3,b3, alpha)
      else
        love.graphics.setColor(r4,g4,b4, alpha)
      end

      love.graphics.line((i) * (barWidth-1) + windowWidth/2, windowHeight / 2 + barHeight / 2, (i-1) * (barWidth-1) + windowWidth/2,
       windowHeight / 2 + barHeight2 / 2)

      love.graphics.setColor(255,255,255)
      -- love.graphics.print("@ " .. math.floor((i) / length) .. "Hz "
        -- .. math.floor(barHeight), windowWidth - 90, (12 * i)) -- frequencies
      -- love.graphics.print(temp, 0, 0) -- current position
    end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end
