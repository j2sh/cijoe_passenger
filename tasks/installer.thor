$LOAD_PATH << 'lib'
require 'cijoe_passenger'

class Installer < Thor
  desc "add APP_NAME REPO", "setup a cijoe instance for a repo"
  method_option :campfire, :type => :hash, :default => {}
  def add(name, repo)
    CIJoePassenger::Installer.new(name, repo, options[:campfire]).add
  end
end
