local settings = require "settings"
local ring = require "ring"

local Delay = {}
Delay.__index = Delay

function Delay:new() -- time: seconds
  local gen = {
    time = 0,
    buffer = ring:new(1),
  }
  return setmetatable(gen, Delay)
end

function Delay:setLength(time)
  self.time = time
  self.buffer = ring:new(math.floor(settings.sampleRate * time)+1)
end

function Delay:clear() --TODO
  self.buffer:fill(0)
end

function Delay:tick(new_sample)
  self.buffer:apply(new_sample)
  return self.buffer:atOffset(0)
end


return Delay
