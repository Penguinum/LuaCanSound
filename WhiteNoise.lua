local WhiteNoise = {}; WhiteNoise.__index = WhiteNoise

local random = math.random

function WhiteNoise:new()
  local gen = {
    active = false,
  }
  return setmetatable(gen, WhiteNoise)
end

function WhiteNoise:start()
  self.active = true
  return self
end

function WhiteNoise:tick()
  if not self.active then
    return 0
  end
  return random() * 2 - 1
end

return WhiteNoise
