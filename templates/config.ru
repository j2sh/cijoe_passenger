require 'cijoe'

# setup middleware
use Rack::CommonLogger

map "/" do
  use Rack::Static, :urls => ["/public"]
end