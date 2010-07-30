# rubygems here so 'rake spec' works
require 'rubygems'
require 'bundler'
Bundler.require(:test)
require 'cijoe_passenger'
include CIJoePassenger