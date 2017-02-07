-- A prototype, work in progress
local ring = require "ring"

local LP = {}; LP.__index = LP

function LP:new()
  local lp = {
    buf = ring:new(10)
  }
  return setmetatable(lp, LP)
end

function LP:tick(new_sample)
  local buf = self.buf
  buf:apply(new_sample)
  local res = 0
  for i = 0, buf.size-1 do
    res = res + buf:atOffset(i)
  end
  return res/(1.0*buf.size)
end

function LP:clear() --TODO
  self.buf:fill(0)
end

return LP
