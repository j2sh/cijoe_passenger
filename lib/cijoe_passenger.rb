$LOAD_PATH << File.join(File.dirname(__FILE__))

require 'thor'
require 'thor/group'
require 'net/http'
require 'uri'
require 'ostruct'
require 'cijoe_passenger/git'
require 'cijoe_passenger/apache_config'
require 'cijoe_passenger/project'
require 'cijoe_passenger/watch'
require 'cijoe_passenger/refresh'
require 'cijoe_passenger/add'
require 'cijoe_passenger/install'

module CIJoePassenger
  Config = OpenStruct.new({
    :cijoe_url => "cijoe.yourcompany.com",
    :apache_config_path => "config/cijoe_passenger.conf",
    :runner => 'rake cruise'
  })
end