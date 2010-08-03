ENV["PATH"] += ":/usr/local/bin"

require 'cijoe'
require 'cijoe_passenger/cijoe'
require 'cijoe_passenger/apps/base'

# setup middleware
use Rack::CommonLogger