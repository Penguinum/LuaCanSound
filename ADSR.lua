local ADSR = {}; ADSR.__index = ADSR
local Settings = require "settings"

local ATTACK = 1
local DECAY = 2
local SUSTAIN = 3
local RELEASE = 4
local FINAL = 5

function ADSR:new(a, d, s, r)
  assert(a >= 0)
  assert(d >= 0)
  assert(s >= 0 and s <= 1)
  assert(r >= 0)
  local adsr = {
    state = 1,
    sample_num = 1,
    state_sample_num = 1,
    sample_value = 0,
    value_delta = 0,
    attack = a * Settings.sampleRate,
    decay = d * Settings.sampleRate,
    sustain = s,
    release = r * Settings.sampleRate,
  }
  return setmetatable(adsr, ADSR)
end

function ADSR:start()
  self.sample_num = 1
  self.state = ATTACK
  self.current_sample = 1
  self.last_value = 0
  self.active = true
  return self
end

function ADSR:stopSustain()
  if self.state < RELEASE then
    self.release_max = self.last_value
    self.current_sample = 0
  end
  self.state = RELEASE
  return self
end

function ADSR:stop()
  self.state = FINAL
end

function ADSR:tick()
  if not self.active then
    return 0
  end
  local cur_state = self.state
  if cur_state == ATTACK then
    if self.attack == 0 then
      self.state = DECAY
    else
      self.last_value = self.current_sample / self.attack
      if self.current_sample >= self.attack then
        self.state = DECAY
        self.current_sample = 1
      end
      self.current_sample = self.current_sample + 1
      return self.last_value
    end
  end
  if cur_state == DECAY then
    if self.decay == 0 then
      self.state = self.state + 1
    else
      self.last_value = 1 - (1 - self.sustain) * self.current_sample / self.decay
      if self.current_sample >= self.decay then
        self.state = self.state + 1
        self.current_sample = 0
      end
      self.current_sample = self.current_sample + 1
      return self.last_value
    end
  end
  if cur_state == SUSTAIN then
    self.last_value = self.sustain
    return self.last_value
  end
  if cur_state == RELEASE then
    if self.release == 0 then
      self.last_value = 0
      self.state = FINAL
    else
      self.last_value = self.release_max - self.release_max * self.current_sample / self.release
      if self.current_sample >= self.release then
        self.state = FINAL
        self.active = false
      end
      self.current_sample = self.current_sample + 1
      return self.last_value
    end
  end
  return 0
end

return ADSR
