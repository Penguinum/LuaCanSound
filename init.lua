local package_table = {
  generators = {
    Sine = require "Sine",
    Square = require "Square",
    Triangle = require "Triangle",
    WhiteNoise = require "WhiteNoise",
    KarplusStrong = require "KarplusStrong",
  },
  filters = {
    Delay = require "Delay",
    Lowpass = require "Lowpass",
    KarplusStrongFilter = require "KarplusStrongFilter",
  },
  envelopes = {
    ASR = require "ASR",
    ADSR = require "ADSR",
  },
  base = {
    generator = require "generator",
    envelope = require "envelope",
  },
  settings = require "settings"
}

return package_table
