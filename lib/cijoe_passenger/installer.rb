module CIJoePassenger
  class Installer
    attr_reader :name, :repo, :campfire

    def initialize(name, repo, campfire)
      @name = name
      @repo = repo
      @campfire = campfire
    end

    def bundle_install
      Sh.exec "[[ -f Gemfile ]] && bundle install", name
    end

    def link_rack_config
      from = File.join("config", "config.ru")
      to = File.join(name, "public", "config.ru")
      Sh.exec "ln -s #{from} #{to}"
    end

    def apache_config
      @apache_config ||= File.open(Config.apache_config_path, "r") do |f|
        f.readlines
      end
    end

    def add_rack_base_uri_to_apache_config
      apache_config.insert(1, "\tRackBaseURI /#{name}/public\n")
    end

    def save_apache_config
      File.open(Config.apache_config_path, 'w') do |f|
        f.writes(apache_config.join(""))
      end
    end

    def update_apache_config
      add_rack_base_uri_to_apache_config
      save_apache_config
    end

    def configure_cijoe_runner
      Git.add_config_to_repo("cijoe.runner", Config.runner, name)
    end

    def configure_campfire
      campfire.each do |k, v|
        Git.add_config_to_repo("campfire.#{k}", v, name)
      end
    end

    def add
      Git.clone(repo)
      bundle_install
      link_rack_config
      update_apache_config
      configure_cijoe_runner
      configure_campfire
      puts "Don't forget to setup a config/database.yml"
    end
  end
end
