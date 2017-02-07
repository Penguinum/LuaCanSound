local Ring = {}
Ring.__index = Ring

function Ring:new(size)
  local buf = {
    data = {},
    size = size,
    current_pos = 1,
  }
  return setmetatable(buf, Ring):fill(0)
end

function Ring:fill(value)
  for i = 1, self.size do
    self.data[i] = value
  end
  return self
end

function Ring:apply(sample)
  self.data[self.current_pos] = sample
  if self.current_pos == self.size then
    self.current_pos = 1
  else
    self.current_pos = self.current_pos + 1
  end
  return self
end

function Ring:atOffset(offset)
  local pos = self.current_pos + offset
  if pos < 1 then
    pos = pos + self.size
  elseif pos > self.size then
    pos = pos - self.size
  end
  return self.data[pos]
end

return Ring
