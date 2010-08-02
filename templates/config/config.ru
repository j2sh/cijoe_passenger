# Required so that we can set path correctly for Config, which 
# is loaded statically due to a bug in cijoe

$work_path = File.join(File.expand_path(File.dirname(__FILE__)), 'work')
require 'cijoe'

# setup middleware
use Rack::CommonLogger

# configure joe
CIJoe::Server.configure do |config|
  config.set :project_path, $work_path
  config.set :show_exceptions, true
  config.set :lock, true
end

run CIJoe::Server