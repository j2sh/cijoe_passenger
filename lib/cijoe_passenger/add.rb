module CIJoePassenger
  class Add < Thor::Group
    namespace :add
    argument :name, :type => :string, :desc => "The project name"
    argument :repo, :type => :string, :desc => "The git repo address"
    argument :campfire, :type => :hash, :desc => "A hash of campfire options", :default => {}

    def clone
      Git.clone(repo)
    end

    def bundle_install
      Sh.exec "[[ -f Gemfile ]] && bundle install", name
    end

    def link_rack_config
      from = File.join("config", "config.ru")
      to = File.join(name, "public", "config.ru")
      Sh.exec "ln -s #{from} #{to}"
    end

    def add_app_to_apache_config
      ApacheConfig.add_app(name)
    end

    def configure_cijoe_runner
      Git.add_config_to_repo("cijoe.runner", Config.runner, name)
    end

    def configure_campfire
      campfire.each do |k, v|
        Git.add_config_to_repo("campfire.#{k}", v, name)
      end
    end

    def remind
      puts "Don't forget to setup a config/database.yml"
    end
  end
end