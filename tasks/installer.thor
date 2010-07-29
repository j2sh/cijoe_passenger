$LOAD_PATH << 'lib'
require 'cijoe_passenger'

class Installer < Thor
  desc "add APP_NAME REPO", "setup a cijoe instance for a repo"
  method_options :campfire => :hash
  def add(name, repo)
    CIJoePassenger::Installer.new(name, repo).add
  end
end
