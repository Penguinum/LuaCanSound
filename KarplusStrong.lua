local KarplusStrongFilter = require "KarplusStrongFilter"

local KS = require("generator")()
local ASR = require "ASR"

KS.pluckers = {}
KS.plucker_names = {}

function KS:requirePlucker(module_name)
  local new_plucker = require(module_name)
  if not new_plucker then
    return
  end
  KS.pluckers[module_name] = new_plucker
  table.insert(KS.plucker_names, module_name)
end

KS:requirePlucker("Sine")
KS:requirePlucker("Square")
KS:requirePlucker("Triangle")
KS:requirePlucker("WhiteNoise")

local type = type

-- Allowed parameters and their default values
KS.parameters = {
  plucker = {
    value = "Square",
    set = function(ks_obj, value)
      local value_type = type(value)
      if value_type == "string" then
        ks_obj.plucker = KS.pluckers[value]
      elseif value_type == "table" then
        ks_obj.plucker = value
      end
      ks_obj.input_gen = ks_obj.plucker:new()
    end,
  },
  frequency_multiplier = {
    value = 4,
  },
  distort_mul = {
    value = 0.2,
  },
}

function KS:new()
  local gen = {
    frequency = 0,
    sample_number = 0,
    ks_filter = KarplusStrongFilter:new(),
    input_gen_envelope = ASR:new(),
  }
  return setmetatable(gen, KS):initDefaults()
end

function KS:start(frequency)
  self.frequency = frequency
  self.ks_filter:setFrequency(frequency)
  self.ks_filter:clear()
  self.input_gen:start(frequency*self.frequency_multiplier)
  local size = self.ks_filter.delay_filter.buffer.size
  self.input_gen_envelope:set{attack_samples=size/2.0, sustain_samples=0, release_samples=size/2.0}:start()
  self.input_gen_envelope:start()
  self.old_frequency_multiplier = self.frequency_multiplier
  return self
end

function KS:fill_tick()
end

function KS:afterfill_tick()
end

function KS:tick()
  local input = self.input_gen_envelope:tick(self.input_gen)
  return self.ks_filter:tick(input) * 0.3 -- * self.distort_mul
end

return KS
