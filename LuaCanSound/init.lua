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
  },
  envelopes = {
    ASR = require "ASR",
    ADSR = require "ADSR",
  },
  settings = require "settings"
}

return package_table
