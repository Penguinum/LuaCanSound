local settings = require "settings"

local Triangle = require("generator")()
local M_PI = math.pi

function Triangle:new()
  local gen = {
    phase = 0,
    dt = 1,
    phase_delta = 0,
    active = false,
    width = 0.5
  }
  return setmetatable(gen, Triangle)
end

function Triangle:start(frequency)
  assert(frequency > 0)
  self.sample_num = 0
  self.dt = 1 / settings.sampleRate
  self.phase_delta = frequency * 2 * M_PI * self.dt
  self.w_up = M_PI * self.width
  self.w_down = M_PI * (1 - self.width)
  self.phase = 2 * M_PI - self.w_up
  self.active = true
  return self
end

function Triangle:tick()
  if not self.active then
    return 0
  end
  if self.phase >= 2 * M_PI then
    self.phase = self.phase - 2 * M_PI
  end
  local sample
  local w_up, w_down, phase = self.w_up, self.w_down, self.phase
  if w_down == 0 then
    sample = -1 + 1.0 / M_PI * phase
  else
    if phase < 2 * w_down then
      sample = 1 - phase / w_down
    else
      sample = -1 + (phase - 2 * w_down) / w_up
    end
  end
  self.phase = phase + self.phase_delta
  return sample
end

return Triangle
