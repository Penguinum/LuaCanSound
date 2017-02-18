local settings = require "settings"
local Square = require("generator")()

local M_PI = math.pi
local TWO_M_PI = 2 * M_PI
local sampleRate = settings.sampleRate

Square.properties = {
  frequency = 200,
}

function Square:new()
  local gen = {
    phase = 0,
    phase_delta = 0,
    active = false,
    width = 0.5
  }
  return setmetatable(gen, Square)
end

function Square:start(frequency)
  assert(frequency > 0)
  self.sample_num = 0
  self.phase_delta = frequency * TWO_M_PI / sampleRate
  self.phase = 0
  self.active = true
  return self
end

function Square:tick()
  if not self.active then return 0 end
  local phase = self.phase
  if phase >= TWO_M_PI then
    phase = phase - TWO_M_PI
  end
  self.phase = phase + self.phase_delta
  return (phase < M_PI) and 1 or -1
end

return Square
