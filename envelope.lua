local settings = require "settings"

local Env = {}

function Env:tick()
  return 0
end

function Env:start()
  self.active = true
  return self
end

function Env:set(param_table)
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

function Env:initDefaults()
  for k, v in pairs(self.parameters) do
    if v.value then
      self:set{[k]=v.value}
    end
  end
  return self
end

function Env:stop()
  self.active = false
  return self
end

function Env:continue()
  self.active = true
  return self
end

function Env:generate(length_seconds)
  local length_samples = settings.sampleRate * length_seconds
  local sound_array = {}
  for i = 1, length_samples do
    sound_array[i] = self:tick()
  end
  return sound_array
end

local function Create()
  local new_class = {}
  local new_class_mt = {__index=Env}
  setmetatable(new_class, new_class_mt)
  new_class.__index = new_class
  return new_class
end

return Create
