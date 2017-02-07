-- Simple envelope: attack and release

local ASR = require("envelope")()
local sampleRate = require("settings").sampleRate

ASR.parameters = {
  attack_seconds = {
    value = 0,
    set = function(obj, value)
      obj.attack_seconds = value
      obj.attack_samples = value * sampleRate
    end
  },
  attack_samples = {
    set = function(obj, value)
      obj.attack_samples = value
      obj.attack_seconds = value / sampleRate
    end
  },
  -- Sustain time, not level
  sustain_seconds = {
    value = 1,
    set = function(obj, value)
      obj.sustain_seconds = value
      obj.sustain_samples = value * sampleRate
    end
  },
  sustain_samples = {
    set = function(obj, value)
      obj.sustain_samples = value
      obj.sustain_seconds = value / sampleRate
    end
  },
  release_seconds = {
    value = 0,
    set = function(obj, value)
      obj.release_seconds = value
      obj.release_samples = value * sampleRate
    end
  },
  release_samples = {
    set = function(obj, value)
      obj.release_samples = value
      obj.release_seconds = value / sampleRate
    end
  },
}

function ASR:new()
  local ar = {
    last_value = 0
  }
  return setmetatable(ar, ASR):initDefaults()
end

function ASR:start()
  self.attack_samples_left = self.attack_samples
  self.sustain_samples_left = self.sustain_samples or 0
  self.release_samples_left = self.release_samples or 0
  self.last_value = 0
  if self.attack_samples_left > 0 then
    self.attack_delta = 1 / self.attack_samples_left
  end
  if self.release_samples_left > 0 then
    self.release_delta = -1 / self.release_samples_left
  end
  self.tick = self.__tickAttack
  return self
end

function ASR:__tickAttack(gen)
  if self.attack_samples_left <= 0 then
    self.tick = ASR.__tickSustain
    self.last_value = 1
    return self:tick()
  end
  self.last_value = self.last_value + self.attack_delta
  self.attack_samples_left = self.attack_samples_left - 1
  if gen then
    return self.last_value * gen:tick()
  end
  return self.last_value
end

function ASR:__tickSustain(gen)
  if self.sustain_samples_left <= 0 then
    self.tick = ASR.__tickRelease
    return self:tick()
  end
  self.sustain_samples_left = self.sustain_samples_left - 1
  if gen then
    return gen:tick()
  end
  return 1
end

function ASR:__tickRelease(gen)
  if self.release_samples_left <= 0 then
    self.tick = ASR.__tickFinal
    return self:tick()
  end
  self.last_value = self.last_value + self.release_delta
  self.release_samples_left = self.release_samples_left - 1
  if gen then
    return self.last_value * gen:tick()
  end
  return self.last_value
end

function ASR:__tickFinal()
  return 0
end

return ASR
