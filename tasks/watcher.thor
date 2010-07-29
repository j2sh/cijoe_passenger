require 'cijoe_passenger'

class Watcher < Thor
  desc "scan", "Scan for new commits in all projects"
  def scan
    CIJoePassenger::Watcher.scan
  end
end