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