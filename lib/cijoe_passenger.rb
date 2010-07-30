$LOAD_PATH << 'cijoe_passenger'
require 'net/http'
require 'uri'
require 'ostruct'
require 'cijoe_passenger/sh'
require 'cijoe_passenger/git'
require 'cijoe_passenger/apache_config'
require 'cijoe_passenger/project'
require 'cijoe_passenger/watcher'
require 'cijoe_passenger/refresher'
require 'cijoe_passenger/installer'

module CIJoePassenger
  Config = OpenStruct.new({
    :cijoe_url => "cijoe.yourcompany.com",
    :apache_config_path => "/etc/httpd/conf.d/cijoe.conf",
    :runner => 'rake cruise'
  })
end