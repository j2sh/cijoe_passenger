module CIJoePassenger
  class Add < Thor::Group
    include Thor::Actions

    namespace :add
    argument :name, :type => :string, :desc => "The project name"
    argument :repo, :type => :string, :desc => "The git repo address"
    argument :campfire, :type => :hash, :desc => "A hash of campfire options", :default => {}

    def clone
      invoke "git:clone", [name, repo]
    end

    def link_rack_config
      from = File.join(Dir.pwd, "config", "config.ru")
      to = File.join(name, "config.ru")
      run "ln -s #{from} #{to}"
    end

    def add_app_to_apache_config
      invoke "apache_config:add_rack_base_uri", [name]
    end

    def configure_cijoe_runner
      invoke "git:add_config_to_repo", [name, "cijoe.runner", Config.runner]
    end

    def configure_campfire
      campfire.each do |k, v|
        invoke "git:add_config_to_repo", [name, "campfire.#{k}", v]
      end
    end

    def create_skeleton
      empty_directory File.join(name, 'public')
      empty_directory File.join(name, 'tmp')
    end

    def remind
      puts "Don't forget to setup database.yml"
    end
  end
end