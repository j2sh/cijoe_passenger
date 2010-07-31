module CIJoePassenger
  class Watch < Thor::Group
    namespace :watch

    def scan
      Project.refreshable.each do |p|
        invoke "refresh", [p.name]
      end
    end
  end
end