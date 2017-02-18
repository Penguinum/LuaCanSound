local Delay = require "Delay"

local Ha = {}
Ha.__index = Ha

function Ha:new()
  local gen = {
    previous_sample = 0
  }
  return setmetatable(gen, Ha)
end

function Ha:tick(s)
  local result = (self.previous_sample + s) / 2.0
  self.previous_sample = s
  return result
end

function Ha:clear()
  self.previous_sample = 0
  return self
end

local KS_filter = {}
KS_filter.__index = KS_filter

function KS_filter:new()
  local gen = {
    ha_filter = Ha:new(),
    delay_filter = Delay:new(),
    frequency = 0,
    filtered_output = 0,
  }
  return setmetatable(gen, KS_filter)
end

function KS_filter:setFrequency(frequency)
  self.frequency = frequency
  local delay_line_length = 1.0 / frequency
  self.delay_filter:setLength(delay_line_length)
  return self
end

function KS_filter:clear()
  self.filtered_output = 0
  self.ha_filter:clear()
  self.delay_filter:clear()
end

function KS_filter:tick(input)
  local in_plus_filtered = input + self.filtered_output
  local output = self.delay_filter:tick(in_plus_filtered)*0.995
  self.filtered_output = self.ha_filter:tick(output)
  return output
end

return KS_filter
