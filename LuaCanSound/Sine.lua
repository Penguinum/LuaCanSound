local Sine = require("generator")()
local settings = require "settings"

local sin = math.sin
local TWO_PI = 2 * math.pi
local sampleRate = settings.sampleRate

Sine.properties = {
  frequency = 200,
}

function Sine:tick()
  if not self.active then return 0 end
  local phase = self.phase
  local value = sin(phase)
  self.phase = phase + self.phase_delta
  return value
end

function Sine:start(frequency)
  self.frequency = frequency
  self.active = true
  self.phase_delta = TWO_PI * frequency / sampleRate
  return self
end

function Sine:new()
  local gen = {
    phase = 0,
    phase_delta = 0,
    active = false,
  }
  return setmetatable(gen, Sine)
end

return Sine
