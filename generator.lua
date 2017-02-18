local settings = require "settings"

local Gen = {}

function Gen:tick()
  return 0
end

function Gen:set(param_table)
  local parameters = self.parameters
  for k, v in pairs(param_table) do
    if parameters[k] then
      if parameters[k].set then
        parameters[k].set(self, v)
      else
        self[k] = v
      end
    end
  end
  return self
end

function Gen:initDefaults()
  for k, v in pairs(self.parameters) do
    if v.value then
      self:set{[k]=v.value}
    end
  end
  return self
end

function Gen:setDefault(new_params)
  local params = self.parameters
  for k, v in pairs(new_params) do
    if params[k] then
      params[k].value = v
    end
  end
  return Gen
end

function Gen:getDefault(param)
  return self.parameters[param].value
end

function Gen:start(frequency)
  self.frequency = frequency
  self.active = true
  return self
end

function Gen:stop()
  self.active = false
  return self
end

function Gen:continue()
  self.active = true
  return self
end

function Gen:generate(length_seconds)
  local length_samples = settings.sampleRate * length_seconds
  local sound_array = {}
  for i = 1, length_samples do
    sound_array[i] = self:tick()
  end
  return sound_array
end

local function Create()
  local new_class = {}
  local new_class_mt = {__index=Gen}
  setmetatable(new_class, new_class_mt)
  new_class.__index = new_class
  return new_class
end

return Create
