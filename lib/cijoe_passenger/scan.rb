module CIJoePassenger
  class Scan < Thor::Group
    namespace :scan

    def scan
      Project.refreshable.each do |p|
        invoke "refresh", [p.name]
      end
    end
  end
end