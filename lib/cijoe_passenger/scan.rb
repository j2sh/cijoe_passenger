module CIJoePassenger
  class Scan < Thor::Group
    namespace :scan

    def scan
      Project.stale.each(&:build)
    end
  end
end