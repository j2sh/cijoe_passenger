module CIJoePassenger
  class Watcher < Thor::Group
    namespace :watch

    def scan
      Project.refreshable.each do |p|
        invoke "refresh", [p.name]
      end
    end
  end
end