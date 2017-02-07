local ks = require "ks_filter"

local KS_battery = {}
KS_battery.__index = KS_battery

function KS_battery:new(...)
  local filter = {
    filters = {},
  }
  for k, frequency in pairs{...} do
    filter.filters[k] = ks:new()
    filter.filters[k]:setFrequency(frequency)
  end
  return setmetatable(filter, KS_battery)
end

function KS_battery:clear()
  for k, v in pairs(self.filters) do
    v:clear()
  end
end

function KS_battery:tick(input)
  local output = 0
  for k, v in pairs(self.filters) do
    output = output + v:tick(input)
  end
  output = output / #self.filters
  return output
end

return KS_battery

