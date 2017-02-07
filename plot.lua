#!/usr/bin/env th

local torch = require "torch"
local gnuplot = require "gnuplot"
local LuaCanSound = require "LuaCanSound"

local sample_rate = 44100
local seconds = 1
LuaCanSound.settings.sampleRate = sample_rate

local range = torch.range(1, seconds * sample_rate)
local KS = LuaCanSound.generators.KarplusStrong

local ks = KS:new():start(100)
for i = 1, range:size():totable()[1] do
  range[i] = ks:tick()
end

math.randomseed(os.time())

local range2 = torch.range(1, seconds * sample_rate)

print(ks.input_gen)
ks:set{plucker="Sine", frequency_multiplier=10}:start(100)
print(ks.input_gen)
for i = 1, range2:size():totable()[1] do
  range2[i] = ks:tick()
end

gnuplot.plot({'1', range, '-'}, {'2', range2, '-'})
