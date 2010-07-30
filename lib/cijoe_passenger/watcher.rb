module CIJoePassenger
  class Watcher < Thor::Group
    namespace :watch
    def scan
      Project.all.each do |p|
        invoke "refresh", [p.name] if p.refreshable?
      end
    end
  end
end