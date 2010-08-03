$LOAD_PATH << File.join(File.dirname(__FILE__))

require 'thor'
require 'thor/group'
require 'net/http'
require 'uri'
require 'ostruct'
require 'yaml'
require 'cijoe_passenger/git'
require 'cijoe_passenger/project'
require 'cijoe_passenger/scan'
require 'cijoe_passenger/add'
require 'cijoe_passenger/install'

module CIJoePassenger
  config_path = File.join('config', 'config.yml')
  config_yml = File.exist?(config_path) ? YAML.load_file(config_path) : {}
  Config = OpenStruct.new(config_yml)
end