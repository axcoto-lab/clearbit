$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/test'
require 'minitest/mock'
require 'minitest/pride'
require 'rack/test'
require 'pry'

require_relative '../app'
